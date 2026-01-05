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
