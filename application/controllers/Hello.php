<?php
defined('BASEPATH') or exit('No direct script access allowed');
header("Access-Control-Allow-Origin: *");

class Hello extends CI_Controller
{

  public function societe()
  {
    $tableau = $this->Select_model->findAll("societe");
    echo json_encode($tableau[0]);
  }

  public function devise()
  {
    $tableau = $this->Select_model->findAll("devise");
    echo json_encode($tableau);
  }

  public function unite()
  {
    $tableau = $this->Select_model->findAll("unite");
    echo json_encode($tableau);
  }

  public function racine()
  {
    $tableau = $this->Select_model->findAll("racine");
    echo json_encode($tableau);
  }

  public function comptable()
  {
    $tableau = $this->Select_model->findAll("comptable");
    echo json_encode($tableau);
  }

  public function tiers()
  {
    $tableau = $this->Select_model->findAll("tiers");
    echo json_encode($tableau);
  }

  public function compte_tiers()
  {
    $tableau = $this->Select_model->findAll("compte_tiers");
    echo json_encode($tableau);
  }

  public function journal()
  {
    $tableau = $this->Select_model->findAll("journal");
    echo json_encode($tableau);
  }

  public function ecriture()
  {
    $tableau = $this->Select_model->findAll("ecriture");
    echo json_encode($tableau);
  }

  public function balance()
  {
    $id = $this->input->get('id');
    $tableau = $this->Select_model->findAll("balance WHERE exercice = $id");
    echo json_encode($tableau);
  }

  public function livre()
  {
    $col = $this->input->get("col");
    $value = $this->input->get("value");
    $tableau = $this->Select_model->findAll("ecriture where $col = '$value'");
    echo json_encode($tableau);
  }

  public function create_comptable()
  {
    $compte = $this->input->post('compte');
    $intitule = $this->input->post('intitule');

    if ($compte == "" || $intitule == "") {
      echo 1;
      return;
    }
    $count = count($this->Select_model->findAll("comptable WHERE compte = '$compte'"));
    if ($count != 0) {
      echo 2;
      return;
    }

    $this->Insert_model->comptable($compte, $intitule);
    echo 0;
  }

  public function create_journal()
  {
    $code = $this->input->post('code');
    $intitule = $this->input->post('intitule');

    if ($code == "" || $intitule == "") {
      echo 1;
      return;
    }
    $count = count($this->Select_model->findAll("journal WHERE code = '$code'"));
    if ($count != 0) {
      echo 2;
      return;
    }

    $this->Insert_model->journal($code, $intitule);
    echo 0;
  }

  public function create_tiers()
  {
    $numero = $this->input->post('numero');
    $compte = $this->input->post('compte');
    $intitule = $this->input->post('intitule');

    if ($numero == "" || $intitule == "" || $compte == "") {
      echo 1;
      return;
    }
    $count = count($this->Select_model->findAll("tiers WHERE compte = '$compte' AND numero = '$numero'"));
    if ($count != 0) {
      echo 2;
      return;
    }
    if (strlen($numero) != 8) {
      echo 3;
      return;
    }

    $this->Insert_model->tiers($numero, $compte, $intitule);
    echo 0;

    if ($compte >= 41000 && $compte < 42000) {
      $query = "
        INSERT INTO entreprise 
        (numero, nom, adresse, email, dirigeant)
        VALUES
        ('$numero', 'Entreprise $intitule', 'Antananarivo', '$intitule@gmail.com', '$intitule')
      ";
      $this->db->query($query);
    }
  }

  public function bilan()
  {
    $date = $this->input->get("date");
    $query = "
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
          date <= '$date'
        GROUP BY
          comptable.compte, 
          comptable.intitule,
          exercice;
    ";
    $result = $this->db->query($query);
    $tableau = $result->result_array();
    echo json_encode($tableau);
  }

  public function centre()
  {
    $tableau = $this->Select_model->findAll("charge_total_centre");
    echo json_encode($tableau);
  }

  public function produit()
  {
    $tableau = $this->Select_model->findAll("produit_afficher");
    echo json_encode($tableau);
  }

  public function centre_incorporable()
  {
    $centre = $this->input->get("centre");
    $tableau = $this->Select_model->findAll("charge_par_incorporable_par_centre where centre = $centre and variable != 0 or centre = $centre and fixe != 0");
    echo json_encode($tableau);
  }

