
SELECT * FROM trolley_preventive, trolley_list 
WHERE tr_p_week = 29 AND tr_tipus = "X" AND tr_p_ds7i = tr_sorszam;


SELECT sid, sReceptszam FROM setupsheets WHERE sAktiv = 1 ORDER BY sReceptszam;

SELECT * FROM parameters WHERE ((pr_Date || ' ' || pr_Time) 
    BETWEEN '2021-07-10 22:00' AND '2021-07-10 23:59') AND (pr_sFluxSzallitottMenny > 0);



--Felvitt munkalapok es cuccaik torlese :
delete from repair;
delete from feeder_works;
delete from feeder_errors;
delete from usedparts;
-- ********************************************

--Troli cuccok t�rl�se :
delete from trolley_repair;
delete from trolley_works;
delete from used_trolley_parts;



select * from repair where e_date < "2013-3-1";


--osszes alkatresz egy feederhez, adott idoszakra :
select repair.ds7i,repair.r_date,parts.p_name,parts.p_cost from 
repair,parts,usedparts 
where repair.ds7i = "377366" and 
(repair.r_date > "2013-01-01" and repair.r_date < "2013-06-01")
and repair.r_del = 0 and (usedparts.r_id = repair.id and parts.id = usedparts.p_id) 
order by repair.r_date; 


select repair.id as rep_id,repair.ds7i,repair.r_date,repair.r_comment,
users.id,users.u_name,sorok.name as sor
from repair,users,sorok where ds7i="377366" and r_end = 1 and r_type = 0 
and users.id = repair.u_id and sorok.id = repair.line  
and (repair.r_date >= "2013-01-01" and repair.r_date <= "2013-12-31") order by repair.id;



--Idoszakos alkatreszfelhasznalas a nem torolt munkalapoknal :
select p_name,p_ordernum,count(p_name) as darab,p_cost,sum(p_cost) as osszar
from usedparts,parts,repair 
where (r_date >= "2012-01-01" and r_date <= "2012-09-31") and r_del = 0 
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
delete from repair where id = 1085;
delete from feeder_errors where r_id = 1;
delete from feeder_works where r_id = 1;
delete from usedparts where r_id = 1;
delete from feeder_repair_codes where id >= 1;

--frissitesek....
UPDATE parts SET p_cost = 113.85 WHERE id = 105;

--adagol�t�pus friss�t�se(0=Siemens S,F,HS; 1=Siemens X ; 2=Fuji ; 3=RLI ; 4=VCD & SEQ):
UPDATE repair SET r_type = 0 WHERE ds7i = "544544";
select * from repair where ds7i="544544";

--adagol� m�ret m�dos�t�sa -feeder_size t�bla alapj�n!
select * from repair where ds7i="265326";
UPDATE repair SET size = 3 WHERE ds7i = "291690";

--operator frissites:
select * from repair where ds7i="265326";
UPDATE repair SET wd_num = "82832",op_name = "Paska Istv�n",line = 9 WHERE id = 6280;

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
select * from repair where r_type = 0 and ds7i = "265923";
select * from repair where r_type = 0 and ds7i = "369971";
select * from repair where r_type = 0 and ds7i = "370115"; --6 - 7
select * from repair where r_type = 0 and ds7i = "378753"; --6 - 7
SELECT * FROM fej WHERE hely <> 1 AND torolve = 0 ORDER BY sorozatszam;;


------------------------------------------------------

--Adott felhasznalo altal javitott adagolok az adott id�szakban :
select r_date,ds7i,r_comment, feeder_types.ft_type as Típus from repair,users, feeder_types  
where r_del = 0 and (r_type = 0 or r_type = 1) and r_end = 1 and 
users.id = u_id and u_id = 13 and feeder_types.id = r_type and 
r_date >= "2021-01-01" and r_date <= "2021-01-31" 
order by r_date;

--Adott azonositoju (ds7i) adagolo javitasai az adott id�szakban :
select repair.id,repair.ds7i,repair.r_date,parts.p_name,parts.p_cost from 
repair,usedparts,parts 
where repair.r_del = 0 and r_end = 1 and 
repair.r_date > "2013-02-18" and repair.r_date < "2013-10-31" and usedparts.r_id = repair.id and parts.id = usedparts.p_id 
order by repair.r_date; 

