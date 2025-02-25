-- STORE ANALYSIS
-- Q1 •	Which are the top 10 stores in terms of Incremental Revenue (IR) generated from the promotions?
SELECT 
    fc.store_id AS stores,
	city AS cities,
    SUM(CASE WHEN promo_type = 'BOGOF' THEN (quantity_sold_after_promo - quantity_sold_before_promo) * base_price ELSE 0 END) AS 'BOGOF Incremental Revenue',
    SUM(CASE WHEN promo_type = '50% OFF' THEN (quantity_sold_after_promo - quantity_sold_before_promo) * base_price ELSE 0 END) AS '50% OFF Incremental Revenue',
	SUM(CASE WHEN promo_type = '25% OFF' THEN (quantity_sold_after_promo - quantity_sold_before_promo) * base_price ELSE 0 END) AS '25% OFF Incremental Revenue',
	SUM(CASE WHEN promo_type = '33% OFF' THEN (quantity_sold_after_promo - quantity_sold_before_promo) * base_price ELSE 0 END) AS '33% OFF Incremental Revenue',
	SUM(CASE WHEN promo_type = '500 Cashback' THEN (quantity_sold_after_promo - quantity_sold_before_promo) * base_price ELSE 0 END) AS '500 Cashback Incremental Revenue',
    SUM(CASE WHEN promo_type = 'BOGOF' THEN (quantity_sold_after_promo - quantity_sold_before_promo) * base_price ELSE 0 END +
        CASE WHEN promo_type = '50% OFF' THEN (quantity_sold_after_promo - quantity_sold_before_promo) * base_price ELSE 0 END +
		CASE WHEN promo_type = '25% OFF' THEN (quantity_sold_after_promo - quantity_sold_before_promo) * base_price ELSE 0 END +
		CASE WHEN promo_type = '33% OFF' THEN (quantity_sold_after_promo - quantity_sold_before_promo) * base_price ELSE 0 END +
		CASE WHEN promo_type = '500 Cashback' THEN (quantity_sold_after_promo - quantity_sold_before_promo) * base_price ELSE 0 END 
		) AS 'Total Incremental Revenue'
FROM 
    Sales..fact_events fc
JOIN
	Sales..dim_stores ds ON ds.store_id = fc.store_id
GROUP BY 
    fc.store_id,city
ORDER BY 
    'Total Incremental Revenue' DESC OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY

-- Q2 •	Which are the bottom 10 stores when it comes to Incremental Sold Units (ISU) during the promotional period?

SELECT 
    fc.store_id,
	city AS cities,
    SUM(CASE WHEN promo_type = 'BOGOF' THEN (quantity_sold_after_promo-quantity_sold_before_promo) ELSE 0 END) AS 'BOGOF Incremental Revenue',
    SUM(CASE WHEN promo_type = '50% OFF' THEN (quantity_sold_after_promo-quantity_sold_before_promo) ELSE 0 END) AS '50% OFF Incremental Revenue',
	SUM(CASE WHEN promo_type = '25% OFF' THEN (quantity_sold_after_promo-quantity_sold_before_promo)  ELSE 0 END) AS '25% OFF Incremental Revenue',
	SUM(CASE WHEN promo_type = '33% OFF' THEN (quantity_sold_after_promo-quantity_sold_before_promo) ELSE 0 END) AS '33% OFF Incremental Revenue',
	SUM(CASE WHEN promo_type = '500 Cashback' THEN (quantity_sold_after_promo-quantity_sold_before_promo)  ELSE 0 END) AS '500 Cashback Incremental Revenue',
    SUM(CASE WHEN promo_type = 'BOGOF' THEN (quantity_sold_after_promo-quantity_sold_before_promo)  ELSE 0 END +
        CASE WHEN promo_type = '50% OFF' THEN (quantity_sold_after_promo-quantity_sold_before_promo)  ELSE 0 END +
		CASE WHEN promo_type = '25% OFF' THEN (quantity_sold_after_promo-quantity_sold_before_promo)  ELSE 0 END +
		CASE WHEN promo_type = '33% OFF' THEN (quantity_sold_after_promo-quantity_sold_before_promo)  ELSE 0 END +
		CASE WHEN promo_type = '500 Cashback' THEN (quantity_sold_after_promo-quantity_sold_before_promo)  ELSE 0 END 
		) AS 'Total Incremental Revenue'
