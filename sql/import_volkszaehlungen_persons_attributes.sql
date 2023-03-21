
/*
pk_entity: 300718
Georg Abig Produit manuellement et doublon dans la table d'origine
Je l'utilise pour produire des données à la main
*/
SELECT *
FROM importer.hisb_t_name_comparison_1860
WHERE fk_information_entity IS NOT NULL;

select * from information.role order by pk_entity desc limit 20;



select * from information.text_property order by pk_entity desc limit 20;
select * from information.appellation order by pk_entity desc limit 20;


/***

tv_biogr_base_1860

name, vorname, geschlecht, geburstjahr, konfession, beruf, nationality, herkunft

***/

SELECT *
FROM tables.rebuild_partitioned_table (24626627,'tv_biogr_base_1860',ARRAY[24626664,24626666,24626668,24626676,24626680,24626674, 24626690, 24626692]::INTEGER[]);




/***
APPELLATIONS and biographical elements
***/ 


CREATE TABLE importer.volksz_1860_t_names 
AS
(SELECT concat("24626664",' ',"24626666") full_naming,
       "24626668" gender,
       NULL::integer as gender_id,
       CASE
         WHEN importer.isnumeric ("24626676") THEN "24626676"::INTEGER
         ELSE NULL
       END gebjahr,
       "24626680" konf,
       NULL::integer religion_id,
       "24626690" nationality,  -- Nationality can be modeled as membership in an E74 Group 
       NULL::integer nationality_id,
       "24626692" herkunft_abkurz,
       "24626674" beruf,
       NULL::integer[] beruf_id,
       pk_row
FROM tv_biogr_base_1860
ORDER BY "24626664",
         "24626666");

CREATE INDEX volksz_1860_t_names_idx_1 
  ON importer.volksz_1860_t_names (full_naming);
CREATE INDEX volksz_1860_t_names_idx_2 
  ON importer.volksz_1860_t_names (nationality);
CREATE INDEX volksz_1860_t_names_idx_2_1 
  ON importer.volksz_1860_t_names (nationality_id);
CREATE INDEX volksz_1860_t_names_idx_3 
  ON importer.volksz_1860_t_names (beruf);




SELECT *
FROM importer.volksz_1860_t_names
WHERE beruf ~* 'kauf';
--AND gebjahr > 0;



SELECT nationality,
       COUNT(*) freq
FROM importer.volksz_1860_t_names
--WHERE gebjahr > 0
GROUP BY nationality
ORDER BY freq DESC;


/*
Liste des nationalités renseignée dans la table d'origine

Renseignés: 648234, 648250, 648293, 648284, 648267

 NOT IN (648234, 648250, 648293, 648284, 648267)
*/
SELECT nationality,
       nationality_id,
       COUNT(*) freq
FROM importer.volksz_1860_t_names
--WHERE gebjahr > 0
GROUP BY nationality,
         nationality_id
ORDER BY freq DESC;




select *
from  importer.volksz_1860_t_names
where nationality = 'Thurgau' limit 10;




SELECT *
FROM importer.volksz_1860_t_names
WHERE nationality = 'St. Gallen' LIMIT 50;




BEGIN;
UPDATE importer.volksz_1860_t_names
   SET nationality_id = 732522
WHERE nationality = 'St. Gallen';




/***
POUR LA CARTE
Effectifs nationalités avec lieu de référence (capitale) et coorconnées géographiques
***/

WITH tw1 AS
(
  SELECT nationality,
         nationality_id,
         COUNT(*) freq
  FROM importer.volksz_1860_t_names t1
  WHERE nationality_id IS NOT NULL
  GROUP BY nationality_id,
           nationality
)
SELECT tw1.nationality AS state,
       tw1.freq,
       t3.fk_entity,
       importer.get_entity_appellation(t3.fk_entity),
       ST_Y(t6.geo_point::geometry) AS long,
       ST_X(t6.geo_point::geometry) AS lat
       
FROM tw1,
     information.role t2,
     information.role t3,
     information.role t4,
     information.role t5,
     information.place t6
WHERE t2.fk_property = 1182
AND   t2.fk_entity = tw1.nationality_id
AND   t3.fk_property = 1178
AND   t3.fk_temporal_entity = t2.fk_temporal_entity
AND   t3.fk_entity = t4.fk_entity
AND   t4.fk_property = 1181
AND   t5.fk_temporal_entity = t4.fk_temporal_entity
AND   t5.fk_property = 148
AND   t6.pk_entity = t5.fk_entity

ORDER BY tw1.freq DESC;




/*** 
Erreur de Paris

SELECT t4.fk_entity,
       importer.get_entity_appellation(t4.fk_entity),
       ST_Y(t6.geo_point::geometry) AS long,
       ST_X(t6.geo_point::geometry) AS lat
FROM 
     information.role t4,
     information.role t5,
     information.place t6
WHERE t4.fk_entity = 81770

AND   t4.fk_property = 1181
AND   t5.fk_temporal_entity = t4.fk_temporal_entity
AND   t5.fk_property = 148
AND   t6.pk_entity = t5.fk_entity;



***/








