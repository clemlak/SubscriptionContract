pragma solidity 0.5.0;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";


contract TestToken is ERC20 {
    constructor() public {
        _mint(msg.sender, 21000000 * 10 ** 18);
    }
}
