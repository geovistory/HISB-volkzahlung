/****

These scripts are about producing 'refers to' entities from VZ1860 Table to Geovistory Information

FB, Fall 2020

****/


/***
LISTE der SPALTEN 
in der 1860 Tabelle

TAble ID = 24626627
***/

SELECT t0.pk_entity, t0.id_for_import, t0.id_for_import_txt, t2.definition data_type, t1.definition column_type, t0.is_imported, t0.fk_original_column, t0.fk_publication_status, t0.fk_creator, t0.fk_last_modifier, t0.fk_digital, t0.fk_license, t0.fk_namespace, t0.metadata, t0.notes, t0.schema_name, t0.sys_period, t0.table_name, t0.entity_version, t0.tmsp_creation, t0.tmsp_last_modification
FROM data.column t0
  LEFT JOIN system.system_type t1 ON t1.pk_entity = t0.fk_column_content_type
  LEFT JOIN system.system_type t2 ON t2.pk_entity = t0.fk_data_type
WHERE fk_digital = 24626627;




--find all cells for column 24700267 which was used to create refers to relations to Person instances
SELECT *
FROM tables.cell_24626627
WHERE fk_column = 24700267
LIMIT 10;

-- Zweig Maria Christina
SELECT *
FROM tables.cell_24626627
WHERE pk_cell = 27913891;

/* find all statements where this cell is subject
there can be many of them, in different projects
*/
SELECT *
FROM information.statement
WHERE fk_subject_tables_cell = 27913891;



/***
Chercher toutes les personnes qui ont deux cellules de table liées à leur fiche Person
***/
WITH tw1 AS (
SELECT fk_object_info, count(*) eff
FROM information.statement
WHERE fk_property = 1334
AND   fk_subject_tables_cell > 0
GROUP BY fk_object_info
HAVING COUNT(*) > 1
LIMIT 15 )
	
SELECT tw1.*, ep.*
FROM war.entity_preview ep,
     tw1
WHERE tw1.fk_object_info = ep.pk_entity;
and ep.fk_project = 374840;



-- Georg Abig
SELECT *
FROM information.statement
WHERE fk_object_info = 300718
AND   fk_property = 1334
AND   fk_subject_tables_cell IS NOT NULL;




-- find the project association for each statement
SELECT *
FROM projects.info_proj_rel
WHERE fk_entity = 946196  -- 913977 84903 946196
LIMIT 10; 


-- the corresponding person
SELECT *
FROM information.entity
WHERE pk_entity = 306166;

-- inspect import metadata for this entity
SELECT *
FROM information.persistent_item
WHERE pk_entity = 306166;


SELECT count(*)
FROM tables.cell
WHERE fk_column = 24626788
LIMIT 10;

--result: 39040
SELECT COUNT(*)
FROM tables.cell t1
  LEFT JOIN tables.cell t2 ON t2.fk_row = t1.fk_row
WHERE t1.fk_column = 24626628
AND   t2.fk_column = 24626788 LIMIT 10;

--result : 41292
SELECT COUNT(*)
FROM tables.cell t1
WHERE t1.fk_column = 24626628;

--2252
select 41292 - 39040;

SELECT COUNT(*)
FROM importer.hisb_t_name_comparison_1860;





SELECT count(*)
FROM importer.hisb_t_name_comparison_1860;


SELECT *
FROM importer.hisb_t_name_comparison_1860
ORDER BY name_1,
         name_2;




SELECT *
FROM tables.rebuild_partitioned_table (24626627,NULL,ARRAY[]::INTEGER[]);


SELECT *
FROM tv_24626627 LIMIT 10;

SELECT *
FROM tv_24626627
WHERE "24626788" IS NOT NULL
 LIMIT 10;

 -- add class column mapping 
--INSERT INTO data.class_column_mapping (fk_class, fk_column) VALUES (21, XXXXXXXX);
-- person 
--INSERT INTO data.class_column_mapping (fk_class, fk_column) VALUES (629, YYYYYYYY); 
-- gender

SELECT entity_version,
       fk_class,
       fk_column,
       fk_creator,
       fk_last_modifier,
       fk_license,
       fk_namespace,
       fk_publication_status,
       id_for_import,
       id_for_import_txt,
       metadata,
       notes,
       pk_entity,
       tmsp_creation,
       tmsp_last_modification
FROM data.class_column_mapping;



 


select * from data.namespace
where fk_project = 374840;


select * from importer.hisb_t_name_comparison_1860;




SELECT *
FROM tables.cell
WHERE fk_row = 24691062;


SELECT *
FROM data.digital
WHERE fk_namespace = 24626451 LIMIT 100;


SELECT t0.pk_entity,
       t0.id_for_import,
       t0.id_for_import_txt,
       t2.definition data_type,
       t1.definition column_type,
       t0.is_imported,
       t0.fk_original_column,
       t0.fk_publication_status,
       t0.fk_creator,
       t0.fk_last_modifier,
       t0.fk_digital,
       t0.fk_license,
       t0.fk_namespace,
       t0.metadata,
       t0.notes,
       t0.schema_name,
       t0.sys_period,
       t0.table_name,
       t0.entity_version,
       t0.tmsp_creation,
       t0.tmsp_last_modification
