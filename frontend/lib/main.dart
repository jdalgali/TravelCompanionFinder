import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/travel_provider.dart';
import 'providers/message_provider.dart';
import 'providers/explore_provider.dart';
import 'services/recommendation_service.dart';
import 'services/travel_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/travels/create_travel_screen.dart';
import 'screens/messages/message_screen.dart';
import 'screens/explore/explore_screen.dart';
import 'widgets/bottom_bar.dart';
import 'app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, TravelProvider>(
          create: (context) => TravelProvider(token: null),
          update: (context, auth, previousTravels) =>
              TravelProvider(token: auth.token)..updateToken(auth.token),
        ),
        ChangeNotifierProxyProvider<AuthProvider, MessageProvider>(
          create: (context) => MessageProvider(token: null),
          update: (context, auth, previousMessages) =>
              MessageProvider(token: auth.token)..updateToken(auth.token),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ExploreProvider>(
          create: (context) => ExploreProvider(
              RecommendationService(TravelService(token: null))),
          update: (context, auth, previousExplore) => ExploreProvider(
              RecommendationService(TravelService(token: auth.token))),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Companion Finder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: AppTheme.textTheme,
        platform: TargetPlatform.iOS,
        splashColor: Colors.transparent,
      ),
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return auth.isAuthenticated ? const BottomBar() : const LoginScreen();
        },
      ),
      onGenerateRoute: (settings) {
        if (settings.name == CreateTravelScreen.routeName) {
          final args = settings.arguments as Map<String, dynamic>?;
          return MaterialPageRoute(
            builder: (context) => CreateTravelScreen(
              initialTravel: args?['travel'],
            ),
          );
        } else if (settings.name == MessageScreen.routeName) {
          return MaterialPageRoute(
            builder: (context) => const MessageScreen(),
          );
        } else if (settings.name == ExploreScreen.routeName) {
          return MaterialPageRoute(
            builder: (context) => const ExploreScreen(),
          );
        }
        return null;
      },
    );
  }
}
