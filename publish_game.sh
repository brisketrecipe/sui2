#!/bin/bash
# a bash script to automate the process of publishing the game package
# this script should be run at root of the repo

export ADMIN=0x38ee009d5322b62bf9e3d3da6b0d99acb25a142a2fe5e987ade51b683202e275
export PLAYER_X=0xf326523f79d8615a4b7b8869ac89ea028d8434e192a96ea52f4d43b3a08cb731
export PLAYER_O=0x0c66fff8a62348aeb7b217a52447ef55fcc48dacb460c2a0a3feb870c3ee94eb

export ADMIN_GAS=0xd139e0819cdb994254910841b07a92e04f7dc9f4038101adb50130912e627497
export X_GAS=0x220eb491ca8c1c591b3799e09f44155f70e13f81c93f987fc08327d26f00baf1
export O_GAS=0xf0e5cc7b75e7d2f127b96309243b1819b0836bdd1de1539abc168c973b49e71e

export XCAP=0x68e4e4a82bd2e80c9847c7548cd75bf55d3b5aacfda10965c2fe8e72178467b4
export OCAP=0x2e234b8ced5274374c62d6348301bc31c882c312b285177e26b382d2b4706624
export GAME=0xeeee2a76654ae29cf81ba69cf334c472d85cc54205d05f6c7c91195232e8c2aa


# assign address
CLIENT_ADDRESS=$(sui client addresses | tail -n +2)
ADMIN=`echo "${CLIENT_ADDRESS}" | head -n 1`
PLAYER_X=`echo "${CLIENT_ADDRESS}" | sed -n 2p`
PLAYER_O=`echo "${CLIENT_ADDRESS}" | sed -n 3p`
# gas id
IFS='|'
ADMIN_GAS_INFO=$(sui client gas --address $ADMIN | sed -n 3p)
read -a tmparr <<< "$ADMIN_GAS_INFO"
ADMIN_GAS_ID=`echo ${tmparr[0]} | xargs`

X_GAS_INFO=$(sui client gas --address $PLAYER_X | sed -n 3p)
read -a tmparr <<< "$X_GAS_INFO"
X_GAS_ID=`echo ${tmparr[0]} | xargs`

O_GAS_INFO=$(sui client gas --address $PLAYER_O | sed -n 3p)
read -a tmparr <<< "$O_GAS_INFO"
O_GAS_ID=`echo ${tmparr[0]} | xargs`

# publish games
certificate=$(sui client publish ./sui_programmability/examples/games --gas $ADMIN_GAS_ID --gas-budget 30000)

package_id_identifier="The newly published package object ID:"
res=$(echo $certificate | awk -v s="$package_id_identifier" 'index($0, s) == 1')
IFS=':'
read -a resarr <<< "$res"
echo ${resarr[1]}
PACKAGE_ID=`echo ${resarr[1]} | xargs`

echo "package id: $PACKAGE_ID"
# Playing TicTacToe

# create a game
sui client call --package $PACKAGE_ID --module tic_tac_toe --function create_game --args $PLAYER_X $PLAYER_O --gas $ADMIN_GAS_ID --gas-budget 1000

# start playing the game ...