part of '../../../main.dart';

Future<ProviderContainer> _mainInitializer() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  _setupLogger();
  await _initFirebase();
  await _initSupabase();

  final container =
      ProviderContainer(observers: [ProviderLogger(), ProviderCrashlytics()]);
  // Warming-up androidDeviceInfoProvider to be used synchronously at AppTheme to setup the navigation bar
  // behavior for older Android versions without flickering (of the navigation bar) when app starts.
  await container.read(androidDeviceInfoProvider.future).suppressError();
  // Warming-up sharedPrefsAsyncProvider to be used synchronously at theme/locale. Not warming-up this
  // at splashServicesWarmup as theme/locale is used early at SplashScreen (avoid theme/locale flickering).
  await container.read(sharedPrefsAsyncProvider.future).suppressError();

  // Skip deferFirstFrame on web - it's not needed and can cause issues
  if (!kIsWeb) {
    // This Prevent closing native splash screen until we finish warming-up custom splash images.
    // App layout will be built but not displayed.
    widgetsBinding.deferFirstFrame();
    widgetsBinding.addPostFrameCallback((_) async {
      // Run any function you want to wait for before showing app layout.
      final BuildContext context = widgetsBinding.rootElement!;
      await _precacheAssets(context);

      // When the native splash screen is fullscreen, iOS will not automatically show the notification
      // bar when the app loads. To show it, setEnabledSystemUIMode has to be explicitly set:
      await SystemChrome.setEnabledSystemUIMode(
        SystemUiMode
            .edgeToEdge, // https://github.com/flutter/flutter/issues/105714
      );

      // Closes splash screen, and show the app layout.
      widgetsBinding.allowFirstFrame();
    });
  }

  return container;
}

void _setupLogger() {
  hierarchicalLoggingEnabled = true;
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord r) {
    if (r.loggerName.isEmpty) {
      loggerOnDataCallback()?.call(r);
    }
  });
}

Future<void> _initFirebase() async {
  try {
    log('Firebase: Initializing...');
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    log('Firebase: Initialized successfully');
    // Set the background messaging handler early on, as a named top-level function
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    // Seed sample data for development (only adds data if orders collection is empty)
    await FirestoreSeeder.seedIfEmpty();
  } catch (e) {
    log('Firebase: initialization FAILED');
    log('Error details: $e');
    // On web, this is usually due to missing environment variables
    if (kIsWeb) {
      log('Check if you provided FIREBASE_WEB_* dart defines');
    }
  }
}

Future<void> _precacheAssets(BuildContext context) async {
  await <Future<void>>[
    SplashScreen.precacheAssets(context),
  ].wait.suppressError();
}

Future<void> _initSupabase() async {
  const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
    log('Supabase configuration not found - storage features will be limited');
    return;
  }

  try {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
    log('Supabase initialized successfully');
  } catch (e) {
    log('Supabase initialization failed: $e');
  }
}

/// This provided handler must be a top-level function.
/// It works outside the scope of the app in its own isolate.
/// More details: https://firebase.google.com/docs/cloud-messaging/flutter/receive#background_messages
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  /*await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );*/
  log('Handling a background message ${message.messageId}');
}
