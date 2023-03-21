/***

IMPORTANT – semptembre 2019

Ces scripts contiennent les requêtes SQL utilisées pour importer les données de VZ1860 concernant les personnes.
Les conserver soigneusement

***/



/*
pk_entity: 300718
Georg Abig Produit manuellement et doublon dans la table d'origine
Je l'utilise pour produire des données à la main
*/ 










SELECT *
FROM importer.hisb_t_name_comparison_1860
WHERE fk_information_entity IS NOT NULL;

SELECT count(*)
FROM importer.hisb_t_name_comparison_1860;


SELECT *
FROM importer.hisb_t_name_comparison_1860
WHERE konf_1 = 'isr' OR konf_2 = 'isr'
ORDER BY name_1,
         name_2;

WITH tw1 AS
(
  SELECT name_1 AS name,
         pk_row_1 AS pk_row
  FROM importer.hisb_t_name_comparison_1860
  UNION
  SELECT name_1 AS name,
         pk_row_1 AS pk_row
  FROM importer.hisb_t_name_comparison_1860
)
SELECT *
FROM tw1
ORDER BY name LIMIT 10;



SELECT count(*)
FROM tw1;







/***

Allgemeine Fragen

***/


/*
24626451 namespace für Volkszählungen in HISB Project
*/ 
SELECT *
FROM data.namespace
WHERE fk_project = 374840 LIMIT 10;

-- digitals in HISB Volkszählungen Namespace
SELECT *
FROM data.digital
WHERE fk_namespace = 24626451 LIMIT 100;

-- columns in Volkszählung 1860
SELECT t0.pk_entity, t0.id_for_import, t0.id_for_import_txt, t2.definition data_type, t1.definition column_type, t0.is_imported, t0.fk_original_column, t0.fk_publication_status, t0.fk_creator, t0.fk_last_modifier, t0.fk_digital, t0.fk_license, t0.fk_namespace, t0.metadata, t0.notes, t0.schema_name, t0.sys_period, t0.table_name, t0.entity_version, t0.tmsp_creation, t0.tmsp_last_modification
FROM data.column t0
  LEFT JOIN system.system_type t1 ON t1.pk_entity = t0.fk_column_content_type
  LEFT JOIN system.system_type t2 ON t2.pk_entity = t0.fk_data_type
WHERE fk_digital = 24626627;



/***
Liste complète de cellules pour une ou plusieur lignes
***/ 
--  Rows
SELECT *
FROM tables.row
WHERE fk_digital IN (24626627) LIMIT 100;

-- colonne ajoutée qui contient la pk_entity de la personne créée
SELECT *
FROM tables.cell
WHERE fk_column IN (24626788) LIMIT 100;

/*
Rows without association to person
*/

SELECT t3.*, t2.*, t1.* -- COUNT(*) -- t3.*, t2.*, t1.*
FROM tables.cell t1
  LEFT JOIN tables.cell t2
         ON t2.fk_row = t1.fk_row
        AND t2.fk_column = 24626788
  left join  war.entity_preview t3 on t3.pk_entity = t2.numeric_value      
WHERE t1.fk_column = 24626628 
AND t3.pk_entity IS NULL -- IS NOT NULL
LIMIT 100;





--WHERE pk_row IN (24649199,24681279);
-- cells
SELECT t1.pk_cell,
       t1.fk_column,
       t2.string,
       t1.string_value,
       t1.numeric_value,
       t1.fk_digital,
       t1.fk_row,
       t1.id_for_import,
       t1.id_for_import_txt,
       t1.metadata,
       t1.notes,
       t1.sys_period,
       t1.tmsp_creation,
       t1.tmsp_last_modification
FROM tables.cell t1
  LEFT JOIN data.text_property t2 ON t2.fk_entity = t1.fk_column
WHERE fk_row IN (24645871,24645872,24645873,24645874)
--(24649321, 24677183 ) --24649199,24681279) --24658185
ORDER BY fk_row,
         fk_column
LIMIT 20;
         


SELECT string_value,
       COUNT(*) freq
FROM tables.cell_24626627
WHERE fk_column = 24626686 -- 24626694
GROUP BY string_value
ORDER BY freq DESC;




/*
GENERIC REBUILD
*/

SELECT *
FROM tables.rebuild_partitioned_table (24626627,'tv_biogr_base_1860',ARRAY[]::INTEGER[]);

SELECT * FROM tv_biogr_base_1860 LIMIT 10;


