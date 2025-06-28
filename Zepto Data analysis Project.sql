
select * from zepto_v1

--1. What is the average discount percentage across each product category?--
	select  top 10
			category,
			avg(discountPercent)as Avg_discount
	from zepto_v1
	group by Category 
	order by Avg_discount desc;

--2. Which products have the highest price drop (MRP - Discounted Price)?--
select top 10 name,category,
					mrp,
					discountedSellingPrice,
					(mrp-discountedSellingPrice) as price_drop
from zepto_v1

order by price_drop desc;


--3. Which discounted products are out of stock?
select top 10 category,name,
					mrp as MRP,
					discountedSellingPrice
from zepto_v1 
where discountPercent > 0 and outOfStock = 1
order by discountedSellingPrice desc;

--4. What’s the total potential vs. actual revenue post-discount?--
--problem - the output is exceeded limit of int form so i tried cast & bigint function--
--to check if the limit is exceeded--
-----------try cast & bigint------
select 
	sum(cast(mrp*quantity as bigint)) as potential_revenue,
	sum(cast(discountedSellingPrice*quantity as bigint)) as actual_revenue,
	SUM(cast(mrp*quantity-discountedSellingPrice*quantity as bigint)) as revenue_loss
		from zepto_v1 

--5. Which categories have the most out-of-stock items?--
select category, count(Category) as out_stock_count
from zepto_v1
where outOfStock = 1
group by Category
order by out_stock_count desc;

--M2--
SELECT category, COUNT(*) AS out_stock_count
FROM zepto_v1
WHERE outOfStock = 1
GROUP BY category
ORDER BY out_stock_count DESC;



--6. What’s the average MRP per 100 grams by category?--

select category, 
	   round(avg(cast(mrp as float)/ nullif(weightingms,0)*100),2) as avg_mrp_per_100g

from zepto_v1		
where weightInGms is not null and weightInGms > 0
group by Category
order by avg_mrp_per_100g desc;

 --7. Which exact products are currently out of stock, along with their discounted price and size?--
 SELECT 
    Category,
    name,
    discountedSellingPrice,
    weightInGms
FROM zepto_v1
WHERE outOfStock = 1
ORDER BY Category, name;

--8. Which top 10 products have high stock but low quantity sold?--

select top 10 category,
			name, 
			availablequantity,
			quantity
from zepto_v1 
where availableQuantity >= 0 and quantity <= 5
order by availableQuantity desc;



--9. Are heavier products more heavily discounted?--

select
	case 
		when weightInGms <= 500 then '251-500g'
		when weightInGms <= 1000 then '501-1000g'
		when weightInGms <= 250 then '0-250g'
	else '1000g+'
		end as weight_range,
		avg(discountpercent) as Avg_discount

from zepto_v1

group by 
	 case 
	 when weightInGms <= 500 then '251-500g'
		when weightInGms <= 1000 then '501-1000g'
		when weightInGms <= 250 then '0-250g'
	else '1000g+'
end
order by weight_range;


--10. Which categories have the widest discount range?--
select category,max(discountpercent) - min(discountpercent) as discount_range
from zepto_v1
group by Category
order by discount_range desc;

--11-Which top low-stock products (≤2 units) are still on discount?--
select category,name,
				availableQuantity,
				discountPercent,
				mrp,
				discountedSellingPrice,
				(discountedSellingPrice-mrp) as loss
from zepto_v1
where availableQuantity <= 2 and discountPercent > 0 
order by discountPercent desc;

--12. Is there a trend between discount % and quantity sold?--

	select 
		   case 
				when discountpercent = 0 then '0%'
				when discountpercent between 1 and 10 then '1-10%'
				when discountpercent between 11 and 20 then '11-20%'
				when discountpercent between 20 and 30 then '12-30%'
				when discountpercent between 30 and 40 then '30-40%'
				when discountpercent between 40 and 50 then '40-50%'

				else '50%+'

				end as discount_range,

				avg(quantity) as avg_qty_sold,
				sum(quantity) as total_qty_sold,
				COUNT(*) as product_count
		from zepto_v1
		group by 
			case 
			when discountpercent = 0 then '0%'
				when discountpercent between 1 and 10 then '1-10%'
				when discountpercent between 11 and 20 then '11-20%'
				when discountpercent between 20 and 30 then '12-30%'
				when discountpercent between 30 and 40 then '30-40%'
				when discountpercent between 40 and 50 then '40-50%'
			else '50%+'
		
			end 
			order by discount_range

--13. What is the total revenue loss greater than 1000 due to discounting per category?--
select category, 
				sum(mrp * quantity) as potential_revenue,
				SUM(discountedsellingprice * quantity) as actual_rev,
				sum((mrp - discountedSellingPrice) * quantity) as revenue_loss
							
from zepto_v1
group by Category
order by revenue_loss;


---------------------------------------------------------------------------------------------------------------------------------------------------
--Dipanshu rawat--
---------------------------------------------------------------------------------------------------------------------------------------------------



