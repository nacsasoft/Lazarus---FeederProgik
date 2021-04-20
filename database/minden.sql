--Felvitt munkalapok es cuccaik torlese :
delete from repair;
delete from feeder_works;
delete from feeder_errors;
delete from usedparts;
-- ********************************************



--osszes alkatresz egy feederhez, adott idoszakra :
select repair.ds7i,repair.r_date,parts.p_name,parts.p_cost from 
repair,parts,usedparts 
where repair.ds7i = "265541" and 
repair.r_date > "2010-04-01" and repair.r_date < "2010-06-01"
and repair.r_del = 0 and usedparts.r_id = repair.id and parts.id = usedparts.p_id 
order by repair.r_date; 


--Idszakos alkatreszfelhasznalas a nem torolt munkalapoknal :
select p_name,p_ordernum,count(p_name) as darab,p_cost,sum(p_cost) as osszar
from usedparts,parts,repair 
where (r_date >= "2010-03-03" and r_date <= "2010-05-05") and r_del = 0 
and usedparts.p_id = parts.id and usedparts.r_id = repair.id  group by p_name;


--TOP Feederkoltsegek a nem torolt munkalapoknal adott idoszakra :
select ds7i, sum(p_cost) as osszar 
from usedparts,parts,repair,users 
where (r_date >= "2010-06-01" and r_date <= "2010-06-31") and p_id = parts.id and r_id = repair.id and r_type = 0 and r_del = 0 and u_id = users.id 
group by ds7i order by osszar desc limit 10;


--altalanos hibak,idoszakra is ! 
--(pl.: mely feedereknel volt az adott idszakban tol -ig  pl. offszethiba).
select ds7i,r_date,count(feeder_errors.id) as hibaszam  
from repair,feeder_errors 
where (repair.r_date >= "2010-05-03" and repair.r_date <= "2010-05-05" and repair.r_del = 0) 
and r_type = 0 and feeder_errors.r_id = repair.id and feeder_errors.e_id = 3
group by ds7i order by hibaszam desc;

--Adott id-ju munkalap teljes otrlese (mindennel eggyutt !!!)
delete from repair where id = 1;
delete from feeder_errors where r_id = 1;
delete from feeder_works where r_id = 1;
delete from usedparts where r_id = 1;

--frisstes....
UPDATE repair
SET line_id = 0 
WHERE id > 0;

--Adott idoszakban,24 oran belul visszahozott (adott tipusu feederek):
--create table tt as select * from repair order by r_date;
select a.ds7i as ds7i,t.r_date as elso_jav,a.r_date as masodik_jav,users.u_name as elso_jav_neve,a.u_id from repair as t,users
inner join repair as a 
on t.ds7i = a.ds7i
where users.id = t.u_id and 
(a.r_date >= "2011-01-01" and a.r_date <= "2011-12-31" 
and a.r_type = 0 and a.r_del = 0 and a.r_end = 1) and 
((date(t.r_date,"+1 day") = a.r_date and a.id > t.id) 
or (t.r_date = a.r_date and t.id > a.id))
group by t.ds7i,a.r_date order by a.r_date;

------------------------------------------------------
--egynapon visszahozott adagolok :
select * from repair where r_type = 0 and ds7i = "366804";
select * from repair where r_type = 0 and ds7i = "370118";
select * from repair where r_type = 0 and ds7i = "377393"; --6 - 7
select * from repair where r_type = 0 and ds7i = "378753"; --6 - 7
------------------------------------------------------

--Adott felhasznalo altal javitott adagolok az adott idõszakban :
select r_date,ds7i,r_comment from repair,users 
where r_del = 0 and r_type = 0 and r_end = 1 and 
users.id = u_id and u_id = 5 and 
r_date >= "2012-01-01" and r_date <= "2012-01-31" 
order by r_date;

--Adott azonositoju (ds7i) adagolo javitasai az adott idõszakban :
select * from repair 
where r_del = 0 and r_type = 0 and r_end = 1 and ds7i = "544533" and 
r_date >= "2011-02-01" and r_date <= "2011-12-31" 
order by r_date;


--Setuposok lekerdezesei :
--Kivalasztott adagolo javitasai idorendben :
--csak a kalibrált adagoló kerüljön bele !!
select r_date as [Kalibrálás dátuma], r_comment as [Megjegyzés],u_name as [Javító] 
from repair,users,feeder_works 
where ds7i = "391536" and u_id = users.id and feeder_works.r_id = repair.id 
and feeder_works.w_id = 1 
order by r_date;

--Kalibralt adagolok :
select repair.* from repair,feeder_works 
where repair.id = feeder_works.r_id and feeder_works.w_id = 1;

--Osszes javitott feeder darabszamok :
select count(repair.id) from repair;

--Mennyi nap alatt, mennyi adagolot javitottak :
SELECT users.u_name,count(repair.id) as darab,count(distinct repair.r_date) as napok 
FROM repair,users
WHERE repair.u_id = users.id and 
r_date >= "2010-08-01" and r_date <= "2010-08-31"
GROUP BY users.u_name 
order by u_name;


--Arhivalashoz....
delete from repair where r_date <= "2010-12-31";
delete from feeder_errors where r_id < 3062;
delete from feeder_works where r_id < 3062;
delete from usedparts where r_id < 3062;

--DB urites....
delete from repair;
delete from feeder_errors;
delete from feeder_works;
delete from usedparts;


-- extra mezo felvitele :
ALTER TABLE repair ADD COLUMN wd_num varchar(10);


CREATE TABLE "ds7i_report" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "DS7i" TEXT, 
"JavitasDate" TEXT, "Cost" TEXT, "Parts" TEXT, "Works" TEXT );


-- TOP 10 legtobbet javitott feeder :
select ds7i,count (ds7i) as ds7i_num from repair group by ds7i order by ds7i_num desc limit 10;
 