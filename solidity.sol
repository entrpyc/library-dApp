// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.0;

import "./Ownable.sol";

contract Library is Ownable {
    event BookAdded(uint32 _id, string _title, uint32 _stock);
    event BookBorrowed(address _userId, uint32 _bookId);
    event BookReturned(address _userId, uint32 _bookId);
    event BookStockUpdated(uint32 _id, string _title, uint32 _stock);
    
    struct Book {
        uint32 id;
        string title;
        uint32 stock;
        address[] usersThatBorrowedTheBook;
    }
    
    struct Record {
        address user;
        bool status;
        uint date;
    }
    
    mapping(uint32 => Book) public books;
    uint32[] public booksIds;
    
    mapping(address => mapping(uint32 => bool)) public userBorrowedBook;
    
    
    function addBook(string calldata _title, uint32 _quantity) public onlyOwner {
        uint32 _id = uint32(booksIds.length);
        
        books[_id] = Book(_id, _title, _quantity, new address[](0));
        booksIds.push(_id);
        
        emit BookAdded(_id, _title, _quantity);
    }
    
    function updateStock(uint32 _id, uint32 _quantity) public onlyOwner {
        books[_id].stock = _quantity;
        
        emit BookStockUpdated(_id, books[_id].title, _quantity);
    }
    
    function borrowBook(uint32 _id) public {
        require(userBorrowedBook[msg.sender][_id] == false, "You have already borrowed this book.");
        require(books[_id].stock > 0, "There are no available copies of this book.");
        
        books[_id].stock -= 1;
        userBorrowedBook[msg.sender][_id] = true;
        books[_id].usersThatBorrowedTheBook.push(msg.sender);
        
        emit BookBorrowed(msg.sender, _id);
    }
    
    function returnBook(uint32 _id) public {
        require(userBorrowedBook[msg.sender][_id] == true, "You currently haven't borrowed this book.");
        
        books[_id].stock += 1;
        userBorrowedBook[msg.sender][_id] = false;
        books[_id].usersThatBorrowedTheBook.push(msg.sender);
        
         emit BookReturned(msg.sender, _id);
    }
    
    function getBooksIdsLength() public view returns(uint count) {
        return booksIds.length;
    }
    
    function getBooksIds() public view returns(uint32[] memory){
        return booksIds;
    }
    
    function getUsersThatBorrowedBook(uint32 _id) public view returns(address[] memory){
        return books[_id].usersThatBorrowedTheBook;
    }
}
