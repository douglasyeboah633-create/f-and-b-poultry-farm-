# Dockerfile for F and B Poultry Farm
# This file tells Fly.io how to build and run your app

# Use Python 3.11 as the base image
FROM python:3.11-slim

# Set the working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements file
COPY backend/requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# Create directory for database
RUN mkdir -p /app/backend

# Expose port 8080 (Fly.io uses this)
EXPOSE 8080

# Start the application (database initializes on first request)
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "--timeout", "120", "--chdir", "/app/backend", "main:app"]
