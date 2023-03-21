/***
[5 March 2020]

This page is about exploring the HISB census data

***/


/*
List the table columns
*/
SELECT pk_entity,
       id_for_import_txt
FROM data.column
WHERE fk_digital = 24626627;

--1860 : 24626627; 1850 : 24626480;


/***

RESULT = COLUMN's LIST

1860 : 24626627; 

pk_entity	id_for_import_txt
24626628	ID-Nr
24626630	Erstnennung_Adresse (ja)
24626632	alte Haus-Nr
24626634	alte Haus-Nr nummerisch
24626636	Stadt_Gemeinde (wohnhaft)
24626638	Quartier-Nummer
24626640	Quartier
24626642	Haushalte_pro_Adresse
24626644	Haushalt-Nr
24626646	Zeddel-Nummer
24626648	Buch-Zeddel-Nummer
24626650	Bewohner-Reihenfolge (Hh)
24626652	Personen_pro_Haushalt (abs)
24626654	Zimmerzahl Zeddel
24626656	Zimmerzahl Buch
24626658	Wohnungs-Kennziffer
24626660	Bewohner-Reihenfolge (Adresse)
24626662	Personen_pro_Adresse (abs)
24626664	Name
24626666	Vorname
24626668	Geschlecht
24626670	Alter (Jahre)
24626672	Zivilstand
24626674	Beruf-Gewerbe
24626676	Geburtsjahr
24626678	Geburtsmonat Säugling
24626680	Konfession
24626682	Unterschrift
24626684	Abwesend
24626686	Gemeindbürger von
24626688	Aufenthatsverhältnisse
24626690	Bürger anderer Kt oder Ausländer (syst. nach Fiebig)
24626692	Bürger anderer Kantone (vereinheitlicht)
24626694	Staatszugehörigkeit
24626696	Heimatlose und Findlinge
24626698	Geburtsort
24626700	Ordonanstutzer
24626702	sonstige Stutzer
24626704	mit Perkussionszündung
24626706	mit Steinschloss
24626708	Strasse (Adressbuch 1854)
24626710	Haus-Nr (Adressbuch 1854)
24626712	Hausname (Adressbuch 1854)
24626714	1854 an gleicher Adresse wohnhaft
24626716	Bemerkungen allg. (Fiebig)
24626718	STJ-Nr
24626720	KPR-Personen-ID-Nr
24626722	KG-Reg-Nr
24626724	Spit-Nr (1)
24626726	Spit-Nr (2)
24626728	Spit-Nr (3)
24626730	Spit-Nr (4)
24626732	Spit-Nr (5)
24626734	Spit-Nr (6)
24626736	Spit-Nr (7)
24626738	Spit-Nr (8)
24626740	Spit-Nr (9)
24626742	Quelle (Zählungsbogen)
24626744	ID-Nr Archiv-Schachtel
24626746	Bündel-Bezeichnung
24626748	URL-Adresse der Quelle (Zählungsbogen)
24626750	Foto (Zählungsbogen)
24626752	Quelle (Übertragungsbuch)
24626754	Seite Buch (ab Nr. 2494)
24626756	URL-Adresse der Quelle (Übertragungsbuch)
24626758	Foto (Übertragungsbuch)
24626760	Transkribierende (Name)
24626762	Zeitraum der Transkription
24626764	Bemerkungen Transkription
24626766	Grunddatei für HISB (Dateiname)
24626768	Datenkonsolidierung für HISB (Name)
24626770	Datenkonsolidierung Datum
24626772	Problem: überprüfen (ja/nein/korr)
24626774	Problem: Sachlage
24626776	Tr. Gegengelesen (nein/Name)
24626778	Tr. Gegengelesen Datum
24626780	Bemerkung Gegengelesung


1850 : 24626480;
 
pk_entity	id_for_import_txt
24626481	ID-Nr
24626483	Erstnennung_Adresse (ja)
24626485	alte Haus-Nr
24626487	alte Haus-Nr nummerisch
24626489	Person_oder_Liegenschaft
24626491	Stadt_Gemeinde (wohnhaft)
24626493	Quartier-Nummer
24626495	Quartier
24626497	Haushalte_pro_Adresse
24626499	Haushalt-Nr
24626501	Bewohner-Reihenfolge (Hh)
24626503	Personen_im_Haushalt (abs)
24626505	Wohnungs-Kennziffer
24626507	Bewohner-Reihenfolge (Adresse)
24626509	Personen_pro_Adresse (abs)
24626511	Name
24626513	Vorname
24626515	Geschlecht
24626517	Alter (Jahre)
24626519	Zivilstand
24626521	Beruf-Gewerbe
24626523	Geburtsjahr
24626525	Konfession
24626527	Grundeigenthümer (=Hauseigentümer)
24626529	Abwesend
24626531	Abwesenheitsgrund
24626533	Gemeindbürger von
24626535	Aufenthaltsverhältnisse  (detailliert)
24626537	Aufenthaltsverhältnisse  (abgekürzt)
24626539	Schweizerbürger anderer Kantone (wie im Buch)
24626541	Schweizerbürger anderer Kantone (vereinh., abgek.)
24626543	Staatszugehörigkeit
24626545	Heimatlose, geduldet und politische Flüchtlinge
24626547	Strassen 1850
24626549	Strasse (Adressbuch 1854)
24626551	Hausname (Adressbuch 1854)
24626553	Div. Adressverzeichnisse (1862)
24626555	diverses  Volkszählung 1850
24626557	Strasse (Adressbuch 1862)
24626559	Haus-Nr (Adressbuch 1862)
24626561	Hausname (Adressbuch 1862)
24626563	Strasse (Inform. von M. Zulauf)
24626565	Haus-Nr (Inform. von M. Zulauf)
24626567	STJ-Nr
24626569	KPR-Personen-ID-Nr
24626571	KG-Reg-Nr
24626573	Spit-Nr (1)
24626575	Spit-Nr (2)
24626577	Spit-Nr (3)
24626579	Spit-Nr (4)
24626581	Spit-Nr (5)
24626583	Spit-Nr (6)
24626585	Spit-Nr (7)
24626587	Spit-Nr (8)
24626589	Spit-Nr (9)
24626591	Bemerkungen spez. Spital (Fiebig)
24626593	Quelle (Übertragungsbuch)
24626595	Seite Buch
24626597	URL-Adresse der Quelle (Übertragungsbuch)
24626599	Foto (Übertragungsbuch)
24626601	Transkribierende (Name)
24626603	Zeitraum der Transkription
24626605	Bemerkungen Transkription
24626607	Grunddatei für HISB (Dateiname)
24626609	Datenkonsolidierung für HISB (Name)
24626611	Datenkonsolidierung Datum
24626613	Problem: überprüfen (ja/nein/korr)
24626615	Problem: Sachlage
24626617	Transkription Gegengelesen (nein/Name)
24626619	Tr. Gegengelesen Datum
24626621	Bemerkung Gegenlesung
24626623	Name und Vorname
24626625	Name "Komma" Vorname

*/ 


