#!/bin/bash
GREEN_COLOR='\033[0;32m'
RED_COLOR='\033[0;31m'
WITHOU_COLOR='\033[0m'
DELEGATOR_ADDRESS='*****'
VALIDATOR_ADDRESS='cohovaloper1******'
DELAY=60*1 #in secs - how often restart the script 
WALLET_NAME=********* 
PASS_WALLET=**********
COHO_CHAIN="darkenergy-1"
#NODE="tcp://localhost:26657" #change it only if you use another rpc port of your node



for((;;)); do
        echo -e "Get reward from Delegation"
        echo "${PASS_WALLET}" | cohod tx distribution withdraw-all-rewards --from ${WALLET_NAME} --chain-id=$COHO_CHAIN --fees 100ucoho  --yes
        for (( timer=30; timer>0; timer-- ))
        do
                printf "* sleep for ${RED_COLOR}%02d${WITHOUT_COLOR} sec\r" $timer
                sleep 1
        done
 
#        BAL=$(cohod query bank balances ${DELEGATOR_ADDRESS} --chain-id=$COHO_CHAIN | awk '/amount:/{print $NF}' | tr -d '"')
        BAL=$(cohod query bank balances ${DELEGATOR_ADDRESS} --chain-id=$COHO_CHAIN --output json | jq -r '.balances[] | select(.denom=="ucoho")' | jq -r .amount)
        echo -e "BALANCE: ${GREEN_COLOR}${BAL}${WITHOU_COLOR} ucoho\n"

        echo -e "Claim rewards\n"
        echo "${PASS_WALLET}" | cohod tx distribution withdraw-rewards ${VALIDATOR_ADDRESS} --from ${WALLET_NAME} --commission --chain-id=$COHO_CHAIN --fees 100ucoho  --yes
        for (( timer=30; timer>0; timer-- ))
        do
                printf "* sleep for ${RED_COLOR}%02d${WITHOU_COLOR} sec\r" $timer
                sleep 1
        done
        BAL=$(cohod query bank balances ${DELEGATOR_ADDRESS} --chain-id=$COHO_CHAIN --output json | jq -r '.balances[] | select(.denom=="ucoho")' | jq -r .amount)
#        BAL=$(cohod query bank balances ${DELEGATOR_ADDRESS} --chain-id=$COHO_CHAIN | awk '/amount:/{print $NF}' | tr -d '"')
        BAL=$(($BAL-50000))
        echo -e "BALANCE: ${GREEN_COLOR}${BAL}${WITHOU_COLOR} ucoho\n"
        echo -e "Stake ALL 11111\n"
        if (( BAL > 900000 )); then
        echo "${PASS_WALLET}" | cohod tx staking delegate ${VALIDATOR_ADDRESS} ${BAL}ucoho --from ${WALLET_NAME} --chain-id=$COHO_CHAIN  --fees 100ucoho --yes
        else
          echo -e "BALANCE: ${GREEN_COLOR}${BAL}${WITHOU_COLOR} ucoho BAL < 900000 ((((\n"
        fi 
        for (( timer=${DELAY}; timer>0; timer-- ))
        do
                printf "* sleep for ${RED_COLOR}%02d${WITHOU_COLOR} sec\r" $timer
                sleep 1
        done       

done
