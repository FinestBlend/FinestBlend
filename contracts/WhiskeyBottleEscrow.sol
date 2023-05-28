// SPDX-License-Identifier: UNLICENSED 
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";


contract WhiskeyBottleEscrow is ERC721Holder {

    enum Stages { PaymentPending, ItemSent, Received }
    Stages public stage = Stages.PaymentPending;
    address payable public seller;
    address payable public buyer;
    uint256 public price;
    // Define NFT contract and IPFS metadata for the NFT
    IERC721 public whiskeyNftContract;
    string public whiskeyNftIpfsUri;
    uint256 public whiskeyNftId;
    IERC20 public FACTR = IERC20('Our FACTR token address');


    constructor(address _whiskeyNftAddress, uint256 _whiskeyNftId, string memory _whiskeyNftLink, address payable _seller) payable {
        whiskeyNftContract = IERC721(_whiskeyNftAddress);
        whiskeyNftIpfsUri = _whiskeyNftLink;
        whiskeyNftId = _whiskeyNftId;
        seller = _seller;
        price = msg.value;
    }

    function checkBalance() public view returns (uint256) {
        return FACTR.balanceOf(msg.sender);
    }


    function confirmReceived() public onlyBuyer {
        require(stage == Stages.Received);
        seller.transfer(address(this).balance);
        stage = Stages.PaymentPending;
    }

    function confirmCompletion() public onlySeller {
        require(stage == Stages.ItemSent);
        stage = Stages.Received;
    }

    function refundBuyer() public onlySeller {
        require(stage == Stages.PaymentPending);
        payable(msg.sender).transfer(address(this).balance);
        stage = Stages.PaymentPending;
    }

    function sendItem() public onlySeller {
        require(stage == Stages.PaymentPending);
        whiskeyNftContract.safeTransferFrom(seller, buyer, whiskeyNftId);
        stage = Stages.ItemSent;
    }

    function buyerInitializeSale() public payable {
        require(stage == Stages.PaymentPending);
        require(msg.value == price);
        buyer = payable(msg.sender);
        stage = Stages.ItemSent;
    }

    modifier onlySeller() {
        require(msg.sender == seller, "Only seller is allowed to perform this action");
        _;
    }

    modifier onlyBuyer() {
        require(msg.sender == buyer, "Only seller is allowed to perform this action");
        _;
    }

    
}

contract DataConsumerV3 {
    AggregatorV3Interface internal dataFeed;

    /**
     * Network: Goerli
     * Aggregator: ETH/USDC
     * Address: 0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43
     */

    constructor() {
        dataFeed = AggregatorV3Interface(
            0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43
        );
    }

    /**
     * Returns the latest answer.
     */
    function getLatestData() public view returns (int) {
        // prettier-ignore
        (
            /* uint80 roundID */,
            int answer,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = dataFeed.latestRoundData();
        return answer;
    }
}
