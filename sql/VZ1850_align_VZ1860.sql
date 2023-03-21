/***

FB, Fall 2021 ...

Alignement scripts VZ1850 to VZ1860

Cf. https://kleiolab.atlassian.net/l/c/oH5FWixg


***/

-- VZ1850 : rebuild (virtual) table with relevant columns
SELECT *
FROM tables.rebuild_partitioned_table (24626480,'tv_biogr_base_1850',ARRAY[24626623,24626513,
				24626511,24626515,24626523,24626521, 24626525,24626537, 24732186, 24732187,24626541,24626543,24626495, 24626485,24626519]::INTEGER[]);

SELECT * FROM tv_biogr_base_1850 LIMIT 10;

SELECT COUNT(*) FROM tv_biogr_base_1850;  --30052



-- VZ1860  : rebuild (virtual) table with relevant columns
SELECT *
FROM tables.rebuild_partitioned_table (24626627,'tv_biogr_base_1860',ARRAY[24700267,24626666,24626664,24626668,24626676,24626680,
		24626674,24731798,24731799, 24626690, 24626692, 24626694, 24626640, 24626632,24626672]::INTEGER[]);

SELECT * FROM tv_biogr_base_1860 LIMIT 10;

SELECT COUNT(*) FROM tv_biogr_base_1860; -- 41292



--gender VZ 1850 - inspect available values : 29689 renseignées
SELECT "24626515",
       COUNT(*) AS eff
FROM tv_biogr_base_1850
GROUP BY "24626515"
ORDER BY eff DESC;

--gender VZ 1860 - inspect available values : 41250 re
SELECT "24626668",
       COUNT(*) AS eff
FROM tv_biogr_base_1860
GROUP BY "24626668"
ORDER BY eff DESC;


--gebjahr VZ 1850 - inspect available values
SELECT "24626523",
       COUNT(*) AS eff
FROM tv_biogr_base_1850
GROUP BY "24626523"
ORDER BY "24626523";


--gebjahr VZ 1860 - inspect available values
SELECT "24626676",
       COUNT(*) AS eff
FROM tv_biogr_base_1860
GROUP BY "24626676"
ORDER BY "24626676";



--Konfession VZ 1850 - inspect available values
/**
ka = Keine Angabe
GH, November 2020 : sonstige derzeit nicht berücksichtigen
**/
SELECT "24626525",
       COUNT(*) AS eff
FROM tv_biogr_base_1850
GROUP BY "24626525"
ORDER BY "24626525";

--Konfession VZ 1860 - inspect available values
/**
ka = Keine Angabe
GH, November 2020 : sonstige derzeit nicht berücksichtigen
**/
SELECT "24626680",
       COUNT(*) AS eff
FROM tv_biogr_base_1860
GROUP BY "24626680"
ORDER BY "24626680";


-- tests
SELECT 11233*100/30052   ;
SELECT 11233/30052::numeric   ;




/***

HERKUNFT UND  STAATSANGEHÖRIGKEIT

***/


--Herkunft wie in Quelle  VZ 1850 
/**
Keine Angaben ?!? In der Tat, es gibt keine Daten im Uhrsprünglichen CSV, Juli 2019
**/
SELECT "24626539",
       COUNT(*) AS eff
FROM tv_biogr_base_1850
GROUP BY "24626539"
ORDER BY "24626539";

--Herkunft VZ 1850  --BS	11233 / 30052 * 100 = 37.37 %
SELECT "24732186",
       COUNT(*) AS eff
FROM tv_biogr_base_1850
GROUP BY "24732186"
ORDER BY "24732186";



-- VZ1850 - Spalten wie in Wiki
/***
24626539 -- Schweizerbürger anderer Kantone (wie im Buch) : keine Werte !
24626541 -- Schweizerbürger anderer Kantone (vereinh., abgek.)
24626543 -- Staatszugehörigkeit 
***/
SELECT "24626539", "24626541","24626543",
       COUNT(*) AS eff
FROM tv_biogr_base_1850
GROUP BY "24626539","24626541","24626543"
ORDER BY "24626539","24626541","24626543";



--Herkunft std VZ 1860 (neue Spalte, ID) BS  11101 / 41292 * 100 =  26.88 %
SELECT "24731798",
       COUNT(*) AS eff
FROM tv_biogr_base_1860
GROUP BY "24731798"
ORDER BY "24731798";


--Herkunft std VZ 1860
SELECT "24626692",
       COUNT(*) AS eff
FROM tv_biogr_base_1860
GROUP BY "24626692"
ORDER BY "24626692";

--Herkunft VZ 1860
SELECT "24626690",
       COUNT(*) AS eff
FROM tv_biogr_base_1860
GROUP BY "24626690"
ORDER BY "24626690";




/***

Population by year and nationality

***/


--- 1850
WITH tw1 AS
(
  SELECT "24626523",
         CASE
           WHEN "24732186" = 9 THEN 'BS'
           ELSE 'other'
         END nationality
  FROM tv_biogr_base_1850
), tw2 AS (
SELECT "24626523", nationality,
       COUNT(*) AS eff
FROM tw1
GROUP BY "24626523",
         nationality
), tw3 AS  (

SELECT "24626523",
       CASE WHEN nationality = 'BS' THEN eff ELSE NULL END AS BS,
       CASE WHEN nationality = 'other' THEN eff ELSE NULL END AS other
FROM tw2
ORDER BY "24626523"

)
SELECT "24626523" AS year,
       MAX(bs) AS bs,
       MAX(other) AS other,
       MAX(bs) +MAX(other) AS total
FROM tw3
GROUP BY "24626523"
ORDER BY "24626523";



--- 1860
WITH tw1 AS
(
  SELECT "24626676",
         CASE
           WHEN "24731798" = 9 THEN 'BS'
           ELSE 'other'
         END nationality
  FROM tv_biogr_base_1860
), tw2 AS (
SELECT "24626676", nationality,
       COUNT(*) AS eff
FROM tw1
GROUP BY "24626676",
         nationality
), tw3 AS  (

SELECT "24626676",
       CASE WHEN nationality = 'BS' THEN eff ELSE NULL END AS BS,
       CASE WHEN nationality = 'other' THEN eff ELSE NULL END AS other
FROM tw2
ORDER BY "24626676"

)
SELECT "24626676" AS year,
       MAX(bs) AS bs,
       MAX(other) AS other,
       MAX(bs) +MAX(other) AS total
FROM tw3
GROUP BY "24626676"
ORDER BY "24626676";










"24626523",




-- VZ1860 - Spalten wie in Wiki
/***
24626690 - Bürger anderer Kt oder Ausländer (syst. nach Fiebig)
24626692 - Bürger anderer Kantone (vereinheitlicht)
24626694 - Staatszugehörigkeit
***/
SELECT "24626690","24626692", "24626694",
       COUNT(*) AS eff
FROM tv_biogr_base_1860
GROUP BY "24626690", "24626692","24626694"
ORDER BY "24626690","24626692","24626694";







/*** 
*  New tables prepared by GH, Januar 2021
* 
* 24731751 ;  24731674  ;  24731705
* 
***/