/***

tv_biogr_base_1860

name, vorname, geschlecht, geburstjahr, konfession, beruf, nationality, herkunft

***/ 
SELECT *
FROM tables.rebuild_partitioned_table (24626627,'tv_biogr_base_1860',ARRAY[24626664,24626666, 24700267,24626668,24626676,24626680,
24626674,24626690,24626692, 24626640,24626632]::INTEGER[]);



SELECT * FROM tv_biogr_base_1860 LIMIT 10;




/***
APPELLATIONS and biographical elements
***/ 
DROP TABLE t_names;

CREATE TEMPORARY TABLE t_names 
AS
(SELECT concat("24626664",' ',"24626666") full_naming,
       "24626668" gender,
       CASE
         WHEN importer.isnumeric ("24626676") THEN "24626676"::INTEGER
         ELSE NULL
       END gebjahr,
       "24626680" konf,
       "24626690" nationality,
       -- Nationality can be modeled as membership in an E74 Group 
       "24626692" herkunft_abkurz,
       "24626674" beruf,
       pk_row
FROM tv_biogr_base_1860
ORDER BY "24626664",
         "24626666");

SELECT *
FROM t_names LIMIT 50;

CREATE INDEX t_names_idx_1 
  ON t_names (full_naming);

CREATE INDEX t_names_idx_2
  ON t_names (beruf);

SELECT *
FROM t_names
WHERE beruf ~* 'kauf';

--AND gebjahr > 0;
SELECT *
FROM t_names
WHERE full_naming ~* 'Saxe';

SELECT *
FROM t_names
ORDER BY full_naming LIMIT 50;

SELECT nationality,
       COUNT(*) freq
FROM t_names
WHERE gebjahr > 0
GROUP BY nationality
ORDER BY freq DESC;

/***
Probléme des doublons

Je retiens toutes les personnes nées la même années ou avec la même origine et la même confession,
dont le nom est similaire à différents degrés

Peut-être 20 à 30 % de ces personnes sont identique mais il faut une vérification à la main car les paramètre sont très différents

***/ 
SELECT *
FROM importer.hisb_t_name_comparison_1860
WHERE 1 = 1
AND   (gebjahr_1 = gebjahr_2 OR konf_1 = konf_2 AND herk_1 = herk_2)
--AND   set_as_same IS TRUE
ORDER BY name_1,
         name_2;

/***

2089 personnes seront EXCLUES !!!  de l'import en attendant vérification 
ainsi que celles qui n'ont pas d'années de naissance.

!!! 39040 personnes à importer

***/ 
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

SELECT DISTINCT 21,8,8,('{"source": {"import_id": "import_20190925_1",
          "digital_id": 24626627, "digital_label": "Volkszählung 1860", 
          "pk_row": ' || pk_row || '}}')::JSONB import_metadata FROM t_names WHERE pk_row NOT IN (SELECT pk_row FROM tw1) AND gebjahr > 0 LIMIT 50;

/*
PERSONS

Insert persistent items, class 21 Person

39040 rows affected
*/ 
--INSERT INTO information.persistent_item
(fk_class,fk_creator,fk_last_modifier,metadata) WITH tw1
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

SELECT DISTINCT 21,8,8,('{"source": {"import_id": "import_20190925_1",
          "digital_id": 24626627, "digital_label": "Volkszählung 1860", 
          "pk_row": ' || pk_row || '}}')::JSONB import_metadata FROM t_names WHERE pk_row NOT IN (SELECT pk_row FROM tw1) AND gebjahr > 0;

