-- lets create tables to import our values into 
create table sales_dataset(
OrderID text,
"Date" text,
CustomerID text,
Product text,
Quantity text,
UnitPrice text,
ShippingAddress text,
PaymentMethod text,
OrderStatus text,
TrackingNumber text,
ItemsInCart text,
CouponCode text,
ReferralSource text,
TotalPrice text
);

create table steps_log (
    step_id serial primary key,
    step_description text,
    action_taken text,
    reason text
);
-- lets clean our table before checking for duplicate rows using orderid
-- first we change column types to standard form
alter table sales_dataset
alter column orderid type varchar(20) using orderid :: varchar(20),
alter column "Date" type date using "Date" :: date,
alter column customerid type varchar(8) using customerid :: varchar(8),
alter column quantity type int using quantity :: int,
alter column unitprice type numeric(10,2) using unitprice :: numeric(10,2),
alter column paymentmethod type varchar(30) using PaymentMethod :: varchar(30),
alter column orderstatus type varchar(20) using orderstatus :: varchar(20),
alter column trackingnumber type varchar(20) ,
alter column itemsincart type int using ItemsInCart :: int,
alter column couponcode type varchar(20) using couponcode :: varchar(20),
alter column referralsource type varchar(30) using referralsource :: varchar(30),
alter column totalprice type numeric(20,2) using totalprice :: numeric(20,2);

-- lets rename date column to lower to stop error from casing issues
alter table sales_dataset
rename "Date" to "date";


-- weve loaded our data, first lets check for duplicates
select * from sales_dataset
limit 20;

select * from steps_log;

select *
from sales_dataset
group by orderid
having count (*) > 1;

-- lets identify missing values
-- first for non text columns (they dont require regex to check fake nulls)
select * from sales_dataset
where "date" is null
      or quantity is null
      or unitprice is null
      or itemsincart is null
      or  totalprice is null;


-- for text values
select * from sales_dataset; 
where orderid is null
      or customerID is null
      or product is null
      or shippingaddress is null
      or paymentmethod is null
      or orderstatus is null
      or trackingnumber is null
      or couponcode is null;

	 
-- and now regex for fake nulls in text and varchar columns
SELECT *
FROM sales_dataset
WHERE orderid IS NULL
   OR TRIM(orderid) = ''
   OR orderid ~ '^(--|-|\.)$'
   OR LOWER(TRIM(orderid)) IN ('null', 'n/a', 'na')
   
   or
   WHERE customerid IS NULL
   OR TRIM(customerid) = ''
   OR customerid ~ '^(--|-|\.)$'
   OR LOWER(TRIM(customerid)) IN ('null', 'n/a', 'na')
   
   or
   WHERE product IS NULL
   OR TRIM(product) = ''
   OR product ~ '^(--|-|\.)$'
   OR LOWER(TRIM(product)) IN ('null', 'n/a', 'na')
   
   or 
   WHERE shippingaddress IS NULL
   OR TRIM(shippingaddress) = ''
   OR shippingaddress ~ '^(--|-|\.)$'
   OR LOWER(TRIM(shippingaddress)) IN ('null', 'n/a', 'na')
   
   or
   WHERE paymentmethod IS NULL
   OR TRIM(paymentmethod) = ''
   OR paymentmethod ~ '^(--|-|\.)$'
   OR LOWER(TRIM(paymentmethod)) IN ('null', 'n/a', 'na')
   
   or
   WHERE orderstatus IS NULL
   OR TRIM(orderstatus) = ''
   OR orderstatus ~ '^(--|-|\.)$'
   OR LOWER(TRIM(orderstatus)) IN ('null', 'n/a', 'na')
   
   or
   WHERE trackingnumber IS NULL
   OR TRIM(trackingnumber) = ''
   OR trackingnumber ~ '^(--|-|\.)$'
   OR LOWER(TRIM(trackingnumber)) IN ('null', 'n/a', 'na')
   
   or
   WHERE couponcode IS NULL
   OR TRIM(couponcode) = ''
   OR couponcode ~ '^(--|-|\.)$'
   OR LOWER(TRIM(couponcode)) IN ('null', 'n/a', 'na')
   
   or
   WHERE referralsource IS NULL
   OR TRIM(referralsource) = ''
   OR referralsource ~ '^(--|-|\.)$'
   OR LOWER(TRIM(referralsource)) IN ('null', 'n/a', 'na');



-- lets update our steps table
select * from steps_log;

insert into steps_log(step_id, step_description, action_taken, reason)
values ('0001','table creation', 'created both tables; sales data and steps log','to import our data from csv to sql'),
       ('0002','correcting data format','we ran code to alter each columns data type','we imported all our data columns as text format'),
       ('0003','checking for duplicates','we ran code to check for duplicates, using the orderid(pk) column','checking to see if the orderid column is truly unique and for duplicates')
	   ;

insert into steps_log(step_id, step_description, action_taken, reason)
values ('0004','identified missing values', 'ran code to find nulls and fake nulls','to find missing values - we found valid nulls in coupon code column')
       ('0005','raw table creation', 'created fresh tables for raw data importation', 'backup raw sales data for our schemas');

