# LYQX Shopping App

A modern e-commerce mobile application built with Flutter, showcasing best practices in
architecture, state management, and UI design.

## Features

- **User Authentication** - Login functionality with token management
- **Product Catalog** - Browse products with category filtering
- **Product Details** - View detailed product information
- **Shopping Cart** - Add, remove, and manage cart items
- **Wishlist** - Save favorite products for later
- **Dark/Light Mode** - Theme switching with persistence
- **Responsive Design** - Works on various device sizes

## Screenshots

*Add your screenshots here*

## Technologies Used

- **Flutter** - UI toolkit for building natively compiled applications
- **Dart** - Programming language
- **BLoC Pattern** - State management using Cubits
- **Go Router** - Navigation and routing
- **Dependency Injection** - Using GetIt and Injectable
- **REST API** - Integration with FakeStore API
- **Shared Preferences** - Local storage for app data

## Project Structure

lib/
├── app.dart # Main app widget
├── data/ # Data layer
│ ├── api_config.dart # API configuration
│ ├── model/ # Data models
│ ├── repositories/ # Repository pattern implementation
│ └── service/ # API services
├── di/ # Dependency injection
├── main.dart # Entry point
├── presentation/ # UI layer
│ ├── components/ # Reusable UI components
│ └── views/ # App screens
│ ├── auth/ # Authentication screens
│ ├── cart/ # Cart screen
│ ├── home/ # Home screen
│ ├── product/ # Product detail screen
│ └── wishlist/ # Wishlist screen
├── router/ # App navigation
├── theme/ # App theming
└── viewmodel/ # Business logic (Cubits)

## Getting Started

### Prerequisites

- Flutter SDK (version 3.0.0 or later)
- Dart SDK (version 2.17.0 or later)
- Android Studio / VS Code
- An emulator or physical device for testing

### Installation

1. Clone the repository
   git clone https://github.com/abiodunosagie/lyqx.git

2. Navigate to the project folder
   cd lyqx-shopping-app

3. Get dependencies
   flutter pub get

4. Run the code generation for dependency injection
   flutter pub run build_runner build --delete-conflicting-outputs

5. Run the app
   flutter run

## Usage

### Authentication

The app includes a demo login system. Use the following credentials:

- **Username:** johnd
- **Password:** m38rmF$

### Navigation

The app uses Go Router for navigation. The main routes are:

- `/welcome` - Welcome screen
- `/signin` - Sign in screen
- `/home` - Home screen with product listings
- `/product/:id` - Product detail screen
- `/cart` - Shopping cart
- `/wishlist` - User's wishlist

## Architecture

The app follows a clean architecture approach with three main layers:

1. **Data Layer** - Models, repositories, and services
    - API calls using Dio
    - Repository pattern for data operations
    - Model classes for data representation

2. **Business Logic Layer** - Cubits for state management
    - AuthCubit - Handles user authentication
    - ProductCubit - Manages product data
    - CartCubit - Manages shopping cart
    - WishlistCubit - Manages user's wishlist
    - ThemeCubit - Manages app theme

3. **Presentation Layer** - UI components and screens
    - Reusable components for consistent UI
    - Screen-specific widgets
    - Responsive design using custom utilities

## Dependencies

Key dependencies used in this project:

dependencies:
flutter:
sdk: flutter
flutter_bloc: ^8.0.0 # State management
go_router: ^6.0.0 # Navigation
dio: ^5.0.0 # HTTP client
get_it: ^7.2.0 # Service locator
injectable: ^2.1.0 # Dependency injection
shared_preferences: ^2.0.0 # Local storage
iconsax: ^0.0.8 # Icon pack

## Contributors

- Your Name - Initial work - https://github.com/abiodunosagie/lyqx.git

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- FakeStore API for providing the product data
- All open-source packages used in this project