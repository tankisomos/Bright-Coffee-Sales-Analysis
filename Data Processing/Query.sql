------------------------------------------------------------------
--              Familirizing with Data  
------------------------------------------------------------------

-- checking and confirming table rows
Select *
From bright_coffee_shop_analysis;

--Check data Period (start:2023-01-01 and end date:2023-06-30)
Select  Min(transaction_date)
From bright_coffee_shop_analysis;

--End date
Select Max(transaction_date)
From bright_coffee_shop_analysis;

--- Checking products that are on offer
Select Distinct product_id,
                product_category AS Product_Name,
                product_type,
                product_detail
From bright_coffee_shop_analysis
Sort by Product_Name;

-- checking stores (number: 3 and location:Lower Manhattan,Hell's Kitchen,Astoria)

Select Distinct store_location
From workspace.default.bright_coffee_shop_analysis;
 
------------------------------------------------------------------
--                   Data Processing
 
------------------------------------------------------------------
--- Calculate overall total revenue of 3 shops
Select
 Sum(transaction_qty * unit_price) AS Overall_Total_Revenue_for_all_stores,
      
                Product_id,
                product_category AS Product_Name,
                product_type,
                product_detail,
                store_location,
              
--- Calculate total revenue per shop
      Sum(transaction_qty * unit_price) AS Total_Revenue_per_store,

---- calculate overall sales for 3 shops
  Count (transaction_id) AS Total_Sales_for_all_stores,

--Total sales per shop
     Count (Distinct transaction_id) AS Total_Sales_per_store,

-- revenue and sales per time bucket at each shop 

CASE
    WHEN HOUR(transaction_time) Between 6 and 12 then 'Morning'
    WHEN HOUR(transaction_time) Between 12 and 16 then 'Afternoon'
    WHEN HOUR(transaction_time) Between 16 and 19 then 'Evening'
    Else 'Night'
    End AS Time_of_The_Day,
    Count(Distinct transaction_id) AS Total_Sales_per_time_bucket,
    Sum(transaction_qty * unit_price) AS Total_Revenue_per_time_bucket,

 ----Products Revenue Trend Over Time

     Date(transaction_date) AS Day,
            product_category,
            transaction_qty * unit_price AS Total_Product_Revenue_Overtime,
   
 ----Total revenue per product type
SUM(transaction_qty * unit_price) AS total_revenue_per_product_Type,

-- Products Sales Trend Over Time

  Date(transaction_date) AS Day,
            Dayname(transaction_date) AS Day_Name,
            Count (transaction_id) AS Total_product_sales_overtime,
         
    
    ---Sales trends across products and time intervals

    DATE_TRUNC('month', transaction_date) AS month,
    CAST(SUM(transaction_qty * unit_price) AS INT) AS total_product_revenue_overtime,

    CAST(SUM(transaction_qty * unit_price) AS INT) AS product_total_revenue,
  
---DAY of the week with high and less revenue per shop

   Dayname(transaction_date) AS Day_name,
   Cast( Sum(Distinct transaction_qty * unit_price) AS INT) AS Total_Revenue_per_day,
       
----A month of the year with highest and lowest sales and revenue

    MONTHNAME(transaction_date) AS Month_name,
    Count(transaction_id) AS Total_Sales_per_month,
    Cast(Sum (transaction_qty * unit_price)AS INT) AS Total_Revenue_Per_Month 
    
FROM bright_coffee_shop_analysis

Group By 
         product_id,product_category,product_type,product_detail,store_location,transaction_time,transaction_date,transaction_qty,unit_price,
        
         DATE_TRUNC('month', transaction_date);
        
        
