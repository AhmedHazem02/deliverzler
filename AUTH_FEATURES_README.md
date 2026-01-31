# نظام استعادة كلمة المرور والتحقق من البريد الإلكتروني

## 📋 نظرة عامة

تم تطوير نظام متكامل لاستعادة كلمة المرور والتحقق من البريد الإلكتروني مع دعم كامل للغة العربية والإنجليزية، وتصميم متجاوب لجميع الأجهزة (Mobile, Tablet, Web).

## ✨ الميزات الرئيسية

### 1. استعادة كلمة المرور (Forgot Password)
- ✅ صفحة مخصصة لإرسال رابط إعادة تعيين كلمة المرور
- ✅ نظام Rate Limiting (60 ثانية بين كل طلب)
- ✅ عداد تنازلي يعرض الوقت المتبقي
- ✅ رسائل نجاح/خطأ واضحة ومفصلة
- ✅ تصميم responsive (Compact للموبايل، Medium للتابلت)
- ✅ دعم كامل للعربية والإنجليزية

### 2. التحقق من البريد الإلكتروني (Email Verification)
- ✅ فحص تلقائي كل 5 ثوان للتحقق من الإيميل
- ✅ كشف ذكي عند العودة للتطبيق (WidgetsBindingObserver)
- ✅ إعادة إرسال البريد مع نظام cooldown
- ✅ زر "هل أدخلت إيميل خاطئ؟" للخروج
- ✅ فحص من السيرفر مباشرة (Server-side verification)
- ✅ رسائل توضيحية ونصائح (تحقق من spam)

### 3. التكامل الكامل مع التطبيق
- ✅ التسجيل يرسل verification email تلقائياً
- ✅ التوجيه للـ verification screen بعد التسجيل مباشرة
- ✅ CheckAuth يتحقق من Email Verification قبل السماح بالدخول
- ✅ Router يتعامل مع EmailNotVerifiedException
- ✅ زر "Forgot Password?" في صفحة تسجيل الدخول

## 🏗️ معمارية النظام

### Clean Architecture
```
lib/
├── auth/
│   ├── domain/                          # طبقة النطاق
│   │   ├── auth_failure.dart           # أنواع الأخطاء (Freezed)
│   │   └── email_not_verified_exception.dart
│   ├── infrastructure/                  # طبقة البنية التحتية
│   │   ├── data_sources/
│   │   │   └── auth_remote_data_source.dart
│   │   └── repos/
│   │       └── auth_repo.dart          # Repository مع Either pattern
│   └── presentation/                    # طبقة العرض
│       ├── providers/
│       │   ├── forgot_password_provider.dart
│       │   └── email_verification_provider.dart
│       ├── components/
│       │   └── forgot_password_form_component.dart
│       └── screens/
│           ├── forgot_password_screen/
│           │   ├── forgot_password_screen.dart
│           │   ├── forgot_password_screen_compact.dart
│           │   └── forgot_password_screen_medium.dart
│           └── email_verification_screen/
│               └── email_verification_screen.dart
```

## 🔧 التقنيات المستخدمة

### State Management & Architecture
- **Riverpod** - State management مع keepAlive
- **Freezed** - Immutable data classes و union types
- **fpdart** - Functional programming (Either, Option, Unit)

### Navigation & UI
- **go_router** - Type-safe navigation مع TypedGoRoute
- **WindowClassLayout** - Responsive design
- **Material Design 3** - مع دعم RTL

### Firebase & Backend
- **Firebase Authentication** - Email/Password authentication
- **Email Verification API** - Server-side verification
- **Password Reset API** - رابط إعادة تعيين كلمة المرور

### Utilities
- **WidgetsBindingObserver** - Lifecycle management
- **Timer.periodic** - Periodic checks
- **ARB files** - Internationalization (i18n)

## 📝 الكود الأساسي

### 1. Forgot Password Provider

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'forgot_password_provider.freezed.dart';
part 'forgot_password_provider.g.dart';

