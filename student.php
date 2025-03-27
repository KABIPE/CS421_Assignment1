
<?php
// endPoint 1
// students.php

// Sample student data (replace with your actual data or database retrieval)
$students = array(
    array("name" => "Alice Johnson", "program" => "Software Engineering"),
    array("name" => "Bob Williams", "program" => "Computer Science"),
    array("name" => "Charlie Brown", "program" => "Information Technology"),
    array("name" => "David Miller", "program" => "Software Engineering"),
    array("name" => "Eve Davis", "program" => "Data Science"),
    array("name" => "Frank Garcia", "program" => "Software Engineering"),
    array("name" => "Grace Wilson", "program" => "Cybersecurity"),
    array("name" => "Henry Rodriguez", "program" => "Software Engineering"),
    array("name" => "Ivy Moore", "program" => "Networking"),
    array("name" => "Jack Taylor", "program" => "Software Engineering")
);

// Set the content type to JSON
header('Content-Type: application/json');

// Encode the array to JSON and echo it
echo json_encode($students);
?>