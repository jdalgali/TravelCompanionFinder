#!/bin/bash

# Get current timestamp for versioning
VERSION=$(date +"%Y%m%d_%H%M%S")

# Create deployment zip with timestamp
echo "Creating deployment package v${VERSION}..."
cd aws/
zip "../deploy_${VERSION}.zip" docker-compose.yml Dockerfile nginx.conf

echo "Created deploy_${VERSION}.zip"

# Optional: Remove older deployment zips (keep last 5)
cd ..
ls -t deploy_*.zip | tail -n +6 | xargs -r rm

echo "Done! Upload deploy_${VERSION}.zip to Elastic Beanstalk"