-- lets find mean, median, mode and count values of our data
-- mean
select avg("quantity") as mean_quantity,
       avg("unitprice") as mean_unitprice,
	   avg("itemsincart") as mean_itemsincart,
	   avg("totalprice") as mean_totalprice
from sales_dataset;

-- median
select
    percentile_cont(0.5)
    within group (order by "quantity") as median_quantity,
	percentile_cont(0.5)
	within group (order by "unitprice") as median_unitprice,
	percentile_cont(0.5) 
	within group (order by "itemsincart") as median_itemsincart,
	percentile_cont(0.5)
	within group (order by "totalprice") as median_totalprice
from sales_dataset;

-- mode
select 
   mode() within group (order by "quantity") as mode_quantity,
   mode() within group (order by "unitprice") as mode_unitprice,
   mode() within group (order by "itemsincart") as mode_itemsincart,
   mode() within group (order by "totalprice") as mode_totalprice
from sales_dataset;

-- total row count
select count(*) as total_orders
from sales_dataset;

-- lets create boundaries to find potential outliers for each column individually 
with quartiles as(
select 
percentile_cont (0.25)
within group (order by "quantity") as quantity_q1,
percentile_cont(0.75) 
within group (order by "quantity") as quantity_q3
from sales_dataset),
boundaries as(
select
  quantity_q1,
  quantity_q3,
  quantity_q1 - (1.5 * quantity_q3 - quantity_q1) as quantity_lower_bound,
  quantity_q3 + (1.5 * quantity_q3 - quantity_q1) as quantity_upper_bound
  from quartiles
)
-- then confirm boundaries
select 
quantity_lower_bound,
quantity_upper_bound
from boundaries;

 -- then run min max queries
 select 
 min(quantity),
 max(quantity)
 from sales_dataset;
 
 -- and count the possible outliers in our quantity column
with quartiles as(
select 
percentile_cont (0.25)
within group (order by "quantity") as quantity_q1,
percentile_cont(0.75) 
within group (order by "quantity") as quantity_q3
from sales_dataset),
boundaries as(
select
  quantity_q1,
  quantity_q3,
  quantity_q1 - (1.5 * quantity_q3 - quantity_q1) as quantity_lower_bound,
  quantity_q3 + (1.5 * quantity_q3 - quantity_q1) as quantity_upper_bound
  from quartiles
)select count (*) as outlier_count
  from sales_dataset as s
  cross join boundaries as b
where s.quantity < b.quantity_lower_bound
      or s.quantity > b.quantity_upper_bound;




-- lets create boundaries to find potential outliers for each column individually 
-- unitprice
with quartiles as(
select 
percentile_cont (0.25)
within group (order by "unitprice") as unitprice_q1,
percentile_cont(0.75) 
within group (order by "unitprice") as unitprice_q3
from sales_dataset),
boundaries as(
select
  unitprice_q1,
  unitprice_q3,
  unitprice_q1 - (1.5 * unitprice_q3 - unitprice_q1) as unitprice_lower_bound,
  unitprice_q3 + (1.5 * unitprice_q3 - unitprice_q1) as unitprice_upper_bound
  from quartiles
)
 -- then count the possible outliers in our quantity column
with quartiles as(
select 
percentile_cont (0.25)
within group (order by "unitprice") as unitprice_q1,
percentile_cont(0.75) 
within group (order by "unitprice") as unitprice_q3
from sales_dataset),
boundaries as(
select
  unitprice_q1,
  unitprice_q3,
  unitprice_q1 - (1.5 * unitprice_q3 - unitprice_q1) as unitprice_lower_bound,
  unitprice_q3 + (1.5 * unitprice_q3 - unitprice_q1) as unitprice_upper_bound
  from quartiles
)select count (*) as outlier_count
  from sales_dataset as s
  cross join boundaries as b
where s.unitprice < b.unitprice_lower_bound
      or s.unitprice > unitprice_upper_bound;

	  
-- then confirm boundaries
with quartiles as(
select 
percentile_cont (0.25)
within group (order by "unitprice") as unitprice_q1,
percentile_cont(0.75) 
within group (order by "unitprice") as unitprice_q3
from sales_dataset),
boundaries as(
select
  unitprice_q1,
  unitprice_q3,
  unitprice_q1 - (1.5 * unitprice_q3 - unitprice_q1) as unitprice_lower_bound,
  unitprice_q3 + (1.5 * unitprice_q3 - unitprice_q1) as unitprice_upper_bound
  from quartiles
)select 
unitprice_lower_bound,
unitprice_upper_bound
from boundaries;

 -- then run min max queries
 with quartiles as(
select 
percentile_cont (0.25)
within group (order by "unitprice") as unitprice_q1,
percentile_cont(0.75) 
within group (order by "unitprice") as unitprice_q3
from sales_dataset),
boundaries as(
select
  unitprice_q1,
  unitprice_q3,
  unitprice_q1 - (1.5 * unitprice_q3 - unitprice_q1) as unitprice_lower_bound,
  unitprice_q3 + (1.5 * unitprice_q3 - unitprice_q1) as unitprice_upper_bound
  from quartiles
)select 
 min(unitprice),
 max(unitprice)
 from sales_dataset;

