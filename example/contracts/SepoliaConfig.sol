// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title SepoliaConfig
 * @dev Configuration for FHEVM on Sepolia testnet
 */
contract SepoliaConfig {
    struct FHEVMConfigStruct {
        address acl;
        address kmsVerifier;
        address decryptionOracle;
    }
    
    function getFHEVMConfig() public pure returns (FHEVMConfigStruct memory) {
        return FHEVMConfigStruct({
            acl: 0x0000000000000000000000000000000000000000,
            kmsVerifier: 0x0000000000000000000000000000000000000000,
            decryptionOracle: 0x0000000000000000000000000000000000000000
        });
    }
}
