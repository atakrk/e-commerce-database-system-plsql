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

