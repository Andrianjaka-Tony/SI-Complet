-- Utils
CREATE VIEW compte_tiers AS
SELECT
  *
FROM
  comptable 
  WHERE 
    compte >= 40000 AND
    compte < 42000;


-- Livre
SELECT
  comptable.compte,
  comptable.intitule,
  SUM(debit) AS debit,
  SUM(credit) AS credit,
  exercice
FROM
  ecriture 
  JOIN
    comptable ON ecriture.compte = comptable.compte
  WHERE 
    date <= current_date
  GROUP BY
    comptable.compte, 
    comptable.intitule,
    exercice;

-- Balance
CREATE VIEW Balance AS
SELECT
  comptable.compte,
  comptable.intitule,
  SUM(debit) AS debit,
  SUM(credit) AS credit,
  exercice
FROM
  ecriture 
  JOIN
    comptable ON ecriture.compte = comptable.compte
  GROUP BY
    comptable.compte, 
    comptable.intitule,
    exercice;

CREATE VIEW mouvement_balance AS
SELECT
  exercice,
  SUM(debit) AS debit,
  SUM(credit) AS credit
FROM
  Balance
  GROUP BY
    exercice;


-- Analytique
CREATE VIEW variable_par_incorporatble AS
  SELECT
    ChCo.*
  FROM
    incorporable AS I
      JOIN
        charge_compte AS ChCo
          ON I.compte = ChCo.compte
    WHERE ChCo.nature = 1;

CREATE VIEW fixe_par_incorporatble AS
  SELECT
    ChCo.*
  FROM
    incorporable AS I
      JOIN
        charge_compte AS ChCo
          ON I.compte = ChCo.compte
    WHERE ChCo.nature = 2;

CREATE VIEW variable_par_incorporatble_par_centre AS
  SELECT 
    CeCo.nature, CeCo.centre, CeCo.compte, CeCo.valeur * VaPaIn.valeur AS valeur
  FROM
    variable_par_incorporatble AS VaPaIn
      JOIN
        centre_compte AS CeCo
          ON VaPaIn.compte = CeCo.compte
          AND VaPaIn.nature = CeCo.nature;

CREATE VIEW fixe_par_incorporatble_par_centre AS
  SELECT 
    CeCo.nature, CeCo.centre, CeCo.compte, CeCo.valeur * FiPaIn.valeur AS valeur
  FROM
    fixe_par_incorporatble AS FiPaIn
      JOIN
        centre_compte AS CeCo
          ON FiPaIn.compte = CeCo.compte
          AND FiPaIn.nature = CeCo.nature;

CREATE VIEW argent_variable_par_incorporable_par_centre AS
  SELECT
    VaPaInPaCe.compte, VaPaInPaCe.valeur * Ec.debit / 10000 AS valeur, VaPaInPaCe.centre
  FROM
    variable_par_incorporatble_par_centre AS VaPaInPaCe
      JOIN
        ecriture AS Ec
          ON VaPaInPaCe.compte = Ec.compte;

CREATE VIEW argent_fixe_par_incorporable_par_centre AS
  SELECT
    VaPaFiPaCe.compte, VaPaFiPaCe.valeur * Ec.debit / 10000 AS valeur, VaPaFiPaCe.centre
  FROM
    fixe_par_incorporatble_par_centre AS VaPaFiPaCe
      JOIN
        ecriture AS Ec
          ON VaPaFiPaCe.compte = Ec.compte;

CREATE VIEW charge_par_incorporable_par_centre AS
  SELECT 
    argent_variable_par_incorporable_par_centre.valeur AS variable,
    argent_fixe_par_incorporable_par_centre.valeur AS fixe,
    argent_fixe_par_incorporable_par_centre.centre,
    argent_fixe_par_incorporable_par_centre.compte,
    comptable.intitule
  FROM 
    argent_variable_par_incorporable_par_centre
    JOIN
      argent_fixe_par_incorporable_par_centre
        ON argent_variable_par_incorporable_par_centre.centre = argent_fixe_par_incorporable_par_centre.centre AND
        argent_variable_par_incorporable_par_centre.compte = argent_fixe_par_incorporable_par_centre.compte
    JOIN 
      comptable 
        ON argent_variable_par_incorporable_par_centre.compte = comptable.compte;

CREATE VIEW argent_variable_par_incorporable_par_centre_non_null AS
  SELECT 
    *
  FROM 
    argent_variable_par_incorporable_par_centre 
    WHERE valeur != 0;

CREATE VIEW argent_fixe_par_incorporable_par_centre_non_null AS
  SELECT 
    *
  FROM 
    argent_fixe_par_incorporable_par_centre 
    WHERE valeur != 0;

