-- Q1 provide a list of products with the base price greater than 500 and that are featured in promo type of 'BOGOF'.This 
-- information will help us identify high-value products that are currently being heavily discounted which can be useful for 
-- evaluating our pricing and promotion strategies

SELECT
		fc.product_code as 'Product Code',
		product_name as Product
FROM
		Sales..fact_events fc
JOIN
		Sales..dim_products dp ON dp.product_code = fc.product_code
WHERE 
		promo_type = 'BOGOF' AND base_price >500
GROUP BY
		product_name,
		fc.product_code

-- Q2. Generate a report that provides an overview of the number of stores in each city. 
-- The results will be sorted in descending order of store counts, allowing us to identify the cities with the highest store presence.
-- The report includes two essential fields: city and store count, which will assist in optimizing our retail operations.

SELECT
		city,
		COUNT(fc.store_id) AS 'No. of stores'
FROM
		Sales..fact_events fc
JOIN
		Sales..dim_stores ds ON ds.store_id = fc.store_id
GROUP BY
		city
ORDER BY
		COUNT(fc.store_id) DESC

-- Q3. Generate a report that displays each campaign along with the total revenue generated before and after the campaign? 
-- The report includes three key fields: campaign_name, totaI_revenue(before_promotion), totaI_revenue(after_promotion). 
-- This report should help in evaluating the financial impact of our promotional campaigns. (Display the values in millions)

SELECT 
		campaign_name,
		CAST(SUM(quantity_sold_before_promo*base_price)AS Float)/1000000  AS 'Revenue Before Promotion (Mn)',
		CAST(SUM(quantity_sold_after_promo*base_price)AS Float)/1000000 AS ' Revenue After Promotion (Mn)'
FROM		
		Sales..fact_events fe
JOIN
		Sales..dim_campaigns dc ON dc.campaign_id = fe.campaign_id
GROUP BY
		campaign_name

-- Q4. Produce a report that calculates the Incremental Sold Quantity (ISU%) for each category during the Diwali campaign. 
-- Additionally, provide rankings for the categories based on their ISU%. 
-- The report will include three key fields: category, isu%, and rank order. 
-- This information will assist in assessing the category-wise success and impact of the Diwali campaign on incremental sales.

SELECT
    campaign_name,
    category,
    CAST(SUM(quantity_sold_after_promo) AS FLOAT) / SUM(quantity_sold_before_promo) * 100 AS 'ISU %',
    RANK() OVER (ORDER BY CAST(SUM(quantity_sold_after_promo) AS FLOAT) / SUM(quantity_sold_before_promo) * 100 DESC) AS 'ISU RANK'
FROM
    Sales..fact_events fe
JOIN
    Sales..dim_campaigns dc ON dc.campaign_id = fe.campaign_id
JOIN
    Sales..dim_products dp ON dp.product_code = fe.product_code
WHERE
    campaign_name = 'Diwali'
GROUP BY
    campaign_name,
    category;

-- O5. Create a report featuring the Top 5 products, ranked by Incremental Revenue Percentage (IR%), across all campaigns. 
-- The report will provide essential information including product name, category, and ir%. 
-- This analysis helps identify the most successful products in terms of incremental revenue across our campaigns, assisting in product optimization

SELECT
		product_name,
		CAST(SUM(quantity_sold_after_promo) AS FLOAT) / SUM(quantity_sold_before_promo) * 100 AS 'ISU %',
		RANK() OVER (ORDER BY CAST(SUM(quantity_sold_after_promo) AS FLOAT) / SUM(quantity_sold_before_promo) * 100 DESC) AS 'ISU RANK'
FROM
		Sales..fact_events fe
JOIN
		Sales..dim_products dp ON dp.product_code = fe.product_code
GROUP BY
		product_name
ORDER BY
		[ISU %] DESC OFFSET 0 ROWS FETCH FIRST 5 ROWS ONLY