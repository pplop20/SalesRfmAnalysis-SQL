--Inspect Data
select *
from [dbo].[sales_data_sample]

--Checking unique values
select distinct status from [dbo].[sales_data_sample] --Could be plotted
select distinct YEAR_ID from [dbo].[sales_data_sample]
select distinct PRODUCTLINE from [dbo].[sales_data_sample] --Could be Plotted
select distinct COUNTRY from [dbo].[sales_data_sample]  --Could be Ploted
select distinct DEALSIZE from [dbo].[sales_data_sample] --Could be Plotted
select distinct TERRITORY from [dbo].[sales_data_sample] --Could be Plotted

--ANALYSIS
--Group sales by PRODUCTLINE
select PRODUCTLINE, SUM(sales) Revenue
from [dbo].[sales_data_sample]
group by PRODUCTLINE 
order by 2 desc

--Sales across year
select YEAR_ID, SUM(sales) Revenue
from [dbo].[sales_data_sample]
group by YEAR_ID 
order by 2 desc --It's weird why the revenue from 2005 is so drastically less than the other 3 years

select distinct MONTH_ID from [dbo].[sales_data_sample]
where YEAR_ID = 2005  --So in 2005 they operated only for 5 months, it makes sense now why their revenue wasn't as high as in other years

--Sales per deal size
select DEALSIZE, SUM(sales) Revenue
from [dbo].[sales_data_sample]
group by DEALSIZE 
order by 2 desc --Medium sized deals are the ones that generate more revenue apparently

-- Best month for sales in a particular year, revenue in each month.

--2003
select MONTH_ID, SUM(sales) Revenue, COUNT(ORDERNUMBER) Orders
from [dbo].[sales_data_sample]
where YEAR_ID = 2003
group by MONTH_ID
order by 2 desc

--2004
select MONTH_ID, SUM(sales) Revenue, COUNT(ORDERNUMBER) Orders
from [dbo].[sales_data_sample]
where YEAR_ID = 2004
group by MONTH_ID
order by 2 desc

--2005
select MONTH_ID, SUM(sales) Revenue, COUNT(ORDERNUMBER) Orders
from [dbo].[sales_data_sample]
where YEAR_ID = 2005
group by MONTH_ID
order by 2 desc  --Not representative of trends/performance of the bussiness since they only ran for 5 months this year

--November (MONTH_ID = 11) seems to be their best month, what product do they sell this month.

select MONTH_ID, PRODUCTLINE, SUM(sales) Revenue, COUNT(ORDERNUMBER) Orders
from [dbo].[sales_data_sample]
where YEAR_ID = 2003 and MONTH_ID = 11
group by MONTH_ID, PRODUCTLINE
order by 3 desc

select MONTH_ID, PRODUCTLINE, SUM(sales) Revenue, COUNT(ORDERNUMBER) Orders
from [dbo].[sales_data_sample]
where YEAR_ID = 2004 and MONTH_ID = 11
group by MONTH_ID, PRODUCTLINE
order by 3 desc  --In both years, in the month of November the best selling product is Classic Cars, just like te above query of
				 --best selling product told us.

--Best customer? (RFM analysis)
DROP TABLE IF EXISTS #rfm
;with rfm as
(
	select
		CUSTOMERNAME,
		SUM(sales) Monetary_Value,
		AVG(sales) Avg_Monetary_Value,
		COUNT(ORDERNUMBER) Orders,
		MAX(ORDERDATE) Last_Order_Date,
		(select MAX(ORDERDATE) from [dbo].[sales_data_sample])Max_Order_Date,
		DATEDIFF(DD, MAX(ORDERDATE), (select MAX(ORDERDATE) from [dbo].[sales_data_sample])) Recency	
	from [dbo].[sales_data_sample]
	group by CUSTOMERNAME
),
rfm_calc as
(
select r.*,
	NTILE(4) OVER (order by Recency desc) rfm_recency,
	NTILE(4) OVER (order by Orders) rfm_orders,
	NTILE(4) OVER (order by Monetary_Value) rfm_monetary
from rfm r
)
select 
	c.*, rfm_recency+rfm_monetary+rfm_orders as rfm_cell,
	cast(rfm_recency as varchar) + cast(rfm_orders as varchar) + cast(rfm_monetary as varchar)rfm_cell_string
into #rfm
from rfm_calc c

select CUSTOMERNAME, rfm_recency, rfm_monetary, rfm_orders,
	case
		when rfm_cell_string in (111, 112, 121, 122, 123, 132, 211, 212, 114, 141) then 'lost customers'
		when rfm_cell_string in (133, 134, 143, 144, 244, 334, 343, 344) then 'slipping away, cannot lose' -- Big spenders who haven't bought anything recently
		when rfm_cell_string in (311, 411, 331) then 'new customers'
		when rfm_cell_string in (222, 223, 233, 322) then 'potential churners'
		when rfm_cell_string in (323, 333, 321, 422, 332, 432) then 'active'
		when rfm_cell_string in (433, 434, 443, 444) then 'loyal'
	end rfm_segment
from #rfm

--Products often sold together

--Count of all orders shipped
select ORDERNUMBER, COUNT(*) rn
from [dbo].[sales_data_sample]
where status = 'Shipped'
group by ORDERNUMBER --Order number are not unique it seems like, as in someone can order many products at the same time and all of those products
					 --will have the same order number

--Query that outputs Order Numbers and the pairs of products that were purchased together, so that we can see which products are most often purchased together
--This information will help us say build a campaign in which these 2 (or 3 or 4) products are bundled together for example.
select distinct OrderNumber, stuff(
	
	(select ',' + PRODUCTCODE
	from [dbo].[sales_data_sample] p
	where ORDERNUMBER in
		(
		select ORDERNUMBER 
		from(
			select ORDERNUMBER, COUNT(*) rn
			from [dbo].[sales_data_sample]
			where status = 'Shipped'
			group by ORDERNUMBER
		)m
		where rn = 2 --orders in which 2 items where ordered, this number can be changed to see orders of different number of products purchased together
		)
		and p.ORDERNUMBER = s.OrderNumber
		for xml path ('')),
		1,1,'') Product_Codes
from [dbo].[sales_data_sample] s
order by 2 desc


