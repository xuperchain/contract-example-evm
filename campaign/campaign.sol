// SPDX-License-Identifier: SimPL-2.0
pragma solidity ^0.8.0;

contract campaign {
    // 为 uint256 类型使用 SafeMath 库
    using SafeMath for uint256;
    // owner 账户
    address _owner;
    // 学生会主席
    string _president;
    // 提案候选人
    mapping(uint256 => string) _candidate;
    // 提案票数
    mapping(uint256 => uint256) _votes;
    // 票数阈值
    uint256 _votesTarget;
    // 提案ID
    uint256 _proposalId;
    // 提案状态 为了减少 gas 费消耗，使用uint256类型进行状态记录，并通过mapping来提供状态映射
    mapping(uint256 => uint256) proposalStatus;
    mapping(uint256 => string) pstatus;
    // 投票者集合
    mapping(uint256 => mapping(address => bool)) voted;

    /*
     * 初始化函数
     */
    constructor(address owner) {
        _owner = owner;
        // 初始化提案状态映射
        pstatus[0] = "stoped";
        pstatus[1] = "voting";
        pstatus[2] = "passed";
        pstatus[3] = "completed";
    }

    /*
     * 启动竞选提案 theSender() 方法非必须，等同于 msg.sender;
     */
    function propose(
        string memory candidate,
        uint256 target
    ) public returns (uint256 proposalId) {
        // 验证身份
        require(theSender() == _owner, "error: No permission");
        // 验证提案状态
        require(
            proposalStatus[_proposalId] == 0,
            "error: The proposal is not stoped status"
        );
        // 设置候选人
        _candidate[_proposalId] = candidate;
        // 设置票数阈值
        _votesTarget = target;
        // 设置提案状态
        proposalStatus[_proposalId] = 1;
        return _proposalId;
    }

    /*
     * 查询提案状态
     */
    function queryProposal(
        uint256 proposalId
    ) public view returns (string memory status) {
        return pstatus[proposalStatus[proposalId]];
    }

    /*
     * 投票
     */
    function vote(uint256 proposalId) public returns (string memory status) {
        // 验证提案状态
        require(
            proposalStatus[proposalId] == 1,
            "error: The proposal is not voteable"
        );
        // 验证是否已投票
        require(
            voted[proposalId][theSender()] == false,
            "error: Each person can only vote once"
        );
        // 增加已获取的票数
        _votes[proposalId] = _votes[proposalId].add(1);
        // 避免重复投票
        voted[proposalId][theSender()] = true;
        // 是否达到票数阈值
        if (_votes[proposalId] >= _votesTarget) {
            proposalStatus[proposalId] = 2;
        }
        return "vote successfuly";
    }

    /*
     * 查询提案获取的票数
     */
    function queryVotes(
        uint256 proposalId
    ) public view returns (uint256 votes) {
        return _votes[proposalId];
    }

    /*
     * 检票
     */
    function check(uint256 proposalId) public returns (string memory status) {
        // 验证提案状态
        require(
            proposalStatus[proposalId] == 2,
            "error: The proposal is not eligible for wicket"
        );
        // 验证调用者身份
        require(theSender() == _owner, "error: No permission");
        // 修改提案状态
        proposalStatus[proposalId] = 3;
        // 修改学生会主席信息
        _president = _candidate[proposalId];
        // 为下一次发起提案做准备
        _proposalId = _proposalId.add(1);
        return "check successfuly, the proposal will be take effect";
    }

    /*
     * 查询学生会主席信息
     */
    function queryPresident() public view returns (string memory president) {
        return _president;
    }

    /*
     * 查询提案的候选人信息
     */
    function queryCandidate(
        uint256 proposalId
    ) public view returns (string memory candidate) {
        return _candidate[proposalId];
    }

    /*
     * 返回此次调用者
     */
    function theSender() private view returns (address) {
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
     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0); // Solidity only automatically asserts when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    /**
     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;
        return c;
    }

    /**
     * @dev Adds two numbers, reverts on overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);
        return c;
    }

    /**
     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
     * reverts when dividing by zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}