-- Columns of the new tables -> copied to wiki
SELECT t0.pk_entity, t0.id_for_import, t0.id_for_import_txt, t2.definition data_type, t1.definition column_type, t0.is_imported, t0.fk_original_column, t0.fk_publication_status, t0.fk_creator, t0.fk_last_modifier, t0.fk_digital, t0.fk_license, t0.fk_namespace, t0.metadata, t0.notes, t0.schema_name, t0.sys_period, t0.table_name, t0.entity_version, t0.tmsp_creation, t0.tmsp_last_modification
FROM data.column t0
  LEFT JOIN system.system_type t1 ON t1.pk_entity = t0.fk_column_content_type
  LEFT JOIN system.system_type t2 ON t2.pk_entity = t0.fk_data_type
WHERE fk_digital = 24731705;




--  Staaten : 24731705

SELECT *
FROM tables.rebuild_partitioned_table (24731751,'tv_id_staaten_kantone',ARRAY[24731754,24731753,24731756]::INTEGER[]);

SELECT * FROM tv_id_staaten_kantone LIMIT 10;



--  VZ1850 Staaten & Kantone : 24731674

SELECT *
FROM tables.rebuild_partitioned_table (24731674,'tv_vz_1850_staaten_kantone',ARRAY[24731675, 24731676, 24731677,
									 24731678, 24731679, 24731680, 24731681, 24731682, 24731683, 24731684, 24731685]::INTEGER[]);

SELECT * FROM tv_vz_1850_staaten_kantone LIMIT 10;



--  VZ1860 Staaten & Kantone : 24731705

SELECT *
FROM tables.rebuild_partitioned_table (24731705,'tv_vz_1860_staaten_kantone',ARRAY[24731706,24731707,
                  24731708,24731709,24731710,24731711,24731712,24731713, 24731714, 24731715, 24731716, 24731717 ]::INTEGER[]);

SELECT * FROM tv_vz_1860_staaten_kantone LIMIT 10;




/***

Staatsangehörigkeit, Herkunft 

Behandlung unterschiedlicher identifiers !

Problem nur in VZ1860 Staaten und Kantone wo drei Spalten mit IDs sind


VZ1850 : Eine einzige zusätzliche Spalte produzieren, Werte von 24731682 brauchen

VZ1860 : Eine einzige zusätzliche Spalte produzieren, Werte von 24731714 brauchen


***/


--VZ 1860

SELECT * FROM tv_vz_1860_staaten_kantone LIMIT 10;

SELECT *
FROM tv_vz_1860_staaten_kantone
WHERE "24731711" != "24731714" AND "24731708" = 'ja' LIMIT 10;

-- Eine einzige Spalte produzieren, Werte von 24731714 brauchen ?
-- JA ! überprüft

SELECT * -- count(*)
FROM tv_vz_1860_staaten_kantone
WHERE "24731714" != "24731717" AND "24731708" = 'ja';


-- falsche Identifiers von Hand ersetzen
SELECT *
FROM tables.cell_24731705
WHERE fk_column IN (24731713,24731714)
AND   fk_row IN (SELECT fk_row
                 FROM tables.cell_24731705
                 WHERE fk_column = 24731706
                 AND   numeric_value = 265) LIMIT 100;


SELECT replace(string_value, '.0', ''), *
FROM tables.cell_24731705
WHERE fk_column IN (24731711,24731714,24731717);

-- Eliminate '.0'
--UPDATE tables.cell_24731705 SET string_value = replace(string_value, '.0', '')
WHERE fk_column IN (24731711,24731714,24731717);


-- VZ1850

-- Problem nicht vorhanden, nur zwei ID Spalten
SELECT * FROM tv_vz_1850_staaten_kantone LIMIT 10;


-- Eine einzige Spalte produzieren, Werte von 24731682 brauchen ?
-- JA ! überprüft

-- In der Spalte 24731682 sind korrekt entwerder Kantone oder Staaten drinnen

SELECT * -- count(*)
FROM tv_vz_1850_staaten_kantone
WHERE "24731682" != "24731685" AND "24731677" = 'ja';



SELECT replace(string_value, '.0', ''), *
FROM tables.cell_24731674
WHERE fk_column IN (24731682,24731685);

-- Eliminate '.0'
--UPDATE tables.cell_24731674 SET string_value = replace(string_value, '.0', '')
WHERE fk_column IN (24731682,24731685);



/***

Joining, updating and cleansing of the data

***/


--VZ1860

SELECT *
FROM tables.cell_24626627
WHERE fk_column = 24626690 LIMIT 10;
  

SELECT count(*) freq,
				-- "24731706",
       "24731709",
       "24731712",
       "24731715"
FROM tv_vz_1860_staaten_kantone
GROUP BY "24731709",
         "24731712",
         "24731715";


-- Werte die zum Matching gebraucht werden mit '' anstatt NULL ersetzen
SELECT "24731708" ja_nein,
"24731706" AS n_zeile,
"24731707" AS eff,
"24731713" AS buerger,
"24731714" AS buerger_id,
"24731716" AS citizen,
"24731717" AS citizen_id,
CASE WHEN "24731709" IS NULL THEN '' ELSE "24731709" END,
CASE WHEN "24731712" IS NULL THEN '' ELSE "24731712" END,
CASE WHEN "24731715" IS NULL THEN '' ELSE "24731715" END
FROM tv_vz_1860_staaten_kantone
Limit 50
;

-- Werte die zum Matching gebraucht werden mit '' anstatt NULL ersetzen
SELECT pk_row, 
"24626692" AS buerger_orig,
"24626690" AS citizen_orig,
CASE WHEN "24626690" IS NULL THEN '' ELSE "24626690" END,
CASE WHEN "24626692" IS NULL THEN '' ELSE "24626692" END,
CASE WHEN "24626694" IS NULL THEN '' ELSE "24626694" END
FROM tv_biogr_base_1860
limit 50;







/***

VZ1860

Create the temporary table for preparing the DATA to be INSERTED

***/


--  The NULL values in the JOIN columns must be replaced by '' (empty) values in order to have consistent matching

DROP TABLE tt_vz1860_citizenship;


CREATE TEMPORARY  TABLE tt_vz1860_citizenship AS  

WITH tw1 AS (
SELECT "24731708",
"24731706" AS n_zeile,
"24731707" AS eff,
"24731713" AS buerger,
"24731714" AS buerger_id,
"24731716" AS citizen,
"24731717" AS citizen_id,
CASE WHEN "24731709" IS NULL THEN '' ELSE "24731709" END,
CASE WHEN "24731712" IS NULL THEN '' ELSE "24731712" END,
CASE WHEN "24731715" IS NULL THEN '' ELSE "24731715" END
FROM tv_vz_1860_staaten_kantone
),
tw2 AS (
SELECT pk_row, 
"24626692" AS buerger_orig,
"24626690" AS citizen_orig,
CASE WHEN "24626690" IS NULL THEN '' ELSE "24626690" END,
CASE WHEN "24626692" IS NULL THEN '' ELSE "24626692" END,
CASE WHEN "24626694" IS NULL THEN '' ELSE "24626694" END
FROM tv_biogr_base_1860
)

