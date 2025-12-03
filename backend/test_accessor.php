<?php

// Test Laravel accessor naming for _id attribute

echo "Testing different accessor names:\n\n";

$tests = [
    'get_idAttribute' => 'Current (get_idAttribute)',
    'get_IdAttribute' => 'PascalCase (get_IdAttribute)',  
    'getIdAttribute' => 'No underscore (getIdAttribute)',
];

foreach ($tests as $method => $desc) {
    echo "$desc -> ";
    $attr = str_replace(['get', 'Attribute'], '', $method);
    // Convert from camelCase to snake_case
    $attr = strtolower(preg_replace('/(?<!^)[A-Z]/', '_$0', $attr));
    echo "Attribute: '$attr'\n";
}

echo "\n\nLaravel expects:\n";
echo "For attribute '_id', method should be: get" . str_replace('_', '', ucwords('_id', '_')) . "Attribute\n";
echo "Which is: get" . "Id" . "Attribute = getIdAttribute\n";
echo "\nBut that conflicts with the actual 'id' field!\n";
