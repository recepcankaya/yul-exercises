// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract Whitelist {
    // Max number of whitelisted addresses allowed
    uint8 public maxWhitelistedAddresses;

    // Create a mapping of whitelistedAddresses
    // if an address is whitelisted, we would set it to true, it is false by default for all other addresses.
    mapping(address => bool) public whitelistedAddresses;

    // numAddressesWhitelisted would be used to keep track of how many addresses have been whitelisted
    uint8 public numAddressesWhitelisted;

    // Setting the Max number of whitelisted addresses
    // User will put the value at the time of deployment
    constructor(uint8 _maxWhiteListedAddresses) {
        assembly {
            sstore(0x00, _maxWhiteListedAddresses)
        }
    }

    /**
        addAddressToWhitelist - This function adds the address of the sender to the
        whitelist
     */
    function addAddressToWhitelist() public {
        assembly {
            // Store the caller first into the memory
            mstore(0x00, caller())
            // Store the mapping slot in contract
            mstore(0x20, 0x01)
            // Find mapping slot
            let mappingSlot := keccak256(0x00, 0x40)
            // Get the boolean from mapping
            let isUserRegistered := sload(mappingSlot)
            // Revert if the user has been already whitelisted
            if eq(isUserRegistered, 0x01) {
                revert(0x00, 0x00)
            }

            let numberOfWhitelisted := sload(0x02)
            let maxNumberOfWhiteListed := sload(0x00)
            // Revert if numberOfWhitelisted is equal to maxNumberOfWhiteListed
            if eq(numberOfWhitelisted, maxNumberOfWhiteListed) {
                revert(0x00, 0x00)
            }

            sstore(mappingSlot, 0x01)
            sstore(0x02, add(numberOfWhitelisted, 1))
        }
    }
}
