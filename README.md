<div align="center">
<a href="https://github.com/fahmirizalbudi/synaptiq" target="blank">
<img src="https://raw.githubusercontent.com/fahmirizalbudi/synaptiq/main/assets/logo.svg" width="200" alt="Logo" />
</a>

<br />
<br />

![](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![](https://img.shields.io/badge/OpenRouter-000000?style=for-the-badge&logo=openai&logoColor=white)

</div>

<br/>

## Synaptiq

Synaptiq is a premium, context-aware AI chat assistant designed for a seamless and intelligent conversational experience. Powered by DeepSeek through the OpenRouter API, it remembers your conversation history to provide thoughtful and relevant responses within a modern, borderless UI.

## Features

- **Context-Aware Chat:** Intelligent conversations that remember past messages for better relevance.
- **Multi-Thread Management:** Organize your thoughts across multiple chat sessions with ease.
- **Cloud Sync:** Real-time synchronization of all chats and messages using Firebase Firestore.
- **Secure Authentication:** Easy access via Email/Password or Google Sign-In.
- **Premium UI/UX:** Minimalist design featuring Fluent Icons, Host Grotesk typography, and fluid micro-animations.
- **Smart History Control:** Swipe-to-delete individual threads or wipe your entire history from Settings.
- **Instant Session Deletion:** Quick-action delete button located directly in the sidebar for rapid cleanup.

## Tech Stack

- **Flutter (Dart)**: Native cross-platform framework for a high-performance mobile experience.
- **Riverpod**: Robust state management for predictable and scalable application flow.
- **GoRouter**: Declarative routing system for smooth navigation transitions.
- **Firebase**: Backend infrastructure for Authentication and real-time NoSQL storage.
- **Hive**: Ultra-fast local key-value storage for caching API configurations.
- **OpenRouter API**: Unified interface for accessing state-of-the-art AI models (DeepSeek, etc.).

## Getting Started

To get a local copy of Synaptiq up and running, follow these steps.

### Prerequisites

- **Flutter SDK** (v3.11.0 or higher).
- **Android Studio** / **VS Code**.
- **Firebase Project**: Set up a Firebase project and add your `google-services.json` (Android) or `GoogleService-Info.plist` (iOS).
- **OpenRouter API Key**: Obtain a key from [openrouter.ai](https://openrouter.ai).

## Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/fahmirizalbudi/synaptiq.git
   cd synaptiq
   ```

2. **Add Configuration:**

   Place your `google-services.json` in `android/app/`.

3. **Install dependencies:**

   ```bash
   flutter pub get
   ```

4. **Start the development server:**

   ```bash
   # Run the app on an Emulator or Physical Device.
   flutter run
   ```

## Usage

### Running the App

- **Build/Run:** `flutter run` or launch via your IDE's run button.
- **Setup:** Upon first launch, navigate to **Settings** and input your **OpenRouter API Key** to start chatting.

## License

All rights reserved. This project is for educational or specific project purposes only and cannot be used or distributed without permission.