SELECT DISTINCT tw2.pk_row,
       tw1.n_zeile,
       tw1.eff,
       tw2."24626692" AS buerger_orig,
       tw1.buerger,
       tw1.buerger_id,
       t3."24731753" AS off_bezeichnung,
       tw2."24626694" AS citizen_orig,
       tw1.citizen,
       tw1.citizen_id
FROM tw1,
tw2,
tv_id_staaten_kantone t3  
WHERE tw1."24731708" = 'ja' 
  --AND n_zeile =  237 --248 -- 232 --258 --- 263  --265
  -- tw1."24731709" IS NULL OR 
  AND (tw2."24626690" = tw1."24731709")  /* Nur zwei Spalten für Matching genügen nicht ! */
  AND (tw2."24626692" = tw1."24731712")
  AND (tw2."24626694" = tw1."24731715")
  AND t3."24731754" = tw1.buerger_id::INT
     ;
  LIMIT 200;

-- Problem with NULL values ! 
-- Solved with close IS NULL OR above
SELECT t2.*
FROM tv_biogr_base_1860 t2
WHERE t2."24626690" LIKE 'Würzb%'
-- t1."24731706" = 263  --265
LIMIT 20;

-- 39791 auf 41292 in der Tabelle
SELECT count(*)
FROM tt_vz1860_citizenship;

SELECT *
FROM tt_vz1860_citizenship
-- de la Sachse il y a deux lignes, 200 et 201
WHERE n_zeile = 232 -- 237 --248 -- 232 --258 --- 263  --265 --201
;

-- Keine doubletten mehr mit dem Ersentzen von NULL mit '' (Leerschlag)
SELECT pk_row,
--       buerger_id,
--       off_bezeichnung,
       COUNT(*) freq
FROM tt_vz1860_citizenship
GROUP BY pk_row
HAVING COUNT(*) > 1
ORDER BY freq DESC;



/*** for these rows the JOIN produced errors !before replacing NULL with '' 
-- these are all from Basel, but wrong column
***/

WITH tw1 AS (
-- get all unique rows id
SELECT DISTINCT pk_row, buerger_id, off_bezeichnung
FROM tt_vz1860_citizenship),
tw2 AS (
-- get their frequency and those present more than once
SELECT pk_row,
       COUNT(*) freq
FROM tw1
GROUP BY pk_row
having COUNT(*) > 1
ORDER BY freq DESC)

--SELECT DISTINCT pk_row
SELECT * FROM tw1 --tt_vz1860_citizenship
WHERE pk_row IN (SELECT pk_row FROM tw2);




/***
Create two new columns
***/


SELECT *
FROM data.column
WHERE pk_entity = 24700267;

SELECT *
FROM data.column
ORDER BY pk_entity DESC LIMIT 10;



-- Inserted column pk_entity : 24731798
-- INSERT INTO data."column" (entity_version,notes,fk_namespace,tmsp_creation,tmsp_last_modification,
      fk_digital,fk_data_type,fk_column_content_type,is_imported,fk_column_relationship_type)
VALUES
(
  1,
  'State or Canton ID, cf. table (Digital) 24731751 – Added FB 17 February 2021 – matching from VZ1860 Staaten und Kantone: 24731705. – SQL script : VZ1850_align_VZ1860.sql',
  24626451,
  now(),
  now(),
  24626627,
  3293,
  3291,
  FALSE,
  3367
);

-- Inserted column pk_entity : 24731799
--INSERT INTO data."column" (entity_version,notes,fk_namespace,tmsp_creation,tmsp_last_modification,
      fk_digital,fk_data_type,fk_column_content_type,is_imported,fk_column_relationship_type)
VALUES
(
  1,
  'State or Canton "Offizielle Bezeichnung", cf. table (Digital) 24731751 – Added FB 17 February 2021 – matching from VZ1860 Staaten und Kantone: 24731705. – SQL script : VZ1850_align_VZ1860.sql',
  24626451,
  now(),
  now(),
  24626627,
  3292,
  3291,
  FALSE,
  3367
);


-- Column labels
SELECT *
FROM data.text_property
WHERE fk_entity = 24700267;

SELECT *
FROM data.text_property
ORDER BY pk_entity DESC
LIMIT 5;

--INSERT INTO data.text_property
(
  entity_version,
  fk_namespace,
  tmsp_creation,
  tmsp_last_modification,
  string,
  fk_system_type,
  fk_language,
  fk_entity
)
VALUES
(
  1,
  24626451,
  now(),
  now(),
  'HISB ID Staat/Kanton',
  3295,
  18605,
  24731798
);

-- INSERT INTO data.text_property
(
  entity_version,
  fk_namespace,
  tmsp_creation,
  tmsp_last_modification,
  string,
  fk_system_type,
  fk_language,
  fk_entity
)
VALUES
(
  1,
  24626451,
  now(),
  now(),
  'Staat/Kanton Off. Bezeichnung',
  3295,
  18605,
  24731799
);





SELECT *
FROM tt_vz1860_citizenship
-- de la Sachse il y a deux lignes, 200 et 201
WHERE n_zeile = 232 -- 237 --248 -- 232 --258 --- 263  --265 --201
;

-- prepare values to be produced
SELECT pk_row, buerger_id, off_bezeichnung
FROM tt_vz1860_citizenship
-- de la Sachse il y a deux lignes, 200 et 201
WHERE n_zeile = 258 -- 237 --248 -- 232 --258 --- 263  --265 --201
;


--existing
SELECT *
FROM tables.cell_24626627
WHERE fk_column = 24700267 LIMIT 10;
--new column
SELECT *
FROM tables.cell_24626627
WHERE fk_column = 24731798 LIMIT 10;

-- 39791 rows affected
--INSERT INTO tables.cell_24626627
(
  fk_column,
  fk_row,
  fk_digital,
  numeric_value,--string_value,
  entity_version,
  fk_creator,
  fk_last_modifier,
  tmsp_creation,
  tmsp_last_modification,
  metadata
)

SELECT 
  24731798,
  pk_row,
  24626627,
  buerger_id::INTEGER,
  1,
  8,
  8,
  now(),
  now(),
  ('{"source":"Import FB 17 February 2021 - Values from HISB Table VZ1860 Staaten und Kantone: Digital 24731705 ",
   "id_import":"import_20210217_1" }')::JSONB

FROM tt_vz1860_citizenship
--LIMIT 10
;


--new column
SELECT *
FROM tables.cell_24626627
WHERE fk_column = 24731799 LIMIT 10;

-- 39791 rows affected
--INSERT INTO tables.cell_24626627
(
  fk_column,
  fk_row,
  fk_digital,
  string_value,
  entity_version,
  fk_creator,
  fk_last_modifier,
  tmsp_creation,
  tmsp_last_modification,
  metadata
)

SELECT 
  24731799,
  pk_row,
  24626627,
  off_bezeichnung,
  1,
  8,
  8,
  now(),
  now(),
  ('{"source":"Import FB 17 February 2021 - Values from HISB Table VZ1860 Staaten und Kantone: Digital 24731705 ",
   "id_import":"import_20210217_2" }')::JSONB

FROM tt_vz1860_citizenship
--LIMIT 10
;









/***

VZ1850

Create the temporary table for preparing the DATA to be INSERTED

***/