@freezed
class ForgotPasswordState with _$ForgotPasswordState {
  const factory ForgotPasswordState({
    DateTime? lastSentTime,
    @Default(false) bool emailSent,
  }) = _ForgotPasswordState;
}

@riverpod
class ForgotPassword extends _$ForgotPassword {
  static const cooldownDuration = Duration(seconds: 60);

  @override
  ForgotPasswordState build() => const ForgotPasswordState();

  int get secondsRemaining {
    if (state.lastSentTime == null) return 0;
    final elapsed = DateTime.now().difference(state.lastSentTime!);
    final remaining = cooldownDuration.inSeconds - elapsed.inSeconds;
    return remaining > 0 ? remaining : 0;
  }

  bool get canSend => secondsRemaining <= 0;

  Future<Either<AuthFailure, Unit>> sendPasswordResetEmail(String email) async {
    if (!canSend) return left(const AuthFailure.tooManyRequests());

    final result = await ref.read(authRepoProvider).sendPasswordResetEmail(email);

    return result.fold(
      (failure) => left(failure),
      (_) {
        state = ForgotPasswordState(
          lastSentTime: DateTime.now(),
          emailSent: true,
        );
        return right(unit);
      },
    );
  }
}
```

### 2. Email Verification Provider

```dart
@riverpod
class EmailVerification extends _$EmailVerification {
  Timer? _periodicTimer;

  @override
  EmailVerificationState build(String email) {
    _startPeriodicCheck();
    return EmailVerificationState(email: email);
  }

  void _startPeriodicCheck() {
    _periodicTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => checkVerificationStatus(silent: true),
    );
    
    // Cleanup timer on dispose
    ref.onDispose(() {
      _periodicTimer?.cancel();
    });
  }

  Future<void> checkVerificationStatus({bool silent = false}) async {
    if (!silent) {
      state = state.copyWith(isChecking: true, errorMessage: null);
    }

    final result = await ref.read(authRepoProvider).checkEmailVerified();

    result.fold(
      (failure) {
        if (!silent) {
          state = state.copyWith(
            isChecking: false,
            errorMessage: _mapFailureToMessage(failure),
          );
        }
      },
      (isVerified) {
        state = state.copyWith(
          isChecking: false,
          isVerified: isVerified,
          errorMessage: null,
        );
        
        if (isVerified) {
          _periodicTimer?.cancel();
        }
      },
    );
  }

  Future<void> resendVerificationEmail() async {
    if (!canResend) return;

    state = state.copyWith(errorMessage: null);

    final result = await ref.read(authRepoProvider).sendEmailVerification();

    result.fold(
      (failure) {
        state = state.copyWith(
          errorMessage: _mapFailureToMessage(failure),
        );
      },
      (_) {
        state = state.copyWith(
          lastResendTime: DateTime.now(),
          errorMessage: null,
        );
      },
    );
  }

  Future<void> signOutAndGoBack(BuildContext context) async {
    await ref.read(authRepoProvider).signOut();
    if (context.mounted) {
      const SignInRoute().go(context);
    }
  }
}
```

### 3. Email Verification Screen مع Lifecycle Detection

```dart
class _EmailVerificationScreenState extends ConsumerState<EmailVerificationScreen>
    with WidgetsBindingObserver {
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // الكشف التلقائي عند العودة من تطبيق الإيميل
    if (state == AppLifecycleState.resumed) {
      ref.read(emailVerificationProvider(widget.email).notifier)
        .checkVerificationStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final verificationState = ref.watch(emailVerificationProvider(widget.email));
    final notifier = ref.watch(emailVerificationProvider(widget.email).notifier);

    // الاستماع للتغييرات وإظهار Toast
    ref.listen(emailVerificationProvider(widget.email), (previous, next) {
      if (next.isVerified && !previous!.isVerified) {
        Toasts.showTitledToast(
          context,
          title: tr(context).success,
          description: tr(context).emailVerifiedSuccessfully,
        );
        
        // التوجيه لصفحة Home
        const ApplicationStatusGateRoute().go(context);
      }

      if (next.errorMessage != null && next.errorMessage != previous?.errorMessage) {
        Toasts.showTitledToast(
          context,
          title: tr(context).ops_err,
          description: next.errorMessage!,
        );
      }
    });

    // ... باقي UI
  }
}
```

### 4. Firebase Auth Methods

```dart
// في FirebaseAuthFacade
Future<void> sendPasswordResetEmail({required String email}) async {
  await _errorHandler(() => _firebaseAuth.sendPasswordResetEmail(email: email));
}

