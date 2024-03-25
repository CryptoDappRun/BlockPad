pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}


pragma solidity ^0.8.0;

contract BlockPad {
    address public contractOwner;
    uint256 public feeAmount = 0.001 ether;

    struct MyStruct {
        string Hint;
        string StoreText;
    }

    MyStruct[] public structArray;
    mapping(string => bool) hintExists;

    modifier onlyOwner() {
        require(msg.sender == contractOwner, "Only owner can call this function");
        _;
    }

    constructor() {
        contractOwner = msg.sender;
    }

    function setFeeAmount(uint256 _feeAmount) public onlyOwner {
        feeAmount = _feeAmount;
    }

    function addData(string memory _Hint, string memory _StoreText) public payable {
        require(msg.value >= feeAmount, "Insufficient fee");
        require(!hintExists[_Hint], "Hint already exists");

        MyStruct memory newStruct = MyStruct(_Hint, _StoreText);
        structArray.push(newStruct);
        hintExists[_Hint] = true;

        payable(contractOwner).transfer(feeAmount);
    }

    function searchData(string memory _value) public view returns (string memory, string memory) {
        for (uint256 i = 0; i < structArray.length; i++) {
            if (keccak256(abi.encodePacked(structArray[i].Hint)) == keccak256(abi.encodePacked(bytes(_value)))) {
                return (structArray[i].Hint, structArray[i].StoreText);
            }
        }
        revert("Hint not found");
    }


 function structArrayLength() public view returns (uint256) {
        return structArray.length;
    }





    function TransferETH( address payable _receiver ) public onlyOwner  {
    (_receiver).transfer(address(this).balance);
    }

    function TransferToken( address payable _receiver,address TokenAddress) public onlyOwner  {
    IERC20(_receiver).transfer(_receiver, IERC20(TokenAddress).balanceOf( address(this)) );

    }

    fallback() external payable {}

    receive() external payable {}



}



