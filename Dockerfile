FROM python:3.11-slim

# Set environment
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt update && apt install -y \
    chromium \
    chromium-driver \
    wget \
    curl \
    xvfb \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

# Copy backend and frontend
COPY server.py /app/server.py
COPY static /app/static

WORKDIR /app

EXPOSE 10000

CMD ["uvicorn", "server:app", "--host", "0.0.0.0", "--port", "10000"]
