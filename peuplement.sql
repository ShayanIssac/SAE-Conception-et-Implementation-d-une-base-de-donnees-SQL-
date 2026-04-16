DELETE FROM analyses;
DELETE FROM evenements;
DELETE FROM sites;
DELETE FROM communes;
DELETE FROM departements;
DELETE FROM regions;


CREATE TABLE temp_departements_france (
    code_departement VARCHAR, nom_departement VARCHAR,
    code_region VARCHAR, nom_region VARCHAR
);

CREATE TABLE temp_sites_baignade (
    "Saison balnéaire" VARCHAR, "Région" VARCHAR, "Département" VARCHAR,
    "Code unique d'identification du site de baignade" VARCHAR,
    "Précédent code unique d'identification du site de baignade" VARCHAR,
    "Evolution 2024 vs. 2023" VARCHAR, "Nom du site de baignade" VARCHAR,
    "Code INSEE de la commune" VARCHAR, "Nom de la commune" VARCHAR,
    "Date déclaration UE" VARCHAR, "Type d'eau" VARCHAR,
    "Longitude (ETRS 89)" VARCHAR, "Latitude (ETRS 89)" VARCHAR
);

CREATE TABLE temp_informations_saison (
    "Saison balnéaire" VARCHAR, "Région" VARCHAR, "Département" VARCHAR,
    "Code unique d'identification du site de baignade" VARCHAR,
    "Type d'événement" VARCHAR, "Date de début" VARCHAR,
    "Date de fin" VARCHAR, "Mesures de gestion" VARCHAR
);

CREATE TABLE temp_resultats_analyses (
    "Saison balnéaire" VARCHAR, "Région" VARCHAR, "Département" VARCHAR,
    "Code unique d'identification du site de baignade" VARCHAR,
    "Date de prélèvement" VARCHAR, "Résultat entérocoques intestinaux" VARCHAR,
    "Résultat Escherichia coli" VARCHAR, "Statut du prélèvement" VARCHAR,
    colonne_vide_1 VARCHAR, colonne_vide_2 VARCHAR, colonne_vide_3 VARCHAR
);


COPY temp_departements_france 
FROM './donnees/departements-france.csv' 
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY temp_sites_baignade 
FROM './donnees/liste-des-sites-de-baignade-saison-balneaire-2024.csv' 
WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'WIN1252');

COPY temp_informations_saison 
FROM './donnees/saison-balneaire-2024-informations-sur-la-saison.csv' 
WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'WIN1252');

COPY temp_resultats_analyses 
FROM './donnees/saison-balneaire-2024-resultats-danalyses.csv' 
WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'WIN1252');


INSERT INTO regions (code, nom)
SELECT DISTINCT code_region, nom_region FROM temp_departements_france;

INSERT INTO departements (code, region, nom)
SELECT DISTINCT code_departement, code_region, nom_departement FROM temp_departements_france;

INSERT INTO communes (code, departement, nom)
SELECT DISTINCT "Code INSEE de la commune", 
    CASE WHEN "Code INSEE de la commune" LIKE '97%' THEN LEFT("Code INSEE de la commune", 3)
         ELSE LEFT("Code INSEE de la commune", 2) END,
    "Nom de la commune"
FROM temp_sites_baignade
WHERE 
    CASE WHEN "Code INSEE de la commune" LIKE '97%' THEN LEFT("Code INSEE de la commune", 3)
         ELSE LEFT("Code INSEE de la commune", 2) END 
    IN (SELECT code FROM departements);

INSERT INTO sites (idSite, nom, codeCommune, dateDeclaration, typeEau, longitude, latitude)
SELECT DISTINCT "Code unique d'identification du site de baignade", "Nom du site de baignade",
    "Code INSEE de la commune", 
    TO_DATE("Date déclaration UE", 'DD/MM/YYYY'), 
    "Type d'eau",
    CAST(REPLACE("Longitude (ETRS 89)", ',', '.') AS FLOAT),
    CAST(REPLACE("Latitude (ETRS 89)", ',', '.') AS FLOAT)
FROM temp_sites_baignade
WHERE "Code INSEE de la commune" IN (SELECT code FROM communes);

INSERT INTO evenements (idSite, evenement, debut, fin, mesure)
SELECT "Code unique d'identification du site de baignade", "Type d'événement",
    TO_DATE("Date de début", 'DD/MM/YYYY'), 
    TO_DATE("Date de fin", 'DD/MM/YYYY'),   
    "Mesures de gestion"
FROM temp_informations_saison
WHERE "Code unique d'identification du site de baignade" IN (SELECT idSite FROM sites);

INSERT INTO analyses (idSite, datePrelevement, enterocoques, escherichia)
SELECT "Code unique d'identification du site de baignade", 
    TO_DATE("Date de prélèvement", 'DD/MM/YYYY'), 
    CAST(NULLIF("Résultat entérocoques intestinaux", '') AS INTEGER),
    CAST(NULLIF("Résultat Escherichia coli", '') AS INTEGER)
FROM temp_resultats_analyses
WHERE "Code unique d'identification du site de baignade" IN (SELECT idSite FROM sites);

DROP TABLE temp_departements_france;
DROP TABLE temp_sites_baignade;
DROP TABLE temp_informations_saison;
DROP TABLE temp_resultats_analyses;