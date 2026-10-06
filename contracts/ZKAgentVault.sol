// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ZKAgentVault
 * @notice On-chain AI Agent Vault with ZK verification placeholder
 * @dev Starter template for ZK Prime style grants (On-chain AI Agent + ZK)
 */
contract ZKAgentVault {
    address public owner;
    address public agent;               // AI Agent address
    uint256 public totalDeposited;
    bool public zkEnabled;              // Future ZK verification flag

    mapping(address => uint256) public balances;

    event Deposited(address indexed user, uint256 amount);
    event AgentAction(address indexed agent, string action, uint256 value, bytes32 zkProofHash);
    event AgentUpdated(address indexed oldAgent, address indexed newAgent);
    event ZKEnabled(bool status);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier onlyAgent() {
        require(msg.sender == agent, "Not authorized agent");
        _;
    }

    constructor(address _agent) {
        owner = msg.sender;
        agent = _agent;
        zkEnabled = false;
    }

    // Users deposit ETH that the AI agent can manage
    function deposit() external payable {
        require(msg.value > 0, "Must send ETH");
        balances[msg.sender] += msg.value;
        totalDeposited += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    /**
     * @notice Agent executes an action
     * @param action Description of the action
     * @param to Target address
     * @param amount Amount to send
     * @param zkProofHash Placeholder for future ZK proof hash
     */
    function executeAction(
        string calldata action,
        address to,
        uint256 amount,
        bytes32 zkProofHash
    ) external onlyAgent {
        require(amount <= address(this).balance, "Insufficient balance");
        
        (bool success, ) = to.call{value: amount}("");
        require(success, "Transfer failed");

        emit AgentAction(msg.sender, action, amount, zkProofHash);
    }

    // Owner can update the agent
    function updateAgent(address newAgent) external onlyOwner {
        address old = agent;
        agent = newAgent;
        emit AgentUpdated(old, newAgent);
    }

    // Enable/disable ZK mode (placeholder for future integration)
    function setZKEnabled(bool status) external onlyOwner {
        zkEnabled = status;
        emit ZKEnabled(status);
    }

    // Emergency withdraw
    function emergencyWithdraw() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    receive() external payable {}
}
