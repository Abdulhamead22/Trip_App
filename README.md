# TripSplit 💸✈️

**TripSplit** is a Flutter mobile application designed to help friends and groups manage shared trip expenses, track payments, and calculate who owes whom. The goal is to make splitting expenses simple, transparent, and organized.

## ✨ Features

- **User Authentication:** Sign up, log in, reset passwords, and log out using Firebase Authentication.
- **Trip Management:** Create and view trips with customizable names and currencies.
- **Participant Management:** Add and manage participants for each trip.
- **Expense Tracking:** Record expenses, including the title, amount, payer, and participants sharing the cost.
- **Flexible Expense Splitting:** Support shared expenses and custom participant shares.
- **Settlement Calculation:** Calculate balances and determine who owes money to whom, helping reduce unnecessary transfers.
- **Real-Time Updates:** Listen to Firestore streams to reflect data changes in the app.
- **Account Management:** Update profile information and change passwords.
- **Reusable UI Components:** Use shared widgets for consistent design and maintainable code.

## 🛠️ Technologies Used

- **Flutter** — Cross-platform mobile application development.
- **Dart** — Programming language.
- **Firebase Authentication** — User authentication and account management.
- **Cloud Firestore** — Cloud database and real-time data updates.
- **GetX** — State management, dependency injection, and navigation.
- **Clean Architecture** — Separation of responsibilities across application layers.

## 🏗️ Project Architecture

The project is organized by features, with each feature separated into three layers:

```text
lib/
├── core/
│   ├── bindings/
│   ├── constants/
│   ├── controllers/
│   └── helpers/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── trips/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── participants/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── expenses/
│       ├── data/
│       ├── domain/
│       └── presentation/
├── screens/
├── widgets/
├── firebase_options.dart
└── main.dart
```

### Architecture Layers

- **Data:** Handles Firebase operations, data models, and repository implementations.
- **Domain:** Contains business entities, repository contracts, and use cases.
- **Presentation:** Contains screens, controllers, and UI components.
- **Core:** Provides shared application components, helpers, bindings, and constants.

## 🧮 Expense Settlement

TripSplit calculates each participant's balance by comparing the amount they paid with their share of the expenses.

The settlement algorithm matches participants who are owed money with participants who owe money to help minimize the number of transfers.

## 🚀 Getting Started

### Prerequisites

Make sure you have the following installed:

- Flutter SDK
- Dart SDK
- Android Studio or another supported Flutter development environment
- A Firebase project

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/Abdulhamead22/Trip_App.git
   ```

2. Navigate to the project directory:

   ```bash
   cd TripSplit
   ```

3. Install dependencies:

   ```bash
   flutter pub get
   ```

4. Configure Firebase for your Flutter application using the Firebase Console and FlutterFire CLI. Ensure the generated Firebase configuration matches your project.

5. Run the application:

   ```bash
   flutter run
   ```

> **Note:** Replace the repository URL above if your GitHub repository uses a different name or URL.

## 🎯 Project Goals

This project was developed to practice and apply:

- Building Flutter applications with a maintainable architecture.
- Managing application state and dependencies with GetX.
- Integrating Firebase Authentication and Cloud Firestore.
- Working with real-time streams.
- Separating business logic from the user interface.
- Implementing expense-sharing and settlement calculations.
- Creating reusable and organized UI components.

## 👨‍💻 Developer

**Abdulhamead Almashharawi**

- GitHub: [Abdulhamead22](https://github.com/Abdulhamead22)
- LinkedIn: [Connect with me on LinkedIn](https://www.linkedin.com/in/abdulhamead22/)

---

_TripSplit — Share the trip, split the cost, enjoy the journey._
