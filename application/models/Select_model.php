<?php
defined('BASEPATH') or exit('No direct script access allowed');

class Select_model extends CI_Model
{

  public function findAll($tableName)
  {
    $query = "SELECT * FROM $tableName";
    $result = $this->db->query($query);
    return $result->result_array();
  }
}

?>