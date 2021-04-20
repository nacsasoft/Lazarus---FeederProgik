SELECT feeder_tpm.tpm_date AS "Preventív v. Javítás", feeder_tpm.tpm_outdate AS "Ellenörzés ideje", feeder_tpm.tpm_ds7i as "DS7i", users.u_name AS "operátor", feeder_types.ft_type AS "típus", feeder_size.size AS "méret",
CASE feeder_tpm.tpm_hibakod
    WHEN -1 THEN "OK"
    ELSE (SELECT e_desc FROM error_codes WHERE error_codes.id = feeder_tpm.tpm_hibakod)
END as "Feeder állapota"
FROM feeder_tpm
JOIN users ON feeder_tpm.u_id = users.id 
JOIN feeder_types ON feeder_tpm.tpm_type = feeder_types.id
JOIN feeder_size ON feeder_tpm.tpm_size = feeder_size.id
WHERE tpm_outdate >= "2017-01-01" and tpm_outdate <= "2017-04-31";

--Javitasra varo federek (TPM-bol)
SELECT feeder_tpm.tpm_outdate AS "Ellenörzés ideje", feeder_tpm.tpm_ds7i as "DS7i", users.u_name AS "Ellenőrizte", feeder_types.ft_type AS "Típus", feeder_size.size AS "Méret",
CASE 
    WHEN feeder_tpm.tpm_hibakod > -1 THEN (SELECT e_desc FROM error_codes WHERE error_codes.id = feeder_tpm.tpm_hibakod)
END as "Feeder állapota"
FROM feeder_tpm
JOIN users ON feeder_tpm.u_id = users.id 
JOIN feeder_types ON feeder_tpm.tpm_type = feeder_types.id
JOIN feeder_size ON feeder_tpm.tpm_size = feeder_size.id
WHERE tpm_outdate >= "2017-01-01" and tpm_outdate <= "2017-04-31" and feeder_tpm.tpm_javitasra = 1 and tpm_lezarva = 0
ORDER BY tpm_outdate and tpm_ds7i;


SELECT feeder_tpm.tpm_date AS "Preventív v. Javítás", feeder_tpm.tpm_outdate AS "Preventív ideje", feeder_tpm.tpm_ds7i as "DS7i", users.u_name AS "Preventives", feeder_types.ft_type AS "Típus", feeder_size.size AS "Méret" 
FROM feeder_tpm
JOIN users ON feeder_tpm.prev_u_id = users.id 
JOIN feeder_types ON feeder_tpm.tpm_type = feeder_types.id
JOIN feeder_size ON feeder_tpm.tpm_size = feeder_size.id
WHERE tpm_outdate >= "2017-01-01"  and tpm_outdate <= "2017-04-31" AND tpm_preventive = 1 AND tpm_lezarva = 1;


--TPM operátorok munkája:
SELECT feeder_tpm.tpm_outdate AS "Ellenörzés ideje", feeder_tpm.tpm_ds7i as "DS7i", users.u_name AS "TPM Operátor", feeder_types.ft_type AS "Típus", feeder_size.size AS "Méret" 
FROM feeder_tpm 
JOIN users ON feeder_tpm.u_id = users.id 
JOIN feeder_types ON feeder_tpm.tpm_type = feeder_types.id 
JOIN feeder_size ON feeder_tpm.tpm_size = feeder_size.id 
WHERE (tpm_outdate >= "2017-01-01" AND tpm_outdate <= "2017-04-31");


--Arhivalashoz....
--delete from repair where r_date <= "2015-12-31";
--delete from feeder_errors where r_id < 24332;
--delete from feeder_works where r_id < 24332;
--delete from usedparts where r_id < 24332;

--kiesett adagolók ds7i-ként összesítve :
SELECT count(ds7i) as darabszam,ds7i FROM repair 
WHERE (r_date >= "2016-06-01" AND r_date <= "2017-01-01") and r_type = 1  AND repair.r_del = 0 
GROUP BY ds7i ORDER BY darabszam desc;