-- itemsincart
with quartiles as(
select 
percentile_cont (0.25)
within group (order by "itemsincart") as itemsincart_q1,
percentile_cont(0.75) 
within group (order by "itemsincart") as itemsincart_q3
from sales_dataset),
boundaries as(
select
  itemsincart_q1,
  itemsincart_q3,
  itemsincart_q1 - (1.5 * itemsincart_q3 - itemsincart_q1) as itemsincart_lower_bound,
  itemsincart_q3 + (1.5 * itemsincart_q3 - itemsincart_q1) as itemsincart_upper_bound
  from quartiles
)
 -- then count the possible outliers in our quantity column
select count (*) as outlier_count
  from sales_dataset as s
  cross join boundaries as b
where s.itemsincart< b.itemsincart_lower_bound
      or s.itemsincart > itemsincart_upper_bound;

	  
-- then confirm boundaries
with quartiles as(
select 
percentile_cont (0.25)
within group (order by "itemsincart") as itemsincart_q1,
percentile_cont(0.75) 
within group (order by "itemsincart") as itemsincart_q3
from sales_dataset),
boundaries as(
select
  itemsincart_q1,
  itemsincart_q3,
  itemsincart_q1 - (1.5 * itemsincart_q3 - itemsincart_q1) as itemsincart_lower_bound,
  itemsincart_q3 + (1.5 * itemsincart_q3 - itemsincart_q1) as itemsincart_upper_bound
  from quartiles
)select 
itemsincart_lower_bound,
itemsincart_upper_bound
from boundaries;

 -- then run min max query
 with quartiles as(
select 
percentile_cont (0.25)
within group (order by "itemsincart") as itemsincart_q1,
percentile_cont(0.75) 
within group (order by "itemsincart") as itemsincart_q3
from sales_dataset),
boundaries as(
select
  itemsincart_q1,
  itemsincart_q3,
  itemsincart_q1 - (1.5 * itemsincart_q3 - itemsincart_q1) as itemsincart_lower_bound,
  itemsincart_q3 + (1.5 * itemsincart_q3 - itemsincart_q1) as itemsincart_upper_bound
  from quartiles
)select 
 min(itemsincart),
 max(itemsincart)
 from sales_dataset;




-- totalprice
with quartiles as(
select 
percentile_cont (0.25)
within group(order by "totalprice") as totalprice_q1,
percentile_cont(0.75)
within group(order by "totalprice") as totalprice_q3
from sales_dataset
),
boundaries as(
select
totalprice_q1,
totalprice_q3,
totalprice_q1 - (1.5 * (totalprice_q3 - totalprice_q1)) as totalprice_lower_bound,
totalprice_q3 + (1.5 * (totalprice_q3 - totalprice_q1)) as totalprice_upper_bound
from quartiles
)
-- count outliers
select count (*) as outlier_count
from sales_dataset as s
cross join boundaries as b
where s.totalprice < b.totalprice_lower_bound
   or s.totalprice > b.totalprice_upper_bound;
-- validate outliers with min, max data values
select 
min(totalprice), max(totalprice)
from sales_dataset;
-- check occurences 
with quartiles as(
select 
percentile_cont (0.25)
within group(order by "totalprice") as totalprice_q1,
percentile_cont(0.75)
within group(order by "totalprice") as totalprice_q3
from sales_dataset
),
boundaries as(
select
totalprice_q1,
totalprice_q3,
totalprice_q1 - (1.5 * (totalprice_q3 - totalprice_q1)) as totalprice_lower_bound,
totalprice_q3 + (1.5 * (totalprice_q3 - totalprice_q1)) as totalprice_upper_bound
from quartiles
)select * from sales_dataset as s
cross join boundaries as b
where s.totalprice < b.totalprice_lower_bound
   or s.totalprice > b.totalprice_upper_bound;


-- lets update our steps_log
 select * from steps_log
 order by step_id;
 
 select * from sales_dataset;

update steps_log
set action_taken = 'ran code to find mean, median, mode and order count values'
where step_id = 6;

insert into steps_log(step_id, step_description, action_taken, reason)
values('0006', 'finding statictical values', 'ran code to find the mean, median and mode', 'to understand the distribution of the data'),
      ('0007', 'creating outlier boundaries', 'created boundaries using q1, q3 and then iqr', 'to find possible outliers in our data'),
      ('0008', 'checking for outliers', 'we ran code to count the possible outliers in each important numerical column', 'to find the columns that contained possible outliers'),
      ('0009', 'outlier search result validation',' ran code to validate the outlier search by finding the min and max values for each important numerical column', 'to ensure that the search query returned accurate results'),
	  ('0010', 'outlier validation', 'then we ran code to inspect the outliers found in our data', 'we needed to validate the 8 outliers in the totalprice/revenue column')

select * from steps_log;
