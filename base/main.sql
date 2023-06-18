--
-- PostgreSQL database dump
--

-- Dumped from database version 14.3
-- Dumped by pg_dump version 14.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: centre_compte; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.centre_compte (
    compte integer NOT NULL,
    nature integer NOT NULL,
    centre integer NOT NULL,
    valeur double precision DEFAULT 0 NOT NULL
);


ALTER TABLE public.centre_compte OWNER TO postgres;

--
-- Name: charge_compte; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.charge_compte (
    compte integer NOT NULL,
    nature integer NOT NULL,
    valeur double precision DEFAULT 0 NOT NULL
);


ALTER TABLE public.charge_compte OWNER TO postgres;

--
-- Name: ecriture; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ecriture (
    id integer NOT NULL,
    compte integer,
    journal character varying(10),
    intitule character varying(150),
    piece character varying(20),
    debit numeric DEFAULT 0 NOT NULL,
    credit numeric DEFAULT 0 NOT NULL,
    date date DEFAULT CURRENT_DATE NOT NULL,
    tiers character varying(20) DEFAULT NULL::character varying,
    exercice integer
);


ALTER TABLE public.ecriture OWNER TO postgres;

--
-- Name: incorporable; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.incorporable (
    compte integer NOT NULL
);


ALTER TABLE public.incorporable OWNER TO postgres;

--
-- Name: fixe_par_incorporatble; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.fixe_par_incorporatble AS
 SELECT chco.compte,
    chco.nature,
    chco.valeur
   FROM (public.incorporable i
     JOIN public.charge_compte chco ON ((i.compte = chco.compte)))
  WHERE (chco.nature = 2);


ALTER TABLE public.fixe_par_incorporatble OWNER TO postgres;

--
-- Name: fixe_par_incorporatble_par_centre; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.fixe_par_incorporatble_par_centre AS
 SELECT ceco.nature,
    ceco.centre,
    ceco.compte,
    (ceco.valeur * fipain.valeur) AS valeur
   FROM (public.fixe_par_incorporatble fipain
     JOIN public.centre_compte ceco ON (((fipain.compte = ceco.compte) AND (fipain.nature = ceco.nature))));


ALTER TABLE public.fixe_par_incorporatble_par_centre OWNER TO postgres;

--
-- Name: argent_fixe_par_incorporable_par_centre; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.argent_fixe_par_incorporable_par_centre AS
 SELECT vapafipace.compte,
    ((vapafipace.valeur * (ec.debit)::double precision) / (10000)::double precision) AS valeur,
    vapafipace.centre
   FROM (public.fixe_par_incorporatble_par_centre vapafipace
     JOIN public.ecriture ec ON ((vapafipace.compte = ec.compte)));


ALTER TABLE public.argent_fixe_par_incorporable_par_centre OWNER TO postgres;

--
-- Name: argent_fixe_par_incorporable_par_centre_non_null; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.argent_fixe_par_incorporable_par_centre_non_null AS
 SELECT argent_fixe_par_incorporable_par_centre.compte,
    argent_fixe_par_incorporable_par_centre.valeur,
    argent_fixe_par_incorporable_par_centre.centre
   FROM public.argent_fixe_par_incorporable_par_centre
  WHERE (argent_fixe_par_incorporable_par_centre.valeur <> (0)::double precision);


ALTER TABLE public.argent_fixe_par_incorporable_par_centre_non_null OWNER TO postgres;

--
-- Name: argent_fixe_par_centre; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.argent_fixe_par_centre AS
 SELECT sum(argent_fixe_par_incorporable_par_centre_non_null.valeur) AS valeur,
    argent_fixe_par_incorporable_par_centre_non_null.centre
   FROM public.argent_fixe_par_incorporable_par_centre_non_null
  GROUP BY argent_fixe_par_incorporable_par_centre_non_null.centre;


ALTER TABLE public.argent_fixe_par_centre OWNER TO postgres;

--
-- Name: variable_par_incorporatble; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.variable_par_incorporatble AS
 SELECT chco.compte,
    chco.nature,
    chco.valeur
   FROM (public.incorporable i
     JOIN public.charge_compte chco ON ((i.compte = chco.compte)))
  WHERE (chco.nature = 1);


ALTER TABLE public.variable_par_incorporatble OWNER TO postgres;

--
-- Name: variable_par_incorporatble_par_centre; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.variable_par_incorporatble_par_centre AS
 SELECT ceco.nature,
    ceco.centre,
    ceco.compte,
    (ceco.valeur * vapain.valeur) AS valeur
   FROM (public.variable_par_incorporatble vapain
     JOIN public.centre_compte ceco ON (((vapain.compte = ceco.compte) AND (vapain.nature = ceco.nature))));


ALTER TABLE public.variable_par_incorporatble_par_centre OWNER TO postgres;

--
-- Name: argent_variable_par_incorporable_par_centre; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.argent_variable_par_incorporable_par_centre AS
 SELECT vapainpace.compte,
    ((vapainpace.valeur * (ec.debit)::double precision) / (10000)::double precision) AS valeur,
    vapainpace.centre
   FROM (public.variable_par_incorporatble_par_centre vapainpace
     JOIN public.ecriture ec ON ((vapainpace.compte = ec.compte)));


ALTER TABLE public.argent_variable_par_incorporable_par_centre OWNER TO postgres;

--
-- Name: argent_variable_par_incorporable_par_centre_non_null; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.argent_variable_par_incorporable_par_centre_non_null AS
 SELECT argent_variable_par_incorporable_par_centre.compte,
    argent_variable_par_incorporable_par_centre.valeur,
    argent_variable_par_incorporable_par_centre.centre
   FROM public.argent_variable_par_incorporable_par_centre
  WHERE (argent_variable_par_incorporable_par_centre.valeur <> (0)::double precision);


ALTER TABLE public.argent_variable_par_incorporable_par_centre_non_null OWNER TO postgres;

