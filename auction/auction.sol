// SPDX-License-Identifier: SimPL-2.0
pragma solidity ^0.8.17;

contract auction {
    // 为 uint256 类型使用 SafeMath 库
    using SafeMath for uint256;
    // 拍卖行
    address auctionHouse;
    // 状态池
    mapping(uint256 => string) aStatus;
    // 商品信息，简单考虑，只维护一个 desc
    mapping(uint256 => string) desc;
    // 商品状态
    mapping(uint256 => uint256) status;
    // 商品起拍时间
    mapping(uint256 => uint256) timestamp;
    // 商品起拍价
    mapping(uint256 => uint256) price;
    // 商品当前出价记录
    mapping(uint256 => mapping(uint256 => address)) bids;
    // 商品当前最高出价
    mapping(uint256 => uint256) maxPrice;
    // 商品拥有者
    mapping(uint256 => address) owner;

    // 合约初始化
    constructor(address _owner) {
        // 拍卖行
        auctionHouse = _owner;
        // 初始化状态池
        aStatus[0] = "Off shelf";
        aStatus[1] = "Under auction";
        aStatus[2] = "Had sold";
        // 创建商品
        desc[0] = "xuperchain01";
        desc[1] = "xuperchain02";
        desc[3] = "xuperchain03";
    }

    // 上架商品
    function putOnShelves(uint256 pid) public returns (bool) {
        // 身份验证
        require(sender() == auctionHouse, "auction error: no permission");
        // 状态验证
        require(status[pid] == 0, "auction error: this item cannot be listed");
        // 起拍时间验证，避免执行占用拍卖时间，增加5分钟准备时间
        require(
            (timestamp[pid] - block.timestamp) > 15 minutes,
            "auction error: unable to prepare adequately before this time, pls set the auction time"
        );
        // 起拍价验证
        require(price[pid] > 100, "auction error: the price is too cheap");
        // 开始拍卖
        status[pid] = 1;
        return true;
    }

    // 设置起拍时间
    function setAuctionTime(uint256 pid, uint256 times) public returns (bool) {
        // 身份验证
        require(sender() == auctionHouse, "auction error: no permission");
        // 状态验证
        require(
            status[pid] == 0,
            "auction error: this item cannot be set auction time"
        );
        // 起拍时间验证，避免执行占用拍卖时间，增加1分钟准备时间
        require(
            (times - block.timestamp) > 15 minutes,
            "auction error: unable to prepare adequately before this time"
        );
        // 修改起拍时间
        timestamp[pid] = times;
        return true;
    }

    // 设置起拍价
    function setPrice(uint256 pid, uint256 prices) public returns (bool) {
        // 身份验证
        require(sender() == auctionHouse, "auction error: no permission");
        // 状态验证
        require(
            status[pid] == 0,
            "auction error: this item cannot be set auction time"
        );
        // 起拍价验证
        require(prices > 100, "auction error: the price is too cheap");
        // 设置起拍价格
        price[pid] = prices;
        // 商品初始归属为拍卖行
        owner[pid] = auctionHouse;
        // 起拍价格为初始最高出价
        maxPrice[pid] = prices;
        return true;
    }

    // 出价
    function bid(uint256 pid, uint256 prices) public returns (bool) {
        // 状态验证
        require(status[pid] == 1, "auction error: this item cannot be bid");
        // 价格验证
        require(
            maxPrice[pid] < prices,
            "auction error: your price must more than the maxPrice"
        );
        // 能否继续叫价
        require(verifyBid(pid), "auction error: the item had sold");
        maxPrice[pid] = prices;
        // 记录
        bids[pid][prices] = sender();
        return true;
    }

    // 能否继续叫价
    function verifyBid(uint256 pid) private returns (bool) {
        if (block.timestamp - timestamp[pid] > 10) {
            // 需要停止
            // 状态设置
            status[pid] = 2;
            // 归属者设置
            owner[pid] = bids[pid][maxPrice[pid]];
            return false;
        }
        return true;
    }

    // 获取商品描述
    function getDesc(uint256 pid) public view returns (string memory) {
        return desc[pid];
    }

    // 获取拍卖行地址
    function getAuctionHouse() public view returns (address) {
        return auctionHouse;
    }

    // 获取商品状态
    function getStatus(uint256 pid) public view returns (string memory) {
        return aStatus[status[pid]];
    }

    // 获取商品起拍时间
    function getTimestamp(uint256 pid) public view returns (uint256) {
        return timestamp[pid];
    }

    // 获取商品起拍价格
    function getPrice(uint256 pid) public view returns (uint256) {
        return price[pid];
    }

    // 获取商品当前最高价
    function getMaxPrice(uint256 pid) public view returns (uint256) {
        return maxPrice[pid];
    }

    // 获取商品归属人
    function getOwner(uint256 pid) public view returns (address) {
        return owner[pid];
    }

    // the sender
    function sender() private view returns (address) {
        return msg.sender;
    }
}

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b);
        return c;
    }

    /**
*
@dev Integer division of two numbers truncating the quotient, reverts on division by zero.
*
**/
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0); // Solidity only automatically asserts when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    /**
*
@dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
*
**/
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;
        return c;
    }

    /**
*
@dev Adds two numbers, reverts on overflow.
*
**/
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);
        return c;
    }

    /**
*
@dev Divides two numbers and returns the remainder (unsigned integer modulo),
*
reverts when dividing by zero.
*
**/
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}
