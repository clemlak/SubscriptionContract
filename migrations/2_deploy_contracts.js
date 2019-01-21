/* eslint-env node */
/* global artifacts */

const SubscriptionContract = artifacts.require('SubscriptionContract');
const TestToken = artifacts.require('TestToken');

function deployContracts(deployer) {
  deployer.deploy(TestToken);
  deployer.deploy(SubscriptionContract);
}

module.exports = deployContracts;