SELECT * FROM  tv_vz_1850_staaten_kantone;

--  The NULL values in the JOIN columns must be replaced by '' (empty) values in order to have consistent matching

DROP TABLE tt_vz1850_citizenship;


CREATE TEMPORARY TABLE tt_vz1850_citizenship AS  

WITH tw1 AS (
SELECT "24731677",
"24731675" AS n_zeile,
"24731676" AS eff,
"24731681" AS buerger,
"24731682" AS buerger_id,
"24731684" AS citizen,
"24731685" AS citizen_id,
CASE WHEN "24731680" IS NULL THEN '' ELSE "24731680" END,
CASE WHEN "24731683" IS NULL THEN '' ELSE "24731683" END
FROM tv_vz_1850_staaten_kantone
),
tw2 AS (
SELECT pk_row, 
"24626541" AS buerger_orig,
"24626543" AS citizen_orig,
CASE WHEN "24626541" IS NULL THEN '' ELSE "24626541" END,
CASE WHEN "24626543" IS NULL THEN '' ELSE "24626543" END
FROM tv_biogr_base_1850
)

SELECT DISTINCT tw2.pk_row,
       tw1.n_zeile,
       tw1.eff,
       tw2.buerger_orig,
       tw1.buerger,
       tw1.buerger_id,
       t3."24731753" AS off_bezeichnung,
       tw2.citizen_orig,
       tw1.citizen,
       tw1.citizen_id
FROM tw1,
tw2,
tv_id_staaten_kantone t3  
WHERE tw1."24731677" = 'ja' 
  --AND n_zeile = 88 --4 --12 -- 85
  -- tw1."24731709" IS NULL OR 
  AND (tw2."24626541" = tw1."24731680")
  AND (tw2."24626543" = tw1."24731683")
  AND t3."24731754" = tw1.buerger_id::INT
     ;
  LIMIT 200;

-- Problem with NULL values ! 
-- Solved with close IS NULL OR above
SELECT t2.*
FROM tt_vz1850_citizenship t2
WHERE  n_zeile = 76
-- buerger_orig LIKE '%AG%'

LIMIT 20;

-- 29444 auf 30052 in der Tabelle
SELECT count(*)
FROM tt_vz1850_citizenship;

SELECT *
FROM tt_vz1850_citizenship
-- de la Sachse il y a deux lignes, 200 et 201
WHERE n_zeile = 99 
;


SELECT pk_row,
--       buerger_id,
--       off_bezeichnung,
       COUNT(*) freq
FROM tt_vz1850_citizenship
GROUP BY pk_row
HAVING COUNT(*) > 1
ORDER BY freq DESC;





/***
Create two new columns
***/


SELECT *
FROM data.column
WHERE pk_entity = 24626623; -- Name und vorname

SELECT *
FROM data.column
ORDER BY pk_entity DESC LIMIT 10;



-- Inserted column pk_entity : 24732186
--INSERT INTO data."column" (entity_version,notes,fk_namespace,tmsp_creation,tmsp_last_modification,
      fk_digital,fk_data_type,fk_column_content_type,is_imported,fk_column_relationship_type)
VALUES
(
  1,
  'State or Canton ID, cf. table (Digital) 24731751 – Added FB 18 February 2021 – matching from VZ1850 Staaten und Kantone: 24731674. – SQL script : VZ1850_align_VZ1860.sql',
  24626451,
  now(),
  now(),
  24626480,
  3293,
  3291,
  FALSE,
  3367
);

-- Inserted column pk_entity : 24732187
--INSERT INTO data."column" (entity_version,notes,fk_namespace,tmsp_creation,tmsp_last_modification,
      fk_digital,fk_data_type,fk_column_content_type,is_imported,fk_column_relationship_type)
VALUES
(
  1,
  'State or Canton "Offizielle Bezeichnung", cf. table (Digital) 24731751 – Added FB 18 February 2021 – matching from VZ1860 Staaten und Kantone: 24731674. – SQL script : VZ1850_align_VZ1860.sql',
  24626451,
  now(),
  now(),
  24626480,
  3292,
  3291,
  FALSE,
  3367
);


-- Column labels
SELECT *
FROM data.text_property
WHERE fk_entity = 24626623;

SELECT *
FROM data.text_property
ORDER BY pk_entity DESC
LIMIT 5;

--INSERT INTO data.text_property
(
  entity_version,
  fk_namespace,
  tmsp_creation,
  tmsp_last_modification,
  string,
  fk_system_type,
  fk_language,
  fk_entity
)
VALUES
(
  1,
  24626451,
  now(),
  now(),
  'HISB ID Staat/Kanton',
  3295,
  18605,
  24732186
);

--INSERT INTO data.text_property
(
  entity_version,
  fk_namespace,
  tmsp_creation,
  tmsp_last_modification,
  string,
  fk_system_type,
  fk_language,
  fk_entity
)
VALUES
(
  1,
  24626451,
  now(),
  now(),
  'Staat/Kanton Off. Bezeichnung',
  3295,
  18605,
  24732187
);







SELECT *
FROM tt_vz1850_citizenship
-- de la Sachse il y a deux lignes, 200 et 201
WHERE n_zeile = 70 --99
;

-- prepare values to be produced
SELECT pk_row, buerger_id, off_bezeichnung
FROM tt_vz1850_citizenship
-- de la Sachse il y a deux lignes, 200 et 201
WHERE n_zeile = 99
;


--existing values
SELECT *
FROM tables.cell_24626480
WHERE fk_column = 24626623 LIMIT 10;

--new column : 24732186
SELECT *
FROM tables.cell_24626480
WHERE fk_column = 24732186 LIMIT 10;

-- 29444 rows affected
--INSERT INTO tables.cell_24626480
(
  fk_column,
  fk_row,
  fk_digital,
  numeric_value,--string_value,
  entity_version,
  fk_creator,
  fk_last_modifier,
  tmsp_creation,
  tmsp_last_modification,
  metadata
)

SELECT 
  24732186,
  pk_row,
  24626480,
  buerger_id::INTEGER,
  1,
  8,
  8,
  now(),
  now(),
  ('{"source":"Import FB 18 February 2021 - Values from HISB Table VZ1850 Staaten und Kantone: Digital 24731674 ",
   "id_import":"import_20210218_1" }')::JSONB

FROM tt_vz1850_citizenship
--LIMIT 10
;


--new column : 24732187
SELECT *
FROM tables.cell_24626480
WHERE fk_column = 24732187 LIMIT 10;

-- 29444 rows affected
INSERT INTO tables.cell_24626480
(
  fk_column,
  fk_row,
  fk_digital,
  string_value,
  entity_version,
  fk_creator,
  fk_last_modifier,
  tmsp_creation,
  tmsp_last_modification,
  metadata
)

SELECT 
  24732187,
  pk_row,
  24626480,
  off_bezeichnung,
  1,
  8,
  8,
  now(),
  now(),
  ('{"source":"Import FB 18 February 2021 - Values from HISB Table VZ1850 Staaten und Kantone: Digital 24731674 ",
   "id_import":"import_20210218_2" }')::JSONB