CREATE VIEW argent_variable_par_centre AS
  SELECT 
    SUM(valeur) as valeur, centre
  FROM
    argent_variable_par_incorporable_par_centre_non_null
    GROUP BY centre;

CREATE VIEW argent_fixe_par_centre AS
  SELECT 
    SUM(valeur) as valeur, centre
  FROM
    argent_FIXE_par_incorporable_par_centre_non_null
    GROUP BY centre;

CREATE VIEW variable_total AS
  SELECT
    sum(valeur) AS valeur
  FROM
    argent_variable_par_centre;

CREATE VIEW fixe_total AS
  SELECT
    sum(valeur) AS valeur
  FROM
    argent_fixe_par_centre;

CREATE VIEW proportion_produits AS
  SELECT
    Pr.id AS produit, ChPr.valeur
  FROM
    produit as Pr
      JOIN
      charge_produit AS ChPr
        ON Pr.id = ChPr.produit;

CREATE VIEW charge_variable_produit AS
  SELECT
    PrPr.produit, PrPr.valeur * (SELECT valeur FROM variable_total LIMIT 1) / 100 AS valeur
  FROM
    proportion_produits as PrPr;

CREATE VIEW charge_fixe_produit AS
  SELECT
    PrPr.produit, PrPr.valeur * (SELECT valeur FROM fixe_total LIMIT 1) / 100 AS valeur
  FROM
    proportion_produits as PrPr;

CREATE VIEW charge_total_produit AS
  SELECT
    charge_variable_produit.produit, charge_variable_produit.valeur AS variable, charge_fixe_produit.valeur as fixe, produit.nom
  FROM
    charge_variable_produit
    JOIN
      charge_fixe_produit ON
      charge_variable_produit.produit = charge_fixe_produit.produit
    JOIN
      produit ON
      produit.id = charge_fixe_produit.produit;

CREATE VIEW charge_total_centre as
  SELECT
    argent_variable_par_centre.centre, argent_variable_par_centre.valeur AS variable, argent_fixe_par_centre.valeur as fixe, centre.nom
  FROM
    argent_variable_par_centre
    JOIN
      argent_fixe_par_centre ON
      argent_variable_par_centre.centre = argent_fixe_par_centre.centre
    JOIN
      centre ON
      centre.id = argent_fixe_par_centre.centre;

CREATE VIEW multiplication_centre_produit AS
  SELECT
    *
  FROM
    charge_total_centre, proportion_produits;

CREATE VIEW produit_par_centre as
  SELECT
    MuCePr.variable * MuCePr.valeur / 100 as variable, MuCePr.fixe * MuCePr.valeur / 100 as fixe, MuCePr.nom as nom_centre, Pr.nom as nom_produit
  FROM
    multiplication_centre_produit AS MuCePr
    JOIN 
      produit AS Pr
      ON 
        MuCePr.produit = Pr.id;

CREATE VIEW variable_de_production AS
  SELECT
    proportion_produits.produit, ((SELECT valeur FROM variable_total) * proportion_produits.valeur) / 100 AS valeur
  FROM
    proportion_produits;

CREATE VIEW ratio_variable_production AS
  SELECT 
    production.produit, variable_de_production.valeur / production.poids AS ratio
  FROM 
    production
      JOIN
      variable_de_production ON production.produit = variable_de_production.produit;

CREATE VIEW seuil_jointure AS
  SELECT
    vente.produit,
    variable_de_production.valeur AS variable,
    (SELECT valeur FROM fixe_total) AS fixe,
    vente.prix
  FROM 
    vente 
      JOIN
      variable_de_production ON vente.produit = variable_de_production.produit;

CREATE VIEW seuil AS
  SELECT
    produit,
    (variable + fixe) / prix AS poids
  FROM 
    seuil_jointure;

CREATE VIEW produit_afficher as
  SELECT 
    seuil.produit,
    seuil.poids,
    seuil_jointure.variable,
    seuil_jointure.prix,
    production.poids AS production,
    produit.nom
  FROM 
    seuil
    JOIN
      seuil_jointure ON seuil.produit = seuil_jointure.produit
    JOIN
      production ON seuil.produit = production.produit
    JOIN 
      produit ON seuil.produit = produit.id;

CREATE VIEW fournisseur as
  SELECT
   *
  FROM tiers
    WHERE
      compte >= 40000 AND compte < 41000;

CREATE VIEW client as
  SELECT
   *
  FROM tiers
    WHERE
      compte >= 41000 AND compte < 42000;

CREATE VIEW facture_registred AS
  SELECT
    facture.*,
    ecriture.intitule,
    ecriture.debit AS montant,
    ecriture.date,
    ecriture.tiers
  FROM
    facture
    JOIN
      ecriture ON facture.id = ecriture.piece
    WHERE
      ecriture.debit > 0 AND ecriture.compte >= 41000 AND ecriture.compte <= 42000;