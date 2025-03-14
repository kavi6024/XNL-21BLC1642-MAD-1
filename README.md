# XBanking: A Mobile Banking Application Prototype

This project is a prototype for a mobile banking application built using Flutter, Firebase, and Riverpod.  It demonstrates core banking functionalities such as user authentication, account management, fund transfers, and transaction history.

## Features

* **User Authentication:** Secure user registration and login using Firebase Authentication.
* **Profile Management:**  Users can create and manage their profiles, including personal information and security settings.
* **Fund Transfer:**  Users can send money to other registered users.  Transactions are handled atomically using Firestore transactions to ensure data consistency.
* **Transaction History:**  A detailed history of all transactions is maintained and displayed.
* **Responsive UI:** The application is designed with a responsive UI for a consistent user experience across different screen sizes.
* **State Management:** Riverpod is used for efficient and scalable state management.
* **Backend:** Firebase (Firestore and Authentication) provides the backend infrastructure.

## Technology Stack

* **Flutter:** Cross-platform UI framework.
* **Firebase:** Backend services (Authentication, Firestore).
* **Riverpod:** State management solution.
* **Dart:** Programming language.

## Project Structure

The project is organized into several key components:

* **`models`:** Contains data models for users and transactions.
* **`providers`:** Houses Riverpod providers for managing application state.
* **`screens`:** Contains the UI components for different screens (login, signup, home, send money, transaction history, profile).
* **`services`:** Includes services for interacting with Firebase and handling authentication.

## Getting Started

1. **Clone the repository:**
   ```bash
   git clone <repository_url>
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase:**
   * Create a Firebase project in the Firebase console.
   * Add the Firebase configuration files to your project (refer to Firebase documentation).

4. **Run the application:**
   ```bash
   flutter run
   ```

## Future Enhancements

* **Improved UI/UX:** Further refinement of the user interface and user experience.
* **Additional Features:**  Implementation of features such as bill payments, account statements, and more sophisticated security measures.


## Contributing

Contributions are welcome! Please feel free to open issues or submit pull requests.
