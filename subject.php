<?php
// endpoint 2
// subjects.php

// Sample subjects data (replace with your actual data)
$subjects = array(
    "Year 1" => array(
        "Semester 1" => array("Introduction to Programming", "Mathematics I", "Computer Organization"),
        "Semester 2" => array("Data Structures", "Mathematics II", "Database Systems")
    ),
    "Year 2" => array(
        "Semester 1" => array("Object-Oriented Programming", "Algorithms", "Web Development"),
        "Semester 2" => array("Software Engineering Principles", "Operating Systems", "Computer Networks")
    ),
    "Year 3" => array(
        "Semester 1" => array("Advanced Algorithms", "Database Management Systems", "Software Design"),
        "Semester 2" => array("Software Testing", "Mobile Application Development", "Distributed Systems")
    ),
    "Year 4" => array(
        "Semester 1" => array("Software Project Management", "Information Security", "Cloud Computing"),
        "Semester 2" => array("Final Year Project", "Elective 1", "Elective 2")
    )
);

// Set the content type to JSON
header('Content-Type: application/json');

// Encode the array to JSON and echo it
echo json_encode($subjects);
?>