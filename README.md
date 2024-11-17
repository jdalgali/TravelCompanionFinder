# TravelCompanionFinder

DES424 Cloud App Development Project - SIIT Thammasat University Bangkok Group 04

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
  - [Running Locally](#running-locally)
  - [Running with Docker Compose](#running-with-docker-compose)
  - [Rebuilding After Changes](#rebuilding-after-changes)
- [Contributing](#contributing)
- [License](#license)

## Introduction

TravelCompanionFinder is a web application designed to help users find travel companions. The application allows users to register, create profiles, and search for travel companions based on their preferences.

## Features

- User registration and authentication
- Profile creation and management
- Search for travel companions based on preferences
- Secure storage of user data
- Responsive design for mobile and desktop

## Installation

### Prerequisites

- [Flutter](https://docs.flutter.dev/get-started/install)
- [Android Studio](https://developer.android.com/studio)
- [VS Code](https://code.visualstudio.com/)
- [Chrome](https://www.google.com/chrome/)
- [Android Toolchain](https://developer.android.com/studio/command-line)
- [MongoDB](https://www.mongodb.com/try/download/community) (for local development without Docker)
- [Docker](https://www.docker.com/products/docker-desktop) (optional, for Docker Compose setup)
- [Docker Compose](https://docs.docker.com/compose/install/) (optional, for Docker Compose setup)

### Steps

1. Clone the repository:

    ```sh
    git clone https://github.com/OrbitPeppermint/TravelCompanionFinder.git
    cd TravelCompanionFinder
    ```

2. Install Flutter dependencies:

    ```sh
    flutter pub get
    ```

3. Verify Flutter installation:

    ```sh
    flutter doctor
    ```

## Usage

### Running Locally

#### Setting Up MongoDB

1. Download and install MongoDB from the [official website](https://www.mongodb.com/try/download/community).

2. Start the MongoDB server:

    ```sh
    mongod --dbpath <path_to_your_db_directory>
    ```

#### Running the Backend

1. Navigate to the `backend` directory:

    ```sh
    cd backend
    ```

2. Install backend dependencies:

    ```sh
    npm install
    ```

3. Create a `.env` file in the `backend` directory with the following content:

    ```env
    MONGODB_URI=mongodb://localhost:27017/travel_companion
    JWT_SECRET=your_secret_key
    NODE_ENV=development
    PORT=3000
    ```

4. Start the backend server:

    ```sh
    npm run dev
    ```

#### Running the Frontend

1. Navigate to the `frontend` directory:

    ```sh
    cd frontend
    ```

2. Install frontend dependencies:

    ```sh
    flutter pub get
    ```

3. Run the frontend application:

    ```sh
    flutter run
    ```

### Running with Docker Compose

1. Ensure Docker and Docker Compose are installed and running on your machine.

2. Navigate to the root directory of the project:

    ```sh
    cd TravelCompanionFinder
    ```

3. Build and start the services using Docker Compose:

    ```sh
    docker-compose up --build
    ```

4. Access the application:
    - Frontend: [http://localhost](http://localhost)
    - Backend: [http://localhost:3000](http://localhost:3000)
    - Mongo Express: [http://localhost:8081](http://localhost:8081)

### Rebuilding After Changes

#### Locally

1. Make your changes to the code.
2. Restart the backend or frontend server as needed:

    ```sh
    npm run dev  # For backend
    flutter run  # For frontend
    ```

#### Docker Compose

1. Make your changes to the code.
2. Rebuild and restart the services:

    ```sh
    docker-compose up --build
    ```

## Contributing

We welcome contributions to the TravelCompanionFinder project. Please follow these steps to contribute:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Make your changes.
4. Commit your changes (`git commit -m 'Add some feature'`).
5. Push to the branch (`git push origin feature-branch`).
6. Open a pull request.

## License

This project is licensed under the Creative Commons Legal Code CC0 1.0 Universal. See the [LICENSE](LICENSE) file for details.
