// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;


import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract UnderlyingToken is ERC20 {
    constructor() ERC20('Governance Token', 'GTK') {}

function faucet (address to, uint amount) external {
    _mint(to, amount);
}

}