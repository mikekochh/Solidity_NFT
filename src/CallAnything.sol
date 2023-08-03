// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract CallAnything {
    address public s_someAddress;
    uint256 public s_amount;

    function transfer(address someAddress, uint256 amount) public {
        s_someAddress = someAddress;
        s_amount = amount;
    }

    function getSelectorOne() public pure returns (bytes4 selector) {
        selector = bytes4(keccak256(bytes("transfer(address,uint256)")));
        // This function is getting the function selector, the byte code that will be called when we call transfer function.
        // This is the bytes code the blockchain reads to know to execute the transfer function
    }

    function getDataToCallTransfer(
        address someAddress,
        uint256 amount
    ) public pure returns (bytes memory) {
        return abi.encodeWithSelector(getSelectorOne(), someAddress, amount);
        // This function is getting all of the data, including the function selector, that will be sent to the blockchain for execution
    }

    function callTransferFunctionDirectly(
        address someAddress,
        uint256 amount
    ) public returns (bytes4, bool) {
        (bool success, bytes memory returnData) = address(this).call(
            // getDataToCallTransfer(someAddress, amount)
            abi.encodeWithSelector(getSelectorOne(), someAddress, amount)
            // abi.encodeWithSignature("transfer(address,uint256)", someAddress, amount)
            // these are all the same. Each one is getting the function selector as well as the data that will be called with the function and executing the function on blockchain
        );
        // in this function, we are putting the direct byte code that tells the blockchain what function to call. You can either call a function directly, or send the blockchain
        // the byte code that it can understand and execute on
        return (bytes4(returnData), success);
    }
}
