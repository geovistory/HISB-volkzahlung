/****

Documentation about the import of not yet importerd 1860 persons

****/



/**
LISTE der SPALTEN 
in der 1860 Tabelle

TAble ID = 24626627
**/

SELECT t0.pk_entity, t0.id_for_import, t0.id_for_import_txt, t2.definition data_type, t1.definition column_type, t0.is_imported, t0.fk_original_column, t0.fk_publication_status, t0.fk_creator, t0.fk_last_modifier, t0.fk_digital, t0.fk_license, t0.fk_namespace, t0.metadata, t0.notes, t0.schema_name, t0.sys_period, t0.table_name, t0.entity_version, t0.tmsp_creation, t0.tmsp_last_modification
FROM data.column t0
  LEFT JOIN system.system_type t1 ON t1.pk_entity = t0.fk_column_content_type
  LEFT JOIN system.system_type t2 ON t2.pk_entity = t0.fk_data_type
WHERE fk_digital = 24626627;

-- colonne ajoutée qui contient la pk_entity de la personne créée, elle devrait en fait se trouver dans cette table cell_24626627
SELECT *
FROM tables.cell -- tables.cell_24626627
WHERE fk_column IN (24626788) LIMIT 100;

SELECT count(*)
FROM tables.cell -- tables.cell_24626627
WHERE fk_column IN (24626788) LIMIT 100;


SELECT count(*)
/*
DISTINCT 1,
       24626788 AS column_id,
       8,
       24626627,
       8,
       24626451,
       (t0.metadata #> '{"source","pk_row"}')::TEXT::INTEGER fk_row,
       t0.pk_entity AS identifier
*/
       FROM information.persistent_item t0
