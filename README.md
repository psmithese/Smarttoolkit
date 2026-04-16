# Smart Utility Toolkit

A premium, feature-rich **Smart Utility Toolkit** mobile application built with Flutter. The app brings together five essential everyday tools under one beautifully crafted glassmorphic interface, with smooth animations, persistent offline storage, and a clean MVVM architecture.

---

## ✨ Features

### 🔄 Unit Converter
Convert between different units of measurement across categories like length, weight, temperature, and volume — all in real-time as you type.

### ⚖️ BMI Calculator
Compute your Body Mass Index with visual health-category indicators. Supports both metric and imperial inputs.

### 💱 Currency Converter
Convert currencies using live exchange rates fetched from an open API. Includes a graceful fallback for offline conditions.

### 💡 Tip Calculator
Calculate tip amounts and split the bill between any number of people with an intuitive slider-based interface.

### ✅ Task / Checklist Manager *(Stage 1 Feature)*
A fully-featured task management module with:
- **Create tasks** with a title, optional description, priority level, and due date
- **Three priority levels**: High 🔴, Medium 🟡, Low 🟢 — with colour-coded indicators
- **Mark tasks complete** with a single tap on the circular checkbox
- **Edit tasks** via a long-press or the edit icon — opens a rich bottom-sheet dialog
- **Delete tasks** using a swipe-to-dismiss gesture or a confirmation dialog
- **Filter view**: Switch between All, Active, and Completed tabs instantly
- **Progress header**: Live stats showing total, active, and completed counts + a progress bar
- **Overdue indicators**: Due-date badges turn red when a task is past its deadline
- **Offline persistence**: All tasks are saved locally using `SharedPreferences` — no internet required

---

## 🏗️ Architecture & Code Quality

The app follows a clean **MVVM (Model-View-ViewModel)** architecture with the **Repository pattern** for data access.

```
lib/
├── core/               # App-wide theme, constants
├── shared/
│   └── widgets/        # Reusable GlassCard, CustomTextField
└── features/
    ├── home/           # Home screen with tool grid
    ├── splash/         # Animated splash screen
    ├── onboarding/     # First-launch onboarding flow
    ├── unit_converter/
    ├── bmi_calculator/
    ├── currency_converter/
    ├── tip_calculator/
    └── task_manager/
        ├── task_model.dart       # Immutable data model with copyWith
        ├── task_repository.dart  # SharedPreferences persistence layer
        ├── task_view_model.dart  # Business logic & state (ChangeNotifier)
        └── task_screen.dart      # Full UI with animations
```

| Concern | Solution |
|---|---|
| State Management | `provider` package — `ChangeNotifier` + `Consumer` |
| Offline Storage | `shared_preferences` — lists serialised as JSON strings |
| Animations | `flutter_animate` — fade, slide, scale micro-animations |
| Typography | `google_fonts` — Plus Jakarta Sans |
| Navigation | Named routes registered in `MaterialApp` |

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK `>=3.0.0`
- Dart SDK
- Android Studio or Xcode (for device / emulator)

### Running Locally
```bash
# 1. Clone the repository
git clone <your-repo-url>
cd smarttoolkit

# 2. Install dependencies
flutter pub get

# 3. Run on a connected device or emulator
flutter run
```

### Building a Release APK
```bash
flutter build apk --release
```
The APK will be at:
```
build/app/outputs/flutter-apk/app-release.apk
```

---

## 📱 Offline Support

All task data is persisted locally via `SharedPreferences`. Tasks are serialised to JSON and stored as a `List<String>` under the key `cached_tasks`. The app works fully **without any internet connection** for the task manager, BMI calculator, unit converter, and tip calculator. The currency converter gracefully handles offline states by displaying the last known rates.

---

## 🔗 Submission Links
- **Appetize Preview**: *(insert link)*
- **GitHub Repository**: *(insert link)*