  public function charge()
  {
    $compte = $this->input->post("compte");
    $intitule = $this->input->post("intitule");
    $debit = $this->input->post("debit");
    $variable = $this->input->post("variable");
    $fixe = $this->input->post("fixe");
    $piece = $this->input->post("piece");
    $date = $this->input->post("date");

    $variable_1 = $this->input->post("variable_1");
    $variable_2 = $this->input->post("variable_2");
    $variable_3 = $this->input->post("variable_3");
    $fixe_1 = $this->input->post("fixe_1");
    $fixe_2 = $this->input->post("fixe_2");
    $fixe_3 = $this->input->post("fixe_3");

    if ($compte == "" || $intitule == "" || $debit == "" || $variable == "" || $fixe == "" || $piece == "" || $date == "" || $variable_1 == "" || $variable_2 == "" || $variable_3 == "" || $fixe_1 == "" || $fixe_2 == "" || $fixe_3 == "") {
      echo 1;
      return;
    }
    if ($variable + $fixe != 100) {
      echo 2;
      return;
    }
    if ($debit < 0) {
      echo 3;
      return;
    }
    if ($variable_1 + $variable_2 + $variable_3 != 100 || $fixe_1 + $fixe_2 + $fixe_3 != 100) {
      echo 4;
      return;
    }

    $exercice = $this->Select_model->findAll("exercice WHERE debut <= '$date' AND fin >= '$date'");
    if (count($exercice) == 0) {
      echo 5;
      return;
    }

    $comptable = "
      INSERT INTO comptable 
      (compte, intitule) 
      VALUES 
      ('$compte', '$intitule')
    ";
    $incorporable = "
      INSERT INTO incorporable
      (compte) 
      VALUES
      ('$compte')
    ";
    $charge_compte = "
      INSERT INTO charge_compte
      (compte, nature, valeur)
      VALUES
      ('$compte', 1, $variable),
      ('$compte', 2, $fixe)
    ";
    $ecriture = "
      INSERT INTO ecriture 
      (compte, journal, intitule, piece, debit, credit, date, exercice)
      VALUES
      ('$compte', 'AC', '$intitule', '$piece', '$debit', 0, '$date', 1),
      ('51200', 'BO', '$intitule', '$piece', '0', '$debit', '$date', 1)
    ";
    $centre_compte = "
      INSERT INTO centre_compte 
      (compte, nature, valeur, centre)
      VALUES
      ('$compte', 1, $variable_1, 1),
      ('$compte', 1, $variable_2, 2),
      ('$compte', 1, $variable_3, 3),
      ('$compte', 2, $fixe_1, 1),
      ('$compte', 2, $fixe_2, 2),
      ('$compte', 2, $fixe_3, 3)
    ";

    $query = "SELECT * from comptable where compte = '$compte'";
    $result = $this->db->query($query);
    $tableau = $result->result_array();
    if (count($tableau) == 0) {
      $this->db->query($comptable);
      $this->db->query($incorporable);
      $this->db->query($charge_compte);
      $this->db->query($ecriture);
      $this->db->query($centre_compte);
    } else {
      $this->db->query($ecriture);
    }

    echo 0;
  }

  public function create_produit()
  {
    $nom = $this->input->post("nom");
    $charge = $this->input->post("charge");
    $production = $this->input->post("production");
    $prix = $this->input->post("prix");

    $ids = $this->input->post("ids");
    $idArray = explode("_", $ids);
    $charges = [];
    for ($i = 0; $i < count($idArray); $i++) {
      $charges[] = $this->input->post("charge_$i");
    }

    $produit = "
      INSERT INTO produit 
      (nom)
      VALUES
      ('$nom')
    ";
    $this->db->query($produit);
    $charge_produit = "
      INSERT INTO charge_produit
      (produit, valeur)
      VALUES
      ((SELECT id FROM produit WHERE id = (SELECT MAX(id) FROM produit)), $charge)
    ";
    $this->db->query($charge_produit);
    $production = "
      INSERT INTO production 
      (produit, poids) 
      VALUES 
      ((SELECT id FROM produit WHERE id = (SELECT MAX(id) FROM produit)), $production)
    ";
    $this->db->query($production);
    $vente = "
      INSERT INTO vente 
      (produit, prix)
      VALUES 
      ((SELECT id FROM produit WHERE id = (SELECT MAX(id) FROM produit)), $prix)
    ";
    $this->db->query($vente);
    for ($i = 0; $i < count($charges); $i++) {
      $update = "
        UPDATE charge_produit SET valeur = $charges[$i] WHERE produit = $idArray[$i]
      ";
      $this->db->query($update);
    }
  }

  public function fournisseur()
  {
    $tableau = $this->Select_model->findAll("fournisseur");
    echo json_encode($tableau);
  }

  public function client()
  {
    $tableau = $this->Select_model->findAll("client");
    echo json_encode($tableau);
  }

