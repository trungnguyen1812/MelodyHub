FROM ubuntu:22.04

# Cài đặt system dependencies
RUN apt-get update && apt-get install -y \
    ffmpeg \
    libchromaprint-tools \
    wget \
    python3 \
    python3-pip \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Cài Go 1.21+ (thủ công)
RUN wget https://go.dev/dl/go1.21.13.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.21.13.linux-amd64.tar.gz && \
    rm go1.21.13.linux-amd64.tar.gz

ENV PATH="/usr/local/go/bin:${PATH}"

# Cài soundalike từ Go
RUN go install codeberg.org/derat/soundalike@latest && \
    cp /root/go/bin/soundalike /usr/local/bin/ && \
    chmod +x /usr/local/bin/soundalike

# Cài Python packages cho API
RUN pip3 install --no-cache-dir fastapi uvicorn python-multipart httpx

WORKDIR /app

COPY main.py .

EXPOSE 8002

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8002"]