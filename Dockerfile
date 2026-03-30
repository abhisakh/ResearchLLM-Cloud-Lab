# Use the latest stable Python 3.12 slim image
FROM python:3.12-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
# Pre-set PYTHONPATH so the container always knows where your modules are
ENV PYTHONPATH=/app:/app/backend:/app/frontend

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libgomp1 \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir --default-timeout=1000 \
    --extra-index-url https://download.pytorch.org/whl/cpu \
    -r requirements.txt

# Copy the rest of the application code
COPY . .

# Expose ports for the Backend (8000) and Frontend/Streamlit (8501)
EXPOSE 8000
EXPOSE 8501

# Default command (usually set to the frontend for ease of use)
CMD ["streamlit", "run", "frontend/main_ui.py", "--server.port=8501", "--server.address=0.0.0.0"]