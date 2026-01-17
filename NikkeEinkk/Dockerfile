# Build stage - using ARM64 compatible images for Oracle Cloud Free Tier
FROM --platform=linux/arm64 mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copy csproj and restore dependencies
COPY NikkeEinkk.csproj .
RUN dotnet restore -r linux-arm64

# Copy source code and build
COPY . .
RUN dotnet publish -c Release -r linux-arm64 --self-contained false -o /app/publish

# Runtime stage
FROM --platform=linux/arm64 mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app

# Install curl for downloading data from Object Storage
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Create a non-root user for security
RUN adduser --disabled-password --gecos '' appuser

# Copy published app
COPY --from=build /app/publish .

# Create data directories
RUN mkdir -p /app/data/global /app/data/cn && \
    chown -R appuser:appuser /app

# Copy startup script and fix line endings (Windows CRLF -> Unix LF) and remove BOM
COPY startup.sh /app/startup.sh
RUN sed -i -e 's/\r$//' -e '1s/^\xEF\xBB\xBF//' /app/startup.sh && chmod +x /app/startup.sh && chown appuser:appuser /app/startup.sh

USER appuser

# Expose port
EXPOSE 8080

# Set environment variables
ENV ASPNETCORE_URLS=http://+:8080
ENV ASPNETCORE_ENVIRONMENT=Production

# Use startup script to download data then start app
ENTRYPOINT ["/bin/bash", "/app/startup.sh"]

