// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./Verifier.sol";

contract Traingle is Verifier{

     function verifypplayer(
            uint[2] memory _a,
            uint[2][2] memory _b,
            uint[2] memory _c,
            uint[1] memory _proofInput) 
            public view returns (uint[1] memory) 
            {
            require(
                verifyProof(_a, _b, _c, _proofInput),
                "Failed move proof check"
            );
            return true;
            }

}

