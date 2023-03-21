SELECT *
FROM data.digital
WHERE fk_namespace = 24626451
ORDER BY pk_entity DESC 
LIMIT 30;

SELECT *
FROM data.namespace
where pk_entity = 24626451;

SELECT *
FROM projects.project
WHERE pk_entity = 374840;




SELECT *
FROM data.column
where fk_namespace = 24626451 --AND fk_digital = 24626467
ORDER BY pk_entity DESC LIMIT 200;

-- VZ_1860_H_01_bis_15_20190701_END

SELECT *
FROM data.text_property
WHERE fk_entity = 24626627;






SELECT *
FROM importer."VZ_1860_H_01_bis_15_20190701_END" LIMIT 100;


--SELECT * from tables.create_cell_table_for_digital(24626464);



/*Very slow*/
--SELECT *
FROM tables.cell
WHERE entity_version > 3
ORDER BY pk_cell LIMIT 10;


SELECT COUNT(*)
FROM tables.cell
WHERE id_for_import_txt IS NOT NULL
AND   (string_value IS NULL OR string_value = '');

SELECT *
FROM tables.cell
WHERE LENGTH(id_for_import_txt) > 0
AND   (string_value IS NULL OR string_value = '') LIMIT 100;


SELECT *
FROM tables.cell
WHERE LENGTH(id_for_import_txt) > 0
AND   (string_value IS NULL OR length(string_value) = 0) LIMIT 100;


SELECT COUNT(*)
FROM data.cell
WHERE id_for_import_txt IS NOT NULL
AND   (string_value IS NULL OR string_value = '');




-- begin

ALTER TABLE data.cell
    DISABLE TRIGGER versioning_trigger;
    
ALTER TABLE data.cell
    DISABLE TRIGGER update_entity_version_key;
    
UPDATE data.cell
   SET string_value = id_for_import_txt
WHERE LENGTH(id_for_import_txt) > 0
AND   (string_value IS NULL OR string_value = '');


UPDATE data.cell
   SET entity_version = 1;
   


--- end



ALTER TABLE data.cell
    ENABLE TRIGGER versioning_trigger;
    
ALTER TABLE data.cell
    ENABLE TRIGGER update_entity_version_key;
    

UPDATE tables.cell
   SET string_value = id_for_import_txt
WHERE id_for_import_txt IS NOT NULL
AND   (string_value IS NULL OR string_value = '');


