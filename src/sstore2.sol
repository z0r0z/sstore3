// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.19;

contract sstore2 {
    address public pointer;

    uint256 internal constant DATA_OFFSET = 1;

    function store(uint256 _data) public payable {
        bytes memory runtimeCode = abi.encodePacked(hex"00", _data);

        bytes memory creationCode = abi.encodePacked(hex"600B5981380380925939F3", runtimeCode);

        address _pointer;
        assembly ("memory-safe") {
            _pointer := create(0, add(creationCode, 32), mload(creationCode))
        }

        pointer = _pointer;
    }

    function data() public view returns (uint256 bits) {
        bytes memory retData = readBytecode(pointer, DATA_OFFSET, pointer.code.length - DATA_OFFSET);
        bits = uint256(bytes32(retData));
    }

    function readBytecode(address _pointer, uint256 start, uint256 size)
        internal
        view
        returns (bytes memory _data)
    {
        assembly ("memory-safe") {
            _data := mload(0x40)
            mstore(0x40, add(_data, and(add(add(size, 32), 31), not(31))))
            mstore(_data, size)
            extcodecopy(_pointer, add(_data, 32), start, size)
        }
    }
}
