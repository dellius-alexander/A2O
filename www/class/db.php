<?php
///////////////////////////////////////////////////////////////////////////////
require_once './inc/inc_functions.php';
// Specify two specific Monolog dependencies that you’re going to use:
// use Monolog\Logger;
// use Monolog\Handler\StreamHandler;
///////////////////////////////////////////////////////////////////////////////
/** ***************************************************************************
* Class Name:   Database
* Extends:		class PDO
* File Name:    class.database.php
* Created:      12/31/2019
* Database:     YouAreWorthy
* Author:       Dellius Alexander
* Desc:         Represents a connection between PHP and a MySQL database
******************************************************************************/
///////////////////////////////////////////////////////////////////////////////
/** ***************************************************************************
 * Represents the connection between php and mysql database
 */
class Database extends PDO{

	///////////////////////////////////////////////////////////////////////////
	/** ***********************************************************************
	 * Email object array of user email addresses
	 * @access private
	 * @var logger
	 */
	private $logger;

	///////////////////////////////////////////////////////////////////////////
	/** ***********************************************************************
	 * Database connection variable
	 * @access private
	 * @var conn
	 */
	private $conn;
	///////////////////////////////////////////////////////////////////////////
	/** ***********************************************************************
	 * Server name
	 * @access private
	 * @var host
	 */
	private $host;
	///////////////////////////////////////////////////////////////////////////
	/** ***********************************************************************
	 * Username
	 * @access private
	 * @var username
	 */
	private $username;
	///////////////////////////////////////////////////////////////////////////
	/** ***********************************************************************
	 * Password
	 * @access private
	 * @var Password
	 */
	private $password;
	///////////////////////////////////////////////////////////////////////////
	/** ***********************************************************************
	 * Database name
	 * @access private
	 * @var db_name The database name
	 */
    private $db_name;
	///////////////////////////////////////////////////////////////////////////
	/** ***********************************************************************
	 * Database character set
	 * @access private
	 * @var charset
	 */
	private $charset;
	///////////////////////////////////////////////////////////////////////////
	/** ***********************************************************************
	  * The PDO_MYSQL Data Source Name (DSN)
	 * @access private
	 * @var dsn
	 */
	private $dsn;
	///////////////////////////////////////////////////////////////////////////
	/** ***********************************************************************
	  * The PDO variable
	 * @access private
	 * @var pdo
	 */
	private $pdo;
	///////////////////////////////////////////////////////////////////////////
	/** ***********************************************************************
	  * Port number 32555
	 * @access private
	 * @var port
	 */
	private $port;
	///////////////////////////////////////////////////////////////////////////
	/** ***********************************************************************
	 * Database socket
	 * @access private
	 * @var socket The sql server socket
	 */
	private $db_socket;
	///////////////////////////////////////////////////////////////////////////
	/** ***********************************************************************
	  * Options
	 * @access private
	 * @var options PDO default configuration options:
	 * 		PDO::ATTR_EMULATE_PREPARES   => false, # turn off emulation mode for "real" prepared statements
	 *		PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION, # turn on errors in the form of exceptions
	 *		PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC, # make the default fetch be an associative array
	 */
	private $options;

