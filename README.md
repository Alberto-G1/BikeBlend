# BikeBlend - Bike Sharing App

BikeBlend is a modern, user-friendly bike sharing application built with Flutter. The app allows users to locate, rent, and return bikes across the city, promoting eco-friendly transportation.

## Features

### User Authentication
- Login and signup with email/password
- Social login options (Google, Apple)
- Password recovery

### Bike Rental
- Interactive map showing bike stations
- List view of nearby stations
- Real-time bike availability information
- QR code scanning to unlock bikes
- Ride tracking and history

### User Profile
- Personal information management
- Ride statistics and history
- Membership details
- Payment methods

### Settings
- Theme customization (Light/Dark/System)
- Notification preferences
- Privacy settings
- Language selection
- Distance unit preferences

## Screenshots

[Include screenshots of key screens here]

## Project Structure

```
lib/
├── main.dart                  # App entry point
├── models/                    # Data models
├── providers/                 # State management
│   └── theme_provider.dart    # Theme management
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart  # User login
│   │   └── signup_screen.dart # User registration
│   ├── home_screen.dart       # Main navigation hub
│   ├── map_screen.dart        # Bike station map
│   ├── onboarding_screen.dart # First-time user experience
│   ├── profile_screen.dart    # User profile
│   ├── rides_screen.dart      # Ride history and active rides
│   ├── scan_screen.dart       # QR code scanner
│   └── settings/
│       └── settings_screen.dart # App settings
└── widgets/                   # Reusable UI components
```

## Getting Started

### Prerequisites
- Flutter SDK (2.0.0 or higher)
- Dart SDK (2.12.0 or higher)
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/bike_blend.git
```

2. Navigate to the project directory
```bash
cd bike_blend
```

3. Install dependencies
```bash
flutter pub get
```

4. Run the app
```bash
flutter run
```

## State Management

BikeBlend uses Provider for state management, making it easy to manage app-wide state such as theme preferences.

## Theming

The app supports light and dark themes, with a consistent color scheme across both modes. Users can choose between:
- Light mode
- Dark mode
- System default

## Future Enhancements

- Real-time GPS tracking during rides
- In-app payments
- Gamification and rewards system
- Social features (sharing rides, challenges)
- Integration with fitness apps
- Multi-language support
- Accessibility improvements

## Dependencies

- `provider`: ^6.0.5 - For state management
- `shared_preferences`: ^2.2.0 - For local storage
- `smooth_page_indicator`: ^1.1.0 - For onboarding screen pagination

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
