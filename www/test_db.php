<?php
require_once './class/db.php';

$db = new Database();
echo $db->get_Db_Name();