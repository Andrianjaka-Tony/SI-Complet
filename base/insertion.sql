INSERT INTO societe 
(nom, objet, dirigeant, NIF, RCS, STAT, creation, email, adresse, siege, telephone, logo)
VALUES
('Dimpex', 'Production de blé, de riz et encore d''autres produits.', 'Bruno SIMON', 'NIF_1234', 'RCS_1234', 'STAT_1234', '2023-01-01', 'dimpex@gmail.com', 'Lot B56 Andoharanofotsy', 'Antananarivo', '+261 45 784 69', 'logo.png');


INSERT INTO devise
(nom, valeur, date)
VALUES
('Ariary', '1', '2023-08-31'),
('Euro', '4500', '2023-08-31'),
('Dollar', '4000', '2023-08-31');


INSERT INTO journal
(code, intitule)
VALUES
('AC', 'Achat'),
('AN', 'A nouveau'),
('BN', 'Banque BNI'),
('BO', 'Banque BOA'),
('CA', 'Caisse'),
('OD', 'Opérations diverses'),
('VE', 'Vente export'),
('VL', 'Vente locale'),
('FO', 'Fournisseur'),
('CLT', 'Client');


INSERT INTO exercice 
(debut, fin)
VALUES
('2023-01-01', '2023-12-31');


INSERT INTO ecriture
(compte, journal, intitule, piece, debit, credit, date, exercice)
VALUES
(10100, 'OD', 'Depot de capital', '00001', 0, 1000000000, current_date, 1),
(51200, 'BO', 'Depot de capital', '00001', 1000000000, 0, current_date, 1);


INSERT INTO tva (value) VALUES (20);


INSERT INTO produit
(nom)
VALUES
('Mais');


INSERT INTO charge_produit
(produit, valeur)
VALUES
(1, 100);


INSERT INTO nature 
(nom)
VALUES
('Variable'),
('Fixe');


INSERT INTO centre
(nom)
VALUES
('Administration et disctrict'),
('Usine'),
('Plantation');


INSERT INTO comptable
(compte, intitule) 
VALUES
('60101', 'Achat de semences'),
('60102', 'Achat d engrais et assimiles'),
('60103', 'Achat d emballage'),
('60104', 'Fournitures de magasin'),
('60105', 'Fournitures de bureau'),
('60106', 'Pieces de rechange pour vehicules'),
('60201', 'Eau et electricite'),
('61202', 'Gaz, combustibles, carburants et lubrifiants'),
('61203', 'Location de terrains'),
('61204', 'Entretiens et reparations'),
('61205', 'Assurances'),
('61206', 'Photocopies et assimiles'),
('61207', 'Telephone'),
('61208', 'Envoi de colis (lettres et documents)'),
('61209', 'Honoraires'),
('61210', 'Frais de transport'),
('61211', 'Voyages et deplacements'),
('61212', 'Missions (deplacements, hebergement, restauration)'),
('62700', 'Commissions bancaires'),
('60214', 'Autres charges externes'),
('64115', 'Cueilleurs'),
('63000', 'Impôts et taxes'),
('64102', 'Salaires de la main-d''œuvre temporaire'),
('64113', 'Salaires permanents'),
('64510', 'Cotisations patronales CNAPS'),
('64520', 'Cotisations patronales pour l''organisme sanitaire'),
('64120', 'Autres charges du personnel'),
('68000', 'Amortissements'),
('66000', 'Charges financieres');


