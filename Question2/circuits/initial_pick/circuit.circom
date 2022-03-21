pragma circom 2.0.0;

include "/Users/Hakeem/Documents/zkpassignment/circomlib/circuits/mimcsponge.circom";
include "/Users/Hakeem/Documents/zkpassignment/circomlib/circuits/comparators.circom";


template Main(){
    signal input card;
    signal output cardhash;
    signal output suithash;

    signal suit;

    suit <== card \ 13;

    component mimc = MiMCSponge(1, 220, 1);
    component mimc1 = MiMCSponge(1, 220, 1);

    mimc.ins[0] <== card;
    mimc.k <== 0;
    cardhash <== mimc.outs[0];

    mimc1.ins[0] <== suit;
    mimc1.k <== 0;
    suithash <== mimc1.outs[0];

}

component main = Main();