# Pomodoro Timer App 

Our Pomodoro App is a timer application built from Flutter that helps users maintain focus and productivity by studying in increments of twenty-five minutes and taking five minute interval breaks. This app also features a task list where users can input designated amounts of tasks and the time it takes to complete each task. From there, the app takes the time and sections off how many rounds of pomodoro need to be completed for all tasks to be done. In addition, to ensure users know how long they have been studying, there is a statistics page that tracks all both the total time they have completed a task each month and how many tasks were completed.

## Special Topics
- Users can swipe left and right on a task in task lists to mark as complete or delete tasks.
- Our timer is animated by an increased clockwise motion that tracks how many minutes it has been.
- Leaving the statistics page, users can swipe right to return back to the home screen.

## Features

### 🍅 Pomodoro Timer
- 25-minute work sessions with 5-minute breaks
- Visual timer with animated tomato graphic
- Start, stop, and reset functionality
- Automatic session transitions

### 📋 Task Management
- Create and manage daily tasks
- Estimate time required for each task
- Automatic calculation of Pomodoro rounds needed
- Task completion tracking

### 📊 Progress Tracking
- Monthly statistics for time spent and tasks completed
- Interactive charts showing productivity trends
- Data visualization using FL Chart library

### ☁️ Cloud Sync
- Firebase integration for data persistence
- Cross-device synchronization
- Analytics and crash reporting

### 🎨 Modern UI
- Clean material design interface
- Responsive layout for different screen sizes
- Smooth animations and transitions

## Architecture

The app follows the MVVM (Model-View-ViewModel) architectural pattern:

- **Models**: Represent data structures (Task, Stats)
- **ViewModels**: Contain business logic and state management
- **Views**: Handle UI rendering and user interactions
- **Services**: Manage external dependencies (Firebase, APIs)

State management is handled by the Provider package, ensuring clean separation of concerns and reactive UI updates.

## Tech Stack

- **Framework**: Flutter
- **Architecture**: MVVM (Model-View-ViewModel)
- **State Management**: Provider
- **Database**: Firebase Firestore
- **Analytics**: Firebase Analytics
- **Charts**: FL Chart
- **Date/Time**: Custom Date API service
- **Local Storage**: Shared Preferences

## Project Structure
lib/
│
├── models/
│   ├── stats.dart
│   └── task.dart
│
├── services/
│   ├── date_api.dart
│   ├── firebase_options.dart
│   └── firestore_service.dart
│
├── theme/
│   └── app_theme.dart
│
├── viewmodels/
│   ├── stats_viewmodel.dart
│   ├── task_viewmodel.dart
│   └── timer_viewmodel.dart
│
├── views/
│   ├── home/
│   │   ├── home_screen.dart
│   │   ├── task_list_sheet.dart
│   │   └── tomato_timer.dart
│   │
│   ├── progress/
│   │   └── progress_screen.dart
│   │
│   └── widgets/
│       ├── chart_card.dart
│       └── timer_painter.dart
│
├── app.dart
└── main.dart


## Setup Instructions

### Prerequisites
- Flutter SDK (version 2.18.0 or higher)
- Dart SDK (version 2.18.0 or higher)
- Firebase project with Firestore enabled

### Installation

1. **Clone the repository**
   git clone https://github.com/sruthimalineni/MPX.git
   cd MPX/pomodoro_app

2. **Install dependencies**
   flutter pub get

3. **Configure Firebase**
   - Create a new Firebase project at https://console.firebase.google.com/
   - Enable Firestore Database
   - Enable Firebase Analytics and Crashlytics
   - Download the configuration files:
     - `google-services.json` for Android
     - `GoogleService-Info.plist` for iOS
   - Place these files in the appropriate directories:
     - `android/app/google-services.json`
     - `ios/Runner/GoogleService-Info.plist`

4. **Configure Firebase Options**
   - Update `lib/services/firebase_options.dart` with your Firebase project configuration
   - Or run `flutterfire configure` to automatically generate the options

5. **Run the app**
   flutter run

### Building for Production

**Android:**
flutter build apk --release

**iOS:**
flutter build ios --release

**Web:**
flutter build web --release

## Usage

### Getting Started
1. Launch the app
2. The main screen shows the Pomodoro timer
3. Tap the tomato to start a 25-minute work session

### Managing Tasks
1. Tap the "Task List" button at the bottom
2. Add new tasks with name, description, and estimated minutes
3. The app automatically calculates required Pomodoro rounds
4. Complete tasks to track your progress

### Viewing Progress
1. Tap the chart icon in the top-right corner
2. View monthly statistics for time spent and tasks completed
3. Charts show productivity trends over time

### Timer Controls
- **Start**: Begin a Pomodoro session
- **Stop**: Pause the current session
- **Reset**: Return to initial state


## Testing

Run the test suite:
flutter test
