#!/bin/bash



docker start juice-shop 2>/dev/null || {
    docker rm -f juice-shop
    docker run -d --name juice-shop -p 3000:3000 bkimminich/juice-shop
}

echo "Running at: http://localhost:3000"