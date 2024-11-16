FROM node:18-alpine

# Install netcat
RUN apk add --no-cache netcat-openbsd

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm ci

COPY . .

# Make wait-for script executable
COPY wait-for.sh /wait-for.sh
RUN chmod +x /wait-for.sh

EXPOSE 3000

# Use wait-for script to wait for MongoDB before starting
CMD ["/wait-for.sh", "mongodb:27017", "--", "npm", "start"]