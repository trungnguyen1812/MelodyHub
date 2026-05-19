<?php
$pdo = new PDO('mysql:host=127.0.0.1;dbname=melodyhub', 'root', 'ServBay.dev');
$stmt = $pdo->query("SHOW COLUMNS FROM copyrights LIKE 'copyright_type'");
$row = $stmt->fetch(PDO::FETCH_ASSOC);
echo "Updated enum: " . $row['Type'] . "\n";
