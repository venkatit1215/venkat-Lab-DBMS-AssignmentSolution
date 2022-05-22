create database ecommerce;
use ecommerce;
-- 1)create tables
create table if not exists supplier (
SUPP_ID int unsigned not null primary key auto_increment, 
SUPP_NAME varchar(50) not null, 
SUPP_CITY varchar(50) not null, 
SUPP_PHONE varchar(10) not null);

create table if not exists customer (
CUS_ID int unsigned not null primary key auto_increment, 
CUS_NAME varchar(20) not null, 
CUS_PHONE varchar(10) not null, 
CUS_CITY varchar(30) not null, 
CUS_GENDER enum('M','F'));

create table if not exists category (
CAT_ID int unsigned not null primary key auto_increment, 
CAT_NAME varchar(20) not null);

create table if not exists product(
PRO_ID int unsigned not null primary key auto_increment, 
PRO_NAME varchar(20) not null default('dummy'), 
PRO_DESC varchar(60), 
CAT_ID int unsigned not null, 
constraint FK_CAT_ID foreign key (CAT_ID) references category(CAT_ID));

create table if not exists supplier_pricing(
PRICING_ID int unsigned not null primary key auto_increment, 
PRO_ID int unsigned, 
SUPP_ID int unsigned, 
SUPP_PRICE int default(0), 
FOREIGN KEY (PRO_ID) REFERENCES product(PRO_ID),
FOREIGN KEY (SUPP_ID) REFERENCES supplier(SUPP_ID));

create table if not exists `order` (
ORD_ID int unsigned not null primary key auto_increment, 
ORD_AMOUNT int not null, 
ORD_DATE date not null, 
CUS_ID int unsigned, 
PRICING_ID int unsigned, 
foreign key (CUS_ID) references customer(CUS_ID), 
foreign key (PRICING_ID) references supplier_pricing(PRICING_ID)) auto_increment=101;


create table if not exists rating (
RAT_ID int unsigned not null primary key auto_increment, 
ORD_ID int unsigned not null, 
RAT_RATSTARS int unsigned not null, 
foreign key (ORD_ID) references `order`(ORD_ID));

-- 2) insert data into  tables

insert into supplier (SUPP_NAME, SUPP_CITY, SUPP_PHONE) values 
("Rajesh Retails", "Delhi", "1234567890"),
("Appario Ltd.", "Mumbai", "2589631470"),
("Knome products", "Banglore", "9785462315"),
("Bansal Retails", "Kochi", "8975463285"),
("Mittal Ltd.", "Lucknow", "7898456532");
insert into customer (CUS_NAME, CUS_PHONE, CUS_CITY, CUS_GENDER) values
("AAKASH", "9999999999", "DELHI",   "M"),
("AMAN",	  "9785463215", "NOIDA",   "M"),
("NEHA",   "9999999999", "MUMBAI",  "F"),
("MEGHA",  "9994562399", "KOLKATA", "F"),
("PULKIT", "7895999999", "LUCKNOW", "M");

insert into category (CAT_NAME) values
("BOOKS"),
("GAMES"),
("GROCERIES"),
("ELECTRONICS"),
("CLOTHES");

insert into supplier (SUPP_NAME, SUPP_CITY, SUPP_PHONE) values 
("Rajesh Retails", "Delhi", "1234567890"),
("Appario Ltd.", "Mumbai", "2589631470"),
("Knome products", "Banglore", "9785462315"),
("Bansal Retails", "Kochi", "8975463285"),
("Mittal Ltd.", "Lucknow", "7898456532");

insert into supplier_pricing(PRO_ID, SUPP_ID, SUPP_PRICE) values
(1, 2, 1500),
(3, 5, 30000),
(5, 1, 3000),
(2, 3, 2500),
(4, 1, 1000);

insert into `order` (ORD_AMOUNT, ORD_DATE, CUS_ID, PRICING_ID) values
(1500 	,"2021/10/06", 2, 1),
(1000 	,"2021/10/12", 3, 5),
(30000	,"2021/09/16", 5, 2),
(1500 	,"2021/10/05", 1, 1),
(3000 	,"2021/08/16", 4, 3),
(1450 	,"2021/08/18", 1, 3),
(789 	,"2021/09/01", 3, 2),
(780 	,"2021/09/07", 5, 5),
(3000 	,"2021/00/10", 5, 3),
(2500 	,"2021/09/10", 2, 4),
(1000 	,"2021/09/15", 4, 5),
(789 	,"2021/09/16", 4, 1),
(31000	,"2021/09/16", 1, 2),
(1000 	,"2021/09/16", 3, 5),
(3000 	,"2021/09/16", 5, 3),
(99 	,"2021/09/17", 2, 4);

insert into rating (ORD_ID, RAT_RATSTARS) values
(101, 4),
(102, 3),
(103, 1),
(104, 2),
(105, 4),
(106, 3),
(107, 4),
(108, 4),
(109, 3),
(110, 5),
(111, 3),
(112, 4),
(113, 2),
(114, 1),
(115, 1),
(116, 0);

-- Queries
-- 3)
select count(*), c.CUS_GENDER from customer as c inner join `order` as o on c.CUS_ID = o.CUS_ID where o.ORD_AMOUNT>=3000 group by c.CUS_GENDER;
-- 4)
select supplier.SUPP_NAME, product.PRO_NAME, supplier_pricing.PRICING_ID, `order`.ORD_ID, customer.CUS_NAME from `order` 
inner join customer on `order`.CUS_ID=customer.CUS_ID 
inner join supplier_pricing on `order`.PRICING_ID=supplier_pricing.PRICING_ID
inner join supplier on supplier.SUPP_ID=supplier_pricing.SUPP_ID
inner join product on supplier_pricing.PRO_ID=product.PRO_ID
where `order`.CUS_ID=2;

-- 5)
select s.SUPP_NAME, count(p.PRO_NAME) as product_count from supplier as s inner join supplier_pricing as sp on s.SUPP_ID=sp.SUPP_ID
inner join product as p on p.PRO_ID=sp.PRO_ID group by s.SUPP_NAME having count(p.PRO_NAME)>1;

-- 6)
select cat.CAT_ID, cat.CAT_NAME, p.PRO_NAME, sp.SUPP_PRICE from category as cat
inner join product as p on cat.CAT_ID=p.CAT_ID
inner join supplier_pricing as sp on sp.PRO_ID=p.PRO_ID
group by cat.CAT_NAME having min(sp.SUPP_PRICE);

-- 7)
select PRO_ID, PRO_NAME from product where PRO_ID in (select PRO_ID from supplier_pricing where PRICING_ID in (select PRICING_ID from `order` where ORD_DATE > '2021-10-05'));

-- 8)

select CUS_NAME, CUS_GENDER from customer where CUS_NAME like "A%" or CUS_NAME like "%A";

-- 9)

select `order`.PRICING_ID, avg(rating.RAT_RATSTARS) as rating, case 
when avg(rating.RAT_RATSTARS)=5 then 'Excellent Service'
when avg(rating.RAT_RATSTARS)>4 then 'Good Service'
when avg(rating.RAT_RATSTARS)>2 then 'Average Service'
else 'Poor Service' end as Type_of_Service from `order` 
inner join rating where `order`.ORD_ID=rating.ORD_ID group by `order`.PRICING_ID;










