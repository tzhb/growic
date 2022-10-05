pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./StructDeclaration.sol";

contract YourContract {

  // Make owner a state variable with value type address and make it public
  address public owner;

  // Have a mapping of address to students, you can give the mapping any name of your choice
  mapping(address => Students) studentAddress;

  // Make use of a custom error if wish to
  error StudentExist(address studentid, address owner);

  // Have a modifier called onlyOwner and require that msg.sender = owner
  modifier onlyOwner() {
      require(msg.sender == owner, "Access Denied. You are not the Owner of the Contract! Don't move.");
      _;
  }

  // Have a struct to contain details of students
  Students[] public students;

  // Make sure that student cannot register twice
  modifier DoNotRegisterSecondTime(address _studentid) {
        if (getStudentById(_studentid).studentid != address(0)) {
            revert StudentExist({studentid: _studentid, owner: owner});
        }
        _;
    }

  // Have a function to get student details and it accepts one argument
  function getStudentById(address _studentid) private view
        returns (Students memory)
        {
            return studentAddress[_studentid];
        }

  // function getStudentDetails(address studentID)
  function getStudentDetails(address _studentid) public view returns (Students memory)
    {
        return getStudentById(_studentid);
    }

  // Have a function to register students and it should be onlyOwner
  // function register(address studentID) then add all the rest details of the student from your struct to the argument of this function
  function registerStudent(address _studentid, string calldata _firstname, string calldata _secondname, uint256 _percent, uint256 _total) 
  public onlyOwner DoNotRegisterSecondTime(_studentid) {
        Students memory _students = Students(
            _studentid,
            _firstname,
            _secondname,
            _percent,
            _total,
            Strings.toString(block.timestamp)
        );
        setStudentById(_studentid, _students);
    }
  function setStudentById(address _studentid, Students memory _students) private
    {
        studentAddress[_studentid] = _students;
    }

  // Have a constructor that ensures that owner is equal to the msg.sender
  constructor() payable {    
    owner = msg.sender;
  }

  // to support receiving ETH by default
  receive() external payable {}
  fallback() external payable {}
}