FROM tt_vz1850_citizenship
--LIMIT 10
;

















/***

BERUF

***/


--Beruf  VZ 1850
SELECT "24626521",
       COUNT(*) AS eff
FROM tv_biogr_base_1850
GROUP BY "24626521"
ORDER BY "24626521";


--Beruf 1860
SELECT "24626674",
       COUNT(*) AS eff
FROM tv_biogr_base_1860
GROUP BY "24626674"
ORDER BY "24626674";



--Staatsang.  VZ 1850
SELECT "24626543",
       COUNT(*) AS eff
FROM tv_biogr_base_1850
GROUP BY "24626543"
ORDER BY "24626543";


--Staatsang. VZ 1860
SELECT "24626694",
       COUNT(*) AS eff
FROM tv_biogr_base_1860
GROUP BY "24626694"
ORDER BY "24626694";


--Staatsang. VZ 1860
SELECT "24626692",
       COUNT(*) AS eff
FROM tv_biogr_base_1860
GROUP BY "24626692"
ORDER BY "24626692";







-----------


/*
CREATION  de TABLES d'ALIGNEMENT

Tabelle: importer.matching_vz1850_vz1860_basics > 0.65 ± 1
Tabelle: importer.matching_vz1850_vz1860_basics_similarity05 > 0.5 ± 2
*/

-- Etat automne 2020
--DROP TABLE importer.matching_vz1850_vz1860_basics;

/***
NOUVELLE VERSION 

créée le 18 février 2021


Doc.: https://www.postgresql.org/docs/10/pgtrgm.html


***/



--- Ces tests invitent à séparer les colonnes nom, prénom

select word_similarity('Lenz Johannes', 'Ley Johannes'); -- 0.69
select (word_similarity('Lenz', 'Ley') + word_similarity('Johannes', 'Johannes') /2); -- 0.9

select word_similarity('Weissenberger geb. Utzinger Barbara',  'Weissenberger Barbara'); --0.66
select (word_similarity('Weissenberger geb. Utzinger', 'Weissenberger') + word_similarity('Barbara', 'Barbara')) /2; --0.78


select word_similarity('Meyer Georg Friedrich', 'Ohm Georg Friedrich');  -- 0.73
select (word_similarity('Meyer', 'Ohm') + word_similarity('Georg Friedrich', 'Georg Friedrich') /2); -- 0.5
select word_similarity('Meyer', 'Ohm');  --0


SELECT pk_row,
        "24626513" AS vorname,
        "24626511" AS name,
        "24626515" gender,
				CASE
         WHEN importer.isnumeric ("24626523") THEN "24626523"::INTEGER
         ELSE NULL
       END gebjahr,
       "24626525" AS religion,
       "24732186" AS nationality      
 FROM tv_biogr_base_1850
 where "24626511" is null
 LIMIT 10;








/***

BROAD MATCHING for inspection, you can filter in the end, on the produced tables

The filtering on nationality will be on next table : 

***/

-- Does not seam to work on temporary tables
--CREATE INDEX trgm_idx_1850 ON tv_biogr_base_1850 USING GIST (forename gist_trgm_ops, surname gist_trgm_ops);


DROP TABLE importer.hisb_matching_vz1850_vz1860_basics_similarity_name_vorname_03 ;

CREATE TABLE importer.hisb_matching_vz1850_vz1860_basics_similarity_name_vorname_03
AS
WITH VZ1850 AS (
SELECT pk_row,
        "24626623" AS name,
        "24626513" AS forename,
        "24626511" AS surname,
        "24626515" gender,
				CASE
         WHEN importer.isnumeric ("24626523") THEN "24626523"::INTEGER
         ELSE NULL
       END gebjahr,
       "24626525" AS religion,
       "24732186" AS id_nationality,
       "24732187" AS nationality
       
 FROM tv_biogr_base_1850),

VZ1860 AS (
SELECT pk_row,
				"24700267" AS name,
        "24626666" AS forename,
        "24626664" AS surname,
        "24626668" gender,
				CASE
         WHEN importer.isnumeric ("24626676") THEN "24626676"::INTEGER
         ELSE NULL
       END gebjahr,
       "24626680" AS religion,
       "24731798" AS id_nationality,
       "24731799" AS nationality
       
 FROM tv_biogr_base_1860)


SELECT levenshtein(unaccent (t2.name),unaccent (t1.name)) r_levenshtein,
       similarity(unaccent(t2.forename),unaccent(t1.forename)) r_similarity_forename,
       similarity(unaccent(t2.surname),unaccent(t1.surname)) r_similarity_surname,
       t1.gender AS gender,
       t1.religion AS religion,
       t1.pk_row AS pk_row_vz1850,
       t1.gebjahr AS gebjahr_vz1850,
       t1.name AS name_vz1850,
       t2.name AS name_vz1860,
       t2.gebjahr AS gebjahr_vz1860,
       t2.pk_row AS pk_row_vz1860,
       t1.id_nationality AS id_nationality_vz1850,
       t1.nationality AS nationality_vz1850,
       t2.id_nationality AS id_nationality_vz1860,
       t2.nationality AS nationality_vz1860
     
       
FROM VZ1850 t1,
     VZ1860 t2
WHERE t1.gender = t2.gender
AND   t1.religion = t2.religion
AND   t1.gebjahr BETWEEN t2.gebjahr - 3 AND t2.gebjahr + 3

AND  similarity(unaccent(t2.forename),unaccent(t1.forename)) > 0.3
AND  similarity(unaccent(t2.surname),unaccent(t1.surname)) > 0.3;



--- NOUVELLE TABLE

--  26798 
SELECT count(*)
FROM importer.hisb_matching_vz1850_vz1860_basics_similarity_name_vorname_03 ;


SELECT (r_similarity_surname + r_similarity_forename)/2 mean_siml, *
FROM importer.hisb_matching_vz1850_vz1860_basics_similarity_name_vorname_03 order by r_similarity_surname, r_similarity_forename 
limit 200;


ORDER BY name_vz1850,
         name_vz1860
   ;

LIMIT 20;





-- Original tables

-- VZ1850
SELECT *
FROM tables.rebuild_partitioned_table (24626480,'tv_biogr_base_1850',ARRAY[24626623,24626513,
				24626511,24626515,24626523,24626521, 24626525,24626537, 24732186, 24732187,24626541,24626543,24626495, 24626485,24626519]::INTEGER[]);

SELECT * FROM tv_biogr_base_1850 LIMIT 10;

-- VZ1860
SELECT *
FROM tables.rebuild_partitioned_table (24626627,'tv_biogr_base_1860',ARRAY[24700267,24626666,24626664,24626668,24626676,24626680,
		24626674,24731798,24731799, 24626690, 24626692, 24626694, 24626640, 24626632,24626672]::INTEGER[]);
		
SELECT * FROM tv_biogr_base_1860 LIMIT 10;



SELECT pk_row,
				"24700267" AS name,
        "24626666" AS forename,
        "24626664" AS surname,
        "24626668" gender,
				CASE
         WHEN importer.isnumeric ("24626676") THEN "24626676"::INTEGER
         ELSE NULL
       END gebjahr,
       "24626680" AS religion,
       "24731798" AS nationality
       
 FROM tv_biogr_base_1860 limit 10;