Future<void> sendEmailVerification() async {
  final user = _firebaseAuth.currentUser;
  if (user == null) {
    throw const ServerException(type: ServerExceptionType.general);
  }
  if (user.emailVerified) return; // Already verified
  
  await _errorHandler(() => user.sendEmailVerification());
}

Future<void> reloadUser() async {
  final user = _firebaseAuth.currentUser;
  if (user == null) {
    throw const ServerException(type: ServerExceptionType.general);
  }
  
  await _errorHandler(() => user.reload());
}

Future<bool> isEmailVerified() async {
  await reloadUser(); // ⚠️ مهم: Server-side check لتجنب الـ cache
  return _firebaseAuth.currentUser?.emailVerified ?? false;
}
```

### 5. Router Integration

```dart
// في app_router.dart
redirect: (BuildContext context, GoRouterState state) {
  // التحقق من EmailNotVerifiedException
  final checkAuthState = ref.read(checkAuthProvider);
  if (checkAuthState.hasError &&
      checkAuthState.error is EmailNotVerifiedException) {
    final exception = checkAuthState.error as EmailNotVerifiedException;
    final email = exception.email ?? '';
    
    if (email.isNotEmpty &&
        state.matchedLocation != EmailVerificationRoute(email: email).location) {
      return EmailVerificationRoute(email: email).location;
    }
  }
  
  // ... باقي redirect logic
}
```

## 🌍 الترجمات

تم إضافة 27+ مفتاح ترجمة جديد بالعربية والإنجليزية:

```dart
// الإنجليزية (app_en.arb)
"forgotPassword": "Forgot Password?",
"resetPassword": "Reset Password",
"enterEmailForReset": "Enter your email to receive a password reset link",
"sendResetLink": "Send Reset Link",
"checkEmailForResetLink": "Check your email for the reset link",
"resendIn": "Resend in {seconds} seconds",
"verifyYourEmail": "Verify Your Email",
"verificationEmailSent": "We've sent a verification email to:",
"checkYourEmail": "Please check your email and click the verification link",
"emailVerifiedSuccessfully": "Email verified successfully!",
"wrongEmailQuestion": "Wrong Email?",
"resendVerificationEmail": "Resend Verification Email",
"checkingVerificationStatus": "Checking verification status...",
"checkSpamFolder": "Tip: Check your spam folder if you don't see the email",
// ... والمزيد

// العربية (app_ar.arb)
"forgotPassword": "هل نسيت كلمة المرور؟",
"resetPassword": "إعادة تعيين كلمة المرور",
"enterEmailForReset": "أدخل بريدك الإلكتروني لتلقي رابط إعادة تعيين كلمة المرور",
"sendResetLink": "إرسال رابط إعادة التعيين",
"checkEmailForResetLink": "تحقق من بريدك الإلكتروني للحصول على رابط إعادة التعيين",
"resendIn": "إعادة الإرسال بعد {seconds} ثانية",
"verifyYourEmail": "تحقق من بريدك الإلكتروني",
"verificationEmailSent": "لقد أرسلنا رسالة تحقق إلى:",
"checkYourEmail": "يرجى التحقق من بريدك الإلكتروني والنقر على رابط التحقق",
"emailVerifiedSuccessfully": "تم التحقق من البريد الإلكتروني بنجاح!",
"wrongEmailQuestion": "هل أدخلت إيميل خاطئ؟",
"resendVerificationEmail": "إعادة إرسال رسالة التحقق",
"checkingVerificationStatus": "جاري التحقق من حالة البريد الإلكتروني...",
"checkSpamFolder": "نصيحة: تحقق من مجلد الرسائل غير المرغوب فيها إذا لم تجد الرسالة",
// ... والمزيد
```

## 🔄 تدفق العمل (User Flow)

### 1. Forgot Password Flow
```
User على صفحة Login
    ↓
