<?php
/* VARIABLE DECLARATIONS */
$email_regex = "/^\w+([\.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})+$/";
$str_regex = "/^[a-zA-Z'\s]+$/";
$username_regex = "/^[\w\W\d\D\s]{19}$/";
$email_regex_strict = "/^(?=[A-Z0-9@._%+-]{6,254}$)[A-Z0-9._%+-]{1,64}@(?:[A-Z0-9-]{1,63}\.){1,8}[A-Z]{2,63}$/";
$phone_regex = "/^(\d){3}\D?(\d){3}\D?(\d){4}$/";
$number_regex = "/^([0-9]+)$/";
$name_regex = "/^[a-zA-Z'\s]+$/";
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Wild card search returns all values in the database that meets the regex
$wildcard_search_query = "SELECT ProjectID, ProjectName, E.EmployeeNumber, LastName, FirstName, Department, E.Position, OfficePhone, MaxHours, StartDate, EndDate, HoursWorked, 
Supervisor, EmailAddress 
  FROM EMPLOYEE AS E 
  JOIN (SELECT EmployeeNumber, A.ProjectID, ProjectName, MaxHours, StartDate, EndDate, HoursWorked 
        FROM ASSIGNMENT AS A 
  JOIN PROJECT AS P 
        ON A.ProjectID = P.ProjectID) AS AP ON AP.EmployeeNumber = E.EmployeeNumber
  WHERE E.EmployeeNumber LIKE '%%' or LastName LIKE '%%' or FirstName LIKE '%%' or Department LIKE '%%' or ProjectID LIKE '%%' or ProjectName LIKE '%%' or MaxHours LIKE '%%' or StartDate LIKE '%%' or EndDate LIKE '%%' or HoursWorked LIKE '%%' or EmailAddress LIKE '%%' ORDER BY EmployeeNumber
                       ;";
