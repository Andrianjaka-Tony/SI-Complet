<?php
defined('BASEPATH') or exit('No direct script access allowed');

class Insert_model extends CI_Model
{

  public function comptable($compte, $intitule)
  {
    $query = "INSERT INTO comptable (compte, intitule) VALUES ('$compte', '$intitule')";
    $this->db->query($query);
  }

  public function journal($code, $intitule)
  {
    $query = "INSERT INTO journal (code, intitule) VALUES ('$code', '$intitule')";
    $this->db->query($query);
  }

  public function tiers($numero, $compte, $intitule)
  {
    $query = "INSERT INTO tiers (numero, compte, intitule) VALUES ('$numero', '$compte', '$intitule')";
    $this->db->query($query);
  }
}

?>