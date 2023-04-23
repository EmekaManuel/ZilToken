// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @custom:security-contact marrnuel123@gmail.com

contract ZilDoge is ERC20, ERC20Burnable, Ownable {
    // 10% tax
    // uint256 public constant TAX_DIVISOR = 15;
    uint256 public constant BURN = 5;
    uint256 public constant OWNER_ALLOCATION = 5;

    // Token name, symbol, and initial amount
    constructor() ERC20("ZILDOGE", "ZDOGE") {
        _mint(msg.sender, 1000000000 * 10**decimals());
    }

    // Minting extra tokens - limited to only the owner address
    function mintNewTokens(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function transfer(address to, uint256 amount)
        public
        override
        returns (bool)
    {
        // Check if sender has enough tokens to send
        uint256 balanceSender = balanceOf(msg.sender);
        require(balanceSender >= amount, "ERC20: Not enough balance");

        // Calculate tax amount

        // Calculate transfer amount
        uint256 transferAmount = amount;

        // Calculate burn amount
        uint256 burnAmount = (transferAmount * 5) / 100;

        // Calculate address amount
        uint256 addressAmount = (transferAmount * 10) / 100;

        // Calculate transferable amount
        uint256 transferableAmount = transferAmount -
            (burnAmount +
            addressAmount);

        // Transfer tokens
        _transfer(msg.sender, to, transferableAmount);

        // Burn tokens
        if (burnAmount > 0) {
            _burn(address(0), burnAmount);
        }

        // Transfer tokens to specified address
        if (addressAmount > 0) {
            _transfer(
                msg.sender,
                address(0x05013BB97c157ad59CacE1632aaa4BA85Cf17819),
                addressAmount
            ); // replace 0x00 with the desired address
        }

        return true;
    }
}
