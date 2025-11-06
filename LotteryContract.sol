// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract Lottery{
    address public manager;
    address payable []  public players;
    constructor(address _manager){
         require(_manager!= address(0), " Invalid manager address");
        manager = _manager;
                         
    }
    function alreadyEntered(address user) view private returns(bool){
        for(uint i=0; i<players.length; i++){
            if( players[i]== user)
            return true;
        }
        return false;
    }

    function enter() payable public {
     require(!alreadyEntered(msg.sender), "You have already entered");

     require(msg.value >= 1 ether, "You ether is not enough");
     require(msg.value<= 1 ether, "Your ether is more than charges");
     require(msg.sender != manager, "manager Can't praticipate");
     
     players.push(payable(msg.sender));

    }
    function random() private view returns(uint) {
        return uint (sha256(abi.encodePacked(block.prevrandao, block.timestamp, players)));

    }
    event WinnerSelected(address winner, uint amount);

function pickWinner() public {
    require(msg.sender == manager, "Only manager can pick winner");
    require(players.length >= 3, "Not enough players");

    uint index = random() % players.length;
    address payable winner = players[index];
    uint amount = address(this).balance;

    winner.transfer(amount);
    emit WinnerSelected(winner, amount);

    delete players;
}

    function getPlayers() view public returns(address payable[] memory){
        return players;
    }
}