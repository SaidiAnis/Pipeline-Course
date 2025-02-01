# Dockerfile
FROM python:3.9-slim

# Install system dependencies (libaio1 is required for Oracle)
RUN apt-get update && apt-get install -y libaio1

# Copy your entire project (including the "instantclient" folder)
WORKDIR /app
COPY . .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Explicitly initialize Oracle Client in your code (no environment variables needed)
CMD streamlit run app.py