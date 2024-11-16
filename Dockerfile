# Stage 1: Build the Flutter web app
FROM ubuntu:20.04 AS builder

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Set environment variables
ENV FLUTTER_HOME=/usr/local/flutter
ENV PATH="${FLUTTER_HOME}/bin:${PATH}"

# Install required dependencies
RUN apt-get update && apt-get install -y \
    curl \
    fonts-droid-fallback \
    gdb \
    git \
    libgconf-2-4 \
    libglu1-mesa \
    libstdc++6 \
    python3 \
    unzip \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && git clone https://github.com/flutter/flutter.git ${FLUTTER_HOME} \
    && flutter config --no-analytics \
    && flutter doctor \
    && flutter config --enable-web

# Set the working directory
WORKDIR /app

# Copy the app files
COPY . .

# Get app dependencies and build for web
RUN flutter pub get && flutter build web --release

# Stage 2: Serve the app using Nginx
FROM nginx:alpine

# Copy nginx configuration
COPY --from=builder /app/build/web /usr/share/nginx/html

# Create a simple nginx config
RUN echo 'server { \
    listen 80; \
    location / { \
    root /usr/share/nginx/html; \
    index index.html index.htm; \
    try_files $uri $uri/ /index.html; \
    } \
    }' > /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]