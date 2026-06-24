import 'package:cricket_live_hd/core/app_providers.dart';
import 'package:cricket_live_hd/core/theme/app_theme.dart';
import 'package:cricket_live_hd/features/home/home_screen.dart';
import 'package:cricket_live_hd/features/notifications/notification_history_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'core/services/notification_service.dart';
import 'core/services/firebase_service.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: DefaultFirebaseOptions.apiKey,
      appId: DefaultFirebaseOptions.appId,
      messagingSenderId: DefaultFirebaseOptions.messagingSenderId,
      projectId: DefaultFirebaseOptions.projectId,
      databaseURL: DefaultFirebaseOptions.databaseURL,
      storageBucket: DefaultFirebaseOptions.storageBucket,
    ),
  );
  await NotificationService().handleRemoteMessage(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: DefaultFirebaseOptions.apiKey,
      appId: DefaultFirebaseOptions.appId,
      messagingSenderId: DefaultFirebaseOptions.messagingSenderId,
      projectId: DefaultFirebaseOptions.projectId,
      databaseURL: DefaultFirebaseOptions.databaseURL,
      storageBucket: DefaultFirebaseOptions.storageBucket,
    ),
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await NotificationService().init();

  runApp(const ProviderScope(child: CricketLiveHDApp()));
}

class CricketLiveHDApp extends ConsumerWidget {
  const CricketLiveHDApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    return settingsAsync.when(
      data: (settings) {
        return MaterialApp(
          title: settings?.appName ?? 'Cricket Live HD',
          theme: AppTheme.create(settings),
          debugShowCheckedModeBanner: false,
          home: const HomeScreen(),
          routes: {
            NotificationHistoryScreen.routeName: (_) => const NotificationHistoryScreen(),
          },
        );
      },
      loading: () => MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator()))),
      error: (_, __) => MaterialApp(home: Scaffold(body: Center(child: Text('Failed to load settings')))),
    );
  }
}