FROM 
    Sales..fact_events fc
JOIN
	Sales..dim_stores ds ON ds.store_id = fc.store_id
GROUP BY 
    fc.store_id,city
ORDER BY 
    'Total Incremental Revenue' ASC OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY

-- Q3 •	How does the performance of stores vary by city? 
-- Are there any common characteristics among the top-performing stores that could be leveraged across other stores?

SELECT
    ds.city,
    fc.store_id,
    SUM(CASE WHEN promo_type = 'BOGOF' THEN quantity_sold_after_promo*base_price  ELSE 0 END +
        CASE WHEN promo_type = '50% OFF' THEN quantity_sold_after_promo*base_price  ELSE 0 END +
		CASE WHEN promo_type = '25% OFF' THEN quantity_sold_after_promo*base_price  ELSE 0 END +
		CASE WHEN promo_type = '33% OFF' THEN quantity_sold_after_promo*base_price  ELSE 0 END +
		CASE WHEN promo_type = '500 Cashback' THEN quantity_sold_after_promo*base_price  ELSE 0 END 
		) AS 'Total Revenue After Promotion',
	SUM(CASE WHEN promo_type = 'BOGOF' THEN quantity_sold_before_promo*base_price  ELSE 0 END +
        CASE WHEN promo_type = '50% OFF' THEN quantity_sold_before_promo*base_price  ELSE 0 END +
		CASE WHEN promo_type = '25% OFF' THEN quantity_sold_before_promo*base_price  ELSE 0 END +
		CASE WHEN promo_type = '33% OFF' THEN quantity_sold_before_promo*base_price  ELSE 0 END +
		CASE WHEN promo_type = '500 Cashback' THEN quantity_sold_before_promo*base_price  ELSE 0 END 
		) AS 'Total Revenue Before Promotion',
	SUM(CASE WHEN promo_type = 'BOGOF' THEN (quantity_sold_after_promo-quantity_sold_before_promo)*base_price  ELSE 0 END +
        CASE WHEN promo_type = '50% OFF' THEN (quantity_sold_after_promo-quantity_sold_before_promo)*base_price  ELSE 0 END +
		CASE WHEN promo_type = '25% OFF' THEN (quantity_sold_after_promo-quantity_sold_before_promo)*base_price  ELSE 0 END +
		CASE WHEN promo_type = '33% OFF' THEN (quantity_sold_after_promo-quantity_sold_before_promo)*base_price  ELSE 0 END +
		CASE WHEN promo_type = '500 Cashback' THEN (quantity_sold_after_promo-quantity_sold_before_promo)*base_price  ELSE 0 END 
		) AS 'Top Performing Store',
	promo_type AS Promotions

  
FROM 
    Sales..fact_events fc
JOIN 
    Sales..dim_stores ds ON ds.store_id = fc.store_id
GROUP BY
    ds.city, fc.store_id,promo_type
ORDER BY
		[Top Performing Store] DESC OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY

-- PROMOTION TYPE ANALYSIS
-- •	What are the top 2 promotion types that resulted in the highest Incremental Revenue?