	///////////////////////////////////////  Constructor  /////////////////////
	///////////////////////////////////////////////////////////////////////////
	/** ***********************************************************************
	 * Open a new connection to the MySQL server
	 * @var host  	[optional] Can be either a host name or an IP address. Passing the NULL value or 
	 * 				the string "localhost" to this parameter, the local host is assumed. When possible, 
	 * 				pipes will be used instead of the TCP/IP protocol. Prepending host by p: opens 
	 * 				a persistent connection. mysqli_change_user() is automatically called on connections 
	 * 				opened from the connection pool. Defaults to ini_get("mysqli.default_host")
	 * @var username 	[optional] The MySQL user name. Defaults to ini_get("mysqli.default_user")
	 * @var passwd 	[optional] If not provided or NULL, the MySQL server will attempt to authenticate 
	 * 				the user against those user records which have no password only. This allows one 
	 * 				username to be used with different permissions (depending on if a password as provided 
	 * 				or not). Defaults to ini_get("mysqli.default_pw")
	 * @var db_name 	[optional] If provided will specify the default database to be used when 
	 * 					performing queries. Defaults to ""
	 * @var port 	[optional] Specifies the port number to attempt to connect to the MySQL server. 
	 * 				Defaults to ini_get("mysqli.default_port")
	 * @var socket 	[optional] Specifies the socket or named pipe that should be used. Defaults to 
	 * 				ini_get("mysqli.default_socket")
	 * @return void
	 */
	public function __construct( string $host=null, string $username=null, string $passwd=null, string $db_name=null, int $port=null){
		##############################  Cleanse parameter variables  ##########
		$this->host 		= $host  	== null ? 	"192.168.122.63"	: $host;
		$this->username		= $username == null ? 	"root"			: $username;
		$this->password		= $passwd	== null ? 	"developer"		: $passwd;
		$this->db_name 		= $db_name 	== null ? 	"alphatoo_a2o_backend"	: $db_name;
		$this->port 		= $port		== null ? 	"30007"			: $port;
		$this->charset 		= "utf8";
		$this->db_socket	= "/var/run/mysqld/mysqld.sock";
		$this->ssl_ca       = "/var/lib/mysql/ca.pem";
		$this->ssl_cert     = "/var/lib/mysql/server-cert.pem";
		$this->ssl_key      = "/var/lib/mysql/server-key.pem";
		$this->ssl_ca       = "/var/lib/mysql/ca.pem";
		$this->ssl_cert     = "/var/lib/mysql/client-cert.pem";
		$this->ssl_key      = "/var/lib/mysql/server-key.pem";
		
		// $this->logger = $this->logger();
		############# Do not delete below, for testing purposes ###############
		################  Instantiate MySQLi connection  ######################
		# Change options in the php.ini file in /usr/local/etc/php: display_errors = Off and log_errors = On		
		
		################  Default parameter variables  ########################
		/*
		#
		$this->host 	= $host  	== null ? 	"172.16.238.9" 						: $host;
		$this->username		= $username == null ? 	"user"							: $username;
		$this->password		= $Passwd 	== null ? 	"developer"						: $Passwd;
		$this->db_name 		= $db_name 	== null ? 	"YouAreWorthy"					: $db_name;
		$this->charset 		= 						"utf8mb4_general_ci";
		$this->port 		= $port		== null ? 	"3306"							: $port;
		$this->db_socket	= $socket	== null ? 	"/var/run/mysqld/mysqld.sock"	: $socket;
		*/
		###################  Options Parameters  ##############################
		$this->options 		= [
			PDO::ATTR_EMULATE_PREPARES   => false, # turn off emulation mode for "real" prepared statements
			PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION, # turn on errors in the form of exceptions
			PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC, # make the default fetch be an associative array
			];
		#############  try{}catch{}PDOException ###############################
		date_default_timezone_set("America/New_York");
		try {
			$this->dsn = "mysql:host=".$this->host.";dbname=".$this->db_name.";charset=".$this->charset."";
			$this->pdo = @parent::__construct($this->dsn, $this->username, $this->password, $this->options);
			// $this->logger->info("PDO object initialized: ", [print_r($this->pdo)]);
		} catch (Exception $e) { // Error logging to log file
			// $this->logger->error("<br/><p>".$this->execution_log("Connection attempt failed | ", $e->getMessage()).
			// "<br/>".print_r($this->errorInfo())."</p><br/>");
			exit("<br/><p>".$this->execution_log("Connection attempt failed | ", $e->getMessage()).
			"<br/>".print_r($this->errorInfo())."</p><br/>"); //Should be a message a typical user could understand
		}
		// try {			
		// 	$this->conn = parent::__construct($this->host,$this->username,$this->password,$this->db_name,$this->port,$this->db_socket);
		// 	mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_ALL);
		// 	if($this->connect_errno)
		// 	{
		// 		die("Unable to connect: ".$this->connect_error);
		// 	}

		// } catch (Exception $e) { // Error logging to log file
		// 	$this->execution_log("[ Sorry connection error... [ Num: ".$this->errno."][ Error: ".$this->connect_error."] [", $e->getMessage()."]");
		// 	die();
		// }		
		echo "<p>Connection Successful!!!</p>";	
		return $this->pdo;	
	}
	// ///////////////////////////////////////////////////////////////////////////
	// /** ***********************************************************************
	//  * Get user info
	//  * @access private
	//  */
	// private function logger()
	// {
	// 	// Monolog Integration: https://github.com/Seldaek/monolog
	// 	// Put the following code at the top of your PHP script in an index.html file
	// 	require '/var/www/html/vendor/autoload.php';
	// 	//  instantiate a new Logger and name it SimpleLogger:
	// 	$logger = new Logger('Database');
	// 	// use StreamHandler to make sure the logger stores the logs into your existing server.log file:
	// 	$logger->pushHandler(new StreamHandler('/var/log/www-server.log', Logger::DEBUG));
	// 	$logger->info("class.Database logger initialized......");
	// 	return $logger;
	// }
	///////////////////////////////////////////////////////////////////////////
	/** ***********************************************************************
	 * Get Database name
	 * @access public
	 * @return db_name The database name
	 */
	public function get_Db_Name()
	{
		return $this->db_name;
	}