WHERE t0.fk_class = 21
AND   (t0.metadata #> '{"source","import_id"}')::VARCHAR = '"import_20190925_1"';


/***
Les personnes non importées : 2089 le 23 novembre 2020
***/

/*
Attention
pk_entity: 300718, pk_row : 24675186,24673892
Georg Abig Produit manuellement et doublon dans la table d'origine
Je l'utilise pour produire des données à la main
*/ 


WITH tw1
AS
(SELECT pk_row_1 AS pk_row
FROM importer.hisb_t_name_comparison_1860
WHERE 1 = 1
AND   (gebjahr_1 = gebjahr_2 OR konf_1 = konf_2 AND herk_1 = herk_2)
UNION
SELECT pk_row_2 AS pk_row
FROM importer.hisb_t_name_comparison_1860
WHERE 1 = 1
AND   (gebjahr_1 = gebjahr_2 OR konf_1 = konf_2 AND herk_1 = herk_2)) 

SELECT COUNT(*)
FROM tw1
-- i.e. not Georg Abig
WHERE pk_row NOT IN (24675186,24673892); 



-- comparaison table des personnes importées et non importées
WITH tw1 AS
(
  SELECT name_1 AS name,
         pk_row_1 AS pk_row
  FROM importer.hisb_t_name_comparison_1860
  UNION
  SELECT name_2 AS name,
         pk_row_2 AS pk_row
  FROM importer.hisb_t_name_comparison_1860
),
tw2 AS (
SELECT (t0.metadata #> '{"source","pk_row"}')::TEXT::INTEGER fk_row
       FROM information.persistent_item t0
WHERE  (t0.metadata #> '{"source","import_id"}')::VARCHAR = '"import_20190925_1"'
AND t0.fk_class = 21
)

/*
SELECT * from tw1 LIMIT  20;
*/

/*
SELECT COUNT(*)
FROM tw1
WHERE tw1.pk_row  IN (SELECT pk_row FROM tw2)
AND tw1.pk_row NOT IN (24675186,24673892);
*/


SELECT *
FROM tw1
WHERE tw1.pk_row NOT IN (SELECT fk_row FROM tw2);
AND tw1.pk_row NOT IN (24675186,24673892)
ORDER BY name LIMIT 10;

-- haushalt nummer spital = 621 : 410 Personene

-- Herkunft
WITH tw1 AS
(
  SELECT herk_1 AS origin,
         pk_row_1 AS pk_row
  FROM importer.hisb_t_name_comparison_1860
  UNION
  SELECT herk_2 AS origin,
         pk_row_2 AS pk_row
  FROM importer.hisb_t_name_comparison_1860
)
SELECT origin,
       COUNT(*) AS eff
FROM tw1
GROUP BY origin
ORDER BY origin;

ORDER BY eff DESC;


-- Konfession
WITH tw1 AS
(
  SELECT konf_1 AS konf,
         pk_row_1 AS pk_row
  FROM importer.hisb_t_name_comparison_1860
  UNION
  SELECT konf_2 AS konf,
         pk_row_2 AS pk_row
  FROM importer.hisb_t_name_comparison_1860
)
SELECT konf,
       COUNT(*) AS eff
FROM tw1
GROUP BY konf
ORDER BY konf;

ORDER BY eff DESC;



SELECT  *
FROM importer.hisb_t_name_comparison_1860
where konf_1 = 'ka';




SELECT  *
FROM importer.hisb_t_name_comparison_1860
where herk_2 = 'Würtenberg';


SELECT herk_2 AS origin,
         pk_row_2 AS pk_row
  FROM importer.hisb_t_name_comparison_1860;


/*
Suite à différentes comparaisons un bon compromis semble être celui de prendre celles et ceux qui ont la même année de naissance, confession, genre et origine.
Ça correspond à la requête de départ qui les a exclues – sauf les personnes sans date de naissance
Total de lignes 'doubons' = 266
*/
SELECT t1.*, t4.string_value, t5.string_value, t2.string_value, t3.string_value
FROM importer.hisb_t_name_comparison_1860 t1
	-- Zivilstand
  LEFT JOIN tables.cell_24626627 t2
         ON t2.fk_row = t1.pk_row_1
        AND t2.fk_column = 24626672
  LEFT JOIN tables.cell_24626627 t3
         ON t3.fk_row = t1.pk_row_2
        AND t3.fk_column = 24626672
	-- Gender
  LEFT JOIN tables.cell_24626627 t4
         ON t4.fk_row = t1.pk_row_1
        AND t4.fk_column = 24626668
  LEFT JOIN tables.cell_24626627 t5
         ON t5.fk_row = t1.pk_row_2
        AND t5.fk_column = 24626668
WHERE konf_1 = konf_2
AND   herk_1 = herk_2
AND gebjahr_1 = gebjahr_2
AND  t4.string_value = t5.string_value
--AND t1.r_similarity > 0.8
--AND t1.r_levenshtein < 3
-- exclure Gerog Abig
AND t1.pk_row_1 NOT IN (24675186,24673892)
AND t1.pk_row_2 NOT IN (24675186,24673892)
ORDER BY name_1,
         name_2;
         
/*
Table contenant les lignes 'doubles' pour garder en dur la mémoire du travail effectué
*/


--CREATE TABLE importer.hisb_t_name_comparison_1860_not_imported AS
SELECT t1.*, t4.string_value gend_1, t5.string_value gend_2
FROM importer.hisb_t_name_comparison_1860 t1
	-- Gender
  LEFT JOIN tables.cell_24626627 t4
         ON t4.fk_row = t1.pk_row_1
        AND t4.fk_column = 24626668
  LEFT JOIN tables.cell_24626627 t5
         ON t5.fk_row = t1.pk_row_2
        AND t5.fk_column = 24626668
WHERE konf_1 = konf_2
AND   herk_1 = herk_2
AND gebjahr_1 = gebjahr_2
AND  t4.string_value = t5.string_value
-- exclure Gerog Abig
AND t1.pk_row_1 NOT IN (24675186,24673892)
AND t1.pk_row_2 NOT IN (24675186,24673892)
ORDER BY name_1,
         name_2;
         



SELECT DISTINCT pk_row_2
FROM importer.hisb_t_name_comparison_1860_not_imported;




WITH tw1 AS
(
  SELECT DISTINCT
         
         pk_row_1 AS pk_row,
         name_1 AS name,
         gebjahr_1 gebjahr
  FROM importer.hisb_t_name_comparison_1860
  UNION
  SELECT DISTINCT
         pk_row_2 AS pk_row,
         name_2 AS name,
         gebjahr_2 gebjahr
  FROM importer.hisb_t_name_comparison_1860
)

-- 3338 sans le filtre, 3072 avec le filtre – 3072 à créer
SELECT count(*)
--SELECT *
FROM tw1
-- Georg Abig déjà créé à la main
WHERE pk_row NOT IN (24675186,24673892)
-- les id de la deuxième colonne de la table des 'doublons'
AND pk_row not in (SELECT DISTINCT pk_row_2
FROM importer.hisb_t_name_comparison_1860_not_imported);



-- 3072 personnes à importer
WITH tw1 AS
(
  SELECT DISTINCT
         
         pk_row_1 AS pk_row,
         name_1 AS name,
         gebjahr_1 gebjahr
  FROM importer.hisb_t_name_comparison_1860
  UNION
  SELECT DISTINCT
         pk_row_2 AS pk_row,
         name_2 AS name,
         gebjahr_2 gebjahr
  FROM importer.hisb_t_name_comparison_1860
)

SELECT DISTINCT 21,8,8,('{"source": {"import_id": "import_20201201_1",
          "digital_id": 24626627, "digital_label": "Volkszählung 1860 Phase 2", 
          "pk_row": ' || pk_row || '}}')::JSONB import_metadata 
FROM tw1
-- Georg Abig déjà créé à la main
WHERE pk_row NOT IN (24675186,24673892)
-- les id de la deuxième colonne de la table des 'doublons'
AND pk_row NOT IN (SELECT DISTINCT pk_row_2
FROM importer.hisb_t_name_comparison_1860_not_imported);




/*
PERSONS

Insert persistent items, class 21 Person
3072 rows affected

*/ 
--INSERT INTO information.persistent_item
(fk_class,fk_creator,fk_last_modifier,metadata) 
-- 3072 personnes à importer, cf. ci-dessus
WITH tw1 AS
(
  SELECT DISTINCT
         
         pk_row_1 AS pk_row,
         name_1 AS name,
         gebjahr_1 gebjahr
  FROM importer.hisb_t_name_comparison_1860
  UNION
  SELECT DISTINCT
         pk_row_2 AS pk_row,
         name_2 AS name,
         gebjahr_2 gebjahr
  FROM importer.hisb_t_name_comparison_1860
)

SELECT DISTINCT 21,8,8,('{"source": {"import_id": "import_20201201_1",
          "digital_id": 24626627, "digital_label": "Volkszählung 1860 Phase 2", 
          "pk_row": ' || pk_row || '}}')::JSONB import_metadata 
FROM tw1
-- Georg Abig déjà créé à la main
WHERE pk_row NOT IN (24675186,24673892)
-- les id de la deuxième colonne de la table des 'doublons'
AND pk_row NOT IN (SELECT DISTINCT pk_row_2
FROM importer.hisb_t_name_comparison_1860_not_imported);



/*
TeEn: APPELLATION FOR LANGUAGE
Insert appellations for language: 3072 rows affected

*/ 
--INSERT INTO information.temporal_entity(fk_class,fk_creator,fk_last_modifier,metadata)
SELECT DISTINCT 365,
       8,
       8,
       ('{"source": {"import_id": "import_20201201_2",
       "pk_digital" : 24626627,
          "pk_row": ' ||(t0.metadata #> '{"source","pk_row"}')::TEXT::INTEGER|| ',
          "pk_entity_person": ' || t0.pk_entity || '}}')::JSONB
