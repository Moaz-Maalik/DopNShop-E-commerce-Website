drop database DropNShop
go
create database DropNShop
go
use DropNShop
go
--------------------TABLES AND THEIR PRINTING--------------------
select * from customers
select * from products
select * from review
select * from orders

Update customers
Set customerBalance = 100000
Where customerEmail = 'waleed@gmail.com'

Delete 
From products
Where productName = 's10'

create table customers
(
	customerID int,
	customerName varchar(50) not null, 	
	customerEmail varchar(50) unique not null, 
	customerPassword varchar(50) not null,
	customerNumber varchar(50), 
	customerAddress varchar(50) not null, 
	customerBalance int,

	primary key(customerID)

)

insert into customers values (1, 'Waleed', 'waleed@gmail.com', 'yoyooyoy', '03201486077', 'Dha, lahore', 125000);
insert into customers values (2, 'Haider', 'haider@gmail.com', 'iLUVsteinsGate', '1234566', 'Nespack, Lahore', 110500);
insert into customers values (0, 'Admin' , 'admin@gmail.com', 'admin', '111', 'Society for Admins', 9999999);

drop table products
create table products
(
	productID int,
	productCompanyName varchar(50) not null,
	productName varchar (50) not null,
	productPrice int not null,
	productAmount int,
	productCategory varchar(50) not null,
	primary key (productID)

)

alter table review add constraint FK_productName foreign key (reviewProductID) references dbo.products (productID) on delete cascade on update Cascade


insert into products values (1, 'Samsung', 's10', 90000, 10, 'mobile');
insert into products values (2, 'Nvidia', 'gtx 1060', 35000, 3, 'graphic card');
insert into products values (3, 'De Legend', 'Legendary keYboArd', 200, 1, 'keyboard');
insert into products values (4, 'Pampers', 'diapers size XL', 150, 40, 'Diapers');
insert into products values (5, 'Google', 'pixel 3', 80000, 20, 'mobile');
insert into products values (6, 'Mi', 'Piston basic(earphones)', 900, 70, 'earphone');
insert into products values (7, 'Razer', 'Blackwidow Chroma', 20000, 15, 'keyboard');
insert into products values (8, 'Redragon', 'm711 cobra', 2400, 20, 'mouse');
insert into products values (9, 'Razer', 'kraken (pewdiepie edition)', 15000, 25, 'headphone');
insert into products values (10, 'Intel', 'i5-8400', 40000, 30, 'cpu');
insert into products values (11, 'Bluedio', 'Wireless earphones', 2500, 35, 'earphone');
insert into products values (12, 'Nokia', 'Nokia 6.1 plus', 32000, 20, 'mobile');
insert into products values (13, 'Google', 'Pixel buds', 17000, 15, 'earphone');
insert into products values (15, 'Apple', 'iPhone 7', 55000, 40, 'mobile');

Update products
Set productName = 'Piston Basic'
Where productID = 6

Update products
Set productName = 'T7'
Where productID = 11

drop table Discounts
create table Discounts
(
	productID int,
	discountPercentage int not null,
	expiryDate date not null,
	primary key (productID),
	foreign key (productID) references products(productID)
)

drop table orders
create table orders
(
	orderID int, 
	orderCustomerEmail varchar(50) not null,
	orderProductID int not null, 
	orderDate date not null, 
	deliveryDate date not null, 

	primary key(orderID),
	foreign key (orderCustomerEmail) references customers(customerEmail),
	foreign key (orderProductID) references products(productID)

)

drop table review
create table review
(
	reviewID int,
	reviewCustomerID int not null,
	reviewProductID int not null,
	reviewDescription varchar(500),
	reviewStars int not null,
	primary key (reviewID),
	foreign key (reviewCustomerID) references customers(customerID),
	foreign key (reviewProductID) references products(productID)
)


----------------------------Client Procedures----------------------------
--------------------Login Page--------------------
drop Procedure LoginPage
go
Create Procedure LoginPage
(
	@Email varchar(50), 
	@Password varchar(16),
	@returnCheck int OUT
)
As
Begin
	If Exists
	(
		Select * 
		From customers 
		Where customers.customerEmail = @Email and customers.customerPassword = @Password
	)
	Begin
		Set @returnCheck = 1
		Print 'Login Succesful'
	End
	Else
	Begin
		Set @returnCheck = 0
		Print 'Login Failed (Combination does not match)'
	End
End

Declare @checkValue int
Exec LoginPage 'haider@gmail.com', 'iLUVsteinsgate', @returnCheck = @checkValue
go
select * from customers

--------------------Signup Page--------------------
drop procedure SignupPage
go
Create Procedure SignupPage
(
	@CustomerName varchar(50), 
	@CustomerEmail varchar(50), 
	@CustomerPassword varchar(16), 
	@CustomerNumber varchar(50), 
	@CustomerAddress varchar(50),
	@returncheck int OUT
)
As
Begin
	If Exists(Select * From customers Where customers.customerEmail = @CustomerEmail)
		Begin
			Set @returncheck = 0
			Print 'Signup Failed. Error 69 : Email Already in Use.'
		End
	Else
		Begin
			Declare @ID int
			Select @ID = count(*) From Customers
			Set @ID = @ID + 1
			
			Insert Into  customers (customerID, customerName, customerEmail,customerPassword,customerNumber,customerAddress) values (@ID, @CustomerName, @CustomerEmail, @CustomerPassword, @CustomerNumber, @CustomerAddress)
			
			Set @returncheck = 1
			print 'SignUp successful of ' + @CustomerName
		End