	///////////////////////////////////////////////////////////////////////////
	/** ***********************************************************************
	 * Fetch all array from database; fetches all result rows as 
	 * an associative array, a numeric array, or both
	 * mysqli_fetch_all (PHP 5 >= 5.3.0)
	 * @access public
	 * @var query The mysql query script
	 * @return mixed Mixed return type; array
	 */
    public function fetch_all($query) 
    {
        $result = parent::query($query, null);
        if($result) 
        {
            # check if mysqli_fetch_all function exist or not
            if(function_exists('mysqli_fetch_all')) 
            {
                # NOTE: this below always gets error on certain live server
				# Fatal error: Call to undefined method mysqli_result::fetch_all() in /.../class.database.php 
				# on line 28
                return $result->fetchAll();
            }            
            # fall back to use while to loop through the result using fetch_assoc
            else
            {
                while($row = $result->fetchAll())
                {
                    $return_this[] = $row;
                }

                if (isset($return_this))
                {
                    return $return_this;
                }
                else
                {
                    return false;
                }
            }
        }
        else
        {
            return parent::errorInfo();
        }
    }

	///////////////////////////////////////////////////////////////////////////
	/** ***********************************************************************
	 * fetch a result row as an associative array
	 */
    public function fetch_assoc($query)
    {
        $result = parent::query($query);
        if($result) 
        {
            return $result->fetchAll();
        } 
        else
        {
            # call the get_error function
            return parent::errorInfo();
            # or:
            # return $this->get_error();
        }
    }

	///////////////////////////////////////////////////////////////////////////
	/** ***********************************************************************
	 * Display error
	 * @return String  The error number and message returned at runtime
	 */ 
    public function get_error() 
    {	#  check for the presence of an error
        if(($this->error != null))
        {	# returning the formatted system error message
            return Sprintf(" | Error: [ Num:  %d ] | [ Msg:  %s ]", $this->errno, $this->error);
        }
	}
	
	///////////////////////////////////////////////////////////////////////////
	/** ***********************************************************************
	 * Destructor 
	 */
    public function __destruct()
    {
		$this->host;
		$this->username;
		$this->password;
		$this->db_name;
		$this->charset;
		$this->port;
		$this->db_socket;
		$this->ssl_ca;
		$this->ssl_cert;
		$this->ssl_key;
		$this->ssl_ca;
		$this->ssl_cert;
		$this->ssl_key; 
    }
	