FROM information.persistent_item t0
WHERE t0.fk_class = 21
AND   TRIM('"' FROM (t0.metadata #> '{"source","import_id"}')::VARCHAR) = 'import_20201201_1';



-- 1942 noms à importer
WITH tw1 AS
(
  SELECT DISTINCT
         
         pk_row_1 AS pk_row,
         name_1 AS name,
         gebjahr_1 gebjahr
  FROM importer.hisb_t_name_comparison_1860
  UNION
  SELECT DISTINCT
         pk_row_2 AS pk_row,
         name_2 AS name,
         gebjahr_2 gebjahr
  FROM importer.hisb_t_name_comparison_1860
)

SELECT DISTINCT name
FROM tw1
-- Georg Abig déjà créé à la main
WHERE pk_row NOT IN (24675186,24673892)
-- les id de la deuxième colonne de la table des 'doublons'
AND pk_row NOT IN (SELECT DISTINCT pk_row_2
FROM importer.hisb_t_name_comparison_1860_not_imported);




/***
APPELLATIONS

Créer les appellations qui manquent

*/ 

--- 1942 rows affected

WITH tw1 AS
(
  SELECT DISTINCT
         
         pk_row_1 AS pk_row,
         name_1 AS name,
         gebjahr_1 gebjahr
  FROM importer.hisb_t_name_comparison_1860
  UNION
  SELECT DISTINCT
         pk_row_2 AS pk_row,
         name_2 AS name,
         gebjahr_2 gebjahr
  FROM importer.hisb_t_name_comparison_1860
)

--INSERT INTO information.v_appellation (fk_class,fk_creator,fk_last_modifier,string)
SELECT DISTINCT 40,
       8,
       8,
       TRIM(name) AS name
FROM tw1
-- Georg Abig déjà créé à la main
WHERE pk_row NOT IN (24675186,24673892)
-- les id de la deuxième colonne de la table des 'doublons'
AND pk_row NOT IN (SELECT DISTINCT pk_row_2
FROM importer.hisb_t_name_comparison_1860_not_imported);


/***

Vérifie les dernières lignes importées

***/ 

--Apparemment seulement 608 noms ont été créés
SELECT COUNT(*)
FROM information.appellation
WHERE tmsp_creation BETWEEN '2020-12-01 09:00:01' AND '2020-12-01 09:58:01';




/*
Produce appellation rôles for persons: 
INSERT INTO information.statement successful
3072 rows affected

*/ 
--INSERT INTO information.statement(fk_property,fk_creator,fk_last_modifier,fk_subject_info,fk_object_info,metadata) 
SELECT 1111,
       8,
       8,
       pk_entity information,
       (metadata #> '{"source","pk_entity_person"}')::VARCHAR::INTEGER person,
       ('{"source": {"import_id": "import_20201201_3"}}')::JSONB
FROM information.temporal_entity
WHERE TRIM('"' FROM (metadata #> '{"source","import_id"}')::TEXT) = 'import_20201201_2';

--limit 50;
/***
Compter les rôles produits : 3072
*/ 
SELECT COUNT(*)
FROM information.statement
WHERE TRIM('"' FROM (metadata #> '{"source","import_id"}')::TEXT) = 'import_20201201_3';




SELECT *
FROM information.appellation
WHERE tmsp_creation < '2020-12-01 09:58:01'
ORDER BY pk_entity DESC LIMIT 30;




--- 3072 lignes, toutes les personnes ont une appellation
WITH tw1 AS
(
  SELECT DISTINCT
         
         pk_row_1 AS pk_row,
         name_1 AS name,
         gebjahr_1 gebjahr
  FROM importer.hisb_t_name_comparison_1860
  UNION
  SELECT DISTINCT
         pk_row_2 AS pk_row,
         name_2 AS name,
         gebjahr_2 gebjahr
  FROM importer.hisb_t_name_comparison_1860
)

SELECT DISTINCT 1113,
       8,
       8,
  	 	TRIM(tw1.name) AS name,
       (t0.metadata #> '{"source","pk_row"}')::TEXT::INTEGER pk_row,
       t0.pk_entity pk_temporal_entity,
       t1.pk_entity pk_appellation,
       ('{"source": {"import_id": "import_20201201_4",
				  "pk_row": "' || (t0.metadata #> '{"source","pk_row"}')::TEXT::INTEGER || '"}}')::JSONB import_metadata
FROM information.temporal_entity t0
  JOIN tw1 ON tw1.pk_row = (t0.metadata #> '{"source","pk_row"}')::TEXT::INTEGER
  LEFT JOIN information.appellation t1 ON t1.string = TRIM (tw1.name)
WHERE t0.fk_class = 365
AND   TRIM('"' FROM (t0.metadata #> '{"source","import_id"}')::VARCHAR) = 'import_20201201_2';



/*
Create role for appellation
3072 rows affected
*/ 


WITH tw1 AS
(
  SELECT DISTINCT         
         pk_row_1 AS pk_row,
         name_1 AS name,
         gebjahr_1 gebjahr
  FROM importer.hisb_t_name_comparison_1860
  UNION
  SELECT DISTINCT
         pk_row_2 AS pk_row,
         name_2 AS name,
         gebjahr_2 gebjahr
  FROM importer.hisb_t_name_comparison_1860
)
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
       ('{"source": {"import_id": "import_20201201_4",
				  "pk_row": "' || (t0.metadata #> '{"source","pk_row"}')::TEXT::INTEGER || '"}}')::JSONB import_metadata
FROM information.temporal_entity t0
  JOIN tw1 ON tw1.pk_row = (t0.metadata #> '{"source","pk_row"}')::TEXT::INTEGER
  LEFT JOIN information.appellation t1 ON t1.string = TRIM (tw1.name)
WHERE t0.fk_class = 365
AND   TRIM('"' FROM (t0.metadata #> '{"source","import_id"}')::VARCHAR) = 'import_20201201_2';



/***
Compter les rôles produits : 3072
*/ 
SELECT COUNT(*)
FROM information.statement
WHERE TRIM('"' FROM (metadata #> '{"source","import_id"}')::TEXT) = 'import_20201201_4';





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
       'import_20201201_4' || '_project_association'
FROM information.entity
WHERE TRIM((metadata #> '{"source","import_id"}')::VARCHAR,'"') = 'import_20201201_4'
ORDER BY pk_entity DESC;

/*
DONE FOR:
import_20201201_1
import_20201201_2
import_20201201_3
import_20201201_4
*/ 


SELECT COUNT(*)
FROM projects.info_proj_rel
WHERE notes = 'import_20201201_4_project_association';


SELECT *
FROM war.entity_preview
WHERE pk_entity = 1015602;




-- 3072 rows affected
--INSERT INTO information.statement
(
  fk_property,
  fk_creator,
  fk_last_modifier,
  fk_subject_tables_cell,
  fk_object_info,
  metadata
)

SELECT DISTINCT 1334,
       8,
       8,
       t1.pk_cell,
       t0.pk_entity,
       ('{"source": {"import_id": "import_20201201_5",
       "pk_digital" : 24626627,
          "pk_row": ' ||(t0.metadata #> '{"source","pk_row"}')::TEXT::INTEGER|| ',
          "pk_entity_person": ' || t0.pk_entity || '}}')::JSONB
FROM information.persistent_item t0, tables.cell_24626627 t1
WHERE t0.fk_class = 21
AND   TRIM('"' FROM (t0.metadata #> '{"source","import_id"}')::VARCHAR) = 'import_20201201_1'
AND t1.fk_row = (t0.metadata #> '{"source","pk_row"}')::TEXT::INTEGER
AND t1.fk_column = 24700267;


 LIMIT 10;
 



/*
INSERT INTO projects.info_proj_rel successful
3072 rows affected

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
*/

SELECT 1,
       pk_entity,
       fk_creator,
       fk_last_modifier,
       374840,
       TRUE,
       'import_20201201_5' || '_project_association'
FROM information.statement
WHERE TRIM('"' FROM (metadata #> '{"source","import_id"}')::VARCHAR) = 'import_20201201_5';




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