-- Without column list the function rebuilds the whole table
SELECT *
FROM tables.rebuild_partitioned_table (24626627,NULL,ARRAY[]::INTEGER[]);


SELECT *
FROM tv_24626627 LIMIT 10;

SELECT count(*)
FROM tables.row where fk_digital = 24626627;


/*
Partial rebuilds
*/

-- VZ1860
SELECT *
FROM tables.rebuild_partitioned_table (24626627,'tv_biogr_base_1860',ARRAY[24626664,24626666,24626668,24626676,24626680,24626674, 24626690, 24626692]::INTEGER[]);

SELECT * FROM tv_biogr_base_1860 LIMIT 10;
-- OR

SELECT *
FROM tables.rebuild_partitioned_table (24626627,'tv_adressen',ARRAY[24626628,24626636,24626638,24626640,24626632,24626644]::INTEGER[]);


SELECT *
FROM tv_adressen LIMIT 10;

-- compter par quartier
SELECT "24626640",
       COUNT(*) freq
FROM tv_adressen
GROUP BY "24626640"
ORDER BY freq DESC;

-- compter par adresse
SELECT "24626632",
       COUNT(*) freq
FROM tv_adressen
GROUP BY "24626632"
ORDER BY freq DESC LIMIT 300;

-- compter par adresse et ménage
WITH tw1
AS
(SELECT MAX(CONCAT ("24626640",'_',"24626632")) AS quartier_adresse,
       "24626644" haushalt,
       COUNT(*) freq_h
FROM tv_adressen
GROUP BY "24626644"),
         tw2 AS (SELECT CONCAT("24626640",'_',"24626632") AS quartier_adresse,
                        COUNT(*) freq_a
                 FROM tv_adressen
                 GROUP BY CONCAT("24626640",'_',"24626632"))
