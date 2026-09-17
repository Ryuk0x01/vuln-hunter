#!/bin/bash

echo "[+] Starting OWASP Juice Shop Setup..."

if ! command -v docker &> /dev/null
then
    echo "[-] Docker could not be found. Please install Docker first."
    exit 1
fi

echo "[+] Pulling the latest Juice Shop image..."
docker pull bkimminich/juice-shop

echo "[+] Starting Juice Shop container..."
docker run -d --name juice-shop -p 3000:3000 bkimminich/juice-shop

echo "[+] Waiting for Juice Shop to initialize..."
sleep 5

if docker ps | grep -q juice-shop; then
    echo "[✔] Juice Shop is up and running at: http://localhost:3000"
else
    echo "[-] Failed to start Juice Shop container."
    exit 1
fi