////////////////////////////////////////////////////////////////////////////////////////////////////////
if (!function_exists('test_input'))
{
  /**
 * Test the input
 * trim(), stripslashes(),htmlspecialchars()
 * @param  $data The data to be sanitized
 * @return $data  The sanitized data
 */
  function test_input($data){
  $data = trim($data);
  $data = stripslashes($data);
  return htmlspecialchars($data,ENT_QUOTES,"utf-8");
  }
} // End of test_input
////////////////////////////////////////////////////////////////////////////////////////////////////////
if (!function_exists('get_column_name'))
{
  /**
 * This function searches for the schema in which the specified column exists
 * @param $conn The database connection variable
 * @param $col_name The column name to search for
 * @return $result  The results set returned from sql query containing the schema information
 */
  function get_column_name($conn, $col_name="")
  {

    $query = "SELECT table_name, column_name from information_schema.columns WHERE column_name LIKE '%$col_name%';";
    if(($result = $conn->query($query)) > 0)
    {
      return $result;
    }
    else
    {
      die("Unable to locate column in database, please try again!");
    }
  }
  
} // End of get_colomn_name
////////////////////////////////////////////////////////////////////////////////////////////////////////
if (!function_exists('valid_email'))
{
  /**
 * Validates the email address
 * @param $wp_email_regex
 * @param $str  The email address
 */
  function valid_email($str="", $email_regex="") 
  {
    return preg_match($email_regex="", $str="");
  }
} // End Of valid_email
////////////////////////////////////////////////////////////////////////////////////////////////////////
if (!function_exists('valid_column'))
{
  /**
 * Validates the column input value
 * @param col_val The department value to be tested 
 * @param Query    The query column returned
 * @return Integer 0 = false | 1 = true
 */
  function valid_column($conn,$col_val="", $Query="")
  {
    $n = 0;
    $result = $conn->query($Query);
      foreach($result as $val)
      {
        if($col_val != $val)
        {
          $n++;
        }      
      }
      return ($n > 0) ? 1 : 0;
  }
} // End Of valid_column
////////////////////////////////////////////////////////////////////////////////////////////////////////
if (!function_exists('get_emp_num_row'))
{
  /**
 * Experimental function to get all values for one employee, given the EmployeeNumber
 * @param $emp_num  The employee number
 */
  function get_emp_num_row($conn,$emp_num = ""){
    $get_employee_query = "SELECT EmployeeNumber, LastName, FirstName, P.Department, OfficePhone, P.ProjectID, ProjectName, MaxHours, StartDate, EndDate, HoursWorked FROM PROJECT AS P JOIN (SELECT E.EmployeeNumber, A.HoursWorked, A.ProjectID, FirstName, LastName, Department, Position, OfficePhone, EmailAddress FROM ASSIGNMENT AS A JOIN EMPLOYEE AS E ON 	 A.EmployeeNumber = E.EmployeeNumber) AS AE ON P.ProjectID = AE.ProjectID WHERE EmployeeNumber = $emp_num ORDER BY EmployeeNumber;";

    // Check connection
    if(!$conn){
      die("ERROR: Could not connect. " . mysqli_connect_error());
    }
    else if(mysqli_num_rows($result = mysqli_query($conn, $get_employee_query)) > 0)
        { 
          while($row = mysqli_fetch_array($result)){
          echo "<p>". $row['EmployeeNumber'] . "</p><br>";
          echo $row['FirstName'] . "<br>";
          echo $row['LastName'] . "<br>";
          echo $row['Department']. "<br>";
          echo $row['OfficePhone'] . "<br>";
          echo $row['ProjectID'] . "<br>";
          echo $row['ProjectName'] . "<br>";
          echo $row['MaxHours'] . "<br>";
          echo $row['StartDate'] . "<br>";
          echo $row['EndDate'] . "<br>";
          echo $row['HoursWorked'] . "<br>";
      
      }
    }
  }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////
if (!function_exists('get_col_dropdown'))
{
  /**
 * Gets one column of values from any table, displays dropdown
 * @param $conn       The connection property
 * @param $column_1   The column/field name selected from the 
 * @param $table      The table name
 * @param $column_2   
 * @return $dropdown  The column dropdown
 */
  function get_col_dropdown($conn, $column_1="", $table="", $column_2="", $param="")
  { 
    if(empty($column_2))   
    {
      $dropdown = ""; 
        if ($conn->connect_errno) 
        {
          printf("Connect failed: %s\n", $conn->connect_error);
          exit();
        }
        else if($result = $conn->query("SELECT $column_1 FROM $table ORDER BY  $column_1 ASC;")) 
        {
            // printf("Select returned %d rows.\n\n", $result->num_rows);      
            $dropdown = '<select class="form-content"  name="'.$column_1.'" >';
            // Fetch one and one row
                while($row=mysqli_fetch_row($result))
                {
                  $dropdown .= '<option class="dropdown" name="'.$column_1.'" value="'.$row[0].'">'.$row[0]."</option>";
                }
              $dropdown .= "</select>";
        }
        else
        {
            echo "*****ERROR*****The search returned an empty array...!";
        }  
    }
    else if(!empty($column_2))
    {
      $dropdown = ""; 
      if ($conn->connect_errno) 
      {
        printf("Connect failed: %s\n", $conn->connect_error);
        exit();
      }
      else if($result = $conn->query("SELECT $column_1 FROM $table WHERE $column_2 LIKE $param ORDER BY  $column_1 ASC;")) 
      {
              
          $dropdown = '<select class="form-content"  name="'.$column_1.'" >';
          // Fetch one and one row
              while($row=mysqli_fetch_row($result))
              {
                $dropdown .= '<option class="dropdown" name="'.$column_1.'" value="'.$row[0].'">'.$row[0]."</option>";
              }
            $dropdown .= "</select>";
      }
      else
      {
          echo "*****ERROR*****The search returned an empty array...!";
      }  
    }
    return $dropdown;
  }
} // End Of get_col_dropdown
////////////////////////////////////////////////////////////////////////////////////////////////////////
if(!function_exists('get_dropdown_where'))
{
  function get_dropdown_where($conn, $col_1="", $table="", $col)
  {
    $col_1 = $col_1 == "" ? "" : $col_1;
    $col = $col == "" ? "" : $col;
    $conn = $conn == "" ? "" : $conn;
    $table = $table == "" ? "" : $table;
    $dropdown = ""; 
    if ($conn->connect_errno) 
    {
      printf("Connect failed: %s\n", $conn->connect_error);
      exit();
    }
    else if($result = $conn->query("SELECT $col FROM $table ORDER BY  $col ASC;")) 
    {
        // printf("Select returned %d rows.\n\n", $result->num_rows);      
        $dropdown = '<select class="form-content"  name="'.$col.'" >';
        // Fetch one and one row
            while($row=mysqli_fetch_row($result))
            {
              $dropdown .= '<option class="dropdown" name="'.$col.'" value="'.$row[0].'">'.$row[0]."</option>";
            }
          $dropdown .= "</select>";
    }
    else
    {
        echo "*****ERROR*****The search returned an empty array...!";
    }  
    return $dropdown;
  }

}
////////////////////////////////////////////////////////////////////////////////////////////////////////
if (!function_exists('select_Timezone'))
{
  /**
 * Returns a dropdown list of timezones
 * @param $selected   The selected time zone
 * @return $select    The time zone dropdown
 */
  function select_Timezone($selected = '') 
  { 
    
      // Create a list of timezone 
      $OptionsArray = timezone_identifiers_list(); 
          $select= '<select name="SelectContacts"> 
                      <option disabled selected> 
                          Please Select Timezone 
                      </option>'; 
            
          while (list ($key, $row) = each ($OptionsArray) ){ 
              $select .='<option value="'.$key.'"'; 
              $select .= ($key == $selected ? : ''); 
              $select .= '>'.$row.'</option>'; 
          }   
      return $select; 
  }
} // End Of select_Timezone
////////////////////////////////////////////////////////////////////////////////////////////////////////
if (!function_exists('search_db'))
{
  /**
   * This search_db function searches the database for rows that match the search parameter.
   * You may optionally include the table and connection variable
   * @param $search_param   The search keyword
   * @param $conn           The database connection variable
   * @param $table          The table to search
   * @return $result        The results of the search
   */
  function search_db($search_param="", $conn, $table="")
  {
////////////////////////////////////////////////////////////////////////////////////////////////////////
    $param_search_query = "SELECT E.EmployeeNumber, LastName, FirstName, Department, E.Position, Supervisor,        OfficePhone, EmailAddress, AP.ProjectID, ProjectName, MaxHours, StartDate, EndDate, HoursWorked
    FROM EMPLOYEE AS E JOIN 
      (SELECT EmployeeNumber, A.ProjectID, ProjectName, MaxHours, StartDate, EndDate, HoursWorked
          FROM ASSIGNMENT AS A JOIN PROJECT AS P ON A.ProjectID = P.ProjectID) AS AP ON AP.EmployeeNumber = E.EmployeeNumber
    WHERE CAST(E.EmployeeNumber AS CHAR)  LIKE '%$search_param%' 
      OR CAST(FirstName AS CHAR)  LIKE '%$search_param%' 
      OR CAST(LastName AS CHAR)  LIKE '%$search_param%' 
      OR CAST(E.Department AS CHAR)  LIKE '%$search_param%' 
      OR CAST(E.Position AS CHAR)  LIKE '%$search_param%' 
      OR CAST(Supervisor AS CHAR)  LIKE '%$search_param%' 
      OR CAST(OfficePhone AS CHAR)  LIKE '%$search_param%' 
      OR CAST(EmailAddress AS CHAR)  LIKE '%$search_param%'
      OR CAST(AP.ProjectID AS CHAR)  LIKE '%$search_param%'
      OR CAST(ProjectName AS CHAR)  LIKE '%$search_param%'
      OR CAST(E.Department AS CHAR)  LIKE '%$search_param%'
      OR CAST(MaxHours AS CHAR)  LIKE '%$search_param%'
      OR CAST(StartDate AS CHAR)  LIKE '%$search_param%' 
      OR CAST(EndDate AS CHAR)  LIKE '%$search_param%'
      OR CAST(HoursWorked AS CHAR)  LIKE '%$search_param%' ORDER BY EmployeeNumber;";
    $sql_search_table = "SELECT * FROM $table WHERE EmployeeNumber LIKE '%$search_param%';";
    
    /*****************************************************************/
    
    if($table == "")
    {
      if (($result=mysqli_query($conn, $param_search_query))>0) 
      {               
         return $result;      
      }
    }
    else
    { // Get all the values in a table if the selected column contains the wildcard value
      if ($result=mysqli_query($conn, $sql_search_table))
      {
        return $result;       
      }else{
        die("Sorry zero results returned please try again!!!");
      }
    } // End of else    
  }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////
if(!function_exists('get_table_data'))
{
  /**
   * The get_table_data function takes a query and connection variable
   * and returns the results of the query as specified by the query
   * in the form of a table.
   * @param $conn  The connection variable
   * @param $query The MySQL query string
   * @return $table The table of the query results
   */
  function get_table_data($conn, $query="")
  {
    /* check for connection erro*/
    if ($conn->connect_errno) 
            {
                printf("Connect failed: %s\n", $conn->connect_error);
                exit();
            } // check if results set not empty or for error
            else if((@$result = $conn->query($query)) == false)
            {
                die("No records matching your query were found.");
            }     
            $col_count = $conn->field_count;
            $row_count = $result->num_rows;
            /* Get field information for all columns */
            $finfo = $result->fetch_fields();
            $table = "<table>"."<tr>";
            foreach($finfo as &$val) // build table header using field names
              {
               $table.= "<th class='table-header' >".$val->name."</th>";
            
              }
              $table .= "</tr>";
              while ($row = $result->fetch_assoc()) // build table data fields row by row
              {
                $table.= "<tr>";
                foreach ($row as $field)
                {
                  $table.= "<td class='table-field' >".$field. "</td>";
                } 
                $table.= "</tr>";
              }
            return $table .= "</table>";  // return completed table
  }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////
if(!function_exists("get_field_value"))
{
  /**
   * The get_field_value function gets the specified field value(S) given the correct parameters
   * @param $conn The connection variable
   * @param $query The MySQL Select statement
   * @return mixed Returns a single field is queried, or returns a result set if more than one field is selected
   */
  function get_field_value($conn, $query)
  {
    $result = $conn->query($query);
   
    if($result === false)
    {
      die("No results returned from database...".$conn->connect_error);
    }
    else if(($conn->field_count) > 0)
    {
        $row = $result->fetch_array();
        return $row[0];
    }
    else if(($conn->num_rows) > 1)	
    {
      return $result;
    }      
  }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////
if(!function_exists("get_result_table"))
{
  /**
   * The get_result_table() function accepts a result set from the
   * mysqli_query() function and returns a table of the result set
   * @param $result The results set from a mysql query
   * @return $table A table of the result set
   */
  function get_result_table($result){
     /* Get field information for all columns */
     $finfo = $result->fetch_fields();
     $table = "<table class='result-table'>"."<tr>";
     foreach($finfo as &$val) // build table header using field names
       {
        $table.= "<th class='table-header' >".$val->name."</th>";
     
       }
       $table .= "</tr>";
       while ($row = $result->fetch_assoc()) // build table data fields row by row
       {
         $table.= "<tr>";
         foreach ($row as $field)
         {
           $table.= "<td class='table-field' >".$field. "</td>";
         } 
         $table.= "</tr>";
       }
     return $table .= "</table>";  // return completed table
  }
}
///////////////////////////////////////////////////////////////////////////////////////////////////
/*********************************************************************************************** */
if(!function_exists("resetFunction"))
{
  /**
   * This function refreshes or resets the current webpage
   */
  function resetFunction()
  {
    header("refresh:0");
  }	
}
///////////////////////////////////////////////////////////////////////////////////////////////////
/*********************************************************************************************** */
if(!function_exists(("fix_names")))
{
  /**
   * Capitalizes the first letter and all other letters are lowercase
   * @param string The string to apply function to
   */
  function fix_names(&$string="")
  {
  return ucfirst(strtolower($string));  
  }
}
///////////////////////////////////////////////////////////////////////////////////////////////////
/*********************************************************************************************** */
if(!function_exists("popup_button"))
{
  
  /**
   * The popup button function
   * @var labal The button label
   * @var data_src The source object to be rendered; this can be a file, function or object
   * @var caption  The caption to display when the object renders
   * @return mixed|false The button object or false if data_src empty
   */
  function popup_button($label = "", $data_src = "", $caption = "")
  {  
$popup_button ='
<!-- CSS file for fancybox lightbox -->
<link rel="stylesheet" type="text/css" href="/css/jquery.fancybox.min.css">
<!-- links the javascript myFunction file -->
<script src="/scripts/myFunction.js"></script>
<!-- style for form elements -->
<style>
@media screen and (max-width: 719px){
.popup-button{
display: inline-block;
text-align: center;
width: 100%;
}
.btn{
display: inline-block;
text-align: center;
background-color: #99ccff;
margin: 0 auto;
font-size: 1.5em;
padding: 5px;
border: 5px solid #73AD21;
border-radius: 15px;
text-decoration: none;
opacity: .75;
width: 20%;
}
.fancybox-slide, .fancybox-slide--current, .fancybox-slice--iframe{
display: block;
margin-right: 5%;
margin-left: 5%;
border-radius: 5px 5px 5px 5px !important;
overflow: visible;
background-color:#40e0d0;
border: 5px solid #40e0d0;
height: 0 auto;
width: 90%;
}
.fancybox-slide{
height: 0 auto;
}
}
@media screen and (min-width: 720px){
.popup-button{
display: inline-block;
text-align: center;
width: 100%;
}
.btn{
display: block;
text-align: center;
background-color: #99ccff;
margin: 0 auto;
font-size: 1.5em;
padding: 5px;
border: 5px solid #73AD21;
border-radius: 15px;
text-decoration: none;
opacity: .75;
width: 10%;
}
.fancybox-slide, .fancybox-slide--current, .fancybox-slice--iframe{
display: block;
width: 0 auto;
max-width: 60%;
margin-left:  20%;
margin-right: 20%;
border-radius:30px 30px 30px 30px !important;
overflow: visible;
background-color:#40e0d0;
border: 1px solid #40e0d0;
}
}
</style>
<!--
<div class="#">
<h4></h4>
<p></p>
<a href="#" data-fancybox data-caption="#"><img class="#" src="#" title="#" alt="#"></a>
</div><br>
-->
<div class="container">
<div class="popup-button">
<a class="btn btn-primary"  data-src="'.$data_src.'" data-fancybox data-type="iframe"  href="javascript:;" data-caption="'.$caption.'">'.$label.'</a>
</div>
</div>
<script src="/scripts/jquery-3.3.1.min.js"></script>
<script src="/scripts/jquery.fancybox.min.js"></script>';
    if(empty($data_src))
    {
      exit("Data source paramater is empty! ".__FILE__.__FUNCTION__.__LINE__);
    }
    else
    {
      return $popup_button;
    }
  }
}

if(!function_exists("passwd_desc_param"))
{
  function passwd_desc_param()
  {
$passwd_desc_param = <<<_END
<pre class="pass-desc">
      The password string must contain:
      [a-z]       at least 1 lowercase alphabet
      [A-Z]       at least 1 uppercase alphabet
      [0-9]       at least 1 number
      [!@#$%^&]   at least one special charactet
      8 or more   eight characters or longer
</pre>
_END;
return $passwd_desc_param;
  }
}
?>