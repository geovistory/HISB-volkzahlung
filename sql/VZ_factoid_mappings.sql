/****

This page is about producing factoid mappings

***/

SELECT *
FROM data.digital
WHERE pk_entity = 24626480; --24626627;



WITH tw1 AS(
-- factoid mappings of that person
SELECT 
	t3.fk_factoid_mapping,
	t2.fk_row
FROM 
	information.statement AS t1
INNER JOIN projects.info_proj_rel AS t0 ON (t0.fk_entity = t1.pk_entity)
INNER JOIN tables.cell AS t2 ON (pk_cell = fk_subject_tables_cell)
INNER JOIN data.factoid_property_mapping AS t3 ON (t2.fk_column = t3.fk_column)
INNER JOIN data.digital as t4 ON (t4.pk_entity = t2.fk_digital)
INNER JOIN data.namespace as t5 ON (t5.pk_entity = t4.fk_namespace)
WHERE
	fk_object_info = 300718 -- 313233
	AND t1.fk_property = 1334
	AND t0.fk_project = 374840
	AND t0.is_in_project = TRUE
	AND t5.fk_project = 374840
)
-- the roles (factoid_role_mappings) of all the factoid mappings
SELECT
	t2.fk_digital as digital,
	t1.fk_factoid_mapping as factoid_mapping,
	t2.fk_class AS class,
	t3.fk_property AS property,
	coalesce(t5.numeric_value::text, t5.string_value) AS value,
	t6.fk_object_info
FROM tw1 as t1
INNER JOIN data.factoid_mapping AS t2 ON (t2.pk_entity = t1.fk_factoid_mapping)
INNER JOIN data.factoid_property_mapping AS t3 ON (t2.pk_entity = t3.fk_factoid_mapping)
INNER JOIN tables.cell AS t5 ON (t1.fk_row = t5.fk_row AND t5.fk_column = t3.fk_column) 
LEFT JOIN information.statement as t6 ON (t6.fk_subject_tables_cell = t5.pk_cell AND t6.fk_property = 1334);




SELECT t1.*
FROM information.statement AS t1
  JOIN projects.info_proj_rel AS t0
    ON (t0.fk_entity = t1.pk_entity
   AND t0.fk_project = 374840)
WHERE t1.fk_object_info = 313233
AND   t1.fk_property = 1334;





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


SELECT *
FROM data.class_column_mapping;


/***

VZ1860, column 24626676 Geburtsjahr, class 335 Time primitive
VZ1860, column 24626694	Staatszugehörigkeit, class 68 crm:E74 Group

VZ1860, column 24626674	Beruf-Gewerbe, class 636  Occupation - histSoc:C7  

VZ1850, column 24626623 Name Vorname, Class 21 crm:E21 Person

VZ1850, column 24626521	Beruf-Gewerbe, class 636  Occupation - histSoc:C7  


Liste der Staaten und Kantone: 24731751  

* column 24731753  Offizielle Bezeichnung -> wird auf crm:E74 Group (Id. OntoME: 68) gemäppt, 
                                                sollte aber crm:E40 Legal Body sein, noch nicht im Profil


***/


--INSERT INTO data.class_column_mapping
(
  fk_creator,
  fk_last_modifier,
  fk_column,
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
  24626521,
  24626451,
  636,
  ('{"source": "Produced by FB 16 February 2021 with SQL instruction ", "id_production": "prod_20210216_2"}')::JSONB,
  NOW(),
  NOW()
);


SELECT *
FROM data.factoid_mapping;


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



-- column with the person 24686142
-- pk_factoid _mapping: 24686205


SELECT *
FROM data.factoid_property_mapping;



/***

Suite à problème désormais réglé – plus nécessaire

--UPDATE data.factoid_property_mapping
   SET fk_column = 24686142
WHERE pk_entity = 24686210;


-- DROP TRIGGER versioning_trigger ON data.factoid_property_mapping ;

CREATE TRIGGER versioning_trigger BEFORE INSERT OR DELETE OR UPDATE
  ON data.factoid_property_mapping FOR EACH ROW
--  EXECUTE PROCEDURE versioning('sys_period', 'data.factoid_role_mapping_vt', 'true');
    EXECUTE PROCEDURE versioning('sys_period', 'data.factoid_property_mapping_vt', 'true');

***/









SELECT *
FROM tables.cell
WHERE fk_column = 24626676 LIMIT 10;


/*
List the table columns
*/
SELECT pk_entity,
       id_for_import_txt
FROM data.column
WHERE fk_digital = 24626480;

--1860 : 24626627; 1850 : 24626480;


SELECT *
FROM data.factoid_property_mapping;

/*

** Birth 
Produce the factoid role mapping for :
 *  born person, property = 86, column = VZ1860 : 24700267 (stag:24686142) ; VZ1850 : 24626623 (stag:24626623)
 *  birth year property pk 72 = crm:P82 at some time within, column = VZ1860 : 24626676 ; 1850 : 24626523



** Membership

 *  person property 1188 column = 24700267 - mapping:24730466, column 24700267 - mapping:24731791 (VZ1850: column = 24626623  - mapping: 24731783, 24731784)
 *  group property 1189 column = 24626694 - mapping:24730466, column 24626692 - mapping:24731791   (VZ1850: column = 24626541,24626543  - mapping: 24731783, 24731784)
 
** Occupation
* person property  1441   column = 24700267 (VZ1850: 24626623 - mapping: 24731782)
* occupation property 1442 column = 24626674  (VZ1850: 24626521 - mapping: 24731782)

*/


INSERT INTO data.factoid_property_mapping
(
  fk_creator,
  fk_last_modifier,
  fk_property,
  fk_column,
  fk_factoid_mapping,
  is_outgoing,
  metadata,
  tmsp_creation,
  tmsp_last_modification
)
VALUES
(
  8,
  8,
  1188,
  24700267,
  24731791,
  TRUE,
  ('{"source": "Produced by FB 16 February 2021 with SQL instruction ", "id_production": "prod_20210216_14"}')::JSONB,
  NOW(),
  NOW()
);

