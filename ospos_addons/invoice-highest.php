 <?php

$servername = "localhost";
$username = "ospos";
$password = "ospospwd";
$dbname = "ospos";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);
// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
$conn->query("SET character_set_results = 'utf8', character_set_client = 'utf8', character_set_connection = 'utf8', character_set_database = 'utf8', character_set_server = 'utf8'");
$sql = "SELECT sale_id , invoice_number FROM ospos_sales ORDER BY sale_id ASC";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
	echo $row['sale_id'].":".$row['invoice_number']."\n" ;        
    }
} else {
    echo "0 results";
}

$conn->close();
?> 
