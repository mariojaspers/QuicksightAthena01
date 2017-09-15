SELECT
  year(date_parse(Order_Date,'%c/%e/%Y')) Order_Year,
  Company_Name,
  SUM(quantity) Quantity,
  SUM(sales) Total_Sales,
  SUM(sales)/revenue_billion Sales_to_Revenue_Ratio
FROM labs.b2b_orders o
  JOIN labs.b2b_company co on  co.company_id = o.company_id
  JOIN labs.b2b_customer cu on cu.customer_id = o.customer_id
  JOIN labs.b2b_product p on p.product_id = o.product_id
  JOIN labs.b2b_segment s on s.segment_id = o.segment_id
  JOIN labs.b2b_ship_mode sm on sm.ship_mode_id = o.ship_mode_id
  JOIN labs.b2b_company_financials cp on cp.company_id = co.company_id
  JOIN labs.b2b_industry i on i.industry_id = co.industry_id
GROUP BY
  year(date_parse(Order_Date,'%c/%e/%Y')),
  Company_Name,
  revenue_billion
ORDER BY
  SUM(sales)/revenue_billion DESC
LIMIT 100;
