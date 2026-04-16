/* =============================================================
   FICHIER 1 : CREATION_TABLES.SQL
   Version : FLOAT et VARCHAR (illimité)
   ============================================================= */

-- 1. Nettoyage
DROP TABLE IF EXISTS analyses CASCADE;
DROP TABLE IF EXISTS evenements CASCADE;
DROP TABLE IF EXISTS sites CASCADE;
DROP TABLE IF EXISTS communes CASCADE;
DROP TABLE IF EXISTS departements CASCADE;
DROP TABLE IF EXISTS regions CASCADE;

-- 2. Création des tables
CREATE TABLE regions (
    code VARCHAR(10) PRIMARY KEY,
    nom VARCHAR(100)
);

CREATE TABLE departements (
    code VARCHAR(5) PRIMARY KEY,
    region VARCHAR(10),      
    nom VARCHAR(100),
    FOREIGN KEY (region) REFERENCES regions(code)
);

CREATE TABLE communes (
    code VARCHAR(10) PRIMARY KEY,
    departement VARCHAR(5),   
    nom VARCHAR(100),
    FOREIGN KEY (departement) REFERENCES departements(code)
);

CREATE TABLE sites (
    idSite VARCHAR(50) PRIMARY KEY,
    nom VARCHAR(150),
    codeCommune VARCHAR(10),  
    dateDeclaration DATE,
    typeEau VARCHAR(50),
    longitude FLOAT, -- Changé en FLOAT
    latitude FLOAT,  -- Changé en FLOAT
    FOREIGN KEY (codeCommune) REFERENCES communes(code)
);

CREATE TABLE evenements (
    idEvenement SERIAL PRIMARY KEY,
    idSite VARCHAR(50),       
    evenement VARCHAR(100),
    debut DATE,
    fin DATE,
    mesure VARCHAR, -- VARCHAR sans taille = Illimité (accepte les longs textes)
    FOREIGN KEY (idSite) REFERENCES sites(idSite)
);

CREATE TABLE analyses (
    idAnalyse SERIAL PRIMARY KEY,
    idSite VARCHAR(50),       
    datePrelevement DATE,
    enterocoques INTEGER,
    escherichia INTEGER,
    FOREIGN KEY (idSite) REFERENCES sites(idSite)
);