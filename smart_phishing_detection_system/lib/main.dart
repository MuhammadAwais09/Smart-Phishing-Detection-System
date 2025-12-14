import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// Firebase configuration
import 'firebase_options.dart';

// App screens
import 'splash_screen.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'menu_screen.dart';
import 'screens/history_screen.dart';
import 'screens/chatbot_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/detection_result_screen.dart';

// Optional central color palette for consistency
import 'utils/color_palette.dart';

/// Language Provider for switching between English and Urdu dynamically
class LanguageProvider with ChangeNotifier {
  bool _isUrdu = false;

  bool get isUrdu => _isUrdu;

  void setLanguage(bool isUrdu) {
    _isUrdu = isUrdu;
    notifyListeners();
  }

  Locale get locale =>
      _isUrdu ? const Locale('ur', 'PK') : const Locale('en', 'US');
}

/// App entry point with Firebase initialization
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase using platform-specific configuration
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => LanguageProvider(),
      child: const MainApp(),
    ),
  );
}

/// Root widget that wraps MaterialApp and listens for language changes
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          // Current locale + supported languages
          locale: languageProvider.locale,
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('ur', 'PK'),
          ],

          // Global theme for branding and consistency
          theme: ThemeData(
            primaryColor: AppColors.primaryBlue,
            scaffoldBackgroundColor: AppColors.lightWhite,
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryBlue),
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: AppColors.lightWhite,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: AppColors.lightWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          // Start with splash
          initialRoute: '/',

          // Named routes for navigation
          routes: {
            '/': (_) => const SplashScreen(),
            '/login': (_) => const LoginScreen(),
            '/register': (_) => const RegisterScreen(),
            '/home': (_) => const MenuScreen(),
            '/history': (_) => const HistoryScreen(),
            '/chatbot': (_) => const ChatbotScreen(),
            '/settings': (_) => const SettingsScreen(),
            '/detection': (_) => const DetectionResultScreen(),
          },
        );
      },
    );
  }
}