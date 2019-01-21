/* eslint-env node, mocha */
/* global artifacts, contract, assert */

const Web3 = require('web3');

const SubscriptionContract = artifacts.require('SubscriptionContract');
const TestToken = artifacts.require('TestToken');

let tokenInstance;
let subInstance;

contract('SubscriptionContract', (accounts) => {
  it('Should deploy an instance of the TestToken contract', () => TestToken.deployed()
    .then((contractInstance) => {
      tokenInstance = contractInstance;
    }));

  it('Should give some tokens to account 1', () => tokenInstance.transfer(accounts[1], Web3.utils.toWei('10')));

  it('Should deploy an instance of the SubscriptionContract contract', () => SubscriptionContract.deployed()
    .then((contractInstance) => {
      subInstance = contractInstance;
    }));

  it('Should define the token address', () => subInstance.updateTokenAddress(tokenInstance.address));

  it('Should allow the sub contract to handle accounts 1 funds', () => tokenInstance.approve(subInstance.address, Web3.utils.toWei('10'), {
    from: accounts[1],
  }));

  it('Should create a new subscription for account 1', () => subInstance.createSubscription(1, {
    from: accounts[1],
  }));
});
