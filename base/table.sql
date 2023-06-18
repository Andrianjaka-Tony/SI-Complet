DROP DATABASE si;
CREATE DATABASE si;
\c si;


CREATE TABLE tva (
  value NUMERIC
);


CREATE TABLE societe (
  nom VARCHAR(40) NOT NULL,
  objet VARCHAR(255) NOT NULL,
  dirigeant VARCHAR(100) NOT NULL,
  NIF VARCHAR(20) NOT NULL,
  RCS VARCHAR(20) NOT NULL,
  STAT VARCHAR(20) NOT NULL,
  creation DATE NOT NULL,
  email VARCHAR(50) NOT NULL,
  adresse VARCHAR(100) NOT NULL,
  siege VARCHAR(100) NOT NULL,
  telephone VARCHAR(20) NOT NULL,
  logo VARCHAR(20) NOT NULL
);


CREATE TABLE comptable (
  compte INT PRIMARY KEY,
  intitule VARCHAR(150) NOT NULL
);


CREATE TABLE racine (
  compte INT PRIMARY KEY,
  intitule VARCHAR(150) NOT NULL
);


CREATE TABLE exercice (
  id SERIAL PRIMARY KEY,
  debut DATE NOT NULL,
  fin DATE NOT NULL
);


CREATE TABLE tiers (
  numero VARCHAR(8) NOT NULL,
  compte INT REFERENCES comptable(compte),
  intitule VARCHAR(150) NOT NULL
);


CREATE TABLE journal (
  code VARCHAR(10) PRIMARY KEY,
  intitule VARCHAR(150) NOT NULL
);


CREATE TABLE devise (
  id SERIAL PRIMARY KEY,
  nom VARCHAR(50) NOT NULL,
  valeur NUMERIC DEFAULT 0,
  date DATE NOT NULL DEFAULT current_date
);


CREATE TABLE ecriture (
  id SERIAL PRIMARY KEY,
  compte INT REFERENCES comptable(compte),
  journal VARCHAR(10) REFERENCES journal(code),
  intitule VARCHAR(150),
  piece VARCHAR(20),
  debit NUMERIC NOT NULL DEFAULT 0,
  credit NUMERIC NOT NULL DEFAULT 0,
  date DATE NOT NULL DEFAULT current_date,
  tiers VARCHAR(20) DEFAULT NULL,
  exercice INT REFERENCES exercice(id)
);


CREATE TABLE produit (
  id SERIAL NOT NULL PRIMARY KEY,
  nom VARCHAR(30) NOT NULL
);


CREATE TABLE nature (
  id SERIAL NOT NULL PRIMARY KEY,
  nom VARCHAR(20) NOT NULL
);


CREATE TABLE charge_compte (
  compte INT NOT NULL REFERENCES comptable(compte),
  nature INT NOT NULL REFERENCES nature(id),
  valeur INT NOT NULL DEFAULT 0
);
ALTER TABLE charge_compte
  ALTER COLUMN valeur
    TYPE FLOAT;


CREATE TABLE centre (
  id SERIAL NOT NULL PRIMARY KEY,
  nom VARCHAR(50) NOT NULL
);


CREATE TABLE centre_compte (
  compte INT NOT NULL REFERENCES comptable(compte),
  nature INT NOT NULL REFERENCES nature(id),
  centre INT NOT NULL REFERENCES centre(id),
  valeur INT NOT NULL DEFAULT 0
);
ALTER TABLE centre_compte
  ALTER COLUMN valeur
    TYPE FLOAT;


CREATE TABLE charge_produit (
  produit INT NOT NULL REFERENCES produit(id),
  valeur INT NOT NULL DEFAULT 0
);


CREATE TABLE incorporable (
  compte INT NOT NULL REFERENCES comptable(compte)
);


CREATE TABLE production (
  produit INT REFERENCES produit(id),
  poids NUMERIC
);


CREATE TABLE vente (
  produit INT REFERENCES produit(id),
  prix NUMERIC
);


CREATE TABLE unite (
  id SERIAL PRIMARY KEY,
  nom VARCHAR(100) NOT NULL
);


CREATE TABLE conversion (
  unite INT REFERENCES unite(id),
  valeur NUMERIC NOT NULL
);


CREATE TABLE produit_vente (
  produit INT REFERENCES produit(id),
  compte INT REFERENCES comptable(compte)
);


CREATE TABLE entreprise (
  numero VARCHAR(20),
  nom VARCHAR(50),
  adresse VARCHAR(100),
  email VARCHAR(100),
  dirigeant VARCHAR(100)
);


CREATE TABLE facture (
  id VARCHAR(20) NOT NULL,
  json TEXT
);


CREATE SEQUENCE incFacture;