--
-- Name: argent_variable_par_centre; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.argent_variable_par_centre AS
 SELECT sum(argent_variable_par_incorporable_par_centre_non_null.valeur) AS valeur,
    argent_variable_par_incorporable_par_centre_non_null.centre
   FROM public.argent_variable_par_incorporable_par_centre_non_null
  GROUP BY argent_variable_par_incorporable_par_centre_non_null.centre;


ALTER TABLE public.argent_variable_par_centre OWNER TO postgres;

--
-- Name: comptable; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comptable (
    compte integer NOT NULL,
    intitule character varying(150) NOT NULL
);


ALTER TABLE public.comptable OWNER TO postgres;

--
-- Name: balance; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.balance AS
 SELECT comptable.compte,
    comptable.intitule,
    sum(ecriture.debit) AS debit,
    sum(ecriture.credit) AS credit,
    ecriture.exercice
   FROM (public.ecriture
     JOIN public.comptable ON ((ecriture.compte = comptable.compte)))
  GROUP BY comptable.compte, comptable.intitule, ecriture.exercice;


ALTER TABLE public.balance OWNER TO postgres;

--
-- Name: centre; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.centre (
    id integer NOT NULL,
    nom character varying(50) NOT NULL
);


ALTER TABLE public.centre OWNER TO postgres;

--
-- Name: centre_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.centre_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.centre_id_seq OWNER TO postgres;

--
-- Name: centre_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.centre_id_seq OWNED BY public.centre.id;