INSERT INTO ecriture 
(compte, intitule, piece, date, credit, debit, journal, exercice)
VALUES
('60101', 'Achat de semences', '000030', '2023-08-31', 0, 4321600, 'AC', 1),
('60102', 'Achat d engrais et assimiles', '00002', '2023-08-31', 0, 60000000, 'AC', 1),
('60103', 'Achat d emballage', '00003', '2023-08-31', 0, 7796400, 'AC', 1),
('60104', 'Fournitures de magasin', '00004', '2023-08-31', 0, 4446700, 'AC', 1),
('60105', 'Fournitures de bureau', '00005', '2023-08-31', 0, 2783700, 'AC', 1),
('60106', 'Pieces de rechange pour vehicules', '00006', '2023-08-31', 0, 14373200, 'AC', 1),
('60201', 'Eau et electricite', '00007', '2023-08-31', 0, 34637200, 'OD', 1),
('61202', 'Gaz, combustibles, carburants et lubrifiants', '00008', '2023-08-31', 0, 35675400, 'OD', 1),
('61203', 'Location de terrains', '00009', '2023-08-31', 0, 9742000, 'OD', 1),
('61204', 'Entretiens et reparations', '00010', '2023-08-31', 0, 4987300, 'OD', 1),
('61205', 'Assurances', '00011', '2023-08-31', 0, 5927200, 'OD', 1),
('61206', 'Photocopies et assimiles', '00012', '2023-08-31', 0, 450900, 'OD', 1),
('61207', 'Telephone', '00013', '2023-08-31', 0, 8236300, 'OD', 1),
('61208', 'Envoi de colis (lettres et documents)', '00014', '2023-08-31', 0, 789500, 'OD', 1),
('61209', 'Honoraires', '00015', '2023-08-31', 0, 8538100, 'OD', 1),
('61210', 'Frais de transport', '00016', '2023-08-31', 0, 3200000, 'OD', 1),
('61211', 'Voyages et deplacements', '00017', '2023-08-31', 0, 1934000, 'OD', 1),
('61212', 'Missions (deplacements, hebergement, restauration)', '00018', '2023-08-31', 0, 16222500, 'OD', 1),
('62700', 'Commissions bancaires', '00019', '2023-08-31', 0, 31523800, 'OD', 1),
('60214', 'Autres charges externes', '00020', '2023-08-31', 0, 3142800, 'OD', 1),
('64115', 'Cueilleurs', '00021', '2023-08-31', 0, 31784800, 'OD', 1),
('63000', 'Impôts et taxes', '00022', '2023-08-31', 0, 5029800, 'OD', 1),
('64102', 'Salaires de la main-d''œuvre temporaire', '00023', '2023-08-31', 0, 89267100, 'OD', 1),
('64113', 'Salaires permanents', '00024', '2023-08-31', 0, 71735100, 'OD', 1),
('64510', 'Cotisations patronales CNAPS', '00025', '2023-08-31', 0, 36320600, 'OD', 1),
('64520', 'Cotisations patronales pour l''organisme sanitaire', '00026', '2023-08-31', 0, 654600, 'OD', 1),
('64120', 'Autres charges du personnel', '00027', '2023-08-31', 0, 15956700, 'OD', 1),
('68000', 'Amortissements', '00028', '2023-08-31', 0, 28639600, 'OD', 1),
('66000', 'Charges financieres', '00029', '2023-08-31', 0, 23007600, 'OD', 1);


INSERT INTO ecriture
(compte, journal, intitule, piece, debit, credit, date, exercice)
VALUES
(51200, 'BO', 'Paiement des charges', '000031', 0, 561124500, '2023-09-01', 1);


