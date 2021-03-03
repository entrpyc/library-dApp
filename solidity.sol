pragma solidity 0.7.4;

contract Contract {
  enum borrowingStatus{ BORROWED, RETURNED }
  
  uint booksCount = 0;
  mapping(uint => Book) public books;
  
  mapping(address => Account) libraryAccount;
  
  uint historyBlockCount = 0;
  mapping(uint => HistoryBlock) public borrowingHistory;

  
  address owner;
  
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }
  
  constructor() {
    owner = msg.sender;
  }
  
  struct Book {
    uint id;
    string name;
    uint stock;
  }
  
  struct Account {
    // book id, borrowed: true/false
    mapping(uint => bool) booksBorrowed;
  }
  
  struct HistoryBlock {
    address account;
    string book;
    string transactionType;
  }
  
  function addBook(string memory _name, uint _stock) public onlyOwner {
    booksCount += 1;
    books[booksCount] = Book(booksCount, _name, _stock);
  }
  
  function updateStock(uint _id, uint _stock) public onlyOwner {
    books[_id].stock = _stock;
  }
  
  function borrowBook(uint _id) public {
    if(
      libraryAccount[msg.sender].booksBorrowed[_id] != true &&
      books[_id].stock > 0
    ) {
      books[_id].stock -= 1;
      libraryAccount[msg.sender].booksBorrowed[_id] = true;
      
      historyBlockCount += 1;
      borrowingHistory[historyBlockCount] = HistoryBlock(msg.sender, books[_id].name, 'borrowed');
    }
  }
  
  function returnBook(uint _id) public {
    if(libraryAccount[msg.sender].booksBorrowed[_id] != false) {
      books[_id].stock += 1;
      libraryAccount[msg.sender].booksBorrowed[_id] = false;
      
      historyBlockCount += 1;
      borrowingHistory[historyBlockCount] = HistoryBlock(msg.sender, books[_id].name, 'returned');
    }
  }
  
  function checkAccountAffiliation(address _account, uint _id) public view returns(bool) {
    return libraryAccount[_account].booksBorrowed[_id];
  }
}