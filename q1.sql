-- Left join the stores and sales tables on store_id to include all stores
SELECT 
    s.store_key,
    s.country,
    s.square_meters
	
	FROM 
    stores s
FULL JOIN 
    sales sa
ON 
    s.store_key = sa.store_key;
