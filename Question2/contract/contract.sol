// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./Verifier.sol";

contract Card is Verifier{

    mapping (address => uint256[]) public hash;
    mapping (address => uint256) public suithash;

     function verifypplayer(
            uint[2] memory _a,
            uint[2][2] memory _b,
            uint[2] memory _c,
            uint[2] memory _proofInput) 
            public returns (bool) 
            {
            require(
                verifyProof(_a, _b, _c, _proofInput),
                "Failed move proof check"
            );
            hash[msg.sender].push(_proofInput[0]);
            suithash[msg.sender] = _proofInput[1];

            return true;
            }

    function updateplayer(
            uint[2] memory _a,
            uint[2][2] memory _b,
            uint[2] memory _c,
            uint[2] memory _proofInput) 
            public returns (bool) 
            {
            require(
                verifyProof(_a, _b, _c, _proofInput),
                "Failed move proof check"
            );
            require(suithash[msg.sender] == _proofInput[1], "New input suit doesn't match the previous suit");
            hash[msg.sender].push(_proofInput[0]);
            return true;
            }


}

