FROM python:3.10-slim

# Install system dependencies for aeneas
RUN apt-get update && apt-get install -y \
    ffmpeg \
    espeak \
    espeak-data \
    libespeak-dev \
    python3-dev \
    libffi-dev \
    gcc \
    g++ \
    make \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Upgrade pip and install build tools
RUN pip install --upgrade pip
RUN pip install --no-cache-dir "setuptools<60.0" "numpy==1.22.4" wheel

# Install aeneas
RUN pip install --no-cache-dir aeneas==1.7.3.0 --no-build-isolation

# Install other dependencies
RUN pip install --no-cache-dir fastapi==0.111.0 uvicorn==0.29.0 python-multipart==0.0.9

# Copy source code
COPY main.py .

# Expose port and run
EXPOSE 8001
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8001"]

# Cài các dependencies còn lại
RUN pip install fastapi==0.111.0 uvicorn==0.29.0 python-multipart==0.0.9

COPY main.py .

EXPOSE 8001
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8001"]
