import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Deliverzler'**
  String get appName;

  /// No description provided for @fontFamily.
  ///
  /// In en, this message translates to:
  /// **'Poppins'**
  String get fontFamily;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetConnection;

  /// No description provided for @screenNotFound.
  ///
  /// In en, this message translates to:
  /// **'Oops! Screen not found!'**
  String get screenNotFound;

  /// No description provided for @goToHome.
  ///
  /// In en, this message translates to:
  /// **'Go to Home'**
  String get goToHome;

  /// No description provided for @pleaseCheckYourDeviceNetwork.
  ///
  /// In en, this message translates to:
  /// **'Please check your device\"s network connection.'**
  String get pleaseCheckYourDeviceNetwork;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @ops_err.
  ///
  /// In en, this message translates to:
  /// **'Oops! Something went wrong!'**
  String get ops_err;

  /// No description provided for @pleaseTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Please try again!'**
  String get pleaseTryAgain;

  /// No description provided for @pleaseTryAgainLater.
  ///
  /// In en, this message translates to:
  /// **'Please try again later!'**
  String get pleaseTryAgainLater;

  /// No description provided for @youAreCurrentlyOffline.
  ///
  /// In en, this message translates to:
  /// **'You are currently offline.'**
  String get youAreCurrentlyOffline;

  /// No description provided for @youAreBackOnline.
  ///
  /// In en, this message translates to:
  /// **'Your are back online.'**
  String get youAreBackOnline;

  /// No description provided for @unauthorizedError.
  ///
  /// In en, this message translates to:
  /// **'Account not found or password invalid'**
  String get unauthorizedError;

  /// No description provided for @forbiddenError.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission to access this service'**
  String get forbiddenError;

  /// No description provided for @notFoundError.
  ///
  /// In en, this message translates to:
  /// **'Request page not found. Please contact support for more details.'**
  String get notFoundError;

  /// No description provided for @conflictError.
  ///
  /// In en, this message translates to:
  /// **'The request could not be processed because of conflict in the request. Please try again later.'**
  String get conflictError;

  /// No description provided for @internalError.
  ///
  /// In en, this message translates to:
  /// **'Internal server error. Please contact support for more details.'**
  String get internalError;

  /// No description provided for @serviceUnavailableError.
  ///
  /// In en, this message translates to:
  /// **'The server is temporarily unavailable. Please try again later.'**
  String get serviceUnavailableError;

  /// No description provided for @timeoutError.
  ///
  /// In en, this message translates to:
  /// **'Looks like the server is taking too long to respond. This can be caused by either poor connectivity or an error with our servers. Please try again in a while.'**
  String get timeoutError;

  /// No description provided for @noInternetError.
  ///
  /// In en, this message translates to:
  /// **'No Internet connection. Make sure Wi-Fi or cellular data is turned on, then try again.'**
  String get noInternetError;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error occurred!'**
  String get unknownError;

  /// No description provided for @authInvalidEmailError.
  ///
  /// In en, this message translates to:
  /// **'Your email is not valid. Please enter a valid email.'**
  String get authInvalidEmailError;

  /// No description provided for @authWrongPasswordError.
  ///
  /// In en, this message translates to:
  /// **'Your password is incorrect. Please try again.'**
  String get authWrongPasswordError;

  /// No description provided for @authUserNotFoundError.
  ///
  /// In en, this message translates to:
  /// **'User with this email doesn\'t exist.'**
  String get authUserNotFoundError;

  /// No description provided for @authUserDisabledError.
  ///
  /// In en, this message translates to:
  /// **'Your account has been disabled. Please contact support.'**
  String get authUserDisabledError;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong.'**
  String get somethingWentWrong;

  /// No description provided for @operationCanceledByUser.
  ///
  /// In en, this message translates to:
  /// **'Operation was canceled by user'**
  String get operationCanceledByUser;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @thisFieldIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'This field is empty'**
  String get thisFieldIsEmpty;

  /// No description provided for @pleaseEnterValidNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid mobile number'**
  String get pleaseEnterValidNumber;

  /// No description provided for @pleaseEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get pleaseEnterValidEmail;

  /// No description provided for @pleaseEnterValidName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid name'**
  String get pleaseEnterValidName;

  /// No description provided for @nameMustBeAtLeast2Letters.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 Letters'**
  String get nameMustBeAtLeast2Letters;

  /// No description provided for @nameMustBeAtMost30Letters.
  ///
  /// In en, this message translates to:
  /// **'Name must be at most 30 Letters'**
  String get nameMustBeAtMost30Letters;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @continue2.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue2;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @oK.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get oK;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @chooseOption.
  ///
  /// In en, this message translates to:
  /// **'Choose Option'**
  String get chooseOption;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @timeout_error.
  ///
  /// In en, this message translates to:
  /// **'Looks like the server is taking to long to respond, this can be caused by either poor connectivity or an error with our servers. Please try again in a while'**
  String get timeout_error;

  /// No description provided for @error_1000.
  ///
  /// In en, this message translates to:
  /// **'App Server Error, please contact support.'**
  String get error_1000;

  /// No description provided for @error_401.
  ///
  /// In en, this message translates to:
  /// **'Account not found or password invalid'**
  String get error_401;

  /// No description provided for @error_403.
  ///
  /// In en, this message translates to:
  /// **'forbidden'**
  String get error_403;

  /// No description provided for @error_404.
  ///
  /// In en, this message translates to:
  /// **'Request page not found please contact support for more details.'**
  String get error_404;

  /// No description provided for @error_479.
  ///
  /// In en, this message translates to:
  /// **'Session expired, please login again'**
  String get error_479;

  /// No description provided for @error_500.
  ///
  /// In en, this message translates to:
  /// **'Internal server error, please contact support for more details.'**
  String get error_500;

  /// No description provided for @error_503.
  ///
  /// In en, this message translates to:
  /// **'Service not available'**
  String get error_503;

  /// No description provided for @error_occurred.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error occurred!'**
  String get error_occurred;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @signInToYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Sign in to your account'**
  String get signInToYourAccount;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @emailOrPasswordIsInCorrect.
  ///
  /// In en, this message translates to:
  /// **'Email or password is incorrect. Please try again.'**
  String get emailOrPasswordIsInCorrect;

  /// No description provided for @dontHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign up'**
  String get dontHaveAnAccount;

  /// No description provided for @passwordMustBeAtLeast6Characters.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMustBeAtLeast6Characters;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @enterEmailToReset.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address to receive a password reset link'**
  String get enterEmailToReset;

  /// No description provided for @passwordResetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Password Reset Email Sent!'**
  String get passwordResetEmailSent;

  /// No description provided for @checkEmailForResetLink.
  ///
  /// In en, this message translates to:
  /// **'Check your email inbox for a password reset link. If you don\'t see it, check your spam folder.'**
  String get checkEmailForResetLink;

  /// No description provided for @backToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Back to Sign In'**
  String get backToSignIn;

  /// No description provided for @emailSentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Email sent successfully'**
  String get emailSentSuccessfully;

  /// No description provided for @verifyYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Email'**
  String get verifyYourEmail;

  /// No description provided for @verificationEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Verification Email Sent!'**
  String get verificationEmailSent;

  /// No description provided for @checkYourInbox.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a verification email to'**
  String get checkYourInbox;

  /// No description provided for @clickLinkInEmail.
  ///
  /// In en, this message translates to:
  /// **'Please click the link in the email to verify your account.'**
  String get clickLinkInEmail;

  /// No description provided for @emailVerificationRequired.
  ///
  /// In en, this message translates to:
  /// **'Email Verification Required'**
  String get emailVerificationRequired;

  /// No description provided for @pleaseVerifyEmail.
  ///
  /// In en, this message translates to:
  /// **'Please verify your email address to continue'**
  String get pleaseVerifyEmail;

  /// No description provided for @resendVerificationEmail.
  ///
  /// In en, this message translates to:
  /// **'Resend Verification Email'**
  String get resendVerificationEmail;

  /// No description provided for @resendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend in'**
  String get resendIn;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'seconds'**
  String get seconds;

  /// No description provided for @wrongEmailQuestion.
  ///
  /// In en, this message translates to:
  /// **'Wrong email?'**
  String get wrongEmailQuestion;

  /// No description provided for @changeEmail.
  ///
  /// In en, this message translates to:
  /// **'Change Email'**
  String get changeEmail;

  /// No description provided for @verificationCheckInProgress.
  ///
  /// In en, this message translates to:
  /// **'Checking verification status...'**
  String get verificationCheckInProgress;

  /// No description provided for @emailVerifiedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Email verified successfully!'**
  String get emailVerifiedSuccessfully;

  /// No description provided for @redirectingToHome.
  ///
  /// In en, this message translates to:
  /// **'Redirecting to home...'**
  String get redirectingToHome;

  /// No description provided for @didNotReceiveEmail.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the email?'**
  String get didNotReceiveEmail;

  /// No description provided for @checkSpamFolder.
  ///
  /// In en, this message translates to:
  /// **'Check your spam folder'**
  String get checkSpamFolder;

  /// No description provided for @openEmailApp.
  ///
  /// In en, this message translates to:
  /// **'Open Email App'**
  String get openEmailApp;

  /// No description provided for @verifyAndContinue.
  ///
  /// In en, this message translates to:
  /// **'I\'ve Verified, Continue'**
  String get verifyAndContinue;

  /// No description provided for @tooManyRequestsError.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please wait a moment and try again.'**
  String get tooManyRequestsError;

  /// No description provided for @authEmailAlreadyInUseError.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered. Please sign in.'**
  String get authEmailAlreadyInUseError;

  /// No description provided for @chooseVerificationMethod.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Identity'**
  String get chooseVerificationMethod;

  /// No description provided for @chooseVerificationMethodDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose how you\'d like to verify your account'**
  String get chooseVerificationMethodDesc;

  /// No description provided for @verifyByEmail.
  ///
  /// In en, this message translates to:
  /// **'Verify by Email'**
  String get verifyByEmail;

  /// No description provided for @verifyByEmailDesc.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send a verification link to your email'**
  String get verifyByEmailDesc;

  /// No description provided for @verifyByPhone.
  ///
  /// In en, this message translates to:
  /// **'Verify by Phone'**
  String get verifyByPhone;

  /// No description provided for @verifyByPhoneDesc.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send an OTP code to your phone number'**
  String get verifyByPhoneDesc;

  /// No description provided for @phoneNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required for phone verification'**
  String get phoneNumberRequired;

  /// No description provided for @verifyYourPhone.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Phone'**
  String get verifyYourPhone;

  /// No description provided for @otpSentTo.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a verification code to'**
  String get otpSentTo;

  /// No description provided for @enterOtpCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to your phone'**
  String get enterOtpCode;

  /// No description provided for @sendingOtp.
  ///
  /// In en, this message translates to:
  /// **'Sending verification code...'**
  String get sendingOtp;

  /// No description provided for @autoVerifying.
  ///
  /// In en, this message translates to:
  /// **'Auto-verifying...'**
  String get autoVerifying;

  /// No description provided for @phoneVerifiedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Phone verified successfully!'**
  String get phoneVerifiedSuccessfully;

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendOtp;

  /// No description provided for @didNotReceiveOtp.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code?'**
  String get didNotReceiveOtp;

  /// No description provided for @checkPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Make sure your phone number is correct and try again'**
  String get checkPhoneNumber;

  /// No description provided for @invalidOtpCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid verification code'**
  String get invalidOtpCode;

  /// No description provided for @otpExpired.
  ///
  /// In en, this message translates to:
  /// **'Verification code expired. Please request a new one.'**
  String get otpExpired;

  /// No description provided for @phoneAlreadyLinked.
  ///
  /// In en, this message translates to:
  /// **'This phone number is already linked to another account'**
  String get phoneAlreadyLinked;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @profileSettings.
  ///
  /// In en, this message translates to:
  /// **'Profile Settings'**
  String get profileSettings;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectYourPreferredLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Your Preferred Language'**
  String get selectYourPreferredLanguage;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Name'**
  String get enterYourName;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @enterYourNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Number'**
  String get enterYourNumber;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @please_enable_location_service.
  ///
  /// In en, this message translates to:
  /// **'Please enable location services, and try again'**
  String get please_enable_location_service;

  /// No description provided for @location_permission_required.
  ///
  /// In en, this message translates to:
  /// **'Without location permission you can\'t deliver orders'**
  String get location_permission_required;

  /// No description provided for @tracking_permission_required.
  ///
  /// In en, this message translates to:
  /// **'Without tracking permission you can\'t deliver orders'**
  String get tracking_permission_required;

  /// No description provided for @location_timeout_error.
  ///
  /// In en, this message translates to:
  /// **'It takes long time, please check your internet connection and try again'**
  String get location_timeout_error;

  /// No description provided for @please_wait.
  ///
  /// In en, this message translates to:
  /// **'Please wait'**
  String get please_wait;

  /// No description provided for @determine_location.
  ///
  /// In en, this message translates to:
  /// **'Please wait until your location is determined.'**
  String get determine_location;

  /// No description provided for @thereAreNoOrders.
  ///
  /// In en, this message translates to:
  /// **'There\"re no orders to be delivered.'**
  String get thereAreNoOrders;

  /// No description provided for @orderUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Order Upcoming'**
  String get orderUpcoming;

  /// No description provided for @orderOnTheWay.
  ///
  /// In en, this message translates to:
  /// **'Order OnTheWay'**
  String get orderOnTheWay;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @deliver.
  ///
  /// In en, this message translates to:
  /// **'Deliver'**
  String get deliver;

  /// No description provided for @showMap.
  ///
  /// In en, this message translates to:
  /// **'Show Map'**
  String get showMap;

  /// No description provided for @orderDetails.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get orderDetails;

  /// No description provided for @orderItems.
  ///
  /// In en, this message translates to:
  /// **'Order Items'**
  String get orderItems;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @deliveryFee.
  ///
  /// In en, this message translates to:
  /// **'Delivery Fee'**
  String get deliveryFee;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'EGP'**
  String get currency;

  /// No description provided for @noItemsInOrder.
  ///
  /// In en, this message translates to:
  /// **'No items in this order'**
  String get noItemsInOrder;

  /// No description provided for @id.
  ///
  /// In en, this message translates to:
  /// **'Id'**
  String get id;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @userDetails.
  ///
  /// In en, this message translates to:
  /// **'User Details'**
  String get userDetails;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @reasonForCancelingTheOrder.
  ///
  /// In en, this message translates to:
  /// **'Reason for canceling the order'**
  String get reasonForCancelingTheOrder;

  /// No description provided for @typeYourNote.
  ///
  /// In en, this message translates to:
  /// **'Type your note'**
  String get typeYourNote;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSure;

  /// No description provided for @cancelTheOrder.
  ///
  /// In en, this message translates to:
  /// **'Cancel the order?'**
  String get cancelTheOrder;

  /// No description provided for @submitExcuse.
  ///
  /// In en, this message translates to:
  /// **'Submit Excuse'**
  String get submitExcuse;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// No description provided for @reasonForRejection.
  ///
  /// In en, this message translates to:
  /// **'Reason for Rejection'**
  String get reasonForRejection;

  /// No description provided for @typeYourReason.
  ///
  /// In en, this message translates to:
  /// **'Type your reason for rejecting the order'**
  String get typeYourReason;

  /// No description provided for @excuseSubmissionNote.
  ///
  /// In en, this message translates to:
  /// **'Note: Your request will be sent to admin for review and you\'ll receive a decision soon'**
  String get excuseSubmissionNote;

  /// No description provided for @submitExcuseQuestion.
  ///
  /// In en, this message translates to:
  /// **'Submit excuse for this order?'**
  String get submitExcuseQuestion;

  /// No description provided for @waitingAdminReview.
  ///
  /// In en, this message translates to:
  /// **'Waiting for admin review'**
  String get waitingAdminReview;

  /// No description provided for @excuseSubmittedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Excuse submitted successfully'**
  String get excuseSubmittedSuccessfully;

  /// No description provided for @cannotSubmitExcuse.
  ///
  /// In en, this message translates to:
  /// **'Cannot submit excuse now'**
  String get cannotSubmitExcuse;

  /// No description provided for @doYouWantToDeliverTheOrder.
  ///
  /// In en, this message translates to:
  /// **'Do you want to Deliver the order?'**
  String get doYouWantToDeliverTheOrder;

  /// No description provided for @doYouWantToConfirmTheOrder.
  ///
  /// In en, this message translates to:
  /// **'Do you want to Confirm the order?'**
  String get doYouWantToConfirmTheOrder;

  /// No description provided for @youCanNotProceedThisOrder.
  ///
  /// In en, this message translates to:
  /// **'You can\"t proceed this order!'**
  String get youCanNotProceedThisOrder;

  /// No description provided for @youCanOnlyProceedOrdersYouDelivering.
  ///
  /// In en, this message translates to:
  /// **'You can only proceed orders that you\"re delivering.'**
  String get youCanOnlyProceedOrdersYouDelivering;

  /// No description provided for @arrivedLocation.
  ///
  /// In en, this message translates to:
  /// **'Arrived Location!'**
  String get arrivedLocation;

  /// No description provided for @youAreCloseToLocationArea.
  ///
  /// In en, this message translates to:
  /// **'You\"re close to location area. Order delivery confirmation has enabled.'**
  String get youAreCloseToLocationArea;

  /// No description provided for @searchForAPlace.
  ///
  /// In en, this message translates to:
  /// **'Search for a place...'**
  String get searchForAPlace;

  /// No description provided for @myCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'My current location'**
  String get myCurrentLocation;

  /// No description provided for @pleaseSearchForLocation.
  ///
  /// In en, this message translates to:
  /// **'Please search for the location!'**
  String get pleaseSearchForLocation;

  /// No description provided for @userHasNotProvidedLocation.
  ///
  /// In en, this message translates to:
  /// **'User hasn\'t provided his location point.'**
  String get userHasNotProvidedLocation;

  /// No description provided for @mapNotAvailableOnWeb.
  ///
  /// In en, this message translates to:
  /// **'Map Not Available on Web'**
  String get mapNotAvailableOnWeb;

  /// No description provided for @pleaseUseMobileAppForMapFeatures.
  ///
  /// In en, this message translates to:
  /// **'Please use the mobile app (Android/iOS) to access map features and navigation.'**
  String get pleaseUseMobileAppForMapFeatures;

  /// No description provided for @myOrders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get myOrders;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @onTheWay.
  ///
  /// In en, this message translates to:
  /// **'On The Way'**
  String get onTheWay;

  /// No description provided for @delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// No description provided for @noOrdersFound.
  ///
  /// In en, this message translates to:
  /// **'No orders found.'**
  String get noOrdersFound;

  /// No description provided for @driverApplicationTitle.
  ///
  /// In en, this message translates to:
  /// **'Driver Application'**
  String get driverApplicationTitle;

  /// No description provided for @driverApplicationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete the form below to apply as a delivery driver'**
  String get driverApplicationSubtitle;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInfo;

  /// No description provided for @licenseInfo.
  ///
  /// In en, this message translates to:
  /// **'License Information'**
  String get licenseInfo;

  /// No description provided for @vehicleInfo.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Information'**
  String get vehicleInfo;

  /// No description provided for @documents.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documents;

  /// No description provided for @additionalNotes.
  ///
  /// In en, this message translates to:
  /// **'Additional Notes'**
  String get additionalNotes;

  /// No description provided for @idNumber.
  ///
  /// In en, this message translates to:
  /// **'ID Number'**
  String get idNumber;

  /// No description provided for @licenseNumber.
  ///
  /// In en, this message translates to:
  /// **'License Number'**
  String get licenseNumber;

  /// No description provided for @licenseExpiryDate.
  ///
  /// In en, this message translates to:
  /// **'License Expiry Date'**
  String get licenseExpiryDate;

  /// No description provided for @vehicleType.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Type'**
  String get vehicleType;

  /// No description provided for @vehiclePlate.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Plate'**
  String get vehiclePlate;

  /// No description provided for @personalPhoto.
  ///
  /// In en, this message translates to:
  /// **'Personal Photo'**
  String get personalPhoto;

  /// No description provided for @idDocument.
  ///
  /// In en, this message translates to:
  /// **'ID Document'**
  String get idDocument;

  /// No description provided for @licenseDocument.
  ///
  /// In en, this message translates to:
  /// **'License Document'**
  String get licenseDocument;

  /// No description provided for @vehicleRegistration.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Registration'**
  String get vehicleRegistration;

  /// No description provided for @vehicleInsurance.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Insurance'**
  String get vehicleInsurance;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get requiredField;

  /// No description provided for @submitApplication.
  ///
  /// In en, this message translates to:
  /// **'Submit Application'**
  String get submitApplication;

  /// No description provided for @car.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get car;

  /// No description provided for @motorcycle.
  ///
  /// In en, this message translates to:
  /// **'Motorcycle'**
  String get motorcycle;

  /// No description provided for @bicycle.
  ///
  /// In en, this message translates to:
  /// **'Bicycle'**
  String get bicycle;

  /// No description provided for @noApplicationFound.
  ///
  /// In en, this message translates to:
  /// **'No Application Found'**
  String get noApplicationFound;

  /// No description provided for @submitApplicationToJoin.
  ///
  /// In en, this message translates to:
  /// **'Submit an application to join as a delivery driver'**
  String get submitApplicationToJoin;

  /// No description provided for @applicationPending.
  ///
  /// In en, this message translates to:
  /// **'Application Pending'**
  String get applicationPending;

  /// No description provided for @applicationUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Application Under Review'**
  String get applicationUnderReview;

  /// No description provided for @applicationApproved.
  ///
  /// In en, this message translates to:
  /// **'Application Approved'**
  String get applicationApproved;

  /// No description provided for @applicationRejected.
  ///
  /// In en, this message translates to:
  /// **'Application Rejected'**
  String get applicationRejected;

  /// No description provided for @applicationPendingMessage.
  ///
  /// In en, this message translates to:
  /// **'Your application has been submitted and is pending review'**
  String get applicationPendingMessage;

  /// No description provided for @applicationUnderReviewMessage.
  ///
  /// In en, this message translates to:
  /// **'Your application is being reviewed by our team'**
  String get applicationUnderReviewMessage;

  /// No description provided for @applicationApprovedMessage.
  ///
  /// In en, this message translates to:
  /// **'Congratulations! Your application has been approved. You can now start working'**
  String get applicationApprovedMessage;

  /// No description provided for @applicationRejectedMessage.
  ///
  /// In en, this message translates to:
  /// **'Unfortunately, your application has been rejected. You can apply again'**
  String get applicationRejectedMessage;

  /// No description provided for @rejectionReason.
  ///
  /// In en, this message translates to:
  /// **'Rejection Reason'**
  String get rejectionReason;

  /// No description provided for @resubmitApplication.
  ///
  /// In en, this message translates to:
  /// **'Resubmit Application'**
  String get resubmitApplication;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @applicationDetails.
  ///
  /// In en, this message translates to:
  /// **'Application Details'**
  String get applicationDetails;

  /// No description provided for @submittedAt.
  ///
  /// In en, this message translates to:
  /// **'Submitted At'**
  String get submittedAt;

  /// No description provided for @attention.
  ///
  /// In en, this message translates to:
  /// **'Attention'**
  String get attention;

  /// No description provided for @enterValidEgyptianPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid Egyptian phone number'**
  String get enterValidEgyptianPhone;

  /// No description provided for @idNumberLengthError.
  ///
  /// In en, this message translates to:
  /// **'ID Number must be 14 digits'**
  String get idNumberLengthError;

  /// No description provided for @licenseNumberLengthError.
  ///
  /// In en, this message translates to:
  /// **'License Number must be 14 digits'**
  String get licenseNumberLengthError;

  /// No description provided for @uploadAllRequiredImages.
  ///
  /// In en, this message translates to:
  /// **'Please upload all required images (Personal Photo, ID, License, Registration, Insurance).'**
  String get uploadAllRequiredImages;

  /// No description provided for @pleaseEnterValidVehiclePlate.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid vehicle plate (Numbers followed by Arabic letters).'**
  String get pleaseEnterValidVehiclePlate;

  /// No description provided for @accountInfo.
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get accountInfo;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @fillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields'**
  String get fillAllFields;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign In'**
  String get alreadyHaveAccount;

  /// No description provided for @documentsUploadLater.
  ///
  /// In en, this message translates to:
  /// **'Document upload will be available after approval. You can continue without uploading documents now.'**
  String get documentsUploadLater;

  /// No description provided for @applicationSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Application Submitted Successfully!'**
  String get applicationSubmitted;

  /// No description provided for @applicationSubmittedDesc.
  ///
  /// In en, this message translates to:
  /// **'Your application will be reviewed by our team. You will receive an email notification once your application is approved. Please sign in after receiving the approval email.'**
  String get applicationSubmittedDesc;

  /// No description provided for @dataUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Data updated successfully'**
  String get dataUpdatedSuccessfully;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @excuseRefused.
  ///
  /// In en, this message translates to:
  /// **'Excuse Refused'**
  String get excuseRefused;

  /// No description provided for @mustDeliverOrder.
  ///
  /// In en, this message translates to:
  /// **'You must deliver this order'**
  String get mustDeliverOrder;

  /// No description provided for @refusalReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get refusalReason;

  /// No description provided for @pendingAdminReview.
  ///
  /// In en, this message translates to:
  /// **'Orders pending review'**
  String get pendingAdminReview;

  /// No description provided for @buttonsDisabledUntilReview.
  ///
  /// In en, this message translates to:
  /// **'Actions disabled until admin reviews your request'**
  String get buttonsDisabledUntilReview;

  /// No description provided for @pleaseGoOnlineToReceiveOrders.
  ///
  /// In en, this message translates to:
  /// **'Please go online to receive orders'**
  String get pleaseGoOnlineToReceiveOrders;

  /// No description provided for @chooseResetMethod.
  ///
  /// In en, this message translates to:
  /// **'Choose how you\'d like to reset your password'**
  String get chooseResetMethod;

  /// No description provided for @resetByEmail.
  ///
  /// In en, this message translates to:
  /// **'Reset by Email'**
  String get resetByEmail;

  /// No description provided for @resetByEmailDesc.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send a password reset link to your email'**
  String get resetByEmailDesc;

  /// No description provided for @resetByPhone.
  ///
  /// In en, this message translates to:
  /// **'Reset by Phone'**
  String get resetByPhone;

  /// No description provided for @resetByPhoneDesc.
  ///
  /// In en, this message translates to:
  /// **'Verify your phone number and set a new password'**
  String get resetByPhoneDesc;

  /// No description provided for @sendOtpCode.
  ///
  /// In en, this message translates to:
  /// **'Send Verification Code'**
  String get sendOtpCode;

  /// No description provided for @enterPhoneToReset.
  ///
  /// In en, this message translates to:
  /// **'Enter the phone number linked to your account'**
  String get enterPhoneToReset;

  /// No description provided for @setNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Set New Password'**
  String get setNewPassword;

  /// No description provided for @enterNewPasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password below'**
  String get enterNewPasswordDesc;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @updatePassword.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get updatePassword;

  /// No description provided for @passwordUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Password Updated Successfully!'**
  String get passwordUpdatedSuccessfully;

  /// No description provided for @youCanNowSignIn.
  ///
  /// In en, this message translates to:
  /// **'You can now sign in with your new password'**
  String get youCanNowSignIn;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
