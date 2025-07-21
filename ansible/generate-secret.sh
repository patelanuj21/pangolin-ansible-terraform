#!/bin/bash

# Generate a secure random secret for Pangolin configuration
# Usage: ./generate-secret.sh

echo "Generating a secure random secret for Pangolin..."
echo ""

# Generate a 32-character random string
SECRET=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-32)

echo "Your secure secret: $SECRET"
echo ""
echo "Add this to your group_vars/all/main.yml file:"
echo "pangolin_secret: \"$SECRET\""
echo ""
echo "⚠️  Keep this secret secure and don't share it!" 