
/*

ALIGNEMENT TABLE

[23 April 2021]
The table (digital) with pk_entity 24739954 is the result of the alignement SQL query in the file VZ1850_align_VZ1860.sql 
that was imported into the notebook align_VZ1850_VZ1860.ipynb – in the notebook some lines where excluded (≠ years = 3 and manually)
then the table exported to a SQLite table : database HISB_VZ, table n_df.
There some more lines where set to 0 (= not to be imported) for the field align
From the notebook an update to this table was produced to introduce the new 0 values into the aforementioned field
*/


SELECT *
FROM data.digital
WHERE pk_entity = 24739954;



/*
List the table columns
*/


SELECT pk_entity,
       id_for_import_txt
FROM data.column
WHERE fk_digital = 24739954;



SELECT *
FROM tables.rebuild_partitioned_table (24739954,'tv_align_1850_1860',ARRAY[24739960,24739961,24739963,24739964, 24739962]::INTEGER[]);

SELECT * FROM tv_align_1850_1860 LIMIT 10;

SELECT COUNT(*) FROM tv_align_1850_1860;  --11196
SELECT COUNT(*) FROM tv_align_1850_1860 WHERE "24739962" = 0;  -- 107

-- To be imported
SELECT COUNT(*) FROM tv_align_1850_1860 WHERE "24739962" = 1;  -- 11089

SELECT * FROM tv_align_1850_1860 where "24739960" = 24637111;



/*
VZ1860  List the table columns
*/
SELECT pk_entity,
       id_for_import_txt
FROM data.column
WHERE fk_digital = 24626627;


-- VZ1860  : rebuild (virtual) table with relevant columns
SELECT *
FROM tables.rebuild_partitioned_table (24626627,'tv_biogr_base_1860',ARRAY[24700267,24626666,24626664,24626668,24626676,24626680,
		24626674,24731798,24731799, 24626690, 24626692, 24626694, 24626640, 24626632,24626672]::INTEGER[]);

SELECT * FROM tv_biogr_base_1860 LIMIT 10;

SELECT COUNT(*) FROM tv_biogr_base_1860; -- 41292

/*
VZ1850 – List the table columns
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





-- Georg Abig
SELECT *
FROM information.statement
WHERE fk_object_info = 300718
AND   fk_property = 1334
AND   fk_subject_tables_cell IS NOT NULL;

SELECT * FROM projects.info_proj_rel WHERE fk_entity IN (1104171, 985232, 985231);




SELECT *
FROM tables.rebuild_partitioned_table (24739954,'tv_align_1850_1860',ARRAY[24739960,24739961,24739963,24739964, 24739962]::INTEGER[]);

SELECT * FROM tv_align_1850_1860 LIMIT 10;


/* 

ALIGNMENT PRODUCTION

Done on April 23, 2021 : 11281 statements produced

Some more lines produced instead of 11089 ! 
Probably because of multiple alignment of VZ1860 rows ? to be verified !

*/


BEGIN;
--INSERT INTO information.statement 
				(fk_object_info, 
				fk_subject_tables_cell, 
				fk_property, 
				fk_creator, 
				fk_last_modifier, 
				metadata,
				notes);

--SELECT DISTINCT 
--WITH tw1 AS (
SELECT DISTINCT -- t3.pk_entity, -- identifier of the statement
       t3.fk_object_info, -- identifier of the person
--       t4.entity_label,
       t5.pk_cell, -- to be aligned
       
       --t2.*,
       --t1.*,
       1334 AS property,
       8,8,('{"source": {"import_id": "import_20210423_1",
          "digital_id": 24739954, "note": "Result of VZ1850-VZ1860 alignment", 
          "pk_row": ' || t1.pk_row || '}}')::JSONB import_metadata,
       'import_20210423_1'

FROM tv_align_1850_1860 t1

  JOIN tables.cell_24626627 t2  --VZ1860 
    ON t2.fk_row = t1."24739961"
   AND t2.fk_column = 24700267 -- already aligned with Information, class Person
   
  JOIN tables.cell_24626480 t5  --VZ1850 
    ON t5.fk_row = t1."24739960"
   AND t5.fk_column = 24626623 -- to be aligned with Information, class Person

  LEFT JOIN information.statement t3 ON t3.fk_subject_tables_cell = t2.pk_cell  --
  LEFT JOIN war.entity_preview t4 ON t4.pk_entity = t3.fk_object_info
WHERE "24739962" = 1 

-- result : 11481 !
--) SELECT COUNT(*) FROM tw1;
--AND t3.fk_object_info != 300718
LIMIT 20
;

SELECT COUNT(*)
FROM information.statement
WHERE notes = 'import_20210423_1';


SELECT *
FROM information.statement
WHERE notes = 'import_20210423_1' 
LIMIT 20;

--ROLLBACK;
--COMMIT;


BEGIN;

-- 11281 rows affected
--INSERT INTO projects.info_proj_rel
				(fk_entity, 
				fk_creator, 
				fk_last_modifier, 
				fk_project, 
				is_in_project, 
				is_standard_in_project, 
				notes) ;

