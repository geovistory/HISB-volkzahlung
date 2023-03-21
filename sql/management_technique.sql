SELECT pk_entity,
       definition,
       st_schema_name,
       st_table_name,
       st_column_name,
       entity_version,
       fk_creator,
       fk_last_modifier,
       notes,
       schema_name,
       st_group,
       sys_period,
       table_name,
       tmsp_creation,
       tmsp_last_modification
FROM system.system_type
ORDER BY st_schema_name,
         st_table_name,
         st_column_name,
         pk_entity desc;


/***


WEB REQUEST TYPE
Class OntoME id 
520  -> 607

***/

--UPDATE information.persistent_item
   SET fk_class = 607
WHERE fk_class = 520;

--UPDATE projects.class_field_config
   SET fk_class_for_class_field = 607
WHERE fk_class_for_class_field = 520;

--UPDATE system.system_relevant_class
   SET fk_class = 607
WHERE fk_class = 520;



SELECT *
FROM information.role t1,
     information.persistent_item t2
WHERE t2.pk_entity = t1.fk_entity
AND   t2.fk_class = 607;

-- property : 1324 - > 1000702
--UPDATE information.role t1
   SET fk_property = 1000702
FROM information.persistent_item t2
WHERE t2.pk_entity = t1.fk_entity
AND   t2.fk_class = 607;

SELECT *
FROM data_for_history.property_profile_view
WHERE dfh_has_domain = 607
OR    dfh_has_range = 607;


-- get last produced entities
SELECT *
FROM information.entity
ORDER BY pk_entity DESC LIMIT 10;


-- get last produces time primitives
SELECT *, to_date(julian_day::text, 'J')
FROM information.time_primitive
WHERE pk_entity = 609174
ORDER BY pk_entity DESC LIMIT 10;

-- get last produces roles
SELECT lab.*, prop.*, role.*
FROM information.role role
  LEFT JOIN data_for_history.v_property prop ON prop.pk_property = role.fk_property
  left join data_for_history.v_label lab on lab.fk_property = role.fk_property
ORDER BY pk_entity DESC LIMIT 10;


SELECT *
FROM projects.info_proj_rel
ORDER BY pk_entity DESC
LIMIT 10;






SELECT *
FROM information.text_property
ORDER BY pk_entity DESC LIMIT 10;



SELECT *
FROM information.entity
WHERE pk_entity = 648262;

SELECT *
FROM information.persistent_item
--WHERE fk_class = 520;
where pk_entity = 648262;

SELECT *
FROM information.persistent_item
ORDER BY pk_entity DESC LIMIT 20;



SELECT importer.get_entity_appellation(pk_entity), fk_class, pk_entity
FROM information.persistent_item 
WHERE fk_class = 520;


--INSERT INTO system.system_type
(
  definition,
  st_schema_name,
  st_table_name,
  st_column_name,
  fk_creator,
  fk_last_modifier
)
VALUES
(
  'Identifier or URI. Specify the data type (Integer or String) using the suitable system type in the fk_data_type column',
  'data',
  'column',
  'fk_column_type',
  8,
  8
);

--INSERT INTO data.text_property
(
  schema_name,
  fk_namespace,
  string,
  fk_system_type,
  fk_language,
  fk_entity
)
VALUES
(
  '',
  24626451,
  'ID-Nummer von der entsprechenden Person im Bereich Information',
  3295,
  18605,
  24626788
);
