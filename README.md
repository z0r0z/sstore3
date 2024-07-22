# [sstore3](https://github.com/z0r0z/sstore3)  [![License: AGPL-3.0-only](https://img.shields.io/badge/License-AGPL-black.svg)](https://opensource.org/license/agpl-v3/) [![solidity](https://img.shields.io/badge/solidity-%5E0.8.26-black)](https://docs.soliditylang.org/en/v0.8.26/) [![Foundry](https://img.shields.io/badge/Built%20with-Foundry-000000.svg)](https://getfoundry.sh/) ![tests](https://github.com/z0r0z/sstore3/actions/workflows/ci.yml/badge.svg)

`sstore3` is a hyper-optimized method for reading and writing contract storage. It seeks to fill the gap for cheap short-form data storage, whereas [`sstore2`](https://github.com/0xsequence/sstore2) has achieved an efficiency upgrade for long-form over the standard [`sstore`](https://www.evm.codes/#55?fork=cancun).

`sstore3` for example offers contract read and write storage for less than half the costs of standard `store`.

<img width="626" alt="Screenshot 2024-07-14 at 7 44 45 PM" src="https://github.com/user-attachments/assets/f547dfb3-a2f9-4a9c-be15-dbc2f5699ed5">

## how

`sstore3` consists of two chief methods that are native to addresses themselves: (1) the wei `balance` of an address, and (2) the `address` 0x itself for short-form data storage, such as price, status or contract type flags.

## `balance` method

The `selfbalance()` opcode has a fixed cost of `5` gas. It is therefore a convenient and technically mutable source of state change for a public contract.

```solidity
// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.19;

contract sstore3 {
    function store() public payable {}

    function data() public view returns (uint256 bits) {
        assembly ("memory-safe") {
            bits := selfbalance()
        }
    }
}
```

Tests demonstrating this approach: [📁](./test/sstore3.t.sol)

### recommendations

A public contract that uses the `sstore3` balance method should take some care to guard a deposit (payable) function so that it is not trivial to update the contract's wei balance. This introduces no new costs to the normal methods of guarded storage (for example, an owner-only function that performs a `sstore` or creates a contract via `sstore2`).

For example:

```solidity
function store() public payable onlyOwner {}
```

Here, the `onlyOwner` modifier should enforce the right to call this storage function.

### drawbacks

The `sstore3` balance method can potentially be abused by either self-destructing a contract or withdrawing consensus layer rewards in order to force a wei balance change on an otherwise guarded public contract.

Depending on the exact application this attack vector can span from a low-severity griefing attack to a critical vulnerability!

#### counter

A safe example here, where these considerations still wouldn't matter, would be a public contract with a "flip the switch" initialization state where the authors don't care who calls to turn on this state (or actually want to disclaim this responsibility altogether), such as, for example, "unpausing" the transferability of a token.

In such event, the token contract and the public would be able to sync this new state the moment it receives a wei.

## `address` method

Data can also be cheaply associated with and effectively stored into a contract through its 0x address. For example, Uniswap V4 pool contracts [utilize the address profile](https://x.com/bantg/status/1668964281277136898) in order to determine configuration status, and some contracts might [check whether an address starts with a certain number of zeros](https://github.com/Philogy/sub-zero-contracts/blob/main/src/VanityMarket.sol#L102) to flag if it should be treated as immutable by a contract.

In this similar fashion, `sstore3` address method anticipates using [`create2crunch`](https://github.com/0age/create2crunch) or similar address mining technique to locate and deploy bytecode to specific addresses that follow a protocol's storage conventions. `sstore3` is agnostic to how these conventions may themselves be developed, but a few examples may aid in understanding the application.

To illustrate, the address `0x000000004f5b1f858B5D96cc0d013b8867A5fF60` might contain arbitrary logic but calls to this logic can be framed according to a convention that follows the proposed `sstore3` address method.

To illustrate further, consider that a calling contract might read this address from storage but then otherwise want more data in order to correctly call this address according to its protocol. Typically, this would involve another call or reading more data from local storage. 

Alternatively, and more efficiently, this protocol could be designed such that if an address has four leading `0` (`0x00000000`) bytes, rather than `1`, calls to such address will follow the ERC20 interface rather than the ERC721 interface. Additionally, the number `4` directly following might be a signifier to external applications that the callee contract is on its version `4` and includes a certain ABI format.

The point in all of the above being, to reduce and remove any redundant bytecode or onchain interactions that can elaborate information about a contract by being contained in the contract address itself using `create2`.

## Getting Started

Run: `curl -L https://foundry.paradigm.xyz | bash && source ~/.bashrc && foundryup`

Build the foundry project with `forge build`. Run tests with `forge test`. Measure gas with `forge snapshot`. Format with `forge fmt`.

## Blueprint

```txt
lib
├─ forge-std — https://github.com/foundry-rs/forge-std
src
├─ sstore1 — standard store
├─ sstore2 — sstore2 example
├─ sstore3 — sstore3 example
test
├─ sstore1.t — test standard
├─ sstore2.t — test sstore2
└─ sstore3.t - test sstore3
```

## Notable Mentions

- [sstore2](https://github.com/0xsequence/sstore2)
- [univ4](https://x.com/bantg/status/1668964281277136898)

## Disclaimer

*These smart contracts and testing suite are being provided as is. No guarantee, representation or warranty is being made, express or implied, as to the safety or correctness of anything provided herein or through related user interfaces. This repository and related code have not been audited and as such there can be no assurance anything will work as intended, and users may experience delays, failures, errors, omissions, loss of transmitted information or loss of funds. The creators are not liable for any of the foregoing. Users should proceed with caution and use at their own risk.*

## License

See [LICENSE](./LICENSE) for more details.