SELECT pk_entity,
       fk_creator,
       fk_last_modifier,
       374840 AS project,
       TRUE as is_in_project,
       FALSE as is_standard_in_project,
       'import_20210423_2' as notes
       FROM information.statement
WHERE notes = 'import_20210423_1' 
--LIMIT 20
;



SELECT COUNT(*)
FROM projects.info_proj_rel
WHERE notes = 'import_20210423_2';


SELECT *
FROM projects.info_proj_rel
WHERE notes = 'import_20210423_2' 
LIMIT 20;

--ROLLBACK;
--COMMIT;


select 11281 - 11089;


/* 

Verify reason of multiple lines  (see above)

392 multiple lines

Done on April 23, 2021 : 11281 statements produced

Some more lines produced instead of 11089 ! Delta = 192


*/ 

SELECT DISTINCT ARRAY_AGG(t1.pk_entity)pk_entity_statements,
       ARRAY_AGG(t1.fk_object_info) personen_object_info,
       t2.pk_row pk_row_alignement_VZ1850_VZ1860,
       COUNT(*) AS eff
FROM information.statement t1,
     tv_align_1850_1860 t2
WHERE notes = 'import_20210423_1'
AND   t2.pk_row = (metadata #> '{"source","pk_row"}')::TEXT::INTEGER
GROUP BY t2.pk_row
HAVING COUNT(*) > 1
ORDER BY eff DESC
--LIMIT 100
;

select 0.95 * 0.85 / (0.95 + 0.85) * 2;



SELECT t1.pk_cell,
       t1.numeric_value,
       t2.numeric_value,
       t3.numeric_value
FROM tables.cell_24739954 t1,
     tables.cell_24739954 t2,
     tables.cell_24739954 t3
WHERE t1.fk_row = t2.fk_row
AND   t3.fk_row = t2.fk_row
AND   t1.fk_column = 24739962
AND   t2.fk_column = 24739960
AND   t3.fk_column = 24739961
AND   t2.numeric_value = 24619923
AND   t3.numeric_value = 24656450;
--AND   t1.numeric_value = 0 
LIMIT 20;


UPDATE tables.cell_24739954 t1 set numeric_value = 0

FROM tables.cell_24739954 t2,
     tables.cell_24739954 t3
WHERE t1.fk_row = t2.fk_row
AND   t3.fk_row = t2.fk_row
AND   t1.fk_column = 24739962
AND   t2.fk_column = 24739960
AND   t3.fk_column = 24739961
AND   t2.numeric_value = 24619923
AND   t3.numeric_value = 24656450;
--AND   t1.numeric_value = 0 
LIMIT 20;



/* 
*/

SELECT COUNT(*)
FROM tables.cell_24739954 t1,
     tables.cell_24739954 t2,
     tables.cell_24739954 t3
WHERE t1.fk_row = t2.fk_row
AND   t3.fk_row = t2.fk_row
AND   t1.fk_column = 24739962
AND   t2.fk_column = 24739960
AND   t3.fk_column = 24739961
AND t1.numeric_value = 0;






SELECT t1.fk_class,
       t1.fk_creator,
       t1.fk_last_modifier,
       t1.metadata,
       t1.notes,
       t1.pk_entity,
       t1.schema_name,
       t1.sys_period,
       t1.table_name,
       t1.tmsp_creation,
       t1.tmsp_last_modification,
       t2.calendar,
       t2.entity_version,
       t2.fk_creator,
       t2.fk_entity,
       t2.fk_entity_version,
       t2.fk_entity_version_concat,
       t2.fk_last_modifier,
       t2.fk_project,
       t2.is_in_project,
       t2.is_standard_in_project,
       t2.notes,
       t2.ord_num_of_domain,
       t2.ord_num_of_range,
       t2.ord_num_of_text_property,
       t2.pk_entity,
       t2.schema_name,
       t2.sys_period,
       t2.table_name,
       t2.tmsp_creation,
       t2.tmsp_last_modification
FROM information.persistent_item t1 left join
     projects.info_proj_rel t2 ON   t2.fk_entity = t1.pk_entity
WHERE t1.fk_class = 52
;


SELECT *
FROM projects.dfh_class_proj_rel
WHERE fk_class = 52;




select *
from information.statement
where fk_object_info IN ( 732368,772205 );


select *
from projects.info_proj_rel
where fk_entity IN ( 863629, 1156507);

-- VZ = digital 24626480  pk statement 863629  mine : 1156507

SELECT *
FROM data.digital
WHERE pk_entity = 24612271
--WHERE fk_namespace = 24612270
;

SELECT pk_entity, id_for_import_txt        
FROM data.column
WHERE fk_digital = 24612271;


SELECT *
FROM data.digital
ORDER BY pk_entity DESC
LIMIT 10;


SELECT *
FROM data.factoid_property_mapping
ORDER BY pk_entity DESC;

