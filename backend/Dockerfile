FROM python:3.11-slim

WORKDIR /backend

# Install system dependencies required for building or running packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the backend application
COPY . .

# Expose the API port
EXPOSE 8000

# Set environment variable to ensure python outputs logs directly to stdout
ENV PYTHONUNBUFFERED=1

# Command to run the application using Uvicorn
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