--
-- Name: charge_produit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.charge_produit (
    produit integer NOT NULL,
    valeur integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.charge_produit OWNER TO postgres;

--
-- Name: fixe_total; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.fixe_total AS
 SELECT sum(argent_fixe_par_centre.valeur) AS valeur
   FROM public.argent_fixe_par_centre;


ALTER TABLE public.fixe_total OWNER TO postgres;

--
-- Name: produit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.produit (
    id integer NOT NULL,
    nom character varying(30) NOT NULL
);


ALTER TABLE public.produit OWNER TO postgres;

--
-- Name: proportion_produits; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.proportion_produits AS
 SELECT pr.id AS produit,
    chpr.valeur
   FROM (public.produit pr
     JOIN public.charge_produit chpr ON ((pr.id = chpr.produit)));


ALTER TABLE public.proportion_produits OWNER TO postgres;

--
-- Name: charge_fixe_produit; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.charge_fixe_produit AS
 SELECT prpr.produit,
    (((prpr.valeur)::double precision * ( SELECT fixe_total.valeur
           FROM public.fixe_total
         LIMIT 1)) / (100)::double precision) AS valeur
   FROM public.proportion_produits prpr;


ALTER TABLE public.charge_fixe_produit OWNER TO postgres;

--
-- Name: charge_par_incorporable_par_centre; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.charge_par_incorporable_par_centre AS
 SELECT argent_variable_par_incorporable_par_centre.valeur AS variable,
    argent_fixe_par_incorporable_par_centre.valeur AS fixe,
    argent_fixe_par_incorporable_par_centre.centre,
    argent_fixe_par_incorporable_par_centre.compte,
    comptable.intitule
   FROM ((public.argent_variable_par_incorporable_par_centre
     JOIN public.argent_fixe_par_incorporable_par_centre ON (((argent_variable_par_incorporable_par_centre.centre = argent_fixe_par_incorporable_par_centre.centre) AND (argent_variable_par_incorporable_par_centre.compte = argent_fixe_par_incorporable_par_centre.compte))))
     JOIN public.comptable ON ((argent_variable_par_incorporable_par_centre.compte = comptable.compte)));


ALTER TABLE public.charge_par_incorporable_par_centre OWNER TO postgres;

--
-- Name: charge_total_centre; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.charge_total_centre AS
 SELECT argent_variable_par_centre.centre,
    argent_variable_par_centre.valeur AS variable,
    argent_fixe_par_centre.valeur AS fixe,
    centre.nom
   FROM ((public.argent_variable_par_centre
     JOIN public.argent_fixe_par_centre ON ((argent_variable_par_centre.centre = argent_fixe_par_centre.centre)))
     JOIN public.centre ON ((centre.id = argent_fixe_par_centre.centre)));


ALTER TABLE public.charge_total_centre OWNER TO postgres;

--
-- Name: variable_total; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.variable_total AS
 SELECT sum(argent_variable_par_centre.valeur) AS valeur
   FROM public.argent_variable_par_centre;


ALTER TABLE public.variable_total OWNER TO postgres;

--
-- Name: charge_variable_produit; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.charge_variable_produit AS
 SELECT prpr.produit,
    (((prpr.valeur)::double precision * ( SELECT variable_total.valeur
           FROM public.variable_total
         LIMIT 1)) / (100)::double precision) AS valeur
   FROM public.proportion_produits prpr;


ALTER TABLE public.charge_variable_produit OWNER TO postgres;

--
-- Name: charge_total_produit; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.charge_total_produit AS
 SELECT charge_variable_produit.produit,
    charge_variable_produit.valeur AS variable,
    charge_fixe_produit.valeur AS fixe,
    produit.nom
   FROM ((public.charge_variable_produit
     JOIN public.charge_fixe_produit ON ((charge_variable_produit.produit = charge_fixe_produit.produit)))
     JOIN public.produit ON ((produit.id = charge_fixe_produit.produit)));


ALTER TABLE public.charge_total_produit OWNER TO postgres;

--
-- Name: tiers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tiers (
    numero character varying(8) NOT NULL,
    compte integer,
    intitule character varying(150) NOT NULL
);


ALTER TABLE public.tiers OWNER TO postgres;

--
-- Name: client; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.client AS
 SELECT tiers.numero,
    tiers.compte,
    tiers.intitule
   FROM public.tiers
  WHERE ((tiers.compte >= 41000) AND (tiers.compte < 42000));


ALTER TABLE public.client OWNER TO postgres;

--
-- Name: compte_tiers; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.compte_tiers AS
 SELECT comptable.compte,
    comptable.intitule
   FROM public.comptable
  WHERE ((comptable.compte >= 40000) AND (comptable.compte < 42000));


ALTER TABLE public.compte_tiers OWNER TO postgres;

--
-- Name: conversion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.conversion (
    unite integer,
    valeur numeric NOT NULL
);


ALTER TABLE public.conversion OWNER TO postgres;

--
-- Name: devise; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.devise (
    id integer NOT NULL,
    nom character varying(50) NOT NULL,
    valeur numeric DEFAULT 0,
    date date DEFAULT CURRENT_DATE NOT NULL
);


ALTER TABLE public.devise OWNER TO postgres;

--
-- Name: devise_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.devise_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.devise_id_seq OWNER TO postgres;

--
-- Name: devise_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.devise_id_seq OWNED BY public.devise.id;


--
-- Name: ecriture_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ecriture_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ecriture_id_seq OWNER TO postgres;

--
-- Name: ecriture_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ecriture_id_seq OWNED BY public.ecriture.id;


--
-- Name: entreprise; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.entreprise (
    numero character varying(20),
    nom character varying(50),
    adresse character varying(100),
    email character varying(100),
    dirigeant character varying(100)
);


ALTER TABLE public.entreprise OWNER TO postgres;

--
-- Name: exercice; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.exercice (
    id integer NOT NULL,
    debut date NOT NULL,
    fin date NOT NULL
);


ALTER TABLE public.exercice OWNER TO postgres;

--
-- Name: exercice_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.exercice_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.exercice_id_seq OWNER TO postgres;

--
-- Name: exercice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.exercice_id_seq OWNED BY public.exercice.id;


--
-- Name: facture; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.facture (
    id character varying(20) NOT NULL,
    json text
);


ALTER TABLE public.facture OWNER TO postgres;

--
-- Name: facture_registred; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.facture_registred AS
 SELECT facture.id,
    facture.json,
    ecriture.intitule,
    ecriture.debit AS montant,
    ecriture.date,
    ecriture.tiers
   FROM (public.facture
     JOIN public.ecriture ON (((facture.id)::text = (ecriture.piece)::text)))
  WHERE ((ecriture.debit > (0)::numeric) AND (ecriture.compte >= 41000) AND (ecriture.compte <= 42000));


ALTER TABLE public.facture_registred OWNER TO postgres;

--
-- Name: fournisseur; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.fournisseur AS
 SELECT tiers.numero,
    tiers.compte,
    tiers.intitule
   FROM public.tiers
  WHERE ((tiers.compte >= 40000) AND (tiers.compte < 41000));


ALTER TABLE public.fournisseur OWNER TO postgres;

--
-- Name: incfacture; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.incfacture
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.incfacture OWNER TO postgres;

--
-- Name: journal; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.journal (
    code character varying(10) NOT NULL,
    intitule character varying(150) NOT NULL
);


ALTER TABLE public.journal OWNER TO postgres;

--
-- Name: mouvement_balance; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.mouvement_balance AS
 SELECT balance.exercice,
    sum(balance.debit) AS debit,
    sum(balance.credit) AS credit
   FROM public.balance
  GROUP BY balance.exercice;


ALTER TABLE public.mouvement_balance OWNER TO postgres;

--
-- Name: multiplication_centre_produit; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.multiplication_centre_produit AS
 SELECT charge_total_centre.centre,
    charge_total_centre.variable,
    charge_total_centre.fixe,
    charge_total_centre.nom,
    proportion_produits.produit,
    proportion_produits.valeur
   FROM public.charge_total_centre,
    public.proportion_produits;


ALTER TABLE public.multiplication_centre_produit OWNER TO postgres;

--
-- Name: nature; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nature (
    id integer NOT NULL,
    nom character varying(20) NOT NULL
);


ALTER TABLE public.nature OWNER TO postgres;

--
-- Name: nature_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.nature_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nature_id_seq OWNER TO postgres;

--
-- Name: nature_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.nature_id_seq OWNED BY public.nature.id;


--
-- Name: production; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.production (
    produit integer,
    poids numeric
);


ALTER TABLE public.production OWNER TO postgres;

--
-- Name: variable_de_production; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.variable_de_production AS
 SELECT proportion_produits.produit,
    ((( SELECT variable_total.valeur
           FROM public.variable_total) * (proportion_produits.valeur)::double precision) / (100)::double precision) AS valeur
   FROM public.proportion_produits;


ALTER TABLE public.variable_de_production OWNER TO postgres;

--
-- Name: vente; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vente (
    produit integer,
    prix numeric
);


ALTER TABLE public.vente OWNER TO postgres;

--
-- Name: seuil_jointure; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.seuil_jointure AS
 SELECT vente.produit,
    variable_de_production.valeur AS variable,
    ( SELECT fixe_total.valeur
           FROM public.fixe_total) AS fixe,
    vente.prix
   FROM (public.vente
     JOIN public.variable_de_production ON ((vente.produit = variable_de_production.produit)));


ALTER TABLE public.seuil_jointure OWNER TO postgres;

--
-- Name: seuil; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.seuil AS
 SELECT seuil_jointure.produit,
    ((seuil_jointure.variable + seuil_jointure.fixe) / (seuil_jointure.prix)::double precision) AS poids
   FROM public.seuil_jointure;


ALTER TABLE public.seuil OWNER TO postgres;

--
-- Name: produit_afficher; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.produit_afficher AS
 SELECT seuil.produit,
    seuil.poids,
    seuil_jointure.variable,
    seuil_jointure.prix,
    production.poids AS production,
    produit.nom
   FROM (((public.seuil
     JOIN public.seuil_jointure ON ((seuil.produit = seuil_jointure.produit)))
     JOIN public.production ON ((seuil.produit = production.produit)))
     JOIN public.produit ON ((seuil.produit = produit.id)));


ALTER TABLE public.produit_afficher OWNER TO postgres;

--
-- Name: produit_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.produit_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.produit_id_seq OWNER TO postgres;

--
-- Name: produit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.produit_id_seq OWNED BY public.produit.id;


--
-- Name: produit_par_centre; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.produit_par_centre AS
 SELECT ((mucepr.variable * (mucepr.valeur)::double precision) / (100)::double precision) AS variable,
    ((mucepr.fixe * (mucepr.valeur)::double precision) / (100)::double precision) AS fixe,
    mucepr.nom AS nom_centre,
    pr.nom AS nom_produit
   FROM (public.multiplication_centre_produit mucepr
     JOIN public.produit pr ON ((mucepr.produit = pr.id)));


ALTER TABLE public.produit_par_centre OWNER TO postgres;

--
-- Name: produit_vente; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.produit_vente (
    produit integer,
    compte integer
);


ALTER TABLE public.produit_vente OWNER TO postgres;

--
-- Name: racine; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.racine (
    compte integer NOT NULL,
    intitule character varying(150) NOT NULL
);


ALTER TABLE public.racine OWNER TO postgres;

--
-- Name: ratio_variable_production; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.ratio_variable_production AS
 SELECT production.produit,
    (variable_de_production.valeur / (production.poids)::double precision) AS ratio
   FROM (public.production
     JOIN public.variable_de_production ON ((production.produit = variable_de_production.produit)));


ALTER TABLE public.ratio_variable_production OWNER TO postgres;

--
-- Name: societe; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.societe (
    nom character varying(40) NOT NULL,
    objet character varying(255) NOT NULL,
    dirigeant character varying(100) NOT NULL,
    nif character varying(20) NOT NULL,
    rcs character varying(20) NOT NULL,
    stat character varying(20) NOT NULL,
    creation date NOT NULL,
    email character varying(50) NOT NULL,
    adresse character varying(100) NOT NULL,
    siege character varying(100) NOT NULL,
    telephone character varying(20) NOT NULL,
    logo character varying(20) NOT NULL
);


ALTER TABLE public.societe OWNER TO postgres;

--
-- Name: tva; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tva (
    value numeric
);


ALTER TABLE public.tva OWNER TO postgres;

--
-- Name: unite; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.unite (
    id integer NOT NULL,
    nom character varying(100) NOT NULL
);


ALTER TABLE public.unite OWNER TO postgres;

--
-- Name: unite_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.unite_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.unite_id_seq OWNER TO postgres;

--
-- Name: unite_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.unite_id_seq OWNED BY public.unite.id;


--
-- Name: centre id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.centre ALTER COLUMN id SET DEFAULT nextval('public.centre_id_seq'::regclass);


--
-- Name: devise id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.devise ALTER COLUMN id SET DEFAULT nextval('public.devise_id_seq'::regclass);


--
-- Name: ecriture id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ecriture ALTER COLUMN id SET DEFAULT nextval('public.ecriture_id_seq'::regclass);


--
-- Name: exercice id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exercice ALTER COLUMN id SET DEFAULT nextval('public.exercice_id_seq'::regclass);


--
-- Name: nature id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nature ALTER COLUMN id SET DEFAULT nextval('public.nature_id_seq'::regclass);


--
-- Name: produit id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produit ALTER COLUMN id SET DEFAULT nextval('public.produit_id_seq'::regclass);


--
-- Name: unite id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unite ALTER COLUMN id SET DEFAULT nextval('public.unite_id_seq'::regclass);


--
-- Data for Name: centre; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.centre (id, nom) FROM stdin;
1	Administration et disctrict
2	Usine
3	Plantation
\.


--
-- Data for Name: centre_compte; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.centre_compte (compte, nature, centre, valeur) FROM stdin;
60101	1	1	0
60101	1	2	0
60101	1	3	100
60101	2	1	0
60101	2	2	0
60101	2	3	100
60102	1	1	0
60102	1	2	0
60102	1	3	100
60102	2	1	0
60102	2	2	0
60102	2	3	100
60104	1	1	0
60104	1	2	95
60104	1	3	5
60104	2	1	0
60104	2	2	0
60104	2	3	100
60105	1	1	100
60105	1	2	0
60105	1	3	0
60105	2	1	100
60105	2	2	0
60105	2	3	0
60106	1	1	30
60106	1	2	0
60106	1	3	70
60106	2	1	0
60106	2	2	0
60106	2	3	100
60201	1	1	15
60201	1	2	80
60201	1	3	5
60201	2	1	0
60201	2	2	0
60201	2	3	100
61202	1	1	10
61202	1	2	30
61202	1	3	60
61202	2	1	0
61202	2	2	0
61202	2	3	100
61203	1	1	100
61203	1	2	0
61203	1	3	0
61203	2	1	10
61203	2	2	30
61203	2	3	60
61204	1	1	15
61204	1	2	70
61204	1	3	15
61204	2	1	0
61204	2	2	0
61204	2	3	100
61206	1	1	100
61206	1	2	0
61206	1	3	0
61206	2	1	100
61206	2	2	0
61206	2	3	0
61207	1	1	100
61207	1	2	0
61207	1	3	0
61207	2	1	60
61207	2	2	40
61207	2	3	0
61208	1	1	100
61208	1	2	0
61208	1	3	0
61208	2	1	100
61208	2	2	0
61208	2	3	0
61209	1	1	100
61209	1	2	0
61209	1	3	0
61209	2	1	100
61209	2	2	0
61209	2	3	0
61210	1	1	100
61210	1	2	0
61210	1	3	0
61210	2	1	100
61210	2	2	0
61210	2	3	0
61211	1	1	40
61211	1	2	30
61211	1	3	20
61211	2	1	100
61211	2	2	0
61211	2	3	0
61212	1	1	100
61212	1	2	0
61212	1	3	0
61212	2	1	100
61212	2	2	0
61212	2	3	0
62700	1	1	40
62700	1	2	30
62700	1	3	30
62700	2	1	100
62700	2	2	0
62700	2	3	0
60214	1	1	40
60214	1	2	30
60214	1	3	30
60214	2	1	100
60214	2	2	0
60214	2	3	0
64115	1	1	0
64115	1	2	0
64115	1	3	100
64115	2	1	0
64115	2	2	0
64115	2	3	100
63000	1	1	0
63000	1	2	0
63000	1	3	100
63000	2	1	35
63000	2	2	35
63000	2	3	30
64102	1	1	0
64102	1	2	75
64102	1	3	25
64102	2	1	0
64102	2	2	0
64102	2	3	100
64113	1	1	0
64113	1	2	0
64113	1	3	100
64113	2	1	20
64113	2	2	35
64113	2	3	45
64510	1	1	0
64510	1	2	0
64510	1	3	100
64510	2	1	20
64510	2	2	35
64510	2	3	45
64520	1	1	100
64520	1	2	0
64520	1	3	0
64520	2	1	100
64520	2	2	0
64520	2	3	0
64120	1	1	40
64120	1	2	30
64120	1	3	30
64120	2	1	0
64120	2	2	0
64120	2	3	100
68000	1	1	0
68000	1	2	100
68000	1	3	0
68000	2	1	25
68000	2	2	70
68000	2	3	5
66000	1	1	100
66000	1	2	0
66000	1	3	0
66000	2	1	100
66000	2	2	0
66000	2	3	0
69999	1	1	0
69999	1	2	0
69999	1	3	100
69999	2	1	0
69999	2	2	0
69999	2	3	100
69998	1	1	100
69998	1	2	0
69998	1	3	0
69998	2	1	100
69998	2	2	0
69998	2	3	0
69997	1	1	0
69997	1	2	100
69997	1	3	0
69997	2	1	0
69997	2	2	100
69997	2	3	0
69996	1	1	100
69996	1	2	0
69996	1	3	0
69996	2	1	100
69996	2	2	0
69996	2	3	0
\.


--
-- Data for Name: charge_compte; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.charge_compte (compte, nature, valeur) FROM stdin;
60101	1	100
60101	2	0
60102	1	100
60102	2	0
60104	1	100
60104	2	0
60105	1	0
60105	2	100
60106	1	100
60106	2	0
60201	1	100
60201	2	0
61202	1	100
61202	2	0
61203	1	0
61203	2	100
61204	1	100
61204	2	0
61206	1	0
61206	2	100
61207	1	0
61207	2	100
61208	1	100
61208	2	0
61209	1	100
61209	2	0
61210	1	100
61210	2	0
61211	1	100
61211	2	0
61212	1	0
61212	2	100
62700	1	100
62700	2	0
60214	1	100
60214	2	0
64115	1	100
64115	2	0
63000	1	0
63000	2	100
64102	1	100
64102	2	0
64113	1	0
64113	2	100
64510	1	0
64510	2	100
64520	1	0
64520	2	100
64120	1	100
64120	2	0
68000	1	0
68000	2	100
66000	1	100
66000	2	0
69999	1	100
69999	2	0
69998	1	50
69998	2	50
69997	1	100
69997	2	0
69996	1	100
69996	2	0
\.


--
-- Data for Name: charge_produit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.charge_produit (produit, valeur) FROM stdin;
4	25
1	75
\.


--
-- Data for Name: comptable; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comptable (compte, intitule) FROM stdin;
10100	CAPITAL
10610	RESERVE LEGALE
11000	REPORT A NOUVEAU
11010	REPORT A NOUVEAU SOLDE CREDITEUR
11200	AUTRES PRODUITS ET CHARGES
11900	REPORT A NOUVEAU SOLDE DEBITEUR
12800	RESULTAT EN INSTANCE
13300	IMPOTS DIFFERES ACTIFS
16110	EMPRUNT A LT
16510	ENMPRUNT A MOYEN TERME
20124	FRAIS DE REHABILITATION
20800	AUTRES IMMOB INCORPORELLES
21100	TERRAINS
21200	CONSTRUCTION
21300	MATERIEL ET OUTILLAGE
21510	MATERIEL AUTOMOBILE
21520	MATERIEL MOTO
21600	AGENCEMENT. AM .INST
21810	MATERIELS ET MOBILIERS DE BUREAU
21819	MATERIELS INFORMATIQUES ET AUTRES
21820	MAT. MOB DE LOGEMENT
21880	AUTRES IMMOBILISATIONS CORP
23000	IMMOBILISATION EN COURS
28000	AMORT IMMOB INCORP
28120	AMORTISSEMENT DES CONSTRUCTIONS
28130	AMORT MACH-MATER-OUTIL
28150	AMORT MAT DE TRANSPORT
28160	AMORT A.A.I
28181	AMORT MATERIEL&MOB
28182	AMORTISSEMENTS MATERIELS INFORMATIQ
28183	AMORT MATER & MOB LOGT
32110	STOCK MATIERES PREMIERES
35500	STOCK PRODUITS FINIS
37000	STOCK MARCHANDISES
39700	PROVISIONS/DEPRECIATIONS STOCKS
42100	PERSONNEL: SALAIRES A PAYER
42510	PERSONNEL: AVANCES QUINZAINES
42520	PERSONNEL: AVANCES SPECIALES
42860	PERS:CHARGES  A PAYER
43100	CNAPS
43120	OSTIE
44200	ETAT IBS
44210	ACOMPTE IBS
44321	TVA ... IMPUTER:DEC ULTERIEURE
44500	ETAT:IRSA VERSER
44560	ETAT: TVA DEDUCTIBLE
44570	ETAT: TVA COLLECTEE
44571	TVA A VERSER
45100	COMPTE  COURANT ASSOC
46700	DEB/CRED DIVERS
46800	CHARGES A PAYER DEB/CRED DIVERS
48610	CHARGE CONSTATES D'AVANCE
49100	PERTE/CLIENTS
51200	BOA ANKORONDRANO
51201	BOA DOLLARS
51202	BNI MADAGASCAR
51203	BNI DOLLARS
53100	CAISSE
58110	VIREMENTINTERNE:BANQ/CAISSE
58130	VIREMENT INTERNE:BANQ/BANQ
58140	VIREMENT INTERNE CAISSE/CAISSE
70110	VENTE LOCALE
70120	VENTES  A  L EXPORTATION
70800	AUTRES PROD  DES ACT ANNEX&ACS
71300	VARIATION DE STOCK  P.F
75800	AUTRES PRODUITS D EXPLOITATION
75810	ECART/ENCAISSEMENT
76200	INTERET CREDITEUR BANQUES BNI
76300	INTERET CREDITEUR BANQUES BOA
76600	DIFFERENCE DE CHANGE
70100	Vente de mais concassé
70101	Vente de mais grain
40110	FOURNISSEURS D'EXPLOITATIONS LOCAUX
40120	FOURNISSEURS D'EXPLOITATIONS ETRANGERS
40310	FOURNISSEURS D'IMMOBILISATION
40810	FRNS: FACTURE A RECEVOIR
40910	FRNS: AVANCES&ACOMPTES VERSER
40980	FRNS: RABAIS A OBTENIR
41110	CLIENTS LOCAUX
41120	CLIENTS ETRANGERS
41400	CLIENTS DOUTEUX
41800	CLIENTS FACTURE A RETABLIR
60101	Achat de semences
60102	Achat d engrais et assimiles
60103	Achat d emballage
60104	Fournitures de magasin
60105	Fournitures de bureau
60106	Pieces de rechange pour vehicules
60201	Eau et electricite
61202	Gaz, combustibles, carburants et lubrifiants
61203	Location de terrains
61204	Entretiens et reparations
61205	Assurances
61206	Photocopies et assimiles
61207	Telephone
61208	Envoi de colis (lettres et documents)
61209	Honoraires
61210	Frais de transport
61211	Voyages et deplacements
61212	Missions (deplacements, hebergement, restauration)
62700	Commissions bancaires
60214	Autres charges externes
64115	Cueilleurs
63000	Imp“ts et taxes
64102	Salaires de la main-d'ouvre temporaire
64113	Salaires permanents
64510	Cotisations patronales CNAPS
64520	Cotisations patronales pour l'organisme sanitaire
64120	Autres charges du personnel
68000	Amortissements
66000	Charges financieres
69999	Achat de matieres premieres
69998	Achat de pc pour le personnel
69997	Carburant pour le deplacement
69996	Uniformes gardiens
\.


--
-- Data for Name: conversion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.conversion (unite, valeur) FROM stdin;
1	1
2	1000
\.


--
-- Data for Name: devise; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.devise (id, nom, valeur, date) FROM stdin;
1	Ariary	1	2023-12-31
2	Euro	4500	2023-12-31
3	Dollar	4000	2023-12-31
\.


--
-- Data for Name: ecriture; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ecriture (id, compte, journal, intitule, piece, debit, credit, date, tiers, exercice) FROM stdin;
118	70101	VL	Achat de matiere premiere pour John Doe	DPX-07-2023-0000116	0	12000000	2023-07-01	4111000000002	1
119	44570	TVA	Achat de matiere premiere pour John Doe	DPX-07-2023-0000116	0	2400000	2023-07-01		1
120	41110	CLT	Achat de matiere premiere pour John Doe	DPX-07-2023-0000116	14400000	0	2023-07-01	4111000000002	1
121	41110	CLT	Achat de matiere premiere pour John Doe	DPX-07-2023-0000116	0	1000000	2023-07-01	4111000000002	1
122	51200	BO	Achat de matiere premiere pour John Doe	DPX-07-2023-0000116	1000000	0	2023-07-01	4111000000002	1
93	69997	AC	Carburant pour le deplacement	12345	2000000	0	2023-09-01	\N	1
94	51200	BO	Carburant pour le deplacement	12345	0	2000000	2023-09-01	\N	1
95	69996	AC	Uniformes gardiens	12346	1000000	0	2023-09-17	\N	1
96	51200	BO	Uniformes gardiens	12346	0	1000000	2023-09-17	\N	1
97	69999	AC	Achat de hello world	12356	1000000	0	2023-11-11	\N	1
98	51200	BO	Achat de hello world	12356	0	1000000	2023-11-11	\N	1
39	10100	OD	Depot de capital	00001	0	1000000000	2023-06-10	\N	1
40	51200	BO	Depot de capital	00001	1000000000	0	2023-06-10	\N	1
41	60101	AC	Achat de semences	000030	4321600	0	2023-08-31	\N	1
42	60102	AC	Achat d engrais et assimiles	00002	60000000	0	2023-08-31	\N	1
51	61205	OD	Assurances	00011	5927200	0	2023-08-31	\N	1
43	60103	AC	Achat d emballage	00003	7796400	0	2023-08-31	\N	1
44	60104	AC	Fournitures de magasin	00004	4446700	0	2023-08-31	\N	1
45	60105	AC	Fournitures de bureau	00005	2783700	0	2023-08-31	\N	1
46	60106	AC	Pieces de rechange pour vehicules	00006	14373200	0	2023-08-31	\N	1
47	60201	OD	Eau et electricite	00007	34637200	0	2023-08-31	\N	1
48	61202	OD	Gaz, combustibles, carburants et lubrifiants	00008	35675400	0	2023-08-31	\N	1
49	61203	OD	Location de terrains	00009	9742000	0	2023-08-31	\N	1
50	61204	OD	Entretiens et reparations	00010	4987300	0	2023-08-31	\N	1
52	61206	OD	Photocopies et assimiles	00012	450900	0	2023-08-31	\N	1
53	61207	OD	Telephone	00013	8236300	0	2023-08-31	\N	1
54	61208	OD	Envoi de colis (lettres et documents)	00014	789500	0	2023-08-31	\N	1
55	61209	OD	Honoraires	00015	8538100	0	2023-08-31	\N	1
56	61210	OD	Frais de transport	00016	3200000	0	2023-08-31	\N	1
57	61211	OD	Voyages et deplacements	00017	1934000	0	2023-08-31	\N	1
58	61212	OD	Missions (deplacements, hebergement, restauration)	00018	16222500	0	2023-08-31	\N	1
59	62700	OD	Commissions bancaires	00019	31523800	0	2023-08-31	\N	1
60	60214	OD	Autres charges externes	00020	3142800	0	2023-08-31	\N	1
61	64115	OD	Cueilleurs	00021	31784800	0	2023-08-31	\N	1
62	63000	OD	Imp“ts et taxes	00022	5029800	0	2023-08-31	\N	1
63	64102	OD	Salaires de la main-d'ouvre temporaire	00023	89267100	0	2023-08-31	\N	1
64	64113	OD	Salaires permanents	00024	71735100	0	2023-08-31	\N	1
65	64510	OD	Cotisations patronales CNAPS	00025	36320600	0	2023-08-31	\N	1
66	64520	OD	Cotisations patronales pour l'organisme sanitaire	00026	654600	0	2023-08-31	\N	1
67	64120	OD	Autres charges du personnel	00027	15956700	0	2023-08-31	\N	1
68	68000	OD	Amortissements	00028	28639600	0	2023-08-31	\N	1
69	66000	OD	Charges financieres	00029	23007600	0	2023-08-31	\N	1
70	51200	BO	Paiement des charges	000031	0	561124500	2023-09-01	\N	1
73	69999	AC	Achat de matiere premiere	12569	10000000	0	2023-06-11	\N	1
74	51200	BO	Achat de matiere premiere	12569	0	10000000	2023-06-11	\N	1
75	69998	AC	Achat de pc pour le personnel	12570	20000000	0	2023-06-11	\N	1
76	51200	BO	Achat de pc pour le personnel	12570	0	20000000	2023-06-11	\N	1
113	70101	VL	Hello world	DPX-06-2023-0000115	0	600000	2023-06-25	4111000000001	1
114	44570	TVA	Hello world	DPX-06-2023-0000115	0	120000	2023-06-25		1
115	41110	CLT	Hello world	DPX-06-2023-0000115	720000	0	2023-06-25	4111000000001	1
116	41110	CLT	Hello world	DPX-06-2023-0000115	0	100000	2023-06-25	4111000000001	1
117	51200	BO	Hello world	DPX-06-2023-0000115	100000	0	2023-06-25	4111000000001	1
\.


--
-- Data for Name: entreprise; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.entreprise (numero, nom, adresse, email, dirigeant) FROM stdin;
00000001	Hello Company	Analakely	hello@gmail.com	Hello World
00000002	Entreprise John Doe	Antananarivo	John Doe@gmail.com	John Doe
\.


--
-- Data for Name: exercice; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exercice (id, debut, fin) FROM stdin;
1	2023-01-01	2023-12-31
\.


--
-- Data for Name: facture; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.facture (id, json) FROM stdin;
DPX-06-2023-0000115	{"header":{"nom":"Dimpex","adresse":"Lot B56 Andoharanofotsy","telephone":"+261 45 784 69","email":"dimpex@gmail.com"},"facture":"DPX-06-2023-0000115","entreprise":{"numero":"00000001","nom":"Hello Company","adresse":"Analakely","email":"hello@gmail.com","dirigeant":"Hello World"},"objet":"Hello world","ligne":[{"compte":"70101","nom":"Mais grain","unite":"Kg","quantite":"100","prixUnitaire":"6000","prixTotal":600000}],"montant":600000,"tva":120000,"avance":"100000","total":720000,"reste":620000,"date":"2023-06-25","tiers":"41110"}
DPX-07-2023-0000116	{"header":{"nom":"Dimpex","adresse":"Lot B56 Andoharanofotsy","telephone":"+261 45 784 69","email":"dimpex@gmail.com"},"facture":"DPX-07-2023-0000116","entreprise":{"numero":"00000002","nom":"Entreprise John Doe","adresse":"Antananarivo","email":"John Doe@gmail.com","dirigeant":"John Doe"},"objet":"Achat de matiere premiere pour John Doe","ligne":[{"compte":"70101","nom":"Mais grain","unite":"Tonne","quantite":"2","prixUnitaire":"6000","prixTotal":12000000}],"montant":12000000,"tva":2400000,"avance":"1000000","total":14400000,"reste":13400000,"date":"2023-07-01","tiers":"41110"}
\.


--
-- Data for Name: incorporable; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.incorporable (compte) FROM stdin;
60101
60102
60104
60105
60106
60201
61202
61203
61204
61206
61207
61208
61209
61210
61211
61212
62700
60214
64115
63000
64102
64113
64510
64520
64120
68000
66000
69999
69998
69997
69996
\.


--
-- Data for Name: journal; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.journal (code, intitule) FROM stdin;
AC	Achat
AN	A nouveau
BN	Banque BNI
BO	Banque BOA
CA	Caisse
OD	Op‚rations diverses
VE	Vente export
VL	Vente locale
FO	Fournisseur
CLT	Client
TVA	Taxe sur valeur ajoutee
\.


--
-- Data for Name: nature; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nature (id, nom) FROM stdin;
1	Variable
2	Fixe
\.


--
-- Data for Name: production; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.production (produit, poids) FROM stdin;
1	338000
4	25000
\.


--
-- Data for Name: produit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.produit (id, nom) FROM stdin;
1	Mais concasse
4	Mais grain
\.


--
-- Data for Name: produit_vente; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.produit_vente (produit, compte) FROM stdin;
1	70100
4	70101
\.


--
-- Data for Name: racine; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.racine (compte, intitule) FROM stdin;
10	Capital
11	Report … nouveaux
12	R‚sultat
13	Emprunts
20	Immo incorporel
21	Immo corporel
3	Stock
445	TVA
512	Banque
53	Caisse
6	Charge
7	Produit
766	Gain de change
666	Perte de change
77	Produits extra
67	Charge extra
40	fournisseur
41	client
\.


--
-- Data for Name: societe; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.societe (nom, objet, dirigeant, nif, rcs, stat, creation, email, adresse, siege, telephone, logo) FROM stdin;
Dimpex	Production de bl‚, de riz et encore d'autres produits.	Bruno SIMON	NIF_1234	RCS_1234	STAT_1234	2023-01-01	dimpex@gmail.com	Lot B56 Andoharanofotsy	Antananarivo	+261 45 784 69	logo.png
\.


--
-- Data for Name: tiers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tiers (numero, compte, intitule) FROM stdin;
00000001	41110	Hello
00000001	40110	FRNS_Rakoto
00000002	41110	John Doe
\.


--
-- Data for Name: tva; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tva (value) FROM stdin;
20
\.


--
-- Data for Name: unite; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.unite (id, nom) FROM stdin;
1	Kg
2	Tonne
\.


--
-- Data for Name: vente; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vente (produit, prix) FROM stdin;
1	2000
4	6000
\.


--
-- Name: centre_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.centre_id_seq', 3, true);


--
-- Name: devise_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.devise_id_seq', 3, true);


--
-- Name: ecriture_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ecriture_id_seq', 122, true);


--
-- Name: exercice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.exercice_id_seq', 1, true);


--
-- Name: incfacture; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.incfacture', 116, true);


--
-- Name: nature_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nature_id_seq', 2, true);


--
-- Name: produit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.produit_id_seq', 4, true);


--
-- Name: unite_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.unite_id_seq', 2, true);


--
-- Name: centre centre_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.centre
    ADD CONSTRAINT centre_pkey PRIMARY KEY (id);


--
-- Name: comptable comptable_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comptable
    ADD CONSTRAINT comptable_pkey PRIMARY KEY (compte);


--
-- Name: devise devise_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.devise
    ADD CONSTRAINT devise_pkey PRIMARY KEY (id);


--
-- Name: ecriture ecriture_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ecriture
    ADD CONSTRAINT ecriture_pkey PRIMARY KEY (id);


--
-- Name: exercice exercice_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exercice
    ADD CONSTRAINT exercice_pkey PRIMARY KEY (id);


--
-- Name: journal journal_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.journal
    ADD CONSTRAINT journal_pkey PRIMARY KEY (code);


--
-- Name: nature nature_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nature
    ADD CONSTRAINT nature_pkey PRIMARY KEY (id);


--
-- Name: produit produit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produit
    ADD CONSTRAINT produit_pkey PRIMARY KEY (id);


--
-- Name: racine racine_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.racine
    ADD CONSTRAINT racine_pkey PRIMARY KEY (compte);


--
-- Name: unite unite_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unite
    ADD CONSTRAINT unite_pkey PRIMARY KEY (id);


--
-- Name: centre_compte centre_compte_centre_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.centre_compte
    ADD CONSTRAINT centre_compte_centre_fkey FOREIGN KEY (centre) REFERENCES public.centre(id);


--
-- Name: centre_compte centre_compte_compte_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.centre_compte
    ADD CONSTRAINT centre_compte_compte_fkey FOREIGN KEY (compte) REFERENCES public.comptable(compte);


--
-- Name: centre_compte centre_compte_nature_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.centre_compte
    ADD CONSTRAINT centre_compte_nature_fkey FOREIGN KEY (nature) REFERENCES public.nature(id);


--
-- Name: charge_compte charge_compte_compte_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.charge_compte
    ADD CONSTRAINT charge_compte_compte_fkey FOREIGN KEY (compte) REFERENCES public.comptable(compte);


--
-- Name: charge_compte charge_compte_nature_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.charge_compte
    ADD CONSTRAINT charge_compte_nature_fkey FOREIGN KEY (nature) REFERENCES public.nature(id);


--
-- Name: charge_produit charge_produit_produit_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.charge_produit
    ADD CONSTRAINT charge_produit_produit_fkey FOREIGN KEY (produit) REFERENCES public.produit(id);


--
-- Name: conversion conversion_unite_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversion
    ADD CONSTRAINT conversion_unite_fkey FOREIGN KEY (unite) REFERENCES public.unite(id);


--
-- Name: ecriture ecriture_compte_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ecriture
    ADD CONSTRAINT ecriture_compte_fkey FOREIGN KEY (compte) REFERENCES public.comptable(compte);


--
-- Name: ecriture ecriture_exercice_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ecriture
    ADD CONSTRAINT ecriture_exercice_fkey FOREIGN KEY (exercice) REFERENCES public.exercice(id);


--
-- Name: ecriture ecriture_journal_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ecriture
    ADD CONSTRAINT ecriture_journal_fkey FOREIGN KEY (journal) REFERENCES public.journal(code);


--
-- Name: incorporable incorporable_compte_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incorporable
    ADD CONSTRAINT incorporable_compte_fkey FOREIGN KEY (compte) REFERENCES public.comptable(compte);


--
-- Name: production production_produit_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.production
    ADD CONSTRAINT production_produit_fkey FOREIGN KEY (produit) REFERENCES public.produit(id);


--
-- Name: produit_vente produit_vente_compte_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produit_vente
    ADD CONSTRAINT produit_vente_compte_fkey FOREIGN KEY (compte) REFERENCES public.comptable(compte);


--
-- Name: produit_vente produit_vente_produit_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produit_vente
    ADD CONSTRAINT produit_vente_produit_fkey FOREIGN KEY (produit) REFERENCES public.produit(id);


--
-- Name: tiers tiers_compte_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tiers
    ADD CONSTRAINT tiers_compte_fkey FOREIGN KEY (compte) REFERENCES public.comptable(compte);


--
-- Name: vente vente_produit_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vente
    ADD CONSTRAINT vente_produit_fkey FOREIGN KEY (produit) REFERENCES public.produit(id);


--
-- PostgreSQL database dump complete
--

