# Oracle Database Shopping Cart Design

## Overview

This repository contains the design and implementation of a shopping cart system using Oracle Database, enhanced with Docker for easy deployment and management. The system is structured to handle various aspects of an online shopping platform, including user management, product browsing, order processing, and more.

## Features

- **User Management**: Includes tables for storing user credentials, details, and address information.
- **Product Management**: Detailed information about products and product categories.
- **Order Processing**: Handling customer orders and order details.
- **Shopping Cart Functionality**: Temporary storage for products that users intend to purchase.
- **User Favorites**: Users can mark products as favorites for easy access later.
- **Logging Operations**: Tracking system activities and user interactions.

## Database Schema

The database is designed with the following key tables:
1. **Users**: Stores basic user information.
2. **User Details**: Contains detailed information about users.
3. **Address**: Manages user address details.
4. **Product Categories**: Classifies products into different categories.
5. **Products**: Contains information about products for sale.
6. **Orders**: Records user orders.
7. **Order Details**: Stores details of user orders.
8. **Shopping Cart**: Manages the users' shopping carts.
9. **Product Shopping Cart**: Links products to user shopping carts.
10. **User Favorites**: Allows users to mark favorite products.
11. **Operation Logs**: Logs system operations and user activities.

## Technologies Used

- Oracle Database
- PL/SQL
- Docker
- macOS (for development environment setup)
- Colima
- Homebrew

## Setup and Installation

### Oracle Database in Docker on macOS (M1 Chip)

To set up Oracle Database on macOS with an M1 chip, follow these steps:

1. **Install Homebrew**:
   Homebrew is a package manager for macOS. Install it by running:
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
2. **Install Colima**:
   Colima is an alternative to Docker Desktop, optimized for Apple Silicon (M1) chips. Install it using Homebrew:
   ```bash
   brew install colima
3. **Start Colima:**:
   ```bash
   colima start --arch x86_64 --memory 4
4. **Download Oracle Database Image:**:
   ```bash
   docker pull oracle/database:23.0.0.0
5. **Run Oracle Database Container:**:
   ```bash
   docker run -d --name oracle-db -p 1521:1521 oracle/database:23.0.0.0
5. **Accessing the Database:**:
    Connect to the database using SQL*Plus or any SQL client, using the credentials set during the Docker container setup.
## Usage
Instructions or examples on using the database, running queries, or any scripts included in the project

## Contributing
Contributions to this project are welcome. Please feel free to fork the repository and submit pull requests.   