  public function achat()
  {
    $compte = $this->input->post('compte');
    $intitule = $this->input->post('intitule');
    $piece = $this->input->post('piece');
    $valeur = $this->input->post('valeur');
    $fournisseur = $this->input->post('fournisseur');
    $date = $this->input->post('date');

    $tableau = explode("_", $fournisseur);
    $compteTiers = $tableau[0];
    $tiers = $tableau[1];
    $tiers = $compteTiers . $tiers;
    $query = "
      INSERT INTO ecriture 
      (compte, journal, intitule, piece, debit, credit, date, tiers, exercice)
      VALUES
      ('$compte', 'AC', '$intitule', '$piece', '$valeur', '0', '$date', '$compteTiers$tiers', '1'),
      ('$compteTiers', 'FO', '$intitule', '$piece', '0', $valeur + (SELECT ($valeur * value) / 100 FROM tva), '$date', NULL, '1'),
      ('44560', 'TVA', '$intitule', '$piece', (SELECT ($valeur * value) / 100 FROM tva), '0', '$date', NULL, '1')
    ";
    $this->db->query($query);
  }

  public function vente()
  {
    $compte = $this->input->post('compte');
    $intitule = $this->input->post('intitule');
    $piece = $this->input->post('piece');
    $valeur = $this->input->post('valeur');
    $client = $this->input->post('client');
    $date = $this->input->post('date');

    $tableau = explode("_", $client);
    $compteTiers = $tableau[0];
    $tiers = $tableau[1];
    $tiers = $compteTiers . $tiers;
    $query = "
      INSERT INTO ecriture 
      (compte, journal, intitule, piece, credit, debit, date, tiers, exercice)
      VALUES
      ('$compte', 'VL', '$intitule', '$piece', '$valeur', '0', '$date', '$compteTiers$tiers', '1'),
      ('$compteTiers', 'CLT', '$intitule', '$piece', '0', $valeur + (SELECT ($valeur * value) / 100 FROM tva), '$date', NULL, '1'),
      ('44570', 'TVA', '$intitule', '$piece', (SELECT ($valeur * value) / 100 FROM tva), '0', '$date', NULL, '1')
    ";
    $this->db->query($query);
  }

  public function autre()
  {
    $compte = $this->input->post('compte');
    $intitule = $this->input->post('intitule');
    $piece = $this->input->post('piece');
    $date = $this->input->post('date');
    $debit = $this->input->post('debit');
    $credit = $this->input->post('credit');
    $query = "
      INSERT INTO ecriture 
      (compte, journal, intitule, piece, debit, credit, date, exercice)
      VALUES
      ('$compte', 'OD', '$intitule', '$piece', '$debit', '$credit', '$date', '1'),
      ('51200', 'BO', '$intitule', '$piece', '$credit', '$debit', '$date', '1')
    ";
    $this->db->query($query);
  }

  public function create_facture()
  {
    $n_products = $this->input->post("n_products");
    $client = $this->input->post("client");
    $compte = explode("_", $client)[0];
    $tiers = explode("_", $client)[1];
    $date = $this->input->post("date");
    $avance = $this->input->post("avance");
    $objet = $this->input->post("objet");
    $produits = [];
    for ($i = 1; $i <= $n_products; $i++) {
      $produits[] = array(
        "produit" => $this->input->post("id__produit__$i"),
        "quantite" => $this->input->post("quantite__$i"),
        "unite" => $this->input->post("unite__$i")
      );
    }

    $response = [];

    // Configuration du header de la facture
    $query = "SELECT nom, adresse, telephone, email FROM societe";
    $societe = $this->db->query($query)->result_array()[0];
    $response["header"] = $societe;

    // numero de facture
    $query = "SELECT nextval('incFacture')";
    $idFacture = $this->db->query($query)->result_array()[0]["nextval"];
    $piece = "DPX-$date[5]$date[6]-$date[0]$date[1]$date[2]$date[3]-";
    $numeroFacture = "$idFacture";
    for ($i = strlen($numeroFacture); $i < 7; $i++) {
      $numeroFacture = "0$numeroFacture";
    }
    $piece = "$piece$numeroFacture";
    $response["facture"] = $piece;

    // Entreprise du client
    $query = "SELECT * FROM entreprise WHERE numero = '$tiers'";
    $entreprise = $this->db->query($query)->result_array()[0];
    $response["entreprise"] = $entreprise;

    // Objet de la vente
    $response["objet"] = $objet;

    // ajout des tableaux
    $ligne = [];
    for ($i = 0; $i < count($produits); $i++) {
      $produit = $produits[$i]['produit'];
      $produitUnite = $produits[$i]['unite'];
      $compteProduit = $this->db->query("SELECT compte FROM produit_vente WHERE produit = '$produit'")->result_array()[0]["compte"];
      $nomProduit = $this->db->query("SELECT nom FROM produit WHERE id = '$produit'")->result_array()[0]["nom"];
      $uniteProduit = $this->db->query("SELECT nom FROM unite WHERE id = '$produitUnite'")->result_array()[0]["nom"];
      $conversion = $this->db->query("SELECT valeur FROM conversion WHERE unite = '$produitUnite'")->result_array()[0]["valeur"];
      $poidsKilos = $conversion * $produits[$i]['quantite'];
      $prixUnitaire = $this->db->query("SELECT prix FROM vente WHERE produit = '$produit'")->result_array()[0]["prix"];
      $prixTotal = $poidsKilos * $prixUnitaire;

      $ligneProduit = array(
        "compte" => $compteProduit,
        "nom" => $nomProduit,
        "unite" => $uniteProduit,
        "quantite" => $produits[$i]['quantite'],
        "prixUnitaire" => $prixUnitaire,
        "prixTotal" => $prixTotal
      );

      $ligne[] = $ligneProduit;
    }
    $response["ligne"] = $ligne;

    // Calcul du montant
    $montant = 0;
    for ($i = 0; $i < count($ligne); $i++) {
      $montant += $ligne[$i]["prixTotal"];
    }
    $response["montant"] = $montant;

    // Calcule de la TVA
    $query = "SELECT value from tva";
    $TVA = $this->db->query($query)->result_array()[0]["value"];
    $prixTaxe = $TVA * $montant / 100;
    $response["tva"] = $prixTaxe;

    // Avance
    $response["avance"] = $avance;

    // total a payer
    $response["total"] = $montant + $prixTaxe;

    // reste a payer
    $response["reste"] = $montant + $prixTaxe - $avance;

    // Date de facturation
    $response["date"] = $date;

    // Compte des tiers
    $response["tiers"] = $compte;

    echo json_encode($response);
  }