INSERT INTO charge_compte
(compte, nature, valeur)
VALUES
(60101, 1, 100),
(60101, 2, 0),
(60102, 1, 100),
(60102, 2, 0), 
(60104, 1, 100),
(60104, 2, 0), 
(60105, 1, 0),
(60105, 2, 100), 
(60106, 1, 100),
(60106, 2, 0), 
(60201, 1, 100),
(60201, 2, 0), 
(61202, 1, 100),
(61202, 2, 0), 
(61203, 1, 0),
(61203, 2, 100), 
(61204, 1, 100),
(61204, 2, 0), 
(61206, 1, 0),
(61206, 2, 100), 
(61207, 1, 0),
(61207, 2, 100), 
(61208, 1, 100),
(61208, 2, 0), 
(61209, 1, 100),
(61209, 2, 0), 
(61210, 1, 100),
(61210, 2, 0), 
(61211, 1, 100),
(61211, 2, 0), 
(61212, 1, 0),
(61212, 2, 100), 
(62700, 1, 100),
(62700, 2, 0), 
(60214, 1, 100),
(60214, 2, 0), 
(64115, 1, 100),
(64115, 2, 0), 
(63000, 1, 0),
(63000, 2, 100), 
(64102, 1, 100),
(64102, 2, 0), 
(64113, 1, 0),
(64113, 2, 100), 
(64510, 1, 0),
(64510, 2, 100), 
(64520, 1, 0),
(64520, 2, 100), 
(64120, 1, 100),
(64120, 2, 0), 
(68000, 1, 0),
(68000, 2, 100), 
(66000, 1, 100),
(66000, 2, 0);


INSERT INTO centre_compte 
(compte, nature, valeur, centre)
VALUES
(60101, 1, 0, 1),
(60101, 1, 0, 2),
(60101, 1, 100, 3),
(60101, 2, 0, 1),
(60101, 2, 0, 2),
(60101, 2, 100, 3),

(60102, 1, 0, 1),
(60102, 1, 0, 2),
(60102, 1, 100, 3),
(60102, 2, 0, 1), 
(60102, 2, 0, 2), 
(60102, 2, 100, 3), 

(60104, 1, 0, 1),
(60104, 1, 95, 2),
(60104, 1, 5, 3),
(60104, 2, 0, 1), 
(60104, 2, 0, 2), 
(60104, 2, 100, 3), 

(60105, 1, 100, 1),
(60105, 1, 0, 2),
(60105, 1, 0, 3),
(60105, 2, 100, 1), 
(60105, 2, 0, 2), 
(60105, 2, 0, 3), 

(60106, 1, 30, 1),
(60106, 1, 0, 2),
(60106, 1, 70, 3),
(60106, 2, 0, 1),
(60106, 2, 0, 2),
(60106, 2, 100, 3),

(60201, 1, 15, 1),
(60201, 1, 80, 2),
(60201, 1, 5, 3),
(60201, 2, 0, 1), 
(60201, 2, 0, 2), 
(60201, 2, 100, 3), 

(61202, 1, 10, 1),
(61202, 1, 30, 2),
(61202, 1, 60, 3),
(61202, 2, 0, 1), 
(61202, 2, 0, 2), 
(61202, 2, 100, 3), 

(61203, 1, 100, 1),
(61203, 1, 0, 2),
(61203, 1, 0, 3),
(61203, 2, 10, 1), 
(61203, 2, 30, 2), 
(61203, 2, 60, 3), 

(61204, 1, 15, 1),
(61204, 1, 70, 2),
(61204, 1, 15, 3),
(61204, 2, 0, 1), 
(61204, 2, 0, 2), 
(61204, 2, 100, 3), 

(61206, 1, 100, 1),
(61206, 1, 0, 2),
(61206, 1, 0, 3),
(61206, 2, 100, 1), 
(61206, 2, 0, 2), 
(61206, 2, 0, 3), 

(61207, 1, 100, 1),
(61207, 1, 0, 2),
(61207, 1, 0, 3),
(61207, 2, 60, 1), 
(61207, 2, 40, 2), 
(61207, 2, 0, 3), 

(61208, 1, 100, 1),
(61208, 1, 0, 2),
(61208, 1, 0, 3),
(61208, 2, 100, 1), 
(61208, 2, 0, 2), 
(61208, 2, 0, 3), 

(61209, 1, 100, 1),
(61209, 1, 0, 2),
(61209, 1, 0, 3),
(61209, 2, 100, 1), 
(61209, 2, 0, 2), 
(61209, 2, 0, 3), 

