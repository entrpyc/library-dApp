// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.5;

import "./Ownable.sol";

contract Contract is Ownable {
    enum Status{ DEFAULT, BORROWED, RETURNED }
    
    struct Book {
        string title;
        uint32 stock;
    }
    
    struct Record {
        address user;
        Status status;
        uint date;
    }
    
    Book[] public books;
    mapping(address => mapping(uint32 => Status)) public libraryAccounts;
    mapping(uint32 => Record[]) public registry;
    
    
    function newBook(string calldata _title, uint32 _quantity) public onlyOwner {
        books.push(Book(_title, _quantity));
    }
    
    function updateStock(uint32 _id, uint32 _quantity) public onlyOwner {
        books[_id].stock = _quantity;
    }
    
    function borrowBook(uint32 _id) public {
        require(libraryAccounts[msg.sender][_id] != Status.BORROWED, "You have already borrowed this book.");
        require(books[_id].stock > 0, "There are no available copies of this book.");
        
        books[_id].stock -= 1;
        libraryAccounts[msg.sender][_id] = Status.BORROWED;
        registry[_id].push(Record(msg.sender, Status.BORROWED, block.timestamp));
    }
    
    function returnBook(uint32 _id) public {
        require(libraryAccounts[msg.sender][_id] == Status.BORROWED, "You currently haven't borrowed this book.");
        
        books[_id].stock += 1;
        libraryAccounts[msg.sender][_id] = Status.RETURNED;
        registry[_id].push(Record(msg.sender, Status.RETURNED, block.timestamp));
    }
}
