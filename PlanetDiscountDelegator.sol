pragma solidity ^0.5.16;
import "./PlanetDiscountStorage.sol";

contract PlanetDiscountDelegator is PlanetStorage,PlanetDelegatorInterface {
   
    event NewAdmin(address oldAdmin, address newAdmin);
    
    constructor(address implementation_,address admin_) public {
        // Creator of the contract is admin during initialization
        admin = msg.sender;
        
        _setImplementation(implementation_);
        // Set the proper admin now that initialization is done
        admin = admin_;
    }

    /**
     * @notice Called by the admin to update the implementation of the delegator
     * @param implementation_ The address of the new implementation for delegation
     */
    function _setImplementation(address implementation_) public {
        require(msg.sender == admin, "GErc20Delegator::_setImplementation: Caller must be admin");

        address oldImplementation = implementation;
        implementation = implementation_;

        emit NewImplementation(oldImplementation, implementation);
    }

    function _setAdmin(address newAdmin) public  {
        // Check caller = admin
        require(msg.sender == admin,"caller is not admin");

        // Save current value, if any, for inclusion in log
        address oldAdmin = admin;

        // Store admin with value newAdmin
        admin = newAdmin;

        // Emit NewAdmin(oldAdmin, newAdmin)
        emit NewAdmin(oldAdmin, newAdmin);

    }
    
   
    /**
     * @notice Delegates execution to an implementation contract
     * @dev It returns to the external caller whatever the implementation returns or forwards reverts
     */
    function () external payable {
        require(msg.value == 0,"GErc20Delegator:fallback: cannot send value to fallback");

        // delegate all other functions to current implementation
        (bool success, ) = implementation.delegatecall(msg.data);

        assembly {
            let free_mem_ptr := mload(0x40)
            returndatacopy(free_mem_ptr, 0, returndatasize)

            switch success
            case 0 { revert(free_mem_ptr, returndatasize) }
            default { return(free_mem_ptr, returndatasize) }
        }
    }
}
