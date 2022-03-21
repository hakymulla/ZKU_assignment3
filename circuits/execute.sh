#! /bin/bash
# {
#     "a1": 3,
#     "a2": 3,
#     "b1": 1,
#     "b2": 2,
#     "c1": 5,
#     "c2": 7
# }

# {
#     "a1": 10,
#     "a2": 0,
#     "b1": 8,
#     "b2": 8,
#     "c1": 0,
#     "c2": 1
# }
# {
#     "a1": 1,
#     "a2": 1,
#     "b1": 2,
#     "b2": 2,
#     "c1": 3,
#     "c2": 3
# }

# /*
# Remove files and folder from the previous compilation and ceremony
# */
rm *.zkey
rm *.ptau
rm witness.wtns
rm -rf circuit_cpp
rm -rf circuit_js
rm public.json
rm proof.json
rm verification_key.json
rm *.sym
rm *r1cs

# /*
# Compiling the circuit, file name is circuit.circom
# --r1cs       outputs the constraints in r1cs format
# --wasm       Compiles the circuit to wasm
# --sym        outputs witness in sym format
# --c          Compiles the circuit to c
# This commands creates a circuit_js folder which contains the needed javascript file
# alsa a circuit_cpp folder which contains the needed c++ file to compute the witness
# */ 

circom circuit.circom --r1cs --wasm --sym --c

# /*
# Chane directory into circuit_js folder to compile with javascript
# */ 

cd circuit_js

# /*
# Generating the witness needs 3 files
# generate_witness.js file to generate the witness
# input.json file is the inout file to generate witness (../input.json means the file is in the previous folder/ root folder)
# witness.wtns file is the filename of generated output
# */ 

node generate_witness.js circuit.wasm ../input.json witness.wtns

snarkjs wtns export json witness.wtns witness.json

# : '
# Copied the generated witness.wtns file to the root folder
# '
cp witness.wtns ../witness.wtns

# : '
# Change directory to the previous folder
# '
cd ..



echo "Starting Phase 1" 

# : '
# We start the power of tau ceremony
# '

snarkjs powersoftau new bn128 12 pot12_0000.ptau -v

# : '
# We contribute to the ceremony
# '

snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name="first contribution" -v
echo "Ending Phase 1" 


# Phase 2 
echo " Starting Phase 2"
snarkjs powersoftau prepare phase2 pot12_0001.ptau pot12_final.ptau -v

# :'
# we generate a .zkey file that will contain the proving and verification keys together with all phase 2 contributions.
# '
snarkjs groth16 setup circuit.r1cs pot12_final.ptau circuit_0000.zkey

# : '
# Contribute to the phase 2 of the ceremony:
# '
snarkjs zkey contribute circuit_0000.zkey circuit_0001.zkey --name="1st Contributor Name" -v

# :'
# Export the verification key in json format (from the proving key)
# '
snarkjs zkey export verificationkey circuit_0001.zkey verification_key.json

echo " Ending Phase 2" 

echo "Generating a Proof"
# :'
# Generating a Groth16 Proof 
# The proving key and witness.wtns are the inputs
# The output (proof) will be stored in the proof.json 
# The public output of the computation will be stored in the output.json file
# '
snarkjs groth16 prove circuit_0001.zkey witness.wtns proof.json public.json

echo " Verifying a Proof"
# : '
# For verifying the proof we use the verification key, public output and proof
# Verifying a Proof with the verification_key.json, public.json proof.json
# '
snarkjs groth16 verify verification_key.json public.json proof.json

# Verifying from a Smart Contract
snarkjs zkey export solidityverifier circuit_0001.zkey verifier.sol

snarkjs generatecall