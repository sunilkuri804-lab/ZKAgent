const hre = require("hardhat");

async function main() {
  // Change this to your agent address later
  const agentAddress = "0x0000000000000000000000000000000000000000";

  const ZKAgentVault = await hre.ethers.getContractFactory("ZKAgentVault");
  const vault = await ZKAgentVault.deploy(agentAddress);

  await vault.waitForDeployment();

  console.log("ZKAgentVault deployed to:", await vault.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
