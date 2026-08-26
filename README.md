# 🚀 Simple Flutter Login for ITE 120


---

## 📁 Project Architecture

This project follows a **Feature-Based Architecture**. Instead of grouping files by type (e.g., all screens in one giant folder), code is organized by **feature** (e.g., `auth`).

```text
lib/
├── main.dart                                # Application entry point & ProviderScope
├── app/
│   └── app.dart                             # App-level config (MaterialApp, theme, home)
└── features/
    └── auth/                                # Authentication feature
        └── presentation/                    # UI layer of the auth feature
            ├── screens/
            │   └── login_screen.dart        # Screen layout & composition
            ├── providers/
            │   └── auth_provider.dart       # State & business logic (Riverpod)
            └── widgets/
                ├── button.dart              # Reusable action button
                └── input.dart               # Reusable text input field
```

### Why use Feature-Based Architecture?
1. **Scalability**: Adding new features (e.g., `features/profile/`, `features/dashboard/`) won't clutter existing code.
2. **Separation of Concerns**: UI widgets only handle display, while Providers handle state and logic.
3. **Reusability**: Widgets inside `widgets/` can be reused across different screens within the feature or promoted to a global shared folder later.

---

## 🧠 Riverpod State Management Made Easy

### 1. `ProviderScope` (The Global Store)
Located in `lib/main.dart`:
```dart
void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
```
* **What it does**: `ProviderScope` wraps your entire app at the root. It holds and stores the state of all providers in memory so widgets can access them from anywhere.

---

### 2. `AuthState` (The Data Model)
Located in `lib/features/auth/presentation/providers/auth_provider.dart`:
```dart
class AuthState {
  final bool isLoading;
  final String? errorMessage;
  final bool isAuthenticated;

  const AuthState({
    this.isLoading = false,
    this.errorMessage,
    this.isAuthenticated = false,
  });
}
```
* **What it does**: Represents the current snapshot of authentication data at any moment.
* **Immutability**: In Riverpod, state objects are immutable (they don't mutate directly). When the state changes, a new `AuthState` instance is created using the `copyWith()` helper.

---

### 3. `AuthNotifier` (The Logic & State Updater)
Located in `lib/features/auth/presentation/providers/auth_provider.dart`:
```dart
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  Future<void> login(String email, String password) async { ... }
}
```
* **What it does**: Inherits from `Notifier<AuthState>`. It contains methods like `login()` that validate user input, toggle loading states, and update `state`.
* Whenever `state = ...` is set, Riverpod automatically notifies all listening UI widgets to rebuild.

---

### 4. `authProvider` (The Provider Declaration)
```dart
final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
```
* **What it does**: A global variable that lets the Flutter UI locate and communicate with `AuthNotifier`.

---

### 5. `ConsumerStatefulWidget` & `ref` in the UI
In `lib/features/auth/presentation/screens/login_screen.dart`:

| Riverpod Method | When to use it | Example in code |
| :--- | :--- | :--- |
| `ref.watch(provider)` | To **read** the state and **rebuild** the widget whenever the state changes. | `final authState = ref.watch(authProvider);` |
| `ref.read(provider.notifier)` | Inside event callbacks (button presses) to call logic **without** subscribing to rebuilds. | `ref.read(authProvider.notifier).login(email, pass);` |
| `ref.listen(provider, callback)` | To perform one-off side effects like showing a **SnackBar** or navigating to a new screen. | `ref.listen<AuthState>(authProvider, (prev, next) { ... });` |

---

## 🔄 Overall Application Flow

```text
1. main.dart (Initializes ProviderScope)
       │
       ▼
2. app.dart (Builds MaterialApp, Dark Theme, sets LoginScreen as Home)
       │
       ▼
3. login_screen.dart (Builds the UI form using reusable input & button widgets)
       │
       ├── User types credentials in CustomInputField (widgets/input.dart)
       │
       ├── User clicks CustomButton (widgets/button.dart)
       │      │
       │      ▼
       ├── Calls ref.read(authProvider.notifier).login(email, password)
       │      │
       │      ▼
       └── auth_provider.dart updates state:
              ├── isLoading: true   ──> UI button displays loading spinner
              ├── errorMessage: ... ──> UI renders red error banner above email
              └── isAuthenticated   ──> ref.listen displays success SnackBar
```

---

## 🧪 Demo Credentials (For Testing)

The application includes built-in mock authentication for practice:

* **Email:** `test@example.com`
* **Password:** `password123`

Any other credentials or blank fields will trigger an inline validation error banner above the email field.

---

## 🎨 UI/UX Features
* **Canvas & Surface**: Pure OLED black canvas (`#000000`) with semi-transparent frosted glass card surface (`#0D0D10`).
* **Background**: Silky satin dark metallic wallpaper (`assets/images/bg.jpg`) with dark vignette overlay.
* **Typography**: Crisp, clean `Inter` font with dedicated uppercase sublabels.
* **Micro-interactions**: 150ms focus transitions on inputs and subtle scale animations on the button.
* **Error Handling**: Non-intrusive terminal error banner seamlessly placed above the email address field.