/***
Count = 39040
***/ 
SELECT DISTINCT 24626788 AS column_id,
       8,
       24626627,
       8,
       24626451,
       (t0.metadata #> '{"source","pk_row"}')::TEXT::INTEGER fk_row,
       t0.pk_entity AS identifier
--, replace((t0.metadata #> '{"source","import_id"}')::TEXT, '"', ''), *, t0.pk_entity
       FROM information.persistent_item t0
WHERE t0.fk_class = 21
AND   TRIM((t0.metadata #> '{"source","import_id"}')::VARCHAR,'"') = 'import_20190925_1'
--order by t0.pk_entity desc
LIMIT 50;

SELECT *
FROM information.entity
WHERE TRIM((metadata #> '{"source","import_id"}')::VARCHAR,'"') = 'import_20190925_1'
ORDER BY pk_entity DESC LIMIT 10;

/***

Insertion de l'alignement dans la table
Les clés des instances persistent item créées sont ajoutées dans la table des cellules dans une nouvelle colonne dédiée: 24626788
39040 rows affected
Effectué le 25 septembre 2019, sans metadata


ATTENTION (24 novembre 2020) : malheureusement l'insert s'est fait dans la mauvaise table et pas dans tables.cell_24626627
En fait, les données dont dans les metadonnées de l'import, cf. le SELECT – ça suffit en principe et cette colonne (et le cellules) pourraient être supprimées
car elles provoquent confusion

***/ 
--INSERT INTO tables.cell (
entity_version,fk_column,fk_creator,fk_digital,fk_last_modifier,fk_namespace,fk_row,numeric_value)
SELECT DISTINCT 1,
       24626788 AS column_id,
       8,
       24626627,
       8,
       24626451,
       (t0.metadata #> '{"source","pk_row"}')::TEXT::INTEGER fk_row,
       t0.pk_entity AS identifier
--, replace((t0.metadata #> '{"source","import_id"}')::TEXT, '"', ''), *, t0.pk_entity*/
       FROM information.persistent_item t0
WHERE t0.fk_class = 21
AND   (t0.metadata #> '{"source","import_id"}')::VARCHAR = '"import_20190925_1"';

SELECT fk_column,
       fk_creator,
       fk_digital,
       fk_last_modifier,
       fk_namespace,
       fk_row,
       numeric_value,
       metadata
--       string_value
       FROM tables.cell
ORDER BY pk_cell DESC LIMIT 5;

/*
TeEn: APPELLATION FOR LANGUAGE
Insert appellations for language: 39040 rows affected

*/ 
--INSERT INTO information.temporal_entity(fk_class,fk_creator,fk_last_modifier,metadata)
SELECT DISTINCT 365,
       8,
       8,
       ('{"source": {"import_id": "import_20190925_2",
       "pk_digital" : 24626627,
          "pk_row": ' ||(t0.metadata #> '{"source","pk_row"}')::TEXT::INTEGER|| ',
          "pk_entity_person": ' || t0.pk_entity || '}}')::JSONB
FROM information.persistent_item t0
WHERE t0.fk_class = 21
AND   TRIM('"' FROM (t0.metadata #> '{"source","import_id"}')::VARCHAR) = 'import_20190925_1';

--LIMIT 50;
SELECT *
FROM t_names LIMIT 50;

/***
chercher toutes les instances d'APPELLATION qui existent déjà, i.e. avec la même chaine de caractères

Résultat: il n'y en a aucune avant l'import de la Volkszählung 1860


Noms distinct: 32983 – beaucoup d'homonymes

Préparer la requête en excluant les noms déjà existant en tant que information.appellation
***/ 
WITH tw1
AS
(SELECT DISTINCT TRIM(t1.full_naming) full_naming
FROM information.temporal_entity t0,
     t_names t1
WHERE t1.pk_row = (t0.metadata #> '{"source","pk_row"}')::TEXT::INTEGER
AND   TRIM('"' FROM (t0.metadata #> '{"source","import_id"}')::VARCHAR) = 'import_20190925_2')
--SELECT * FROM tw1 LIMIT 30;
,tw2 AS (SELECT DISTINCT tw1.full_naming
         FROM tw1,
              information.appellation t1
         WHERE tw1.full_naming = t1.string) SELECT DISTINCT full_naming FROM tw1 WHERE full_naming NOT IN (SELECT full_naming FROM tw2)
ORDER BY full_naming;

LIMIT 100;

/***
APPELLATIONS

Créer les appellations qui manquent

*/ 
-- Empty quill_doc {"ops": [{"insert": "\n", "attributes": {"blockid": "1"}}], "latestId": 1}
BEGIN;

ALTER TABLE information.appellation DISABLE TRIGGER sync_quill_doc_and_string;

ALTER TABLE commons.text DISABLE TRIGGER sync_quill_doc_and_string;

WITH tw1 AS
(
  SELECT DISTINCT TRIM(t1.full_naming) full_naming
  FROM information.temporal_entity t0,
       t_names t1
  WHERE t1.pk_row = (t0.metadata #> '{"source","pk_row"}')::TEXT::INTEGER
  AND   TRIM('"' FROM (t0.metadata #> '{"source","import_id"}')::VARCHAR) = 'import_20190925_2'
),
tw2 AS
(
  SELECT DISTINCT tw1.full_naming
  FROM tw1,
       information.appellation t1
  WHERE tw1.full_naming = t1.string
)
--INSERT INTO information.appellation (
fk_class,fk_creator,fk_last_modifier,quill_doc,string,metadata)
SELECT DISTINCT 40,
       8,
       8,
       '{"ops": [{"insert": "\n", "attributes": {"blockid": "1"}}], "latestId": 1}'::JSONB,
       -- !!! évite le NULL !
       TRIM(full_naming) full_naming,
       ('{"source": {"import_id": "import_20190926_1",
          "pk_digital": 24626627 }}')::JSONB
FROM tw1
WHERE full_naming NOT IN (SELECT full_naming FROM tw2)
ORDER BY full_naming;

-- LIMIT 100
ALTER TABLE commons.text ENABLE TRIGGER sync_quill_doc_and_string;

ALTER TABLE information.appellation ENABLE TRIGGER sync_quill_doc_and_string;

UPDATE information.appellation
   SET notes = string,
       string = ''
WHERE TRIM('"' FROM (metadata #> '{"source","import_id"}')::VARCHAR) = 'import_20190926_1';

UPDATE information.appellation
   SET string = notes,
       notes = ''
WHERE TRIM('"' FROM (metadata #> '{"source","import_id"}')::VARCHAR) = 'import_20190926_1';

--ROLLBACK;
COMMIT;

/***

Vérifie les dernières lignes importées

***/ 
SELECT *
FROM information.appellation
WHERE TRIM('"' FROM (metadata #> '{"source","import_id"}')::VARCHAR) = 'import_20190926_1'
--AND   quill_doc IS NOT NULL
ORDER BY pk_entity DESC LIMIT 120;

SELECT COUNT(*)
FROM information.appellation
WHERE TRIM('"' FROM (metadata #> '{"source","import_id"}')::VARCHAR) = 'import_20190926_1'
AND   quill_doc IS NULL;

/*
Produce appellation rôles for persons:  39040 rows affected
Done : 
*/ 
--INSERT INTO information.role(fk_property,fk_creator,fk_last_modifier,fk_entity,fk_temporal_entity,metadata) 
SELECT 1111,  -- 1192 ancienne propriété
       8,
       8,
       (metadata #> '{"source","pk_entity_person"}')::VARCHAR::INTEGER person,
       pk_entity,
       ('{"source": {"import_id": "import_20190925_3"}}')::JSONB
FROM information.temporal_entity
WHERE TRIM('"' FROM (metadata #> '{"source","import_id"}')::TEXT) = 'import_20190925_2';

--limit 50;
/***
Compter les rôles produits
*/ 
SELECT COUNT(*)
FROM information.role
WHERE TRIM('"' FROM (metadata #> '{"source","import_id"}')::TEXT) = 'import_20190925_3';

/*
Create role for appellation
39040 rows affected
*/ 
BEGIN;

WITH tw1 AS
(
  SELECT t0.pk_entity teen_id,
         (t0.metadata #> '{"source","pk_row"}')::VARCHAR::INTEGER pk_row,
         t2.pk_entity appe_id
  FROM information.temporal_entity t0
    JOIN t_names t1 ON t1.pk_row = (metadata #> '{"source","pk_row"}')::VARCHAR::INTEGER
    LEFT JOIN information.appellation t2 ON t2.string = TRIM (t1.full_naming)
  WHERE t0.fk_class = 365
  AND   TRIM('"' FROM (t0.metadata #> '{"source","import_id"}')::TEXT) = 'import_20190925_2'
) INSERT INTO information.role
(
  fk_property,
  fk_creator,
  fk_last_modifier,
  fk_entity,
  fk_temporal_entity,
  metadata
)
SELECT 1113,
       8,
       8,
       appe_id,
       teen_id,
       ('{"source": {"import_id": "import_20190926_2",
				  "pk_row": "' || pk_row || '"}}')::JSONB import_metadata
FROM tw1;

-- LIMIT 10;
COMMIT;

SELECT *
FROM information.appellation
WHERE pk_entity = 488493;

SELECT *
FROM information.role
WHERE TRIM('"' FROM (metadata #> '{"source","import_id"}')::TEXT) = 'import_20190926_2' LIMIT 20;

SELECT 1,
       pk_entity,
       fk_creator,
       fk_last_modifier,
       374840,
       TRUE,
       'import_20190925_1' || '_project_association'
FROM information.entity
WHERE TRIM((metadata #> '{"source","import_id"}')::VARCHAR,'"') = 'import_20190925_1'
ORDER BY pk_entity DESC LIMIT 10;

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

property pk 72 = crm:P82 at some time within

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