يضغط "Forgot Password?"
    ↓
يدخل إلى ForgotPasswordScreen
    ↓
يدخل الإيميل ويضغط "Send Reset Link"
    ↓
Provider يفحص canSend (Cooldown)
    ↓
يرسل الطلب للـ Firebase
    ↓
رسالة نجاح تظهر + عداد الـ 60 ثانية يبدأ
    ↓
User يفتح الإيميل ويضغط على الرابط
    ↓
User يعيد تعيين كلمة المرور على صفحة Firebase
    ↓
User يرجع للتطبيق ويسجل دخول
```

### 2. Email Verification Flow (عند التسجيل)
```
User يملأ نموذج التسجيل
    ↓
يضغط "Submit"
    ↓
SignUpProvider ينشئ الحساب
    ↓
SignUpProvider يرسل verification email تلقائياً
    ↓
Navigation لـ EmailVerificationScreen
    ↓
الشاشة تبدأ periodic check كل 5 ثوان
    ↓
User يفتح الإيميل (التطبيق ينتقل للخلفية)
    ↓
User يضغط على رابط التحقق
    ↓
User يرجع للتطبيق (AppLifecycleState.resumed)
    ↓
WidgetsBindingObserver يكتشف العودة
    ↓
يتم فحص التحقق فوراً (checkVerificationStatus)
    ↓
isVerified = true
    ↓
Toast يظهر "Email verified successfully!"
    ↓
Navigation لـ ApplicationStatusGateRoute (Home)
```

### 3. Email Verification Check on App Start
```
App يبدأ
    ↓
CheckAuthProvider يعمل
    ↓
يتحقق من وجود user
    ↓
يستدعي checkEmailVerified()
    ↓
AuthRepo يستدعي reloadUser() (Server-side)
    ↓
إذا Email غير محقق:
    ↓
يرمي EmailNotVerifiedException(email: user.email)
    ↓
Router يلتقط الـ Exception
    ↓
يوجه لـ EmailVerificationRoute(email: email)
```

## ⚠️ نقاط مهمة (Critical Points)

### 1. Server-side Verification
```dart
Future<bool> isEmailVerified() async {
  await reloadUser(); // ⚠️ ضروري جداً لتجنب الـ cache
  return _firebaseAuth.currentUser?.emailVerified ?? false;
}
```
**لماذا؟** Firebase Auth يخزن حالة الـ `emailVerified` في الـ cache المحلي. يجب استدعاء `reloadUser()` للحصول على الحالة الفعلية من السيرفر.

### 2. Timer Disposal
```dart
ref.onDispose(() {
  _periodicTimer?.cancel(); // ⚠️ ضروري لتجنب Memory leaks
});
```

### 3. Navigation Pattern
```dart
// ✅ استخدم replace() بعد التسجيل
EmailVerificationRoute(email: emailController.text).replace(context);

// ❌ لا تستخدم go() لأن الـ back button سيرجع للـ signup
EmailVerificationRoute(email: emailController.text).go(context);
```

### 4. Freezed Imports
```dart
// ⚠️ يجب استيراد freezed_annotation
import 'package:freezed_annotation/freezed_annotation.dart';

// ⚠️ يجب إضافة كلا الـ parts
part 'forgot_password_provider.freezed.dart';
part 'forgot_password_provider.g.dart';
```

### 5. Silent vs Normal Check
```dart
// Silent check (في الخلفية - لا يظهر loading)
checkVerificationStatus(silent: true);