End

select * from customers

Exec SignupPage 'haleed', 'lmao@gmail.com', 'pass5', '032030','Society of Weebs'
go

--------------------Buying Item From Store--------------------
drop procedure buyingItem
go
create procedure buyingItem
(
	@currentUserEmail varchar (50),
	@itemID int,
	@returnCheck int output
)
As 
Begin

	Declare @id int

	if exists
	(
		select *
		from orders
	)
	begin
		select @id = count(orderID) + 1
		from orders
	end

	else
	begin
		set @id = 1
	end


	declare @amountToBeDeducted int
	select @amountToBeDeducted = p.productPrice
	from products as p
	where p.productID = @itemID
	

	update customers
	set customerBalance = customerBalance - @amountToBeDeducted
	where customerEmail = @currentUserEmail

	if
	(
		select customerBalance
		from customers
		where customerEmail = @currentUserEmail
	) > -1
	begin
		set @returnCheck = 1
		update products
		set productAmount = productAmount - 1
		where productID = @itemID

		insert into orders values (@id, @currentUserEmail, @itemID, getdate(), getdate() + 7)

	end
	else
	begin
		set @returnCheck = 0
		update customers
		set customerBalance = customerBalance + @amountToBeDeducted
		where customerEmail = @currentUserEmail
	
		print 'Current balance is insufficient!'
	end

End

declare @checkValue int
execute buyingItem 'waleed@gmail.com',3,@returnCheck = @checkValue out
select @checkValue


go
--------------------Review Product--------------------
drop procedure reviewProduct
go
create procedure reviewProduct
@customerID int,
@itemID int,
@review varchar (500), 
@stars int
as begin
	declare @id int
	if exists
	(
		select *
		from review
	)
	begin
		select @id = count(*) + 1
		from review
	end

	else
	begin
		set @id = 1
	end

	if not exists 
	(
		select*
		from review
		where reviewCustomerID = @customerID and reviewProductID = @itemID

	)
	begin
		insert into review values (@id, @customerID, @itemID, @review, @stars)
	end

	else 
	print 'Review already posted!'
	
	
end

execute reviewProduct 1, 1, 'This was excellent', 5
execute reviewProduct 2, 1, 'This was good', 4
execute reviewProduct 1, 3, 'This was faulty', 2
execute reviewProduct 2, 3, 'This came broken and they wont respond', 1
execute reviewProduct 1, 2, 'This is a very enonomic and performance is great', 5
execute reviewProduct 2, 2, 'Gtx 1060 proves to be the king of mid range gaming', 5
execute reviewProduct 3, 4, 'Diapers are a little expensive but were really comfortable and my baby had a good sleep', 4
execute reviewProduct 3, 5, 'Pixel 3 has a very ugly look to it, and that is why I dont use it anymore', 2
execute reviewProduct 3, 6, 'Mi yet has proved to build an amazing product in an amazing price', 5
execute reviewProduct 3, 7, 'An average keyboard with an okay key mechanics, but price is insane', 3
execute reviewProduct 4, 5, 'Pixel 3 has the best mobile camera, and software in the world, but lacks in design',4
execute reviewProduct 4, 6, 'Bought the Mi piston basic earphones because they were cheap, but they proved to be very durable and good quality', 5
execute reviewProduct 4, 7, 'Razer charges $150 for RGB and the rest $50 is for the actual keyboard', 3
execute reviewProduct 4, 8, 'Redragon has the best budget mice, but they do feel less durable', 4
execute reviewProduct 4, 9, 'i5-8400 price is too high in Pakistan, but it gives good performance',5



--------------------Read Reviews--------------------
drop procedure readReviews
go
Create procedure readReviews
(
	@itemID int
)
As 
Begin
	select r.reviewCustomerID, p.productName, r.reviewDescription, r.reviewStars
	from review as r
	inner join products as p on(p.productID = r.reviewProductID)
	where r.reviewProductID = @itemID
End

execute readReviews 1
go


--------------------Print Current User Details--------------------
drop procedure currentUserDetails
go
create Procedure currentUserDetails
(
	@currentUser varchar(50)
)
As
Begin
	If not Exists (Select * From customers Where customers.customerEmail = @currentUser)
	Begin
		Print 'User doesnt Exist'
	End
	
	Else
	Begin
		Select *
		From customers
		Where customers.customerEmail = @currentUser
	End
End

Exec currentUserDetails 'waleed@gmail.com'
go

--------------------Display A Products Average Rating--------------------
drop procedure displayAvgRating
go
Create procedure displayAvgRating
(
	@productID int
)
As
Begin
	Select avg(reviewStars)
	From dbo.review
	Where review.reviewProductID = @productID
	Group by review.reviewProductID