SELECT
    promo_type AS promotion,
    SUM(CASE WHEN promo_type = 'BOGOF' THEN quantity_sold_after_promo*base_price ELSE 0 END +
        CASE WHEN promo_type = '50% OFF' THEN quantity_sold_after_promo*base_price ELSE 0 END +
        CASE WHEN promo_type = '25% OFF' THEN quantity_sold_after_promo*base_price ELSE 0 END +
        CASE WHEN promo_type = '33% OFF' THEN quantity_sold_after_promo*base_price ELSE 0 END +
        CASE WHEN promo_type = '500 Cashback' THEN quantity_sold_after_promo*base_price ELSE 0 END
    ) AS 'Total Revenue After Promotion',
    
    SUM(CASE WHEN promo_type = 'BOGOF' THEN quantity_sold_before_promo*base_price ELSE 0 END +
        CASE WHEN promo_type = '50% OFF' THEN quantity_sold_before_promo*base_price ELSE 0 END +
        CASE WHEN promo_type = '25% OFF' THEN quantity_sold_before_promo*base_price ELSE 0 END +
        CASE WHEN promo_type = '33% OFF' THEN quantity_sold_before_promo*base_price ELSE 0 END +
        CASE WHEN promo_type = '500 Cashback' THEN quantity_sold_before_promo*base_price ELSE 0 END
    ) AS 'Total Revenue Before Promotion',
    
    SUM(CASE WHEN promo_type = 'BOGOF' THEN (quantity_sold_after_promo*base_price - quantity_sold_before_promo*base_price) ELSE 0 END +
        CASE WHEN promo_type = '50% OFF' THEN (quantity_sold_after_promo*base_price - quantity_sold_before_promo*base_price) ELSE 0 END +
        CASE WHEN promo_type = '25% OFF' THEN (quantity_sold_after_promo*base_price - quantity_sold_before_promo*base_price) ELSE 0 END +
        CASE WHEN promo_type = '33% OFF' THEN (quantity_sold_after_promo*base_price - quantity_sold_before_promo*base_price) ELSE 0 END +
        CASE WHEN promo_type = '500 Cashback' THEN (quantity_sold_after_promo*base_price - quantity_sold_before_promo*base_price) ELSE 0 END
    ) AS 'Incremental Revenue'
    
FROM 
    Sales..fact_events fc
JOIN 
    Sales..dim_stores ds ON ds.store_id = fc.store_id
GROUP BY
    promo_type
ORDER BY
    [Incremental Revenue] DESC 
OFFSET 0 ROWS FETCH NEXT 2 ROWS ONLY;

-- •	What are the bottom 2 promotion types in terms of their impact on Incremental Sold Units?


SELECT 
    promo_type AS promotions,
   -- SUM(CASE WHEN promo_type = 'BOGOF' THEN (quantity_sold_after_promo-quantity_sold_before_promo) ELSE 0 END) AS 'BOGOF Incremental Revenue',
   -- SUM(CASE WHEN promo_type = '50% OFF' THEN (quantity_sold_after_promo-quantity_sold_before_promo) ELSE 0 END) AS '50% OFF Incremental Revenue',
--	SUM(CASE WHEN promo_type = '25% OFF' THEN (quantity_sold_after_promo-quantity_sold_before_promo)  ELSE 0 END) AS '25% OFF Incremental Revenue',
--	SUM(CASE WHEN promo_type = '33% OFF' THEN (quantity_sold_after_promo-quantity_sold_before_promo) ELSE 0 END) AS '33% OFF Incremental Revenue',
--	SUM(CASE WHEN promo_type = '500 Cashback' THEN (quantity_sold_after_promo-quantity_sold_before_promo)  ELSE 0 END) AS '500 Cashback Incremental Revenue',
	 SUM(CASE WHEN promo_type = 'BOGOF' THEN (quantity_sold_after_promo-quantity_sold_before_promo)  ELSE 0 END +
        CASE WHEN promo_type = '50% OFF' THEN (quantity_sold_after_promo-quantity_sold_before_promo)  ELSE 0 END +
		CASE WHEN promo_type = '25% OFF' THEN (quantity_sold_after_promo-quantity_sold_before_promo)  ELSE 0 END +
		CASE WHEN promo_type = '33% OFF' THEN (quantity_sold_after_promo-quantity_sold_before_promo)  ELSE 0 END +
		CASE WHEN promo_type = '500 Cashback' THEN (quantity_sold_after_promo-quantity_sold_before_promo)  ELSE 0 END 
		) AS 'Total Incremental Revenue'
FROM 
    Sales..fact_events fc
JOIN
	Sales..dim_stores ds ON ds.store_id = fc.store_id
GROUP BY 
    promo_type
ORDER BY 
    'Total Incremental Revenue' ASC OFFSET 0 ROWS FETCH NEXT 2 ROWS ONLY


