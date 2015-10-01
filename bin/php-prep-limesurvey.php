<?php
    global $pq_host, $pq_user, $pq_pass, $pq_db, $conn_string, $dbconn_pg;

    $pg_host = "localhost";
    $pg_user = "some_user";
    $pg_pass = 'some_pass';
    $pg_db  = "some_db";
    $pg_port = "5432"; 

    $tmpVar = getenv("PGHOST");
    if (!empty($tmpVar)) {
      $pg_host = $tmpVar;
    }

    $tmpVar = getenv("PGUSER");
    if (!empty($tmpVar)) {
      $pg_user = $tmpVar;
    }

    $tmpVar = getenv("PGPASS");
    if (!empty($tmpVar)) {
      $pg_pass = $tmpVar;
    }

    $tmpVar = getenv("PGDB");
    if (!empty($tmpVar)) {
      $pg_db = $tmpVar;
    }

    $tmpVar = getenv("PGPORT");
    if (!empty($tmpVar)) {
      $pg_port = $tmpVar;
    }
   
    $tmpVar = getenv("USERPASS");
    if(empty($tmpVar)){
        throw new Exception('USERPASS ENV Missing');
    }
    $user_pass = $tmpVar;

    echo "pg_host: $pg_host\n";
    echo "pg_user: $pg_user\n";
    echo "pg_pass: $pg_pass\n";
    echo "pg_db  : $pg_db\n";
    echo "pg_port: $pg_port\n";
    $conn_string = "host=$pg_host port=$pg_port dbname=$pg_db user=$pg_user password=$pg_pass"; 
    $dbconn_pg = pg_pconnect($conn_string)  or  die('Error connecting to postgres(vsm2m): ' . $conn_string);

    print "m_db: $pg_db <br>";

    $new_pass = hash('sha256', $user_pass);
    #$sqlStr = "update lime_users set password='$new_pass' where users_name='admin'";
    $sqlStr = "INSERT INTO lime_users VALUES(1, 'admin', '$new_pass', 'Administrator', 0, 'en', 'youremail@address.com', 'default', 'default', 'default', '', 1,'2014-03-12', '2014-03-12');";
    
    $result = pg_exec($dbconn_pg, $sqlStr);
    if (!$result) {
      echo "An error occurred: $sqlStr\n";
      exit;
    }

?>
