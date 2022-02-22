pragma solidity ^0.5.17;

contract PlanetStorage {
    
    address public gGammaAddress = 0x9436c5384a14f8fF3dafe7771150BD36F3A90BCc;
    address public gammatroller = 0x0F6Bc276b3b61AAEa65761c92cb01d87A5FCd026;
    address public oracle = 0x3c84650c611b38999e8c5eA7064cDef949D20649;
    
    address public admin;
    
    uint256 public level0Discount = 0;
    uint256 public level1Discount = 500;
    uint256 public level2Discount = 2000;
    uint256 public level3Discount = 5000;
   
    uint256 public level1Min = 100;
    uint256 public level2Min = 500;
    uint256 public level3Min = 1000;
    
    
    /**
     * @notice Total amount of underlying discount given
     */
    mapping(address => uint) public totalDiscountGiven;
    
    mapping(address => bool) public deprecatedMarket;
    
    mapping(address => bool) public isMarketListed;
    
    address[] public deprecatedMarketArr;
    
    /*
     * @notice Array of users which have some supply balnce in market
     */
    mapping(address => address[]) public usersWhoHaveSupply;
    
    
    /*
     * @notice Official record of each user whether the user is present in profitGetters or not
     */
    mapping(address => mapping(address => supplyDiscountSnapshot)) public supplyDiscountSnap;
    
    
    /*
     * @notice Official record of each user whether the user is present in discountGetters or not
     */
    mapping(address => mapping(address => BorrowDiscountSnapshot)) public borrowDiscountSnap;
    
    /**
     * @notice Container for Discount information
     * @member exist (whether user is present in Profit scheme)
     * @member index (user address index in array of usersWhoHaveBorrow)
     * @member lastExchangeRateAtSupply(the last exchange rate at which profit is given to user)
     * @member lastUpdated(timestamp at which it is updated last time)
     */
    struct supplyDiscountSnapshot {
        bool exist;
        uint index;
        uint lastExchangeRateAtSupply;
        uint lastUpdated;
    }
    
    struct ReturnBorrowDiscountLocalVars {
        uint marketTokenSupplied;
    }
    
    mapping(address => address[]) public usersWhoHaveBorrow;

    /**
     * @notice Container for borrow balance information
     * @member principal Total balance (with accrued interest), after applying the most recent balance-changing action
     * @member interestIndex Global borrowIndex as of the most recent balance-changing action
     */
    struct BorrowSnapshot {
        uint principal;
        uint interestIndex;
    }
    
    /**
     * @notice Container for Discount information
     * @member exist (whether user is present in Discount scheme)
     * @member index (user address index in array of usersWhoHaveBorrow)
     * @member lastRepayAmountDiscountGiven(the last repay amount at which discount is given to user)
     * @member accTotalDiscount(total discount accumulated to the user)
     * @member lastUpdated(timestamp at which it is updated last time)
     */
    struct BorrowDiscountSnapshot {
        bool exist;
        uint index;
        uint lastBorrowAmountDiscountGiven;
        uint accTotalDiscount;
        uint lastUpdated;
    }

    
   /**
    * @notice Event emitted when discount is changed for user
    */
    event SupplyDiscountAccrued(address market,address supplier,uint discountGiven,uint lastUpdated);
    
   /**
    * @notice Event emitted when discount is changed for user
    */
    event BorrowDiscountAccrued(address market,address borrower,uint discountGiven,uint lastUpdated);
     
    event gGammaAddressChange(address prevgGammaAddress,address newgGammaAddress);
    
    event gammatrollerChange(address prevGammatroller,address newGammatroller);
    
    event oracleChanged(address prevOracle,address newOracle);
    
}

contract PlanetDelegationStorage {
    /**
     * @notice Implementation address for this contract
     */
    address public implementation;
}

contract PlanetDelegatorInterface is PlanetDelegationStorage {
    /**
     * @notice Emitted when implementation is changed
     */
    event NewImplementation(address oldImplementation, address newImplementation);

    /**
     * @notice Called by the admin to update the implementation of the delegator
     * @param implementation_ The address of the new implementation for delegation
     */
    function _setImplementation(address implementation_) public;
}