-- •	Is there a significant difference in the performance of discount-based promotions versus BOGOF (Buy One Get One Free) or cashback promotions?
SELECT 
    promo_type AS promotions,
    SUM(CASE 
            WHEN promo_type = 'BOGOF' THEN (quantity_sold_after_promo - quantity_sold_before_promo) 
            WHEN promo_type = '50% OFF' THEN (quantity_sold_after_promo - quantity_sold_before_promo) 
            WHEN promo_type = '25% OFF' THEN (quantity_sold_after_promo - quantity_sold_before_promo) 
            WHEN promo_type = '33% OFF' THEN (quantity_sold_after_promo - quantity_sold_before_promo) 
            WHEN promo_type = '500 Cashback' THEN (quantity_sold_after_promo - quantity_sold_before_promo) 
            ELSE 0 
        END) AS 'Incremental Sold Units',
	SUM(CASE 
            WHEN promo_type = 'BOGOF' THEN (quantity_sold_after_promo - quantity_sold_before_promo)*base_price 
            WHEN promo_type = '50% OFF' THEN (quantity_sold_after_promo - quantity_sold_before_promo)*base_price 
            WHEN promo_type = '25% OFF' THEN (quantity_sold_after_promo - quantity_sold_before_promo)*base_price  
            WHEN promo_type = '33% OFF' THEN (quantity_sold_after_promo - quantity_sold_before_promo) *base_price 
            WHEN promo_type = '500 Cashback' THEN (quantity_sold_after_promo - quantity_sold_before_promo)*base_price 
            ELSE 0 
        END) AS 'Incremental Revenue'
FROM 
    Sales..fact_events fc
JOIN
    Sales..dim_stores ds ON ds.store_id = fc.store_id
GROUP BY 
    promo_type
ORDER BY 
    'Incremental Revenue' DESC;

-- •	Which promotions strike the best balance between Incremental Sold Units and maintaining healthy margins?


-- Product and Category Analysis:

-- •	Which product categories saw the most significant lift in sales from the promotions?

SELECT
		category,
		SUM(quantity_sold_before_promo) AS 'Quantity Sold Before Promotion',
		SUM(quantity_sold_after_promo) AS 'Quantity Sold After Promotion',
		SUM((quantity_sold_before_promo)*base_price) AS 'Revenue Before Promotion',
		SUM(CASE WHEN promo_type = 'BOGOF' THEN quantity_sold_after_promo*base_price ELSE 0 END +
        CASE WHEN promo_type = '50% OFF' THEN quantity_sold_after_promo*base_price*0.5 ELSE 0 END +
        CASE WHEN promo_type = '25% OFF' THEN quantity_sold_after_promo*base_price*0.75 ELSE 0 END +
        CASE WHEN promo_type = '33% OFF' THEN quantity_sold_after_promo*base_price*0.67 ELSE 0 END +
        CASE WHEN promo_type = '500 Cashback' THEN quantity_sold_after_promo*base_price-500 ELSE 0 END
    ) AS 'Revenue After Promotion',
		SUM(CASE WHEN promo_type = 'BOGOF' THEN (quantity_sold_after_promo-quantity_sold_before_promo)*base_price ELSE 0 END +
        CASE WHEN promo_type = '50% OFF' THEN (quantity_sold_after_promo*base_price*0.5 - quantity_sold_before_promo*base_price) ELSE 0 END +
        CASE WHEN promo_type = '25% OFF' THEN (quantity_sold_after_promo*base_price*0.75 - quantity_sold_before_promo*base_price) ELSE 0 END +
        CASE WHEN promo_type = '33% OFF' THEN (quantity_sold_after_promo*base_price*0.67 - quantity_sold_before_promo*base_price) ELSE 0 END +
        CASE WHEN promo_type = '500 Cashback' THEN (quantity_sold_after_promo*base_price-500-quantity_sold_before_promo*base_price) ELSE 0 END
    ) AS 'Incremental Revenue',
	SUM(CASE WHEN promo_type = 'BOGOF' THEN quantity_sold_after_promo ELSE 0 END +
        CASE WHEN promo_type = '50% OFF' THEN quantity_sold_after_promo ELSE 0 END +
        CASE WHEN promo_type = '25% OFF' THEN quantity_sold_after_promo ELSE 0 END +
        CASE WHEN promo_type = '33% OFF' THEN quantity_sold_after_promo ELSE 0 END +
        CASE WHEN promo_type = '500 Cashback' THEN quantity_sold_after_promo ELSE 0 END
    ) AS 'Incremental Sold Units'
FROM
		Sales..fact_events fe
