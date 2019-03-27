pragma solidity ^0.4.25;

import "./ParallelContract.sol";

// A parallel contract example
contract ParallelOk is ParallelContract
{
    mapping (string => uint256) _balance;
    
    function transfer(string from, string to, uint256 num) public
    {
        // Just an example, overflow is ok, use 'SafeMath' if needed
        _balance[from] -= num;
        _balance[to] += num;
    }

    function transferWithRevert(string from, string to, uint256 num) public
    {
        // To test whether the parallel revert function is working well
        transfer(from, to, num);
        require(num <= 100);
    }

    function set(string name, uint256 num) public
    {
        _balance[name] = num;
    }

    function balanceOf(string name) public view returns (uint256)
    {
        return _balance[name];
    }
    
    // Register parallel function
    function enableParallel() public
    {
        // critical number is to define how many critical params from start
        registerParallelFunction("transfer(string,string,uint256)", 2); // critical: string string
        registerParallelFunction("set(string,uint256)", 1); // critical: string
    } 

    // Un-Register parallel function
    function disableParallel() public
    {
        unregisterParallelFunction("transfer(string,string,uint256)"); 
        unregisterParallelFunction("set(string,uint256)");
    } 
}