	///////////////////////////////////////////////////////////////////////////
	/** ***********************************************************************
	 * Error logging
	 * @access protected
	 * @var usr_msg The provided string error message to log
	 * @var sys_msg The system provided error message to log
	 * @var level   // TO DO [[],[],[],[],[],[]]
	 */
	public function execution_log($usr_msg = "", $sys_msg = null, int &$level = null)
	{	
		// TODO Setup method to assign based on client location GPS instead of hard coding values
		date_default_timezone_set("America/New_York");
		if($sys_msg == null){			
			//  error_log(date("Y-m-d")." | ".date("h:i:sa")." | ".$usr_msg."\n", 3, "./log/error.log");
			error_log($usr_msg ." <br/>  Backtrace: [ <br/> ".debug_print_backtrace()." <br/> ]",0);
		}
		else
		{
			//  error_log(date("Y-m-d")." | ".date("h:i:sa")." | ".$usr_msg." | ".$sys_msg." \n", 3, 
			//  "./log/error.log");
			error_log($usr_msg." <br/> ".$sys_msg." <br/> Backtrace: [ <br/>".debug_print_backtrace()." <br/>]",0);
		}
	}  // End Of execution_log

	///////////////////////////////////////////////////////////////////////////
	/** ***********************************************************************
	 * PDO connection method
	 * @return PDO The PDO connection object
	 */
	public function _pdo_connect($host=null, string $username=null, $Passwd=null,$db_name=null,$port=null
	,$socket=null)
	{
		################  Cleanse parameter variables  ########################
		$this->host 		= $host  	== null ? 	"172.16.238.9" 					: $host;
		$this->username		= $username == null ? 	"user"							: $username;
		$this->password		= $Passwd 	== null ? 	"developer"						: $Passwd;
		$this->db_name 		= $db_name 	== null ? 	"YouAreWorthy"					: $db_name;
		$this->charset 		= 						"utf8";
		$this->port 		= $port		== null ? 	"3306"							: $port;
		$this->db_socket	= $socket	== null ? 	"/var/run/mysqld/mysqld.sock"	: $socket;
		################  Options Parameters  #################################
		$this->options 		= [
			PDO::ATTR_EMULATE_PREPARES   => false, # turn off emulation mode for "real" prepared statements
			PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION, # turn on errors in the form of exceptions
			PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC, # make the default fetch be an associative array
			];
		#############  try{}catch{}PDOException ###############################
		try {
			$this->dsn = "mysql:host=".$this->host.";dbname=".$this->db_name.";charset=".$this->charset."";
			$this->pdo = parent::__construct($this->dsn, $this->username, $this->password, $this->options);
		} catch (PDOException $e) { // Error logging to log file
			$this->execution_log("Connection attempt failed | ", $e->getMessage());
			exit("Sorry connection error...".$e->getMessage()); //Should be a message a typical user could understand
		} finally {
			$this->execution_log("Connection successful!!!");
			echo "Successful connection!!!";
		}
		return $this->pdo;
	}

	///////////////////////////////////////////////////////////////////////////
	/** ***********************************************************************
	 * Open a new connection to the MySQL server using default class parameters
	 * @return void
	 */
	public function mysqli_connect($host=null, string $username=null, $Passwd=null,$db_name=null,$port=null
	,$socket=null){
		################  Cleanse parameter variables  ########################
		$this->host 		= $host  	== null ? 	"172.16.238.9" 					: $host;
		$this->username		= $username == null ? 	"user"							: $username;
		$this->password		= $Passwd 	== null ? 	"developer"						: $Passwd;
		$this->db_name 		= $db_name 	== null ? 	"YouAreWorthy"					: $db_name;
		$this->charset 		= 						"utf8";
		$this->port 		= $port		== null ? 	"3306"							: $port;
		$this->db_socket	= $socket	== null ? 	"/var/run/mysqld/mysqld.sock"	: $socket;
		$conn = new mysqli($this->host, $this->username, $this->password, $this->db_name, $this->port,$this->db_socket);
		// Check connection
		if ($conn->connect_error) {
			die("Connection failed: " . $conn->connect_error);
		}
		echo "Connected successfully";
		return $conn;
	}

	/////////////////////// PDO alternative connect property //////////////////
	//	try {
	//		$dsn = "mysql:host=".$this->host.";dbname=".$this->$db_name.
	//		";charset=".$this->charset;
	//		$pdo = new PDO($dsn, $this->username, $this->password);
	//		$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);					
	//	} catch (PDOException $e) {
	//		exit("Connection failed: ".$e->getMessage());
	//	}		
	///////////////////////////////////////////////////////////////////////////
	

} 	// *********  End of Database Class 