select repair.id,repair.ds7i,repair.r_date,works.w_desc from 
repair,feeder_works,works  
where repair.r_del = 0 and 
repair.r_date > "2013-02-18" and repair.r_date < "2013-10-01" and feeder_works.r_id = repair.id and works.id = feeder_works.w_id 
order by repair.r_date; 

select repair.id as rep_id,repair.ds7i,repair.r_date,users.id,users.u_name from repair,users 
where r_end = 1 and r_type = 0 and users.id = repair.u_id 
and (repair.r_date >= "2013-01-01" and repair.r_date <= "2013-10-01") 
order by repair.id;


--Ki,mikor,mit :
select repair.id,repair.ds7i,repair.r_date,works.w_desc,parts.p_name from 
repair,feeder_works,works,usedparts,parts  
where repair.r_del = 0 and 
repair.r_date >= "2013-02-18" and repair.r_date <= "2013-10-01" and feeder_works.r_id = repair.id 
and works.id = feeder_works.w_id and usedparts.r_id = repair.id and parts.id = usedparts.p_id 
order by repair.r_date;



select repair.id as rep_id,repair.ds7i,repair.r_date,repair.r_comment,users.id,users.u_name from 
repair, users where r_end = 1 and r_del = 0 
and (repair.r_date >= "2013-02-18" and repair.r_date <= "2013-10-25") 
and r_type = 0 and users.id = repair.u_id order by repair.id;



--Setuposok lekerdezesei :
--Kivalasztott adagolo javitasai idorendben :
--csak a kalibr�lt adagol� ker�lj�n bele !!
select r_date as [Kalibr�l�s d�tuma], r_comment as [Megjegyz�s],u_name as [Jav�t�] 
from repair,users,feeder_works 
where ds7i = "291413" and u_id = users.id and feeder_works.r_id = repair.id 
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
r_date >= "2013-01-01" and r_date <= "2013-08-31"
GROUP BY users.u_name 
order by u_name;


--Arhivalashoz....
delete from repair where r_date <= "2021-12-31";
delete from feeder_errors where r_id < 60176;
delete from feeder_works where r_id < 60176;
delete from usedparts where r_id < 60176;
delete from feeder_repair_codes where r_id < 60176;

--DB urites....
delete from repair;
delete from feeder_errors;
delete from feeder_works;
delete from usedparts;

--Soronk�nti adagolokiesesek :
select repair.ds7i as ds7i,repair.r_date as r_date,sorok.name as name from repair,sorok 
where repair.line = sorok.id order by name;

--Aktu�lis sorr�l kieset adagol�k (sorok.id alapj�n : 0=H,1=I,2=J,3=L stb.) :
select ds7i,r_date,feeder_size.size as feeder_tipus from repair,feeder_size 
where repair.size = feeder_size.id and (r_date >= "2012-08-01" and r_date <= "2012-08-31") 
and line = 3;
--Sorokr�l kiesett adagol�k ds7i-k�nt �sszes�tve :
SELECT count(ds7i) as darabszam,ds7i,sorok.name AS lname FROM repair,sorok 
WHERE (sorok.id = line) AND (r_date >= "2013-01-01" AND r_date <= "2013-08-31") 
GROUP BY ds7i ORDER BY lname,darabszam desc;
--Sorokr�l kiesett adagol�k soronk�nt �sszes�tve :
SELECT sorok.name AS lname,count(ds7i) as darabszam FROM repair,sorok 
WHERE (sorok.id = line) AND (r_date >= "2012-08-01" AND r_date <= "2012-08-31") 
GROUP BY sorok.name ORDER BY lname,darabszam desc;