/***
BABETTE SAXER
Familie de Babette Saxer
24680205,24680206,24680202,24680204,24680203,24658864,24679692

Direkte Annotation der Eltern bei der Geburt
Auch Tod aus dem Sterberegister

***/

SELECT pk_row
FROM importer.volksz_1860_t_names
WHERE full_naming ~* 'Saxer';




SELECT *
FROM tables.rebuild_partitioned_table (24626627,NULL,ARRAY[]::INTEGER[]);

SELECT *
FROM tv_24626627 where pk_row IN (24680205,24680206,24680202,24680204,24680203,24658864,24679692) order by pk_row, "24626628";





/***

MEMBERSHIP -> Nationality


***/


          

SELECT DISTINCT 442 AS fk_class,
       8,
       8,
       ('{"source": {"import_id": "import_20190930_1",
       "pk_digital" : 24626627,
          "pk_row": ' ||(t0.metadata #> '{"source","pk_row"}')::TEXT::INTEGER || ',
          "pk_entity_person": ' || t0.pk_entity || ',
          "pk_staat": ' || t1.nationality_id || '}}')::JSONB
FROM information.persistent_item t0, importer.volksz_1860_t_names	 t1
WHERE  (t0.metadata #> '{"source","pk_row"}')::text::integer = t1.pk_row
AND t0.fk_class = 21
AND   TRIM((t0.metadata #> '{"source","import_id"}')::VARCHAR, '"') = 'import_20190925_1'
and t1.nationality_id > 0
--order by t0.pk_entity desc
LIMIT 50;




/***
MEMBERSHIP   INSERT

28002 rows affected

***/

--INSERT INTO information.temporal_entity
(
  fk_class,
  fk_creator,
  fk_last_modifier,
  metadata
)
SELECT DISTINCT 442 AS fk_class,
       8,
       8,
       ('{"source": {"import_id": "import_20190930_1",
       "pk_digital" : 24626627,
          "pk_row": ' ||(t0.metadata #> '{"source","pk_row"}')::TEXT::INTEGER || ',
          "pk_entity_person": ' || t0.pk_entity || ',
          "pk_staat": ' || t1.nationality_id || '}}')::JSONB
FROM information.persistent_item t0, importer.volksz_1860_t_names	 t1
WHERE  (t0.metadata #> '{"source","pk_row"}')::text::integer = t1.pk_row
AND t0.fk_class = 21
AND   TRIM((t0.metadata #> '{"source","import_id"}')::VARCHAR, '"') = 'import_20190925_1'
and t1.nationality_id > 0;


SELECT *
FROM information.temporal_entity
ORDER BY pk_entity DESC LIMIT 10;



/***

Membership rôles for persons:   histP15 has person as member 
28002 rows affected

***/ 

BEGIN;
--INSERT INTO information.role(fk_property,fk_creator,fk_last_modifier,fk_entity,fk_temporal_entity,metadata) 
SELECT 1188,8,8,
       (metadata #> '{"source","pk_entity_person"}')::VARCHAR::INTEGER person,
       pk_entity,
       ('{"source": {"import_id": "import_20190930_2" ,  "pk_row": ' ||        (metadata #> '{"source","pk_row"}')::text::integer || ' }}')::JSONB  -- ' || (t0.metadata #> '{"source","pk_row"}')::text::integer || '
FROM information.temporal_entity
WHERE TRIM('"' FROM (metadata #> '{"source","import_id"}')::TEXT) = 'import_20190930_1';
limit 50;


/***

Membership rôles for states:   histP16 is membership in 
28002 rows affected

***/ 

BEGIN;
--INSERT INTO information.role(fk_property,fk_creator,fk_last_modifier,fk_entity,fk_temporal_entity,metadata) 
SELECT 1189,8,8,
       (metadata #> '{"source","pk_staat"}')::VARCHAR::INTEGER staat,
       pk_entity,
       ('{"source": {"import_id": "import_20190930_3" ,  "pk_row": ' ||        (metadata #> '{"source","pk_row"}')::text::integer || ' }}')::JSONB  -- ' || (t0.metadata #> '{"source","pk_row"}')::text::integer || '
FROM information.temporal_entity
WHERE TRIM('"' FROM (metadata #> '{"source","import_id"}')::TEXT) = 'import_20190930_1';
limit 50;


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





*/

INSERT INTO projects.info_proj_rel
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
       'import_20190930_3' || '_project_association'
FROM information.entity
WHERE TRIM((metadata #> '{"source","import_id"}')::VARCHAR,'"') = 'import_20190930_3' 
ORDER BY pk_entity DESC;

/*
DONE FOR:


import_20190930_1
import_20190930_2
import_20190930_3


*/


ALTER TABLE projects.info_proj_rel ENABLE TRIGGER after_epr_upsert;

COMMIT;



/*
ATTENTION : l'exécution prend plusieurs minutes
*/ 
SELECT warehouse.entity_preview__create_all();

