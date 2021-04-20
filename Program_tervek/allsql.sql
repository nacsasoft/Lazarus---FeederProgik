SELECT repair.ds7i,repair.r_date,repair.r_comment,feeder_size.size,feeder_types.ft_type,users.u_name 
FROM repair,feeder_size,feeder_types,users 
WHERE users.id = repair.u_id and repair.size = feeder_size.id and repair.r_type = feeder_types.id and users.u_del = 0 and 
(repair.r_date >= "2014-07-01" and repair.r_date <= "2014-08-06" and repair.r_type = 0 and repair.r_del = 0 and repair.r_end = 1) 
ORDER BY repair.ds7i, repair.r_date