SELECT tw2.freq_a,
       tw1.freq_h,
       tw2.quartier_adresse,
       haushalt
FROM tw2,
     tw1
WHERE tw1.quartier_adresse = tw2.quartier_adresse
ORDER BY freq_a DESC,
         tw2.quartier_adresse,
         freq_h DESC LIMIT 500;

SELECT *
FROM tv_24626627
WHERE CONCAT("24626640",'_',"24626632") = 'Unterer Bann_110 A';

-- Bläsi-Bann_79:   St. Johann_257: spital  Unterer Bann_110 A: 
-- Konfession
SELECT *
FROM tables.rebuild_partitioned_table (24626627,'tv_konfession',ARRAY[24626680]::INTEGER[]);

SELECT "24626680",
       COUNT(*) freq
FROM tv_konfession
GROUP BY "24626680";






-- Geburtsort, Staatszugehörigkeit, Burger andere kantone
SELECT *
FROM tables.rebuild_partitioned_table (24626627,'tv_geburtsort',ARRAY[24626698, 24626694, 24626690, 24626692]::INTEGER[]);

SELECT "24626690",
       COUNT(*) freq
FROM tv_geburtsort
GROUP BY "24626690"
ORDER BY freq DESC;







/***

BIOGRAPHISCHE GRUNDELEMENTE

***/


-- 1860: name-vorname, name, vorname, geschlecht, geburstjahr, konfession, beruf, herkunft
SELECT *
FROM tables.rebuild_partitioned_table (24626627,'tv_biogr_base_1860',ARRAY[24700267, 24626664,24626666,24626668,24626676,24626680,24626674, 24626690]::INTEGER[]);

-- 1850: name-vorname, name, vorname, geschlecht, geburstjahr, konfession,  beruf, bürger vereinh.
SELECT *
FROM tables.rebuild_partitioned_table (24626480,'tv_biogr_base_1850',ARRAY[24626623, 24626511,24626513,24626515,24626523,24626525,24626521, 24626541]::INTEGER[]);

SELECT *
FROM tv_biogr_base_1850 LIMIT 10;


-- does not work on temporary table
CREATE INDEX t_names_idx_24626623
  ON tv_biogr_base_1850 ("24626623");
  


SELECT *
FROM tv_biogr_base_1860 LIMIT 10;

SELECT *
FROM tv_biogr_base_1860
WHERE "24626680" ~ 'isr';


/***
Konfession
1860: 24626680
1850: 24626525
***/


SELECT "24626680",
       COUNT(*) AS eff
FROM tv_biogr_base_1860
GROUP BY "24626680"
ORDER BY eff DESC;



SELECT "24626525",
       COUNT(*) AS eff
FROM tv_biogr_base_1850
GROUP BY "24626525"
ORDER BY eff DESC;




/***
BERUFE
***/ 
-- beruf getrennt
WITH tw1
AS
(SELECT pk_row,
       "24626674",
       TRIM(UNNEST(REGEXP_SPLIT_TO_ARRAY("24626674",'und|,+'))) beruf
FROM tv_biogr_base_1860
WHERE "24626674" ~* '^Metz|\sMetz') SELECT pk_row,ARRAY_AGG(beruf),"24626674" FROM tw1
GROUP BY pk_row,
         "24626674";

WITH tw1 AS
(
  SELECT pk_row,
         "24626674",
         TRIM(UNNEST(REGEXP_SPLIT_TO_ARRAY("24626674",'und|,+'))) beruf
  FROM tv_biogr_base_1860
)
SELECT pk_row,
       ARRAY_AGG(beruf) berufe,
       "24626674"
FROM tw1
WHERE "24626674" ~ '^Metz|\sMetz'
GROUP BY pk_row,
         "24626674";

-- métiers nettoyés et séparés
WITH tw1
AS
(SELECT pk_row,
       "24626674",
       TRIM(UNNEST(REGEXP_SPLIT_TO_ARRAY("24626674",'und|,+'))) beruf
FROM tv_biogr_base_1860) 
     SELECT beruf,COUNT(*) freq 
     FROM tw1
