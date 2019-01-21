/* eslint-env node, mocha */
/* global artifacts, contract, it, assert */

const SubscriptionContract = artifacts.require('SubscriptionContract');

let instance;

contract('SubscriptionContract', (accounts) => {
  it('Should deploy an instance of the SubscriptionContract contract', () => SubscriptionContract.deployed()
    .then((contractInstance) => {
      instance = contractInstance;
    }));
});
