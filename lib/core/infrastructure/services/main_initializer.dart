part of '../../../main.dart';

Future<ProviderContainer> _mainInitializer() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  _setupLogger();
  // Initialize Firebase and Supabase in parallel (independent operations)
  await Future.wait([_initFirebase(), _initSupabase()]);

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
  // Try to get from environment first
  String supabaseUrl = const String.fromEnvironment('SUPABASE_URL');
  String supabaseAnonKey = const String.fromEnvironment('SUPABASE_ANON_KEY');

  // Fallback to hardcoded values for development if environment variables are missing
  if (supabaseUrl.isEmpty) {
    supabaseUrl = 'https://denazlkdamrsefwkdxmp.supabase.co';
    log('⚠️ SUPABASE_URL not found in environment, using fallback');
  }
  if (supabaseAnonKey.isEmpty) {
    supabaseAnonKey =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRlbmF6bGtkYW1yc2Vmd2tkeG1wIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjkzNTAzMDAsImV4cCI6MjA4NDkyNjMwMH0.InD1f8XTqNVzmwWPxkEx6-L3iru9WVJyszAXd9JUhV4';
    log('⚠️ SUPABASE_ANON_KEY not found in environment, using fallback');
  }

  log('Supabase URL: ${supabaseUrl.isEmpty ? "EMPTY" : "Found (${supabaseUrl.length} chars)"}');
  log('Supabase Key: ${supabaseAnonKey.isEmpty ? "EMPTY" : "Found (${supabaseAnonKey.length} chars)"}');

  if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
    log('⚠️ Supabase configuration not found - storage features will be limited');
    log('⚠️ Make sure SUPABASE_URL and SUPABASE_ANON_KEY are defined in dart-define');
    return;
  }

  try {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
    log('✅ Supabase initialized successfully');
  } catch (e) {
    log('❌ Supabase initialization failed: $e');
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