--Ki melyik soron mennyit rakott ki �s mikor (wd-azonos�t� szerint �sszehasonl�tva!) :
SELECT dolgozok.name as operator,sorok.name as sor, repair.ds7i, repair.r_date as datum 
FROM repair,sorok,dolgozok 
WHERE (sorok.id = line) and (dolgozok.wd_azonosito = repair.wd_num) AND (r_date >= "2012-09-01" AND r_date <= "2012-09-31") 
ORDER BY sor,datum;
--Ki melyik soron mennyit rakott ki �s mikor (n�v szerint �sszehasonl�tva!):
SELECT dolgozok.name as operator,sorok.name as sor, repair.ds7i, repair.r_date as datum 
FROM repair,sorok,dolgozok 
WHERE (sorok.id = line) and (dolgozok.name = repair.op_name) AND (r_date >= "2012-09-01" AND r_date <= "2012-09-31") 
ORDER BY sor,datum;
--Ki melyik soron mennyit rakott ki n�v szerint :
SELECT dolgozok.name as operator,sorok.name as sor,count(repair.wd_num) as darabszam FROM repair,sorok,dolgozok
WHERE (sorok.id = line) and (dolgozok.wd_azonosito = repair.wd_num) AND (r_date >= "2013-01-01" AND r_date <= "2013-06-31") 
GROUP BY operator ORDER BY darabszam desc;
--Ki melyik soron mennyit rakott ki TOP 10 :
SELECT dolgozok.name as operator,sorok.name as sor,count(repair.wd_num) as darabszam FROM repair,sorok,dolgozok 
WHERE (sorok.id = line) and (dolgozok.wd_azonosito = repair.wd_num) AND (r_date >= "2012-06-01" AND r_date <= "2012-06-31") 
GROUP BY operator ORDER BY darabszam desc LIMIT 10;
--Legt�bbet visszahozott feederek (�sszes�tett) TOP 50  + T�PUS + M�RET:
select repair.ds7i as ds7i,count(ds7i) as javitasok_szama,feeder_size.size as feeder_meret,  
case 
    when feeder_size.type = "0" then "Siemens S" 
    when feeder_size.type = "1" then "Siemens X"
    when feeder_size.type = "2" then "Fuji"     
end as feedertipus 
from repair,sorok,feeder_size 
where (sorok.id = repair.line) and (feeder_size.id = repair.size) 
and (r_date >= "2013-02-25" AND r_date <= "2013-03-03") 
group by repair.ds7i having javitasok_szama > 0 order by javitasok_szama desc;
--Legt�bbet visszahozott feederek (r�szletes - soronk�nt) :
select sorok.name as sor,repair.ds7i as ds7i,count(ds7i) as javitasok_szama from repair,sorok 
where (sorok.id = repair.line) and (r_date >= "2013-02-01" AND r_date <= "2013-02-31") 
group by sor,repair.ds7i order by javitasok_szama desc;

--Legt�bbet visszahozott feederek (�sszes�tett) TOP 50  + T�PUS + M�RET:
select repair.ds7i as ds7i,count(ds7i) as javitasok_szama,feeder_size.size as feeder_meret,  
works.w_desc,
case 
    when feeder_size.type = "0" then "Siemens S" 
    when feeder_size.type = "1" then "Siemens X"
    when feeder_size.type = "2" then "Fuji"     
end as feedertipus 
from repair,sorok,feeder_size,works,feeder_works  
where (sorok.id = repair.line) and (feeder_size.id = repair.size) 
and (r_date >= "2013-02-25" AND r_date <= "2013-03-03") 
and (feeder_works.r_id = repair.id and works.id = feeder_works.id) 
group by repair.ds7i having javitasok_szama > 3 order by javitasok_szama desc;


-- Adott feeder jav�t�sai...
select repair_codes.r_desc from repair_codes,feeder_repair_codes 
where feeder_repair_codes.r_id = 1116 and feeder_repair_codes.r_code_id = repair_codes.id;








SELECT ds7i,r_date,sorok.name AS lname FROM repair,sorok WHERE (sorok.id = line) order by lname;



select * from parts where p_ordernum LIKE '%308621%';
UPDATE parts SET p_name = 'Motor for drive wheel SII' WHERE id = 105;

CREATE TABLE "ds7i_report" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "DS7i" TEXT, "JavitasDate" TEXT, "Cost" TEXT, "Parts" TEXT, "Works" TEXT );

CREATE TABLE repair (
    "id" INTEGER,
    "u_id" INTEGER,
    "r_date" VARCHAR,
    "r_comment" VARCHAR,
    "r_end" INTEGER,
    "r_del" INTEGER,
    "r_type" INTEGER,
    "ds7i" VARCHAR,
    "size" INTEGER DEFAULT (-100)
, "line" INTEGER);

-- Describe SOROK
CREATE TABLE "sorok" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    "name" TEXT
);

-- Dolgoz�k t�bla :
CREATE TABLE "main"."dolgozok" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    "name" TEXT,
    "wd_azonosito" TEXT
);