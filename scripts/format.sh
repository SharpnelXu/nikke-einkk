#!/bin/bash

echo "Formatting Components..."

dotnet format NikkeEinkk.sln

if [ $? -eq 0 ]; then
    echo "Components formatted."
else
    echo "Error during formating"
    exit 1
fi