/*** 


COMPARE NATIONALITIES

Some nationalities are present in 1850 but not in 1860 !


***/


WITH vz1850 AS
(
  SELECT "24732186" nat,
         COUNT(*) AS eff
  FROM tv_biogr_base_1850
  GROUP BY "24732186"
  ORDER BY "24732186"
),
vz1860 AS
(
  SELECT "24731798" nat,
         COUNT(*) AS eff
  FROM tv_biogr_base_1860
  GROUP BY "24731798"
  ORDER BY "24731798"
)
SELECT t1.nat nat_1850,
       t1.eff eff_1850,
       t2.nat nat_1860,
       t2.eff eff_1860,
       CASE
         WHEN t3."24731753" IS NOT NULL THEN t3."24731753"
         ELSE t4."24731753"
       END nat_label
FROM vz1850 t1
  FULL OUTER JOIN vz1860 t2 ON t1.nat = t2.nat
  LEFT JOIN tv_id_staaten_kantone t3 ON t3."24731754" = t1.nat
  LEFT JOIN tv_id_staaten_kantone t4 ON t4."24731754" = t2.nat
  
;



SELECT *
FROM tv_id_staaten_kantone LIMIT 10;







SELECT pk_row,
        "24626623" AS name,
        "24626515" gender,
				CASE
         WHEN importer.isnumeric ("24626523") THEN "24626523"::INTEGER
         ELSE NULL
       END gebjahr,
       "24626525" AS religion,
       "24732186" AS nationality,
       CASE 
       		when "24732186" IN (46,47) THEN 301
       		when "24732186" IN (52,56) THEN 302
       		when "24732186" IN (65,68) THEN 303
       		when "24732186" IN (80) THEN 304
       		when "24732186" IN (143) THEN 305
       		when "24732186" IN (164) THEN 306
       		when "24732186" IN (201,213,220) THEN 307
        END AS coded_nationality_1850
       
       
 FROM tv_biogr_base_1850
 LIMIT 10;
 
SELECT pk_row,
        "24700267" AS name,
        "24626668" gender,
				CASE
         WHEN importer.isnumeric ("24626676") THEN "24626676"::INTEGER
         ELSE NULL
       END gebjahr,
       "24626680" AS religion,
       "24731798" AS nationality,
       CASE 
       		when "24731798" IN (46,47,48) THEN 301
       		when "24731798" IN (52,56,57) THEN 302
       		when "24731798" IN (65,66,68,69) THEN 303
       		when "24731798" IN (81) THEN 304
       		when "24731798" IN (144) THEN 305
       		when "24731798" IN (163) THEN 306
       		when "24731798" IN (201,220) THEN 307
        END AS coded_nationality_1860
       
       
 FROM tv_biogr_base_1860
 LIMIT 10;






/*** 

Création de la table finale d'ALIGNEMENT

***/



-- ca 5 minutes
-- effectif alignés (recall) : 14945  (20 février 2021)

--CREATE TEMPORARY TABLE tt_matched_persons AS


DROP TABLE importer.hisb_matched_persons_1850_1860 ;

CREATE TABLE importer.hisb_matched_persons_1850_1860  AS

WITH tw1 AS (
SELECT r_levenshtein,
			 r_similarity_forename,
       r_similarity_surname,
       gebjahr_vz1850,
       gebjahr_vz1860,
       gender,
       name_vz1850,
       name_vz1860,
       pk_row_vz1850,
       pk_row_vz1860,
       religion,
       nationality_vz1850,
       CASE
         WHEN id_nationality_vz1850 IN (46,47) THEN 301
         WHEN id_nationality_vz1850 IN (52,56) THEN 302
         WHEN id_nationality_vz1850 IN (65,68) THEN 303
         WHEN id_nationality_vz1850 IN (80) THEN 304
         WHEN id_nationality_vz1850 IN (143) THEN 305
         WHEN id_nationality_vz1850 IN (164) THEN 306
         WHEN id_nationality_vz1850 IN (201,213,220) THEN 307
         ELSE id_nationality_vz1850
       END AS id_coded_nationality_1850,
       nationality_vz1860,
       CASE
         WHEN id_nationality_vz1860 IN (46,47,48) THEN 301
         WHEN id_nationality_vz1860 IN (52,56,57) THEN 302
         WHEN id_nationality_vz1860 IN (65,66,68,69) THEN 303
         WHEN id_nationality_vz1860 IN (81) THEN 304
         WHEN id_nationality_vz1860 IN (144) THEN 305
         WHEN id_nationality_vz1860 IN (163) THEN 306
         WHEN id_nationality_vz1860 IN (201,220) THEN 307
         ELSE id_nationality_vz1860
       END AS id_coded_nationality_1860
FROM importer.hisb_matching_vz1850_vz1860_basics_similarity_name_vorname_03
)


SELECT tw1.r_levenshtein,
       tw1.r_similarity_forename,
       tw1.r_similarity_surname,
       tw1.gender,
       tw1.religion,
       tw1.pk_row_vz1850,
       tw1.name_vz1850,
       tw1.name_vz1860,
       tw1.pk_row_vz1860,
       tw1.gebjahr_vz1850,
       tw1.gebjahr_vz1860,
       (|/(gebjahr_vz1860 - gebjahr_vz1850)^2) diff_gebjahr,
       t1."24626521" beruf_1850,
       t2."24626674" beruf_1860,
       t1."24626519" zivstd_1850,
       t2."24626672" zivstd_1860,
       t1."24626495" quart_1850,
       t2."24626640" quart_1860,
       t1."24626485" haus_n_1850,
       t2."24626632" haus_n_1860,
       tw1.id_coded_nationality_1850 coded_nationality,
       tw1.nationality_vz1850,
       tw1.nationality_vz1860,
       t1."24626543" staat_1850,
       t2."24626694" staat_1860,
       t1."24626541" herk_1850,
       t2."24626692" herk_1860

       
FROM tw1,
		tv_biogr_base_1850 t1,
		tv_biogr_base_1860 t2
		
WHERE t1.pk_row = tw1.pk_row_vz1850
AND t2.pk_row = tw1.pk_row_vz1860
AND tw1.id_coded_nationality_1850 = tw1.id_coded_nationality_1860
  ;
  

-- effectif 14945 
SELECT COUNT(*) FROM importer.hisb_matched_persons_1850_1860;


-- liste de toutes les personnes alignées
-- hisb_matched_persons_1850_1860_20210219.csv
SELECT *
FROM importer.hisb_matched_persons_1850_1860
ORDER BY r_similarity_surname,
         r_similarity_forename;
-- birthyear diff lower than 2 : effectif = 11336  - than 2 : effectif = 10117
WHERE r_similarity_forename > 0.4
AND r_similarity_surname > 0.34
AND diff_gebjahr < 2 
ORDER BY r_similarity_surname,
         r_similarity_forename
LIMIT 100;

ORDER BY name_vz1850,
         name_vz1860;

 





/***
Matched from 1850
***/


--30052
SELECT COUNT(*)
FROM tv_biogr_base_1850;




/***

Persons 1851 aligned

***/

