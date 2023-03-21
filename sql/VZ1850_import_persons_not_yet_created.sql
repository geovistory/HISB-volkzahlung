/****

Documentation about the import of not yet created VZ 1850 persons

****/


SELECT *
FROM tables.rebuild_partitioned_table (24739954,'tv_align_1850_1860',ARRAY[24739960,24739961,24739963,24739964, 24739962]::INTEGER[]);

SELECT * FROM tv_align_1850_1860 LIMIT 10;

SELECT COUNT(*) FROM tv_align_1850_1860;  --11196
SELECT COUNT(*) FROM tv_align_1850_1860 WHERE "24739962" = 0;  -- 107
SELECT COUNT(*) FROM tv_align_1850_1860 WHERE "24739962" = 1;  -- 11089



/*
VZ1850 - List the table columns
*/
SELECT pk_entity,
       id_for_import_txt
FROM data.column
WHERE fk_digital = 24626480;

-- VZ1850 : rebuild (virtual) table with relevant columns
SELECT *
FROM tables.rebuild_partitioned_table (24626480,'tv_biogr_base_1850',ARRAY[24626623,24626513,
				24626511,24626515,24626523,24626521, 24626525,24626537, 24732186, 24732187,24626541,24626543,24626495, 24626485,24626519]::INTEGER[]);

SELECT * FROM tv_biogr_base_1850 LIMIT 10;

SELECT COUNT(*) FROM tv_biogr_base_1850;  --30052


SELECT 11089 + 20118;  --  31207 : excédent de 1155 personnes – impossible en l'état de vérifier, des erreurs resteront [FB, 30 avril 2021]
SELECT 31207 - 30052;   -- 1155


-- To be created  : 20118

SELECT COUNT(*)
FROM tv_biogr_base_1850
WHERE pk_row NOT IN (SELECT "24739960" FROM tv_align_1850_1860 WHERE "24739962" = 1);  

-- personnes à importer
SELECT *
FROM tv_biogr_base_1850
WHERE pk_row NOT IN (SELECT "24739960" FROM tv_align_1850_1860 WHERE "24739962" = 1)
LIMIT 20;  





-- 20118 personnes à importer
WITH tw1 AS
(
SELECT DISTINCT *
FROM tv_biogr_base_1850
WHERE pk_row NOT IN (SELECT "24739960" FROM tv_align_1850_1860 WHERE "24739962" = 1)

)
/*
SELECT COUNT(*)
FROM tw1;
*/
SELECT DISTINCT 21,8,8,('{"source": {"import_id": "import_20210430_1",
          "digital_id": 24626480, "digital_label": "Volkszählung 1850 New Persons Production", 
          "pk_row": ' || pk_row || '}}')::JSONB import_metadata   --, pk_row
FROM tw1
--ORDER BY pk_row
LIMIT 20;  




/*
PERSONS

Insert persistent items, class 21 Person
20118 rows affected

*/ 
-- INSERT INTO information.persistent_item
(fk_class,fk_creator,fk_last_modifier,metadata) 
-- 20118 personnes à importer, cf. ci-dessus
WITH tw1 AS
(
SELECT DISTINCT *
FROM tv_biogr_base_1850
WHERE pk_row NOT IN (SELECT "24739960" FROM tv_align_1850_1860 WHERE "24739962" = 1)

)
SELECT DISTINCT 21,8,8,('{"source": {"import_id": "import_20210430_1",
          "digital_id": 24626480, "digital_label": "Volkszählung 1850 New Persons Production", 
          "pk_row": ' || pk_row || '}}')::JSONB import_metadata
FROM tw1;




/*
TeEn: APPELLATION FOR LANGUAGE
Insert appellations for language: 20118 rows affected

*/ 
--INSERT INTO information.temporal_entity(fk_class,fk_creator,fk_last_modifier,metadata)
SELECT DISTINCT 365,
       8,
       8,
       ('{"source": {"import_id": "import_20210430_2",
       "pk_digital" : 24626480,
          "pk_row": ' ||(t0.metadata #> '{"source","pk_row"}')::TEXT::INTEGER|| ',
          "pk_entity_person": ' || t0.pk_entity || '}}')::JSONB
