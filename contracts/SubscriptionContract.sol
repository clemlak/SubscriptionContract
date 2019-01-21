/* solhint-disable not-rely-on-time */
pragma solidity 0.5.0;


import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";


/**
 * @title An amazing project called SubscriptionContract
 * @dev This contract is the base of our project
 */
contract SubscriptionContract is Ownable {
    address public tokenAddress;

    uint256 public subscriptionFee = 10 * 10 ** 18;
    uint256 public periodLength = 60 * 60 * 24 * 30;

    struct Subscription {
        bool isPaused;
        uint256 period;
    }

    mapping (address => Subscription) public subscribersToSubscriptions;

    event NewSubscriber(
        address subscriber,
        uint256 period
    );

    function updateTokenAddress(address newTokenAddress) public onlyOwner() {
        require(newTokenAddress != address(0), "New token address is invalid");

        tokenAddress = newTokenAddress;
    }

    function createSubscription(
        uint256 periodMultiplier
    ) public {
        require(
            subscribersToSubscriptions[msg.sender].period == 0,
            "User is already subscribed"
        );

        IERC20 token = IERC20(tokenAddress);

        require(
            token.allowance(msg.sender, address(this)) >= SafeMath.mul(subscriptionFee, periodMultiplier),
            "Contract is not allowed to manipulate subscriber funds"
        );

        require(
            token.transferFrom(msg.sender, address(this), SafeMath.mul(subscriptionFee, periodMultiplier)),
            "Funds could not be transfered"
        );

        uint256 subscribedPeriod = SafeMath.add(
            now,
            SafeMath.mul(subscriptionFee, periodMultiplier)
        );

        subscribersToSubscriptions[msg.sender].period = subscribedPeriod;
    }

    function pauseSubscription() public {
        subscribersToSubscriptions[msg.sender].isPaused = true;
    }

    function paySubscription(
        uint256 periodMultiplier
    ) public {
        require(
            subscribersToSubscriptions[msg.sender].period > 0,
            "User is not subscribed yet"
        );

        IERC20 token = IERC20(tokenAddress);

        require(
            token.allowance(msg.sender, address(this)) >= SafeMath.mul(subscriptionFee, periodMultiplier),
            "Contract is not allowed to manipulate subscriber funds"
        );

        require(
            token.transferFrom(msg.sender, address(this), SafeMath.mul(subscriptionFee, periodMultiplier)),
            "Funds could not be transfered"
        );

        if (subscribersToSubscriptions[msg.sender].isPaused == true) {
            subscribersToSubscriptions[msg.sender].period = SafeMath.add(
                now,
                SafeMath.mul(subscriptionFee, periodMultiplier)
            );
        } else {
            subscribersToSubscriptions[msg.sender].period = SafeMath.add(
                subscribersToSubscriptions[msg.sender].period,
                SafeMath.mul(subscriptionFee, periodMultiplier)
            );
        }
    }

    function getSubscription(address subscriber) public view returns (
        bool,
        uint256
    ) {
        return (
            subscribersToSubscriptions[subscriber].isPaused,
            subscribersToSubscriptions[subscriber].period
        );
    }
}
