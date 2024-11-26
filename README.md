# TravelCompanionFinder

DES424 Cloud App Development Project - SIIT Thammasat University Bangkok Group 04

## Table of Contents

- [TravelCompanionFinder](#travelcompanionfinder)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Features](#features)
  - [Technologies Used](#technologies-used)
    - [Backend](#backend)
    - [Frontend](#frontend)
  - [Installation](#installation)
    - [Prerequisites](#prerequisites)
    - [Steps](#steps)
  - [Usage](#usage)
    - [Running with Docker Compose](#running-with-docker-compose)
    - [Rebuilding After Changes](#rebuilding-after-changes)
      - [Docker Compose](#docker-compose)
  - [API Documentation](#api-documentation)
    - [Authentication Endpoints](#authentication-endpoints)
    - [Profile Endpoints](#profile-endpoints)
    - [Travel Endpoints](#travel-endpoints)
    - [Message Endpoints](#message-endpoints)
  - [Robot Tests](#robot-tests)
    - [Running Robot Tests](#running-robot-tests)
  - [Contributing](#contributing)
  - [License](#license)

## Introduction

TravelCompanionFinder is a web application designed to help users find travel companions. The application allows users to register, create profiles, and search for travel companions based on their preferences.

## Features

- User registration and authentication with JWT
- Profile creation and management
- Search for travel companions based on preferences
- Real-time messaging between users
- Travel listings creation and management
- Advanced search filters for destinations
- Secure storage of user data
- Responsive design for mobile and desktop

## Technologies Used

### Backend

- **Node.js** with Express
- **MongoDB** with Mongoose
- **JWT** for authentication
- **Winston** for logging
- **Jest** for testing

### Frontend

- **Flutter** for web/mobile
- **Provider** for state management
- **Flutter Secure Storage**
- **HTTP** package for API integration

## Installation

### Prerequisites

- [Docker](https://www.docker.com/products/docker-desktop)
- [Docker Compose](https://docs.docker.com/compose/install/)

### Steps

1. **Clone the repository:**

    ```sh
    git clone https://github.com/OrbitPeppermint/TravelCompanionFinder.git
    cd TravelCompanionFinder
    ```

2. **Build and start the services using Docker Compose:**

    ```sh
    docker compose up --build -d
    ```

3. **Access the application:**
    - Frontend: [http://localhost](http://localhost)
    - Backend: [http://localhost:3000](http://localhost:3000)
    - Mongo Express: [http://localhost:8081](http://localhost:8081)

## Usage

### Running with Docker Compose

1. **Ensure Docker and Docker Compose** are installed and running on your machine.

2. **Navigate to the root directory** of the project:

    ```sh
    cd TravelCompanionFinder
    ```

3. **Build and start the services using Docker Compose:**

    ```sh
    docker compose up --build -d
    ```

4. **Access the application:**
    - Frontend: [http://localhost](http://localhost)
    - Backend: [http://localhost:3000](http://localhost:3000)
    - Mongo Express: [http://localhost:8081](http://localhost:8081)

### Rebuilding After Changes

#### Docker Compose

1. **Make your changes** to the code.
2. **Rebuild and restart the services:**

    ```sh
    docker compose up --build -d
    ```

## API Documentation

### Authentication Endpoints

- **POST** `/api/v1/auth/register` - Register new user
- **POST** `/api/v1/auth/login` - User login

### Profile Endpoints

- **GET** `/api/v1/profile` - Get user profile
- **PATCH** `/api/v1/profile` - Update user profile

### Travel Endpoints

- **GET** `/api/v1/travels` - List travel listings
- **POST** `/api/v1/travels` - Create travel listing
- **GET** `/api/v1/travels/:id` - Get travel details
- **PATCH** `/api/v1/travels/:id` - Update travel listing
- **DELETE** `/api/v1/travels/:id` - Delete travel listing

### Message Endpoints

- **GET** `/api/v1/messages` - Get user messages
- **POST** `/api/v1/messages` - Send new message

## Robot Tests

To run the Robot Framework tests, ensure that the local development environment is running with Docker Compose as described in the [Running with Docker Compose](#running-with-docker-compose) section.

### Running Robot Tests

1. **Navigate to the `robot` directory:**

    ```sh
    cd robot
    ```

2. **Run the tests:**

    ```sh
    robot .
    ```

## Contributing

We welcome contributions to the TravelCompanionFinder project. Please follow these steps to contribute:

1. **Fork the repository.**
2. **Create a new branch:**

    ```sh
    git checkout -b feature-branch
    ```

3. **Make your changes.**
4. **Commit your changes:**

    ```sh
    git commit -m 'Add some feature'
    ```

5. **Push to the branch:**

    ```sh
    git push origin feature-branch
    ```

6. **Open a pull request.**

## License

This project is licensed under the Creative Commons Legal Code CC0 1.0 Universal. See the [LICENSE](LICENSE) file for details.