JOIN
		Sales..dim_products dp ON dp.product_code = fe.product_code
GROUP BY
		category

-- •	Are there specific products that respond exceptionally well or poorly to promotions?

SELECT
		position,
		product_name,		
		[Incremental Revenue]
FROM
	(
		SELECT
		'Top' As position,
		product_name,		
		SUM(CASE WHEN promo_type = 'BOGOF' THEN (quantity_sold_after_promo-quantity_sold_before_promo)*base_price ELSE 0 END +
        CASE WHEN promo_type = '50% OFF' THEN (quantity_sold_after_promo*base_price*0.5 - quantity_sold_before_promo*base_price) ELSE 0 END +
        CASE WHEN promo_type = '25% OFF' THEN (quantity_sold_after_promo*base_price*0.75 - quantity_sold_before_promo*base_price) ELSE 0 END +
        CASE WHEN promo_type = '33% OFF' THEN (quantity_sold_after_promo*base_price*0.67 - quantity_sold_before_promo*base_price) ELSE 0 END +
        CASE WHEN promo_type = '500 Cashback' THEN (quantity_sold_after_promo*base_price-500-quantity_sold_before_promo*base_price) ELSE 0 END
    ) AS 'Incremental Revenue' 
		FROM
			Sales..fact_events fe
		JOIN
			Sales..dim_products dp ON dp.product_code = fe.product_code
		GROUP BY
			product_name
		ORDER BY
			[Incremental Revenue] DESC OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY

		UNION ALL

		SELECT
		'Bottom' As position,
		product_name,		
		SUM(CASE WHEN promo_type = 'BOGOF' THEN (quantity_sold_after_promo-quantity_sold_before_promo)*base_price ELSE 0 END +
        CASE WHEN promo_type = '50% OFF' THEN (quantity_sold_after_promo*base_price*0.5 - quantity_sold_before_promo*base_price) ELSE 0 END +
        CASE WHEN promo_type = '25% OFF' THEN (quantity_sold_after_promo*base_price*0.75 - quantity_sold_before_promo*base_price) ELSE 0 END +
        CASE WHEN promo_type = '33% OFF' THEN (quantity_sold_after_promo*base_price*0.67 - quantity_sold_before_promo*base_price) ELSE 0 END +
        CASE WHEN promo_type = '500 Cashback' THEN (quantity_sold_after_promo*base_price-500-quantity_sold_before_promo*base_price) ELSE 0 END
    ) AS 'Incremental Revenue' 
		FROM
			Sales..fact_events fe
		JOIN
			Sales..dim_products dp ON dp.product_code = fe.product_code
		GROUP BY
			product_name
		ORDER BY [Incremental Revenue] ASC OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY
) AS Combined
ORDER BY [Incremental Revenue] DESC;

-- •	What is the correlation between product category and promotion type effectiveness?
SELECT
    dp.category,
    fe.promo_type,
    SUM(CASE WHEN promo_type = 'BOGOF' THEN (quantity_sold_after_promo - quantity_sold_before_promo) * base_price ELSE 0 END +
        CASE WHEN promo_type = '50% OFF' THEN (quantity_sold_after_promo * base_price * 0.5 - quantity_sold_before_promo * base_price) ELSE 0 END +
        CASE WHEN promo_type = '25% OFF' THEN (quantity_sold_after_promo * base_price * 0.75 - quantity_sold_before_promo * base_price) ELSE 0 END +
        CASE WHEN promo_type = '33% OFF' THEN (quantity_sold_after_promo * base_price * 0.67 - quantity_sold_before_promo * base_price) ELSE 0 END +
        CASE WHEN promo_type = '500 Cashback' THEN (quantity_sold_after_promo * base_price - 500 - quantity_sold_before_promo * base_price) ELSE 0 END
    ) AS Incremental_Revenue,
    SUM(quantity_sold_after_promo) AS Total_Sold_After_Promo,
    SUM(quantity_sold_before_promo) AS Total_Sold_Before_Promo
FROM
    Sales..fact_events fe
JOIN
    Sales..dim_products dp ON dp.product_code = fe.product_code
GROUP BY
    dp.category,
    fe.promo_type
ORDER BY
    dp.category, Incremental_Revenue DESC;


