/* eslint-env node, mocha */
/* global artifacts, contract, it, assert */

const TestToken = artifacts.require('TestToken');

let instance;

contract('TestToken', (accounts) => {
  it('Should deploy an instance of the TestToken contract', () => TestToken.deployed()
    .then((contractInstance) => {
      instance = contractInstance;
    }));

  it('Should check the total supply of the token', () => instance.totalSupply()
    .then((totalSupply) => {
      assert.equal(totalSupply, 21000000 * 10 ** 18, 'Total supply is wrong');
  }));

  it('Should check the balance of account 0', () => instance.balanceOf(accounts[0])
    .then((balance) => {
      assert.equal(balance, 21000000 * 10 ** 18, 'Balance is wrong!');
    }));
});