(61210, 1, 100, 1),
(61210, 1, 0, 2),
(61210, 1, 0, 3),
(61210, 2, 100, 1), 
(61210, 2, 0, 2), 
(61210, 2, 0, 3), 

(61211, 1, 40, 1),
(61211, 1, 30, 2),
(61211, 1, 20, 3),
(61211, 2, 100, 1), 
(61211, 2, 0, 2), 
(61211, 2, 0, 3), 

(61212, 1, 100, 1),
(61212, 1, 0, 2),
(61212, 1, 0, 3),
(61212, 2, 100, 1), 
(61212, 2, 0, 2), 
(61212, 2, 0, 3), 

(62700, 1, 40, 1),
(62700, 1, 30, 2),
(62700, 1, 30, 3),
(62700, 2, 100, 1), 
(62700, 2, 0, 2), 
(62700, 2, 0, 3), 

(60214, 1, 40, 1),
(60214, 1, 30, 2),
(60214, 1, 30, 3),
(60214, 2, 100, 1), 
(60214, 2, 0, 2), 
(60214, 2, 0, 3), 

(64115, 1, 0, 1),
(64115, 1, 0, 2),
(64115, 1, 100, 3),
(64115, 2, 0, 1), 
(64115, 2, 0, 2), 
(64115, 2, 100, 3), 

(63000, 1, 0, 1),
(63000, 1, 0, 2),
(63000, 1, 100, 3),
(63000, 2, 35, 1),
(63000, 2, 35, 2),
(63000, 2, 30, 3),

(64102, 1, 0, 1),
(64102, 1, 75, 2),
(64102, 1, 25, 3),
(64102, 2, 0, 1), 
(64102, 2, 0, 2), 
(64102, 2, 100, 3), 

(64113, 1, 0, 1),
(64113, 1, 0, 2),
(64113, 1, 100, 3),
(64113, 2, 20, 1), 
(64113, 2, 35, 2), 
(64113, 2, 45, 3), 

(64510, 1, 0, 1),
(64510, 1, 0, 2),
(64510, 1, 100, 3),
(64510, 2, 20, 1), 
(64510, 2, 35, 2), 
(64510, 2, 45, 3), 

(64520, 1, 100, 1),
(64520, 1, 0, 2),
(64520, 1, 0, 3),
(64520, 2, 100, 1), 
(64520, 2, 0, 2), 
(64520, 2, 0, 3), 

(64120, 1, 40, 1),
(64120, 1, 30, 2),
(64120, 1, 30, 3),
(64120, 2, 0, 1), 
(64120, 2, 0, 2), 
(64120, 2, 100, 3), 

(68000, 1, 0, 1),
(68000, 1, 100, 2),
(68000, 1, 0, 3),
(68000, 2, 25, 1), 
(68000, 2, 70, 2), 
(68000, 2, 5, 3), 

(66000, 1, 100, 1),
(66000, 1, 0, 2),
(66000, 1, 0, 3),
(66000, 2, 100, 1),
(66000, 2, 0, 2),
(66000, 2, 0, 3);


INSERT INTO incorporable
(compte) 
VALUES
('60101'),
('60102'),
('60104'),
('60105'),
('60106'),
('60201'),
('61202'),
('61203'),
('61204'),
('61206'),
('61207'),
('61208'),
('61209'),
('61210'),
('61211'),
('61212'),
('62700'),
('60214'),
('64115'),
('63000'),
('64102'),
('64113'),
('64510'),
('64520'),
('64120'),
('68000'),
('66000');


INSERT INTO production (produit, poids) VALUES (1, 338000);
INSERT INTO vente VALUES (1, 2000);


INSERT INTO unite (nom) VALUES ('Kg'), ('Tonne');
INSERT INTO conversion (unite, valeur) VALUES ('1', '1'), ('2', '1000');  

INSERT INTO produit_vente (produit, compte) VALUES ('1', '70100'), ('4', '70101');