FROM information.persistent_item t0
WHERE t0.fk_class = 21
AND   TRIM('"' FROM (t0.metadata #> '{"source","import_id"}')::VARCHAR) = 'import_20210430_1';



-- 18113 noms à importer dont 14942 pas encore existants le 30 avril
WITH tw1 AS
(
SELECT DISTINCT *
FROM tv_biogr_base_1850
WHERE pk_row NOT IN (SELECT "24739960" FROM tv_align_1850_1860 WHERE "24739962" = 1)

), tw2 AS (
SELECT DISTINCT TRIM("24626623")
FROM tw1
WHERE length("24626623") > 0
AND TRIM("24626623") NOT IN (SELECT TRIM(string)
FROM information.appellation
WHERE fk_class = 40))

SELECT COUNT (*) from tw2;


SELECT TRIM(string)
FROM information.appellation
WHERE fk_class = 40 LIMIT 10;



/***
APPELLATIONS

Créer les appellations qui manquent

*/ 

--- 14942 rows affected

WITH tw1 AS
(
SELECT DISTINCT *
FROM tv_biogr_base_1850
WHERE pk_row NOT IN (SELECT "24739960" FROM tv_align_1850_1860 WHERE "24739962" = 1)

), tw2 AS (
SELECT DISTINCT TRIM("24626623") AS name
FROM tw1
WHERE length("24626623") > 0
AND TRIM("24626623") NOT IN (SELECT TRIM(string)
FROM information.appellation
WHERE fk_class = 40))

--INSERT INTO information.v_appellation (fk_class,fk_creator,fk_last_modifier,string)
SELECT DISTINCT 40,
       8,
       8,
       name
FROM tw2;


/***

Vérifie les dernières lignes importées

***/ 

--14942 noms ont été créés
SELECT COUNT(*)
FROM information.appellation
WHERE tmsp_creation BETWEEN '2021-04-30 23:30:01' AND '2021-04-30 23:51:01';




/*
Produce appellation rôles for persons: 
INSERT INTO information.statement successful
20118 rows affected

*/ 
--INSERT INTO information.statement(fk_property,fk_creator,fk_last_modifier,fk_subject_info,fk_object_info,metadata) 
SELECT 1111,
       8,
       8,
       pk_entity information,
       (metadata #> '{"source","pk_entity_person"}')::VARCHAR::INTEGER person,
       ('{"source": {"import_id": "import_20210430_3"}}')::JSONB
FROM information.temporal_entity
WHERE TRIM('"' FROM (metadata #> '{"source","import_id"}')::TEXT) = 'import_20210430_2';
--LIMIT 50
;
/***
Compter les rôles produits : 20118
*/ 
SELECT COUNT(*)
FROM information.statement
WHERE TRIM('"' FROM (metadata #> '{"source","import_id"}')::TEXT) = 'import_20210430_3';



--- 20112 lignes, manquent deux personnes qui ont des appellation vides, peut-être des enfants. Pas vérifie.
WITH tw1 AS
(
SELECT DISTINCT *
FROM tv_biogr_base_1850
WHERE pk_row NOT IN (SELECT "24739960" FROM tv_align_1850_1860 WHERE "24739962" = 1)

), tw2 AS (
SELECT DISTINCT TRIM("24626623") AS name, pk_row
FROM tw1
WHERE length("24626623") > 0)

SELECT DISTINCT 1113,
       8,
       8,
  	 	tw2.name,
       (t0.metadata #> '{"source","pk_row"}')::TEXT::INTEGER pk_row,
       t0.pk_entity pk_temporal_entity,
       t1.pk_entity pk_appellation,
       ('{"source": {"import_id": "import_20210430_4",
				  "pk_row": "' || (t0.metadata #> '{"source","pk_row"}')::TEXT::INTEGER || '"}}')::JSONB import_metadata
FROM information.temporal_entity t0
  JOIN tw2 ON tw2.pk_row = (t0.metadata #> '{"source","pk_row"}')::TEXT::INTEGER
  LEFT JOIN information.appellation t1 ON t1.string = tw2.name
WHERE t0.fk_class = 365
AND   TRIM('"' FROM (t0.metadata #> '{"source","import_id"}')::VARCHAR) = 'import_20210430_2';



/*
Create role for appellation
20116 rows affected
*/ 

WITH tw1 AS
(
SELECT DISTINCT *
FROM tv_biogr_base_1850
WHERE pk_row NOT IN (SELECT "24739960" FROM tv_align_1850_1860 WHERE "24739962" = 1)

), tw2 AS (
SELECT DISTINCT TRIM("24626623") AS name, pk_row
FROM tw1
WHERE length("24626623") > 0)
/*
INSERT INTO information.statement
(
  fk_property,
  fk_creator,
  fk_last_modifier,
  fk_subject_info,
  fk_object_info,
  metadata
)
*/

SELECT DISTINCT 1113,
       8,
       8,
       t0.pk_entity pk_temporal_entity,
       t1.pk_entity pk_appellation,
       ('{"source": {"import_id": "import_20210430_4",
				  "pk_row": "' || (t0.metadata #> '{"source","pk_row"}')::TEXT::INTEGER || '"}}')::JSONB import_metadata
FROM information.temporal_entity t0
  JOIN tw2 ON tw2.pk_row = (t0.metadata #> '{"source","pk_row"}')::TEXT::INTEGER
  LEFT JOIN information.appellation t1 ON t1.string = tw2.name
WHERE t0.fk_class = 365
AND   TRIM('"' FROM (t0.metadata #> '{"source","import_id"}')::VARCHAR) = 'import_20210430_2';



/***
Compter les rôles produits : 20116
*/ 
SELECT COUNT(*)
FROM information.statement
WHERE TRIM('"' FROM (metadata #> '{"source","import_id"}')::TEXT) = 'import_20210430_4';





/*

Attention !!!

Ajouter 'CALENDAR' when associating time-primitives !!!


*/
--INSERT INTO projects.info_proj_rel
(
  entity_version,
  fk_entity,
  fk_creator,
  fk_last_modifier,
  fk_project,
  --calendar,
  is_in_project,
  notes
)
 
SELECT 1,
       pk_entity,
       fk_creator,
       fk_last_modifier,
       374840,
       --'gregorian',
       TRUE,
       'import_20210430_4' || '_project_association'
FROM information.entity
WHERE TRIM((metadata #> '{"source","import_id"}')::VARCHAR,'"') = 'import_20210430_4'
ORDER BY pk_entity DESC;

/*
DONE FOR:
import_20210430_1
import_20210430_2
import_20210430_3
import_20210430_4
*/ 


SELECT COUNT(*)
FROM projects.info_proj_rel
WHERE notes = 'import_20210430_4_project_association';


SELECT *
FROM war.entity_preview
WHERE pk_entity = 1357304;




-- 20116 rows affected
/*
INSERT INTO information.statement
(
  fk_property,
  fk_creator,
  fk_last_modifier,
  fk_subject_tables_cell,
  fk_object_info,
  metadata
)
*/
SELECT DISTINCT 1334,
       8,
       8,
       t1.pk_cell,
       t0.pk_entity,
       ('{"source": {"import_id": "import_20210430_5",
       "pk_digital" : 24626480,
          "pk_row": ' ||(t0.metadata #> '{"source","pk_row"}')::TEXT::INTEGER|| ',
          "pk_entity_person": ' || t0.pk_entity || '}}')::JSONB
FROM information.persistent_item t0, tables.cell_24626480 t1
WHERE t0.fk_class = 21
AND   TRIM('"' FROM (t0.metadata #> '{"source","import_id"}')::VARCHAR) = 'import_20210430_1'
AND t1.fk_row = (t0.metadata #> '{"source","pk_row"}')::TEXT::INTEGER
AND t1.fk_column = 24626623;

LIMIT 10;
 



/*
INSERT INTO projects.info_proj_rel successful
20116 rows affected
*/

/*
INSERT INTO projects.info_proj_rel
(
  entity_version,
  fk_entity,
  fk_creator,
  fk_last_modifier,
  fk_project,
  is_in_project,
  notes
) 
--*/

SELECT 1,
       pk_entity,
       fk_creator,
       fk_last_modifier,
       374840,
       TRUE,
       'import_20210430_5' || '_project_association'
FROM information.statement
WHERE TRIM('"' FROM (metadata #> '{"source","import_id"}')::VARCHAR) = 'import_20210430_5';




---- manquent / à faire FB 1 décembre 2020





/***

BIRTH

Count = 39040

***/ 
SELECT DISTINCT 24626788 AS column_id,
       8,
       24626627,
       8,
       24626451,
       (t0.metadata #> '{"source","pk_row"}')::TEXT::INTEGER fk_row,
       t0.pk_entity AS identifier,
       t1.gebjahr
--, replace((t0.metadata #> '{"source","import_id"}')::TEXT, '"', ''), *, t0.pk_entity
       FROM information.persistent_item t0,
     t_names t1
WHERE (t0.metadata #> '{"source","pk_row"}')::TEXT::INTEGER = t1.pk_row
AND   t0.fk_class = 21
AND   TRIM((t0.metadata #> '{"source","import_id"}')::VARCHAR,'"') = 'import_20190925_1'
AND   t1.gebjahr > 0
--order by t0.pk_entity desc
LIMIT 50;

/***

Vérifier où manque le calendar 'gregorian' 
***/ 
SELECT COUNT(*)
FROM information.role t1,
     information.time_primitive t2,
     projects.info_proj_rel t3
WHERE t1.fk_entity = t2.pk_entity
AND   t3.fk_entity = t1.pk_entity
AND   t3.calendar IS NULL;

SELECT COUNT(*)
FROM information.persistent_item t0,
     t_names t1
WHERE (t0.metadata #> '{"source","pk_row"}')::TEXT::INTEGER = t1.pk_row
AND   t0.fk_class = 21
AND   TRIM((t0.metadata #> '{"source","import_id"}')::VARCHAR,'"') = 'import_20190925_1'
AND   t1.gebjahr > 0;

/***

BIRTH

Count = 39040

***/ 
SELECT DISTINCT 24626788 AS column_id,
       8,
       24626627,
       8,
       24626451,
       (t0.metadata #> '{"source","pk_row"}')::TEXT::INTEGER fk_row,
       t0.pk_entity AS identifier,
       t1.gebjahr
--, replace((t0.metadata #> '{"source","import_id"}')::TEXT, '"', ''), *, t0.pk_entity
       FROM information.persistent_item t0,
     t_names t1
WHERE (t0.metadata #> '{"source","pk_row"}')::TEXT::INTEGER = t1.pk_row
AND   t0.fk_class = 21
AND   TRIM((t0.metadata #> '{"source","import_id"}')::VARCHAR,'"') = 'import_20190925_1'
AND   t1.gebjahr > 0
--order by t0.pk_entity desc
LIMIT 50;

/***
BIRTH   INSERT

39040 rows affected

***/ 
-- INSERT INTO information.temporal_entity
(fk_class,fk_creator,fk_last_modifier,metadata)
SELECT DISTINCT 61,
       8,
       8,
       ('{"source": {"import_id": "import_20190927_1",
       "pk_digital" : 24626627,
          "pk_row": ' ||(t0.metadata #> '{"source","pk_row"}')::TEXT::INTEGER|| ',
          "pk_entity_person": ' || t0.pk_entity || '}}')::JSONB
FROM information.persistent_item t0,
     t_names t1
WHERE (t0.metadata #> '{"source","pk_row"}')::TEXT::INTEGER = t1.pk_row
AND   t0.fk_class = 21
AND   TRIM((t0.metadata #> '{"source","import_id"}')::VARCHAR,'"') = 'import_20190925_1'
AND   t1.gebjahr > 0;

SELECT *
FROM information.temporal_entity
ORDER BY pk_entity DESC LIMIT 10;

/***

Birth rôles for persons:      P98 brought into life → E21 Person
39040 rows affected

***/ 
--INSERT INTO information.role(fk_property,fk_creator,fk_last_modifier,fk_entity,fk_temporal_entity,metadata) 
SELECT 86,
       8,
       8,
       (metadata #> '{"source","pk_entity_person"}')::VARCHAR::INTEGER person,
       pk_entity,
       ('{"source": {"import_id": "import_20190927_2"}}')::JSONB
FROM information.temporal_entity
WHERE TRIM('"' FROM (metadata #> '{"source","import_id"}')::TEXT) = 'import_20190927_1';

--limit 50;
SELECT *
FROM information.time_primitive
ORDER BY pk_entity DESC LIMIT 10;

WITH tw1 AS
(
  SELECT TO_CHAR('1850-01-01'::DATE,'J')::INTEGER julian_day,
         '1 year' duration
)
SELECT tw1.*,t1.*
FROM information.time_primitive t1,
     tw1
WHERE t1.julian_day = tw1.julian_day
AND   t1.duration::TEXT = tw1.duration
ORDER BY pk_entity DESC LIMIT 10;


WITH tw1
AS
(SELECT DISTINCT TO_CHAR((t1.gebjahr::VARCHAR|| '-01-01')::DATE,'J')::INTEGER julian_day,
       '1 year' duration,
       t1.gebjahr
FROM information.temporal_entity t0,
     t_names t1
WHERE (t0.metadata #> '{"source","pk_row"}')::TEXT::INTEGER = t1.pk_row
AND   t0.fk_class = 61
AND   TRIM((t0.metadata #> '{"source","import_id"}')::VARCHAR,'"') = 'import_20190927_1'
AND   t1.gebjahr > 0),tw2 AS (SELECT *
                              FROM information.time_primitive t1,
                                   tw1
                              WHERE t1.julian_day = tw1.julian_day
                              AND   t1.duration::TEXT = tw1.duration)
select * from tw1;                              



/***

Cette requête vérifie d'abord quelles années sont déjà dans les valeurs, 
puis AJOUTE celles qui manquent

89 created
***/ 
WITH tw1
AS
(SELECT DISTINCT TO_CHAR((t1.gebjahr::VARCHAR|| '-01-01')::DATE,'J')::INTEGER julian_day,
       '1 year' duration,
       t1.gebjahr
FROM information.temporal_entity t0,
     t_names t1
WHERE (t0.metadata #> '{"source","pk_row"}')::TEXT::INTEGER = t1.pk_row
AND   t0.fk_class = 61
AND   TRIM((t0.metadata #> '{"source","import_id"}')::VARCHAR,'"') = 'import_20190927_1'
AND   t1.gebjahr > 0),tw2 AS (SELECT *
                              FROM information.time_primitive t1,
                                   tw1
                              WHERE t1.julian_day = tw1.julian_day
                              AND   t1.duration::TEXT = tw1.duration)
--INSERT INTO information.time_primitive
(fk_class,fk_creator,fk_last_modifier,julian_day,duration) SELECT DISTINCT 335,8,8,TO_CHAR((t1.gebjahr::VARCHAR|| '-01-01')::DATE,'J')::INTEGER julian_day,'1 year'::calendar_granularities FROM information.temporal_entity t0,t_names t1 WHERE (t0.metadata #> '{"source","pk_row"}')::TEXT::INTEGER = t1.pk_row AND t0.fk_class = 61 AND TRIM((t0.metadata #> '{"source","import_id"}')::VARCHAR,'"') = 'import_20190927_1' AND t1.gebjahr > 0 AND t1.gebjahr NOT IN (SELECT gebjahr FROM tw2);

/***

Insert des rôles qui associent l'année de naissance
39040 rows affected

***/ 
BEGIN;

WITH tw1 AS
(
  SELECT t0.pk_entity,
         t1.pk_row,
         TO_CHAR((t1.gebjahr::VARCHAR|| '-01-01')::DATE,'J')::INTEGER julian_day,
         '1 year'::calendar_granularities duration
  FROM information.temporal_entity t0
    JOIN t_names t1 ON (t0.metadata #> '{"source","pk_row"}')::TEXT::INTEGER = t1.pk_row
  WHERE t0.fk_class = 61
  AND   TRIM((t0.metadata #> '{"source","import_id"}')::VARCHAR,'"') = 'import_20190927_1'
  AND   t1.gebjahr > 0
  --LIMIT 100
) INSERT INTO information.role
(
  fk_property,
  fk_creator,
  fk_last_modifier,
  fk_entity,
  fk_temporal_entity,
  metadata
)
SELECT 72,
       8,
       8,
       t2.pk_entity pk_time_primitive,
       tw1.pk_entity pk_temporal_entity,
       ('{"source": {"import_id": "import_20190927_3", "pk_row": ' || tw1.pk_row || '}}')::JSONB
FROM tw1
  LEFT JOIN information.time_primitive t2
         ON t2.julian_day = tw1.julian_day
        AND t2.duration = tw1.duration
WHERE t2.pk_entity IS NOT NULL;

/***

Mettre à jour les ASSOCIATION AU PROJET

***/ 
SELECT entity_version,
       fk_entity,
       fk_creator,
       fk_last_modifier,
       fk_project,
       is_in_project,
       notes
FROM projects.info_proj_rel LIMIT 30;

BEGIN;

ALTER TABLE projects.info_proj_rel DISABLE TRIGGER after_epr_upsert;






/*

Attention !!!

Ajouter 'CALENDAR' for associating time-primitives


APPELLATIONS NOT YET DONE
import_20190926_1




*/ 
--INSERT INTO projects.info_proj_rel
(
  entity_version,
  fk_entity,
  fk_creator,
  fk_last_modifier,
  fk_project,
  calendar,
  is_in_project,
  notes
)
SELECT 1,
       pk_entity,
       fk_creator,
       fk_last_modifier,
       374840,
       'gregorian',
       TRUE,
       'import_20190927_3' || '_project_association'
FROM information.entity
WHERE TRIM((metadata #> '{"source","import_id"}')::VARCHAR,'"') = 'import_20190927_3'
ORDER BY pk_entity DESC;

/*
DONE FOR:
import_20190925_1
import_20190925_2
import_20190925_3
import_20190926_2
import_20190927_1
import_20190927_2
import_20190927_3
*/ 
ALTER TABLE projects.info_proj_rel ENABLE TRIGGER after_epr_upsert;

COMMIT;

/*
ATTENTION : l'exécution prend plusieurs minutes
*/ 
SELECT warehouse.entity_preview__create_all();

