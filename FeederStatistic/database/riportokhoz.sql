--
--	Riportálás
--
--Ki melyik soron mennyit rakott ki és mikor (wd-azonosító szerint összehasonlítva!) :
SELECT dolgozok.name as operator,sorok.name as sor, repair.ds7i, repair.r_date as datum 
FROM repair,sorok,dolgozok 
WHERE (sorok.id = line) and (dolgozok.wd_azonosito = repair.wd_num) AND 
(r_date >= "2013-01-01" AND r_date <= "2013-12-31") 
ORDER BY sor,datum;

--Ki melyik soron mennyit rakott ki összesítve :
SELECT dolgozok.name as operator,sorok.name as sor,count(repair.wd_num) as darabszam FROM repair,sorok,dolgozok
WHERE (sorok.id = line) and (dolgozok.wd_azonosito = repair.wd_num) AND 
(r_date >= "2013-01-01" AND r_date <= "2013-10-31") 
GROUP BY operator,sor ORDER BY darabszam desc limit 20;

--Legtöbbet visszahozott feederek (összesített) TOP 20  + TÍPUS + MÉRET:
select repair.ds7i as ds7i,count(ds7i) as javitasok_szama,feeder_size.size as feeder_meret,  
case 
    when feeder_size.type = "0" then "Siemens S" 
    when feeder_size.type = "1" then "Siemens X"
    when feeder_size.type = "2" then "Fuji"     
end as feedertipus 
from repair,sorok,feeder_size 
where (sorok.id = repair.line) and (feeder_size.id = repair.size) 
and (r_date >= "2013-01-01" AND r_date <= "2013-10-31") 
group by repair.ds7i order by javitasok_szama desc limit 20;

--Legtöbbet visszahozott feederek (részletes - soronként) :
select sorok.name as sor,repair.ds7i as ds7i,count(ds7i) as javitasok_szama from repair,sorok 
where (sorok.id = repair.line) and 
(r_date >= "2013-01-01" AND r_date <= "2013-10-31") 
group by sor,repair.ds7i order by javitasok_szama desc limit 20;

--Sorokról kiesett adagolók soronként összesítve :
SELECT sorok.name AS lname,count(ds7i) as darabszam FROM repair,sorok 
WHERE (sorok.id = line) AND (r_date >= "2013-01-01" AND r_date <= "2013-10-31") 
GROUP BY sorok.name ORDER BY darabszam;

--Ki melyik soron milyen hibával rakta ki és mikor (wd-azonosító szerint összehasonlítva!) :
SELECT dolgozok.name as operator,sorok.name as sor, repair.ds7i, repair.r_date as datum, errors.e_desc as hibak
FROM repair,sorok,dolgozok,errors,feeder_errors  
WHERE (sorok.id = line) and (dolgozok.wd_azonosito = repair.wd_num) 
and (feeder_errors.r_id = repair.id) and (errors.id = feeder_errors.e_id) 
AND (r_date >= "2013-01-01" AND r_date <= "2013-09-23") 
ORDER BY operator;	--sor,datum;

--A feeder hányszor volt javítva az adott idõszakban?
select repair.ds7i as ds7i,count(ds7i) as javitasok_szama
from repair 
where (repair.ds7i = '330041') and (r_date >= "2013-01-01" AND r_date <= "2013-09-23"); 

--Adott azonositoju (ds7i) adagolo javitasai az adott idõszakban :
select repair.id,repair.ds7i,repair.r_date,parts.p_name,parts.p_cost from 
repair,usedparts,parts 
where repair.ds7i = "265599" and repair.r_del = 0 and r_end = 1 and 
repair.r_date > "2013-01-01" and repair.r_date < "2012-09-31" and 
usedparts.r_id = repair.id and parts.id = usedparts.p_id order by repair.r_date;




--Adott azonositoju (ds7i) adagolo javitasai az adott idõszakban :
select repair.id,repair.ds7i,repair.r_date,parts.p_name,parts.p_cost,works.w_desc from 
repair,usedparts,parts,works,feeder_works 
where repair.ds7i = "265599" and repair.r_del = 0 and r_end = 1 and 
repair.r_date > "2012-09-01" and repair.r_date < "2012-09-31" and 
usedparts.r_id = repair.id and parts.id = usedparts.p_id and 
feeder_works.r_id = repair.id and works.id = feeder_works.w_id order by repair.r_date;

