FROM node:18-alpine

# Install netcat and dos2unix
RUN apk add --no-cache netcat-openbsd dos2unix

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm ci

COPY . .

# Make wait-for script executable and convert line endings
COPY wait-for.sh /wait-for.sh
RUN dos2unix /wait-for.sh && chmod +x /wait-for.sh

EXPOSE 3000

# Default environment variables
ENV NODE_ENV=production
ENV PORT=3000
ENV MONGODB_URI=mongodb://mongodb:27017/travel_companion
ENV JWT_SECRET=default-secret-key

# Use wait-for script to wait for MongoDB before starting
CMD ["/wait-for.sh", "mongodb:27017", "--", "npm", "start"]