--10643
SELECT COUNT(*)
FROM tv_biogr_base_1850
WHERE pk_row IN (SELECT DISTINCT pk_row_vz1850
                     FROM importer.hisb_matched_persons_1850_1860);
--10643
SELECT pk_row,
       "24626623" AS name,
       "24626515" gender,
       CASE
         WHEN importer.isnumeric ("24626523") THEN "24626523"::INTEGER
         ELSE NULL
       END gebjahr,
       "24626525" AS religion,
       "24626521" beruf_1850,
       "24626519" zivstd_1850,
       "24626495" quart_1850,
       "24626485" haus_n_1850,
       "24732186" AS nationality,
       "24626543" staat_1850,
       "24626541" herk_1850
FROM tv_biogr_base_1850
WHERE pk_row IN (SELECT DISTINCT pk_row_vz1850
                     FROM importer.hisb_matched_persons_1850_1860)
 --;
LIMIT 10;



/***

Persons 1851 NOT aligned

***/


--19409
SELECT COUNT(*)
FROM tv_biogr_base_1850
WHERE pk_row NOT IN (SELECT DISTINCT pk_row_vz1850
                     FROM importer.hisb_matched_persons_1850_1860);



SELECT pk_row_vz1850 FROM importer.hisb_matched_persons_1850_1860 limit 10;


--19409
SELECT pk_row,
       "24626623" AS name,
       "24626515" gender,
       CASE
         WHEN importer.isnumeric ("24626523") THEN "24626523"::INTEGER
         ELSE NULL
       END gebjahr,
       "24626525" AS religion,
       "24626521" beruf_1850,
       "24626519" zivstd_1850,
       "24626495" quart_1850,
       "24626485" haus_n_1850,
       "24732186" AS nationality,
       "24626543" staat_1850,
       "24626541" herk_1850
FROM tv_biogr_base_1850
WHERE pk_row NOT IN (SELECT DISTINCT pk_row_vz1850
                     FROM importer.hisb_matched_persons_1850_1860)
-- ;
LIMIT 10;















-- 18 février 2021  : 58283

SELECT COUNT(*) FROM importer.matching_vz1850_vz1860_basics_similarity05;


SELECT *
FROM importer.hisb_matched_persons_1850_1860 LIMIT 50;






SELECT gebjahr_vz1850,
       nationality_vz1850,
       COUNT(*) freq
FROM importer.hisb_matched_persons_1850_1860
GROUP BY gebjahr_vz1850, nationality_vz1850
ORDER BY gebjahr_vz1850;





/***

Grouper par année et origines les personnes alignées

***/

WITH tw1 AS
(
  SELECT DISTINCT pk_row_vz1850,
  			gebjahr_vz1850,
         CASE
           WHEN nationality_vz1850 = 9 THEN 'BS'
           ELSE 'other'
         END nationality
  FROM importer.hisb_matched_persons_1850_1860
), tw2 AS (
SELECT gebjahr_vz1850, nationality,
       COUNT(*) AS eff
FROM tw1
GROUP BY gebjahr_vz1850,
         nationality
), tw3 AS  (

SELECT gebjahr_vz1850,
       CASE WHEN nationality = 'BS' THEN eff ELSE 0 END AS BS,
       CASE WHEN nationality = 'other' THEN eff ELSE 0 END AS other
FROM tw2
ORDER BY gebjahr_vz1850

)
SELECT gebjahr_vz1850 AS year,
       MAX(bs) AS bs,
       MAX(other) AS other,
       MAX(bs) +MAX(other) AS total
FROM tw3
GROUP BY gebjahr_vz1850
ORDER BY gebjahr_vz1850;





--- mème groupement pour personnes non alignées

WITH tw1 AS
(
  SELECT DISTINCT pk_row,
  			CASE
         WHEN importer.isnumeric ("24626523") THEN "24626523"::INTEGER
         ELSE NULL
       END gebjahr_vz1850,
         CASE
           WHEN "24732186" = 9 THEN 'BS'
           ELSE 'other'
         END nationality
         FROM tv_biogr_base_1850
							WHERE pk_row NOT IN (SELECT DISTINCT pk_row_vz1850
                     FROM importer.hisb_matched_persons_1850_1860)

), tw2 AS (
SELECT gebjahr_vz1850, nationality,
       COUNT(*) AS eff
FROM tw1
GROUP BY gebjahr_vz1850,
         nationality
), tw3 AS  (

SELECT gebjahr_vz1850,
       CASE WHEN nationality = 'BS' THEN eff ELSE 0 END AS BS,
       CASE WHEN nationality = 'other' THEN eff ELSE 0 END AS other
FROM tw2
ORDER BY gebjahr_vz1850

)
SELECT gebjahr_vz1850 AS year,
       MAX(bs) AS bs,
       MAX(other) AS other,
       MAX(bs) +MAX(other) AS total
FROM tw3
GROUP BY gebjahr_vz1850
ORDER BY gebjahr_vz1850;







/****

CREATION DES ALIGNEMENTS  entre VZ1850 et les entités

****/


SELECT *
FROM data.digital
ORDER BY pk_entity DESC LIMIT 10;




/*
List the table columns of the alignement table VZ1850-VZ1860

24739960	pk_row_vz1850
24739961	pk_row_vz1860
*/
       
SELECT pk_entity, id_for_import_txt        
FROM data.column
WHERE fk_digital = 24739954;



-- VZ1850 : rebuild (virtual) table with relevant columns : pk_row_vz1850, pk_row_vz1860, name VZ 1850, name VZ 1860
SELECT *
FROM tables.rebuild_partitioned_table (24739954,'tv_align_1850_1860',ARRAY[24739960,24739961,24739963,24739964]::INTEGER[]);

SELECT * FROM tv_align_1850_1860 LIMIT 10;

SELECT COUNT(*) FROM tv_align_1850_1860;  -- effectif 11196



-- 1027 lignes, mentions alignées sur plusieurs personnes
SELECT "24739961", count(*) as eff
FROM tv_align_1850_1860
--WHERE fk_object_info NOT IN (300718)
group by "24739961"
having count(*) > 1
ORDER BY eff desc
LIMIT 2000;

SELECT * FROM tv_align_1850_1860 where "24739961" = 24685322;



-- 979 lignes, mentions alignées sur plusieurs personnes
SELECT "24739960", count(*) as eff
FROM tv_align_1850_1860
--WHERE fk_object_info NOT IN (300718)
group by "24739960"
having count(*) > 1
ORDER BY eff desc
LIMIT 2000;

SELECT * FROM tv_align_1850_1860 where "24739960" = 24645717;




/*
List the table columns of the VZ1860 table 

Colonne alignée :  24700267 Added FB 3 November 2020 - concatenation of cell values for columns: 24626664, 24626666  - separated by one space 
*/
       
SELECT pk_entity, id_for_import_txt, metadata, notes
FROM data.column
WHERE fk_digital = 24626627;


/*
List the table columns of the VZ1850 table 

Colonne alignée :  24626623	Name und Vorname	{"importer_original_label": "col_72"}	In field id_for_import_txt: original column label
*/
       
SELECT pk_entity, id_for_import_txt, metadata, notes
FROM data.column
WHERE fk_digital = 24626480;



