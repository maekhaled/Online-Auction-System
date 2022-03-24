
create database onlineauctiondemo1;
use onlineauctiondemo12;

CREATE table users(
	username varchar(50),
	password varchar(20),
	userType varchar(50),
	Primary Key(username)
);

CREATE table admin(
	username varchar(50),
	password varchar(20),
	Primary Key(username)
);

CREATE table customerRep(
	username varchar(50),
	password varchar(20),
	Primary Key(username)
);

CREATE table endUser(
	username varchar(50),
	password varchar(20),
	Primary Key(username)
);

CREATE table buyer(
	username varchar(50),
	Primary Key (username),
	Foreign Key (username) references endUser(username) 
	ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE table seller(
	username varchar(50),
	Primary Key (username),
	Foreign Key (username) references endUser(username)
	ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE table tickets(
	ticketNumber varchar(20),
	subject varchar(50),
	submissionUser varchar(50),
	assignedRep varchar(50),
	originalQuestion varchar(4000),
	isCompleted tinyint default 0 not null,
	Primary key(ticketNumber)
);

CREATE table submitsQuestion(
	username varchar(50),
	subject	 varchar(40),
	originalQuestion varchar(4000),
    ticketNumber varchar(20),
	Primary Key (username),
	Foreign Key (ticketNumber) references tickets(ticketNumber)
ON UPDATE CASCADE ON DELETE CASCADE,
Foreign Key (username) references users(username)
ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE table sendsAnswer(
username varchar(50),
response varchar(4000),
	Primary Key (username),
	Foreign Key (ticketNumber) references item(tickets)
ON UPDATE CASCADE ON DELETE CASCADE,
Foreign Key (username) references users (username)
ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE table messages(
	ticketNumber varchar(20),
	threadNumber int,
	src varchar(50),
	dest varchar(50),
	body varchar(4000),
	timestamp date,
Primary Key (ticketNumber, threadNumber),
	Foreign Key (ticketNumber) references tickets(ticketNumber)
	ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE table postItem(
	itemID int,
	sellerID varchar(50),
	subcategory varchar(20),
	title varchar(50),
details varchar(100),
	initialPrice float,
currBid float,
	minPrice float,
	increment float,
	sold enum('true','false'),
	endDate datetime,
	Primary Key(itemID),
	Foreign Key(sellerID) references seller(username)
	ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE table placeBidOn(
	bidID int,
	bidSeq int,
	itemID int,
	buyerID varchar(50),
	bidPrice float,
	max float,
	messaged enum('true','false'),
	Primary Key (bidID),
	Foreign Key (itemID) references postItem(itemID)
ON UPDATE CASCADE ON DELETE CASCADE,
Foreign Key (buyerID) references buyer(username)
ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE table tops(
	itemID int,
	size enum('x-small', 'small', 'medium', 'large', 'x-large'),
	topType varchar(20),
	color varchar(20),
	material varchar(20),
	Primary Key(itemID),
	Foreign Key(itemID) references postItem(itemID)
	ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE table bottoms(
	itemID int,
	waistSize float,
	length float,
	color varchar(20),
	material varchar(20),
	Primary Key(itemID),
	Foreign Key(itemID) references postItem(itemID)
	ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE table shoes(
	itemID int,
	shoeSize float,
	shoeType varchar(30),
            color varchar(20),
           brand varchar(30),
	Primary Key(itemID),
	Foreign Key(itemID) references postItem(itemID)
	ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE table alerts(username varchar(50), 
alertNumber int, 
subcategory varchar(10),
title varchar(50), 
primary key (username, alertNumber), 
foreign key (username) references user(username)
ON UPDATE CASCADE ON DELETE CASCADE
);


