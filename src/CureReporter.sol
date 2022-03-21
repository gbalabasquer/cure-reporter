// SPDX-License-Identifier: AGPL-3.0-or-later

/// CureReporter.sol -- CureReporter

// Copyright (C) 2022 Dai Foundation
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

pragma solidity ^0.8.12;

interface VatLike {
    function debt() external view returns (uint256);
    function live() external view returns (uint256);
    function Line() external view returns (uint256);
}

interface WormholeJoinLike {
    function cure() external view returns (uint256);
}

contract CureReporter {
    mapping (address => uint256) public wards;

    uint256 cure_ = type(uint256).max;

    // --- Events ---
    event Rely(address indexed usr);
    event Deny(address indexed usr);
    event Set(uint256 cureV);

    modifier auth {
        require(wards[msg.sender] == 1, "CureReporter/not-authorized");
        _;
    }

    constructor() {
        wards[msg.sender] = 1;
        emit Rely(msg.sender);
    }

    // --- Administration ---
    function rely(address usr) external auth {
        wards[usr] = 1;
        emit Rely(usr);
    }

    function deny(address usr) external auth {
        wards[usr] = 0;
        emit Deny(usr);
    }

    // This function is intended to be called from L2 message reporting this value
    function set(uint256 cureV) external auth {
        cure_ = cureV;
        emit Set(cureV);
    }

    // --- Function to be called by Cure module ---
    function cure() external view returns (uint256 cureV) {
        require(cure_ != type(uint256).max, "CureReporter/cure-still-not-set");
        cureV = cure_;
    }
}