FROM data.column t0
  LEFT JOIN system.system_type t1 ON t1.pk_entity = t0.fk_column_content_type
  LEFT JOIN system.system_type t2 ON t2.pk_entity = t0.fk_data_type
WHERE fk_digital = 24626627
ORDER BY pk_entity DESC;




SELECT count(*)
FROM importer.hisb_t_name_comparison_1860;





SELECT *
FROM data.column t0
WHERE fk_digital = 24626627
ORDER BY pk_entity;


-- label de la colonne
SELECT *
FROM data.text_property
WHERE fk_entity = 24686142;



/*
Insérer les noms composés

INSERT INTO tables.cell_24626627 successful
41292 rows affected

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
*/
SELECT 24700267,
       -- staging: 24686142,
       t1.fk_row,
       24626627,
       concat(t1.string_value,' ',t2.string_value) name_vorname,
       1,
       8,
       8,
       NOW(),
       NOW(),
       ('{"source": "Import FB 3 November 2020 – Same row, concatenated columns: 24626664, 24626666 ", "id_import": "import_20201103_1"}')::JSONB import_metadata -- COUNT(*) = 41292 lignes
       FROM tables.cell_24626627 t1
  LEFT JOIN tables.cell_24626627 t2 ON t1.fk_row = t2.fk_row
WHERE t1.fk_column = 24626664
AND   t2.fk_column = 24626666
ORDER BY concat(t1.string_value,' ',t2.string_value);








select *
FROM tables.cell_24626627
where fk_column = 24700267 --staging : 24686142
limit 10;

select count(*) from information.statement where fk_subject_data is not null;

SELECT *
FROM information.statement
WHERE fk_subject_tables_cell = 27873090;



/*
INSERT INTO information.statement successful
39040 rows affected
sur staging and PRODUCTION


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
SELECT 1334,
       8,
       8,
       t2.pk_cell,
       t1.numeric_value,
       ('{"source": "Import FB 3 November 2020 ", "id_import": "import_20201103_2"}')::JSONB import_metadata -- COUNT(*) = 41292 lignes
       FROM tables.cell t1
  LEFT JOIN tables.cell_24626627 t2 ON t1.fk_row = t2.fk_row
WHERE t1.fk_column = 24626788
AND   t2.fk_column = 24700267; --staging : 24686142;

 LIMIT 10;
 

/*
INSERT INTO information.statement successful
39040 rows affected
sur staging and production
*/

--INSERT INTO projects.info_proj_rel
(
  entity_version,
  fk_entity,
  fk_creator,
  fk_last_modifier,
  fk_project,
  is_in_project,
  notes
) 
SELECT 1,
       pk_entity,
       fk_creator,
       fk_last_modifier,
       374840,
       TRUE,
       'import_20201103_2' || '_project_association'
FROM information.statement
WHERE TRIM((metadata ->> 'id_import')::VARCHAR,'"') = 'import_20201103_2';

ORDER BY pk_entity DESC
limit 10;

/*
Correction de l'erreur de valeur de propriété sur staging, par erreur 1134 à la place de 1334
UPDATE information.statement successful
39040 rows affected
*/
--UPDATE information.statement
   SET fk_property = 1334
WHERE TRIM((metadata ->> 'id_import')::VARCHAR,'"') = 'import_20201103_2';




select (metadata ->> 'id_import'), metadata, *
FROM information.statement
order by pk_entity desc limit 10;

SELECT *
FROM projects.info_proj_rel
ORDER BY pk_entity DESC LIMIT 10;

SELECT *
FROM information.statement
WHERE pk_entity = 953053;

SELECT *
FROM information.statement
ORDER BY pk_entity DESC LIMIT 10;






(SELECT *
FROM tables.cell
WHERE fk_column = 24626788 LIMIT 2)
UNION
(SELECT *
FROM tables.cell_24626627
WHERE fk_column = 24700267 LIMIT 2);  -- staging : 24686142


/***

Factoïd mapping
***/


SELECT *
FROM data.class_column_mapping
ORDER BY pk_entity DESC;




SELECT *
FROM data.factoid_mapping
ORDER BY pk_entity DESC;




/*
Produce the factoid mapping for :
--1860 : 24626627;
 *   crm:E67 Birth, class = 61
 *   hist:C5 Membership, class = 442  (col. 24626692)
 *   hist:C5 Membership, class = 442 (col. 24626694)
 *   histSoc:C8 Occupation (Temporal entity) class 637 

--1850 : 24626480;
 *   crm:E67 Birth, class = 61
 *   hist:C5 Membership, class = 442  (col.24626541)
 *   hist:C5 Membership, class = 442 (col. 24626543)
 *   histSoc:C8 Occupation (Temporal entity) class 637 

--1860 : 24626627; 1850 : 24626480;

*/

--INSERT INTO data.factoid_mapping
(
  fk_creator,
  fk_last_modifier,
  fk_digital,
  fk_namespace,
  fk_class,
  metadata,
  tmsp_creation,
  tmsp_last_modification
)
VALUES
(
  8,
  8,
  24626627,
  24626451,
  442,
  ('{"source": "Produced by FB 16 February 2021 with SQL instruction ", "id_production": "prod_20210216_12"}')::JSONB,
  NOW(),
  NOW()
);

