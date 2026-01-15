#!/bin/bash

echo "Formatting Components..."

if [ ! -d "../Components" ]; then
    echo "Error：Folder Components does not exist."
    exit 1
fi

dotnet format --include "./Components/**/*.cs" --verbosity diagnostic
dotnet format --include "./Tools/**/*.cs" --verbosity diagnostic

if [ $? -eq 0 ]; then
    echo "Components formatted."
else
    echo "Error during formating"
    exit 1
fi