// Normal check (يظهر loading indicator)
checkVerificationStatus(silent: false);
```

## 🧪 الاختبار

### Test Cases

1. **Forgot Password**
   - ✅ إرسال إيميل صحيح
   - ✅ إرسال إيميل غير صحيح
   - ✅ محاولة الإرسال قبل انتهاء الـ cooldown
   - ✅ العداد التنازلي يعمل بشكل صحيح
   - ✅ رسائل الخطأ تظهر بالترجمة الصحيحة

2. **Email Verification**
   - ✅ التسجيل → التوجيه الفوري لـ Verification screen
   - ✅ Periodic check يعمل كل 5 ثوان
   - ✅ Lifecycle detection عند العودة للتطبيق
   - ✅ Toast يظهر عند التحقق الناجح
   - ✅ Navigation لـ Home بعد التحقق
   - ✅ Resend email مع cooldown
   - ✅ Wrong email logout

3. **Router Integration**
   - ✅ Refresh يبقى في الصفحة (مش يروح login)
   - ✅ EmailNotVerifiedException توجه لـ Verification screen
   - ✅ CheckAuth ينتظر verification قبل authentication

## 📦 Build Commands

```bash
# توليد ملفات Freezed و Riverpod
dart run build_runner build --delete-conflicting-outputs

# توليد ملفات الترجمة
flutter gen-l10n

# تشغيل التطبيق
flutter run -d chrome  # للويب
flutter run -d windows  # للويندوز
flutter run  # للموبايل
```

## 🐛 Troubleshooting

### مشكلة: Provider not found
```
Error: The method 'emailVerificationProvider' isn't defined
```
**الحل:** تأكد من المسار الصحيح للـ import
```dart
// ❌ خطأ
import '../providers/email_verification_provider.dart';

// ✅ صحيح
import '../../providers/email_verification_provider.dart';
```

### مشكلة: networkError not found
```
Error: There's no constant named 'networkError' in 'ServerExceptionType'
```
**الحل:** استخدم `noInternet` بدلاً من `networkError`
```dart
// ❌ خطأ
if (e.type == ServerExceptionType.networkError)

// ✅ صحيح
if (e.type == ServerExceptionType.noInternet)
```

### مشكلة: Freezed files not generated
```
Error: Could not resolve annotation for `class ForgotPasswordState`
```
**الحل:** أضف imports المطلوبة وشغل build_runner
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'forgot_password_provider.freezed.dart';
part 'forgot_password_provider.g.dart';
```
ثم:
```bash
dart run build_runner build --delete-conflicting-outputs
```

## 🎨 UI Screenshots Placeholders

### Forgot Password Screen
- Mobile view (Compact)
- Tablet view (Medium)
- Success state
- Error state
- Cooldown timer

### Email Verification Screen
- Initial state
- Checking state
- Wrong email banner
- Resend cooldown
- Success toast

## 📚 Resources

- [Firebase Auth Documentation](https://firebase.google.com/docs/auth)
- [Riverpod Documentation](https://riverpod.dev/)
- [Freezed Package](https://pub.dev/packages/freezed)
- [go_router Documentation](https://pub.dev/packages/go_router)

## 👨‍💻 Developer Notes

### Performance Considerations
- Periodic timer يتم إيقافه عند التحقق الناجح
- Silent checks لتجنب الـ UI flickering
- Server-side verification لضمان الدقة
- Cooldown لتجنب Rate limiting من Firebase

### Security Notes
- Email verification إلزامية قبل الدخول
- Server-side check يمنع bypass
- Rate limiting يمنع spam
- Firebase handles email link security

### Future Improvements
- [ ] إضافة Phone verification
- [ ] إضافة 2FA
- [ ] Email verification reminder notifications
- [ ] Analytics لتتبع conversion rates
- [ ] A/B testing للـ UI variations

---

**التاريخ:** 31 يناير 2026  
**النسخة:** 1.0.0  
**المطور:** GitHub Copilot  
**الحالة:** ✅ مكتمل وجاهز للإنتاج
