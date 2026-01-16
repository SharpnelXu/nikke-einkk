#!/bin/bash
set -e

# Download data from Object Storage if PAR_URL is set
if [ -n "$PAR_URL" ]; then
    echo "Downloading data from Object Storage..."

    # Download global data
    echo "Downloading global data..."
    mkdir -p /app/data/global
    curl -s "${PAR_URL}" | grep -oP '(?<=<Key>)[^<]+' | grep '^global/' | while read file; do
        filename=$(basename "$file")
        echo "  Downloading $filename..."
        curl -s -o "/app/data/global/$filename" "${PAR_URL}${file}"
    done

    # Download cn data
#    echo "Downloading cn data..."
#    mkdir -p /app/data/cn
#    curl -s "${PAR_URL}" | grep -oP '(?<=<Key>)[^<]+' | grep '^cn/' | while read file; do
#        filename=$(basename "$file")
#        echo "  Downloading $filename..."
#        curl -s -o "/app/data/cn/$filename" "${PAR_URL}${file}"
#    done

    echo "Data download complete!"
    ls -la /app/data/global/ || true
#    ls -la /app/data/cn/ || true
fi

cd /app
exec dotnet NikkeEinkk.dll

