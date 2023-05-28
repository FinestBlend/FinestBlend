# FinestBlend 

2 smart contracts : WhiskeyBottleEscrow.sol 
                    CollateralStacking.sol 
                    
The first smart contract is an escrow smart contract. The idea of the first smart contract is to exchange asset between buyer and seller, adding a third part. Here, the value exchanged is a bottle of whiskey, backed with an NFT. This NFT has a USDC value. To make sure that the price of USDC is up to date, we are using an oracle, the chainlink oracle. 

- checkbalance() : This fonction is important in our smart contract because it allow us to check if the user balance can mint his NFTs and put in collateral FACTR token. 
Attention : This collateral shoul be an amount that is not to much, not to cheap in order to save the value of the FACTR token. We want to make sure that the token is not to much volatile. 


The second smart contract, is a Stacking Smart contract. The idea, is that when the user wants to stack his bottle of whiskey, he will activate the escrow smart contract in the other way around. The NFTs, linked with the Real World Asset ( the wiskey bottle ), will be stacked to the buyer. So the buyer will have a reward based on the APY rate of the NFTs. 