  public function confirm_facture()
  {
    $facture = $this->input->post("facture");
    $object = json_decode($facture);

    $lignes = $object->ligne;
    $numero = $object->entreprise->numero;
    $tiers = "$object->tiers" . "$numero";
    for ($i = 0; $i < count($lignes); $i++) {
      $compte = $lignes[$i]->compte;
      $prixTotal = $lignes[$i]->prixTotal;
      $query = "
        INSERT INTO ecriture 
        (compte, journal, intitule, piece, debit, credit, date, tiers)
        VALUES
        ('$compte', 'VL', '$object->objet', '$object->facture', '0', '$prixTotal', '$object->date', '$tiers')
      ";
      $this->db->query($query);
    }

    $query = "
      INSERT INTO ecriture 
      (compte, journal, intitule, piece, debit, credit, date, tiers)
      VALUES
      ('44570', 'TVA', '$object->objet', '$object->facture', '0', '$object->tva', '$object->date', '')
    ";
    $this->db->query($query);

    $query = "
      INSERT INTO ecriture 
      (compte, journal, intitule, piece, debit, credit, date, tiers)
      VALUES
      ('$object->tiers', 'CLT', '$object->objet', '$object->facture', '$object->total', '0', '$object->date', '$tiers')
    ";
    $this->db->query($query);

    if ($object->avance != 0) {
      $query = "
        INSERT INTO ecriture 
        (compte, journal, intitule, piece, debit, credit, date, tiers)
        VALUES
        ('$object->tiers', 'CLT', '$object->objet', '$object->facture', '0', '$object->avance', '$object->date', '$tiers'),
        ('51200', 'BO', '$object->objet', '$object->facture', '$object->avance', '0', '$object->date', '$tiers')
      ";
      $this->db->query($query);
    }

    $json = json_encode($object);
    $query = "
      INSERT INTO facture VALUES ('$object->facture', '$json');
    ";
    $this->db->query($query);

    $query = "update ecriture set exercice = 1";
    $this->db->query($query);
  }

  public function facture()
  {
    $tableau = $this->Select_model->findAll("facture_registred");
    echo json_encode($tableau);
  }

  public function recherche_textuel()
  {
    $texte = $this->input->get("texte");
    $tableau = $this->Select_model->findAll("facture_registred where json like '%$texte%'");
    echo json_encode($tableau);
  }

  public function recherche_date()
  {
    $begin = $this->input->get("begin");
    $end = $this->input->get("end");
    $tableau = $this->Select_model->findAll("facture_registred where date >= '$begin' and date <= '$end'");
    echo json_encode($tableau);
  }

  public function recherche_montant()
  {
    $begin = $this->input->get("montant_begin");
    $end = $this->input->get("montant_end");
    $tableau = $this->Select_model->findAll("facture_registred where montant >= '$begin' and montant <= '$end'");
    echo json_encode($tableau);
  }
}

?>