End

Execute displayAvgRating 2
go


--------------------Search Bar--------------------
drop procedure searchBar
go
Create procedure searchBar
(
	@searchString varchar(50)
)
As
Begin
	If Exists
	(
		Select *
		From products
		Where products.productName like '%' + @searchString + '%'
	)
	Begin
		Select *
		From products
		Where products.productName like '%' + @searchString + '%'
	End
	Else
	Begin
		If Exists 
		(
			Select *
			From products
			Where products.productCategory like '%' + @searchString + '%'
		)
		Begin
			Select *
			From products
			Where products.productCategory like '%' + @searchString + '%'
		End
	End
End

Execute searchBar 'earphone'
go


--------------------client's HomePage--------------------
create procedure clientHomePage
As
Begin
	Select products.productID, products.productName, avg(reviewStars)
	From products
	Inner join review ON (products.productID = review.reviewProductID)
	Group by products.productID, products.productName
	Having avg(reviewStars) > 2
End
go

execute clientHomePage

--------------------Popular Products--------------------
go
create procedure popularProducts
as
begin
	select p.productId, p.productCategory, p.productCompanyName, p.productName, p.productPrice, p.productAmount, avg(r.reviewStars) as [Average Rating]
	from products as p
	inner join review as r on (r.reviewProductID = p.productID)
	group by p.productId, p.productCategory, p.productCompanyName, p.productName, p.productPrice, p.productAmount
	having avg(r.reviewStars) > 3

end

execute popularProducts

--------------------Categories--------------------
go
Create procedure productCategories
As
Begin
	Select distinct products.productCategory
	From products
	Order by productCategory asc
End


--------------------Change Current User's Password--------------------
go
Create procedure changePassword
(
	@email varchar(50),
	@password varchar(16),
	@newPassword varchar(16),
	@returnCheck int OUTPUT
)
As
Begin
	If Exists
	(
		Select * 
		From customers 
		Where customers.customerEmail = @Email and customers.customerPassword = @Password
	)
	Begin
		Update customers
		Set customerPassword = @newPassword
		Where customerPassword = @password and customerEmail = @email
		Set @returnCheck = 1
	End
	Else
	Begin
		Set @returnCheck = 0
		Print 'Password/Email Combination does not match'
	End
End

Declare @checkValue int
Exec changePassword 'haider@gmail.com','iLUVsteinsgate','dropnshopCEO', @returnCheck = @checkValue


------------------------------------------------------------ADMIN'S POWERS------------------------------------------------------------
drop procedure deleteReview
go
Create Procedure deleteReview
(
	@reviewID int
)
As
Begin
	Delete 
	From review
	Where review.reviewID = @reviewID
End

Execute deleteReview 2

--------------------Add New Item In Store--------------------
drop procedure addNewItem
go
Create Procedure addNewItem
(
	@productCategory varchar (50),
	@productCompanyName varchar(50),
	@productName varchar(50),
	@productPrice int,
	@productAmount int,
	@returnCheck int out
)
As
Begin
	declare @id int
	if exists
	(
		select *
		from products
	)
	Begin
		Select top 1 @id = productID
		from products
		Order by productID desc
	End

	Set @id = @id + 1

	if not exists
	(
		Select *
		From products
		Where products.productName = @productName
	)
	Begin
		Set @returnCheck = 1
		Insert into products values (@id, @productCompanyName, @productName, @productPrice, @productAmount,@productCategory)
	End
	Else
	Begin
		Set @returnCheck = 0
		print 'Product Already in Store'
	End

End

declare @checkValue int
Execute addNewItem 'Phone','Samsung','Note10', 135000, 69
select @checkValue


--------------------Delete Item From Store--------------------
drop procedure deleteItem
go
Create Procedure deleteItem
(
	@productName varchar(50),
	@returnCheck int out
)
As
Begin
	If Exists
	(
		Select * 
		From products
		Where products.productName = @productName
	)
	Begin
		Set @returnCheck = 1
		Delete 
		From products
		Where products.productName = @productName
	End
	Else
	Begin
		Set @returnCheck = 0
		print 'Product doesnt exist'
	End
End




--------------------Add Discount On Item--------------------
drop procedure addDiscount
go
Create procedure addDiscount
(
	@productID int,
	@discountPercentage int,
	@expiryDate date
)
As
Begin
	insert into Discounts values (@productID, @discountPercentage, @expiryDate)
End

Execute addDiscount 1,10,'2019-5-28'
Execute addDiscount 3,10,'2019-5-20'
Execute addDiscount 2,15,'2019-4-20'
Select * from Discounts

--------------------Delete Discount On Item--------------------
drop procedure deleteDiscount
go
Create procedure deleteDiscount
As
Begin
	Delete 
	From Discounts
	Where Discounts.expiryDate < GETDATE()
End

Execute deleteDiscount

--------------------Restock Items--------------------
drop procedure restockItems
go
Create procedure restockItems
(
	@productID int
)
As
Begin
	--This procedure checks if quantity is less than 10, then it restocks it.
	Update Products
	Set productAmount = productAmount + 10
	Where productAmount < 10
	
End

select * From review
