#!/bin/bash

# Simple HTTP status and header inspection

URL=${1:-https://www.google.com}

echo "Checking HTTP headers for $URL"
curl -I $URL
