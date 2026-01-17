#!/bin/bash

echo "========================================="
echo "NikkeEinkk Startup Script"
echo "========================================="
echo "Current time: $(date)"
echo "Current user: $(whoami)"
echo "Current directory: $(pwd)"
echo ""

# Show environment info
echo "=== Environment Info ==="
echo "ASPNETCORE_ENVIRONMENT: ${ASPNETCORE_ENVIRONMENT:-not set}"
echo "ASPNETCORE_URLS: ${ASPNETCORE_URLS:-not set}"
echo "PAR_URL set: $([ -n "$PAR_URL" ] && echo 'yes' || echo 'no')"
echo ""

# Check if dotnet is available
echo "=== Checking dotnet ==="
which dotnet || echo "ERROR: dotnet not found in PATH"
dotnet --list-runtimes || echo "ERROR: dotnet --list-runtimes failed"
echo ""

# List app directory contents
echo "=== App Directory Contents ==="
ls -la /app/
echo ""

# Download data from Object Storage if PAR_URL is set
if [ -n "$PAR_URL" ]; then
    echo "=== Downloading Data from Object Storage ==="
    echo "PAR_URL (first 50 chars): ${PAR_URL:0:50}..."

    # Create directories
    mkdir -p /app/data/global /app/data/cn
    echo "Created data directories"

    # Download StaticData.zip (global data)
    echo ""
    echo "=== Downloading StaticData.zip ==="
    STATIC_URL="${PAR_URL}global/StaticData.zip"
    echo "URL: ${STATIC_URL:0:80}..."
    curl -sfL -o "/app/data/global/StaticData.zip" "$STATIC_URL"
    CURL_EXIT=$?
    if [ $CURL_EXIT -ne 0 ]; then
        echo "ERROR: Failed to download StaticData.zip (curl exit code: $CURL_EXIT)"
    else
        echo "Downloaded StaticData.zip ($(stat -c%s "/app/data/global/StaticData.zip" 2>/dev/null || echo "?") bytes)"
    fi

    # Download Locale.zip
    echo ""
    echo "=== Downloading Locale.zip ==="
    LOCALE_URL="${PAR_URL}global/Locale.zip"
    echo "URL: ${LOCALE_URL:0:80}..."
    curl -sfL -o "/app/data/global/Locale.zip" "$LOCALE_URL"
    CURL_EXIT=$?
    if [ $CURL_EXIT -ne 0 ]; then
        echo "ERROR: Failed to download Locale.zip (curl exit code: $CURL_EXIT)"
    else
        echo "Downloaded Locale.zip ($(stat -c%s "/app/data/global/Locale.zip" 2>/dev/null || echo "?") bytes)"
    fi

    echo ""
    echo "=== Data Download Complete ==="
else
    echo "=== PAR_URL not set, skipping data download ==="
    echo "WARNING: Application may fail to start without data files!"
fi

# Show final data directory state
echo ""
echo "=== Data Directory Contents ==="
echo "/app/data/global/:"
ls -la /app/data/global/ 2>&1 || echo "  (directory does not exist or is empty)"
echo ""
echo "/app/data/cn/:"
ls -la /app/data/cn/ 2>&1 || echo "  (directory does not exist or is empty)"
echo ""

# Check if required files exist
echo "=== Checking Required Files ==="
if [ -f "/app/NikkeEinkk.dll" ]; then
    echo "OK: /app/NikkeEinkk.dll exists"
else
    echo "ERROR: /app/NikkeEinkk.dll not found!"
    ls -la /app/*.dll 2>&1 || echo "  No .dll files found in /app"
fi

if [ -f "/app/appsettings.Production.json" ]; then
    echo "OK: /app/appsettings.Production.json exists"
    echo "Contents:"
    cat /app/appsettings.Production.json
else
    echo "WARNING: /app/appsettings.Production.json not found"
fi
echo ""

# Start the application
echo "========================================="
echo "Starting NikkeEinkk Application..."
echo "========================================="
cd /app
exec dotnet NikkeEinkk.dll

