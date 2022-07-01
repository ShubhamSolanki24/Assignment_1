//SPDX-License-Identifier: MIT 
pragma solidity  >=0.5.0 <0.9.0;

// Created a smart contract that allows a user to deposit and withdraw ETHERS.
contract Locker{

    // Private state variable
    address private owner =msg.sender;

    //mapped the address of the owner balance in the contract
    mapping(address => uint) private balances;
    uint count;
 
  //declare event for deposit 
   event Deposit(address indexed _from ,string message);
  
     //1) function to deposit amount in locker
    function deposit() public payable{
       require(msg.value > 0 wei,  "Value for deposit should be more than 0 wei"); //minimum amount deposit should be more than 0
       require(msg.sender == owner,  "owner can only deposit"); // only owner can deposit ,it will prevent from vulnerability
        balances[msg.sender] += msg.value;
        count =1; 
       //emit event for deposit
       emit Deposit(msg.sender, "event for deposit"); 
    }    
    
    //declare event for withdraw
    event Withdraw(address indexed _sender,string message);
   // function of withdraw the desired amount
   
    function withdraw(uint _amount) public{
         require(msg.sender == owner,  "owner can only withdraw");// only owner can withdraw
   
          if(count == 1){
        // withdraw cannot be done in single go and withdraw amount should be less then the amount just deposited in the locker,if not Display required Error
           require( _amount < balances[msg.sender] , "Cannot withdraw in Single go"); 
           balances[msg.sender] -= _amount;
            count += 1;
          }
   
          else if(count>=2){
            //withdraw amount should be equal to locker balance or less but can never withdraw more than locker have,if not Display required Error  
             require( _amount <= balances[msg.sender], "insufficient ETHER");
            balances[msg.sender] -= _amount;
             count += 1;
         }
   
          //amount is transfer back to owner account ,once amount is subtracted from the locker
            payable(msg.sender).transfer(_amount);
          
            // emit event of withdraw to the UI
        emit Withdraw(msg.sender, "event for withdraw"); 
    }

     // function for checking the balance
    function getBal() public view returns(uint){
        return address(this).balance;
    }
}