WHERE beruf ~ 'meist'
GROUP BY beruf
ORDER BY freq DESC;


--knech magd gesel meister;
SELECT *
FROM tables.quill_doc_cell LIMIT 10;

SELECT concat("24626664",' ',"24626666") full_naming,
       pk_row
FROM tv_biogr_base
WHERE "24626664" ~* 'Magda'
OR    "24626664" ~* 'Georg'
ORDER BY "24626664",
         "24626666";






/***
Documentation:
https://stackoverflow.com/questions/16195986/isnumeric-with-postgresql
Look at the interesting discussion in the post
***/ 
CREATE OR REPLACE FUNCTION importer.isnumeric (TEXT) RETURNS BOOLEAN
AS
$$ DECLARE x NUMERIC;

BEGIN x = $1::NUMERIC;

RETURN TRUE;

EXCEPTION WHEN others THEN RETURN FALSE;

END;

$$ STRICT LANGUAGE plpgsql IMMUTABLE;





/***
APPELLATIONS
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
       "24626690" herkunft,
       "24626674" beruf,
       pk_row
FROM tv_biogr_base_1860
ORDER BY "24626664",
         "24626666");

CREATE INDEX t_names_idx_1 
  ON t_names (full_naming);



SELECT gebjahr::INTEGER,
       *
FROM t_names
WHERE full_naming ~* 'abe';






--DROP TABLE importer.hisb_t_name_comparison_1860;
--CREATE TABLE importer.hisb_t_name_comparison_1860
AS
WITH tw1 AS
(
SELECT beruf,
       full_naming,
       gebjahr,
       gender,
       herkunft,
       konf,
       pk_row
FROM t_names --LIMIT 5000
)
SELECT levenshtein(unaccent (t2.full_naming),unaccent (t1.full_naming)) r_levenshtein,
       similarity(unaccent (t2.full_naming),unaccent (t1.full_naming)) r_similarity,
       t1.full_naming name_1,
       t2.full_naming name_2,
       t1.pk_row pk_row_1,
       t2.pk_row pk_row_2,
       FALSE::boolean as set_as_same,
       NULL::integer as fk_information_entity,
       t1.gebjahr gebjahr_1,
       t2.gebjahr gebjahr_2,
       t1.konf konf_1,
       t2.konf konf_2,
       t1.herkunft herk_1,
       t2.herkunft herk_2,
       t1.beruf beruf_1,
       t2.beruf beruf_2
FROM tw1 t1
  CROSS JOIN tw1 t2
WHERE t2.pk_row > t1.pk_row
AND   t2.gender = t1.gender
AND   t2.gebjahr BETWEEN t1.gebjahr - 1 AND t1.gebjahr + 1
AND   similarity(unaccent(t2.full_naming),unaccent(t1.full_naming)) > 0.65
ORDER BY pk_row_1,
         pk_row_2;


SELECT COUNT(*)
FROM importer.hisb_t_name_comparison_1860;

SELECT *
FROM importer.hisb_t_name_comparison_1860
LIMIT 10;

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

SELECT 1, *
FROM importer.hisb_t_name_comparison_1860 WHERE pk_row_1 in (select pk_row from tw1)
UNION
SELECT 2, *
FROM importer.hisb_t_name_comparison_1860 WHERE pk_row_2 in (select pk_row from tw1);




/***
Probléme des doublons

Je retiens toutes les personnes nées la même années, avec la même origine et la même confession


***/

SELECT *
FROM importer.hisb_t_name_comparison_1860
WHERE gebjahr_1 = gebjahr_2
--AND konf_1 = konf_2
--AND herk_1 = herk_2
--AND   set_as_same IS TRUE
ORDER BY name_1,
         name_2;


  
SELECT  t2.string_value, t3.string_value, t1.*
FROM importer.hisb_t_name_comparison_1860 t1, tables.cell t2, tables.cell t3
WHERE t2.fk_row = t1.pk_row_1
AND t2.fk_column = 24626632
AND t3.fk_row = t1.pk_row_2
AND t3.fk_column = 24626632
AND   gebjahr_1 = gebjahr_2
AND ( t2.string_value = '257' or  t3.string_value = '257')  -- patients ou présents à l'hopital
ORDER BY name_1,
         name_2;
