-- Georg Abig
SELECT *
FROM information.statement
WHERE fk_object_info = 300718
AND   fk_property = 1334
AND   fk_subject_tables_cell IS NOT NULL;



WITH tw1 AS (
-- chercher les cells de la table 1860
SELECT t2.fk_row,
       t2.string_value,
       t1."24739963" name_vz1850,
       t2.pk_cell pk_cell_1860,
       t1."24739960" pk_row_vz1850
FROM tv_align_1850_1860 t1,
			tables.cell_24626627 t2
WHERE t1."24739961" = t2.fk_row 
AND t2.fk_column = 24700267   -- colonne alignée avec la personne dans information
)

SELECT pk_row_vz1850,
       COUNT(*) AS eff
FROM tw1
GROUP BY pk_row_vz1850
HAVING COUNT(*) > 1
ORDER BY eff DESC;

 




/***
Les valeurs pour l'aglinement
***/

WITH tw1 AS (
-- chercher les cells de la table 1860
SELECT t2.fk_row,
       t2.string_value,
       t1."24739963" name_vz1850,
       t2.pk_cell pk_cell_1860,
       t1."24739960" pk_row_vz1850
FROM tv_align_1850_1860 t1,
			tables.cell_24626627 t2
WHERE t1."24739961" = t2.fk_row 
AND t2.fk_column = 24700267   -- colonne alignée avec la personne dans information
), 
tw2 AS (
SELECT tw1.*,
       t3.fk_object_info,
       t4.pk_cell pk_cell_1850
FROM tw1,
     information.statement t3,
     tables.cell_24626480 t4
WHERE t3.fk_subject_tables_cell = tw1.pk_cell_1860
AND   t3.fk_property = 1334
AND   t4.fk_row = tw1.pk_row_vz1850
AND   t4.fk_column = 24626623
)

-- 1182 lignes, mentions alignées sur plusieurs personnes
SELECT pk_row_vz1850, count(*) as freq
FROM tw2
WHERE fk_object_info NOT IN (300718)
group by pk_row_vz1850
having count(*) > 1
ORDER BY freq desc
LIMIT 2000;


select fk_object_info, pk_cell_1850
from tw2
limit 10;


-- 1182 lignes, mentions alignées sur plusieurs personnes
SELECT pk_row_vz1850, count(*) as eff
FROM tw2
WHERE fk_object_info NOT IN (300718)
group by pk_row_vz1850
having count(*) > 1
ORDER BY eff desc
LIMIT 2000;

-- 1029 lignes, une personne peut être plusieurs mentions
SELECT fk_object_info, count(*) as eff
FROM tw2
WHERE fk_object_info NOT IN (300718)
group by fk_object_info
having count(*) > 1
ORDER BY eff desc
LIMIT 2000;


-- 0 lignes, i.e. pas de doublons d'alignement
SELECT pk_row_vz1850, fk_object_info, count(*) as eff
FROM tw2
WHERE fk_object_info NOT IN (300718)
group by pk_row_vz1850, fk_object_info
having count(*) > 1
ORDER BY eff desc
LIMIT 2000;


-- 1182 lignes, mentions alignées sur plusieurs personnes
SELECT pk_row_vz1850, count(*) as eff
FROM tw2
WHERE fk_object_info NOT IN (300718)
group by pk_row_vz1850
having count(*) > 1
ORDER BY eff desc
LIMIT 2000;




-- 11395 lignes
SELECT COUNT(*) 
FROM tw2
WHERE fk_object_info NOT IN (300718);


-- {"source": {"pk_row": 24667365, "import_id": "import_20190925_1", "digital_id": 24626627, "digital_label": "Volkszählung 1860"}}








----









































-- automne 2020
SELECT COUNT(*) FROM importer.matching_vz1850_vz1860_biogr_similarity05;
SELECT COUNT(*) FROM importer.matching_vz1850_vz1860_biogr;
SELECT COUNT(*) FROM importer.matching_vz1850_vz1860_basics;





SELECT count(*), pk_row_vz1850 FROM importer.matching_vz1850_vz1860_basics group by pk_row_vz1850;

SELECT * FROM importer.matching_vz1850_vz1860_biogr where pk_row_vz1850 = 24626872;




SELECT *
FROM importer.matching_vz1850_vz1860_biogr LIMIT 100;

SELECT herk_1850, COUNT(*) eff
FROM importer.matching_vz1850_vz1860_biogr GROUP BY herk_1850 ;






WITH tw1 AS (SELECT gender_vz1850,
       --gender_vz1860,
       r_levenshtein,
       r_similarity,
       pk_row_vz1850,
       pk_row_vz1860,
       name_vz1850,
       name_vz1860,
       gebjahr_vz1850,
       gebjahr_vz1860,
       konf_1850,
       konf_1860,
       CASE WHEN staat_1850 = 'Schweiz' THEN herk_1850 ELSE staat_1850 END herk_combi_1850,
       CASE WHEN staat_1860 = 'Schweiz' THEN herk_1860 ELSE staat_1860 END herk_combi_1860,
       beruf_1850,
       beruf_1860,
       zivstd_1850,
       zivstd_1860,
       staat_1850,
       staat_1860,
       quart_1850,
       quart_1860,
       haus_n_1850,
       haus_n_1860
FROM importer.matching_vz1850_vz1860_biogr_similarity05
where r_similarity > 0.5),
tw2 AS (
SELECT *
FROM tw1
WHERE konf_1850 = konf_1860
AND   herk_combi_1850 = herk_combi_1860),
tw3 AS (
SELECT COUNT(*) AS eff,
       pk_row_vz1850
FROM tw2
GROUP BY pk_row_vz1850
HAVING COUNT(*) > 1
)
SELECT * FROM tw2 WHERE pk_row_vz1850 NOT IN (SELECT pk_row_vz1850 FROM tw3);
AND name_vz1860 ~ 'geb';

/* Vérification
SELECT COUNT(*) AS eff,
       pk_row_vz1850
FROM tw2
WHERE pk_row_vz1850 NOT IN (SELECT pk_row_vz1850 FROM tw3)
GROUP BY pk_row_vz1850
ORDER BY eff DESC;
*/


AND name_vz1860 ~ 'geb';

--SELECT * FROM tw2;
--SELECT COUNT(*) FROM tw2; -- 7964
SELECT count(*) AS eff, pk_row_vz1850 from tw2 group by pk_row_vz1850 order by eff desc;
SELECT herk_combi_1850, COUNT(*) eff -- 4308 BS  = 0.54
FROM tw2
GROUP BY herk_combi_1850
ORDER BY eff DESC;
-- 24644404: Madgalena Stump
WHERE pk_row_vz1850 = 24616985;

-- la proportion de balois BS parmi les personnes alignées
SELECT 4308/7964::numeric; -- 0.54
 -- la proportion de balois BS alignés par rapport à tous les balois
SELECT 4308/11233::numeric; -- 0.30

SELECT COUNT(*)
FROM importer.matching_vz1850_vz1860_basics_similarity05;


select count(*) from importer.matching_vz1850_vz1860_basics --_similarity05
where r_similarity > 0.65;
limit 500;





------------



