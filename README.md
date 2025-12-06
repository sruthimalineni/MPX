# Pomodoro Timer App 

Our Pomodoro App is a timer application built from Flutter that helps users maintain focus and productivity by studying in increments of twenty-five minutes and taking five minute interval breaks. This app also features a task list where users can input designated amounts of tasks and the time it takes to complete each task. From there, the app takes the time and sections off how many rounds of pomodoro need to be completed for all tasks to be done. In addition, to ensure users know how long they have been studying, there is a statistics page that tracks all both the total time they have completed a task each month and how many tasks were completed.

## Special Topics
- Users can swipe left and right on a task in task lists to mark as complete or delete tasks.
- Our timer is animated by an increased clockwise motion that tracks how many minutes it has been.
- Leaving the statistics page, users can swipe right to return back to the home screen.

## Features

### 🍅 Pomodoro Timer
- 25-minute work sessions with 5-minute breaks
<img width="390" height="798" alt="image" src="https://github.com/user-attachments/assets/1c624b2c-c5f2-41dd-a752-99ea884c783d" />
<img width="395" height="798" alt="image" src="https://github.com/user-attachments/assets/958271d0-a8c9-4a8b-9c75-90aede3b48c9" />

- Visual timer with an animated clock
  
  <img width="399" height="798" alt="image" src="https://github.com/user-attachments/assets/7d4144db-08e3-4084-b892-a8851ef8784d" />

- Start, stop, and reset functionality
- Automatic session transitions between work and break times.

### 📋 Task Management
- Create and manage daily tasks
<img width="385" height="791" alt="image" src="https://github.com/user-attachments/assets/ca69e82e-836a-47cd-8ee7-f32d2d6987d0" />
<img width="378" height="792" alt="image" src="https://github.com/user-attachments/assets/45e2c71a-f2cd-4a0f-b343-800e199fc996" />

- Automatic calculation of Pomodoro rounds needed
<img width="384" height="789" alt="image" src="https://github.com/user-attachments/assets/f5179b9a-4bd6-4941-b204-3826eda774f0" />

- Gestures: Swipe left to delete a task. Swipe right to complete a task.
<img width="382" height="790" alt="image" src="https://github.com/user-attachments/assets/a3cceed2-dbd6-43fa-8cc7-3853d6047fab" />
<img width="382" height="790" alt="image" src="https://github.com/user-attachments/assets/dc6302b3-d22c-4b6b-89ff-e8c23281019c" />


### 📊 Progress Tracking
- Monthly statistics for time spent and tasks completed
<img width="382" height="790" alt="image" src="https://github.com/user-attachments/assets/c45509ca-ab66-48dd-a2e2-2db5ba0b4e12" />

- Gestures: Users can swipe left to see previous months and right to see more recent months.

![Simulator Screen Recording - iPhone 16 Pro - 2025-12-05 at 20 58 51](https://github.com/user-attachments/assets/47cf231c-34a9-4f80-9e9d-0179cad61334)


- Data visualization is done using FL Chart library

### ☁️ Cloud Sync
- Firebase integration for data persistence, storing data regarding the time the user spent and the number of tasks they completed.

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
- **Date/Time**: Date API service

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
