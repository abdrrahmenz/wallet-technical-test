import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id')
  ];

  /// General settings section title
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// Privacy policy menu item
  ///
  /// In en, this message translates to:
  /// **'Privacy & Policy'**
  String get privacyPolicy;

  /// Terms of service menu item
  ///
  /// In en, this message translates to:
  /// **'Term of Service'**
  String get termOfService;

  /// Help menu item
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// Change language menu item
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// Title for language selection dialog
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Indonesian language option
  ///
  /// In en, this message translates to:
  /// **'Indonesia'**
  String get indonesia;

  /// Change theme menu item
  ///
  /// In en, this message translates to:
  /// **'Change Theme'**
  String get changeTheme;

  /// Language label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Hello greeting
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// Hello user greeting
  ///
  /// In en, this message translates to:
  /// **'Hello User'**
  String get helloUser;

  /// Username placeholder text
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// Confirmation message for sign out
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get confirmSignOut;

  /// Description for sign out action
  ///
  /// In en, this message translates to:
  /// **'You will be logged out of this account, but you can login again.'**
  String get signOutDescription;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Yes button text
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// Transactions title
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// Message when no wallets are available
  ///
  /// In en, this message translates to:
  /// **'No wallets found'**
  String get noWalletsFound;

  /// Message prompting user to create a wallet
  ///
  /// In en, this message translates to:
  /// **'Create a wallet first to start making transactions'**
  String get createWalletFirst;

  /// Select wallet dropdown label
  ///
  /// In en, this message translates to:
  /// **'Select Wallet'**
  String get selectWallet;

  /// Placeholder text for wallet selection
  ///
  /// In en, this message translates to:
  /// **'Choose a wallet...'**
  String get chooseWallet;

  /// Instruction to select a wallet
  ///
  /// In en, this message translates to:
  /// **'Select a wallet'**
  String get selectAWallet;

  /// New transaction button text
  ///
  /// In en, this message translates to:
  /// **'New Transaction'**
  String get newTransaction;

  /// Deposit transaction type
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get deposit;

  /// Withdrawal transaction type
  ///
  /// In en, this message translates to:
  /// **'Withdrawal'**
  String get withdrawal;

  /// Deposit money page title
  ///
  /// In en, this message translates to:
  /// **'Deposit Money'**
  String get depositMoney;

  /// Withdraw money page title
  ///
  /// In en, this message translates to:
  /// **'Withdraw Money'**
  String get withdrawMoney;

  /// Deposit description
  ///
  /// In en, this message translates to:
  /// **'Add money to your wallet'**
  String get addMoneyToWallet;

  /// Withdrawal description
  ///
  /// In en, this message translates to:
  /// **'Withdraw money from your wallet'**
  String get withdrawMoneyFromWallet;

  /// Transaction details page title
  ///
  /// In en, this message translates to:
  /// **'Transaction Details'**
  String get transactionDetails;

  /// Error message when transaction is not found
  ///
  /// In en, this message translates to:
  /// **'Transaction not found'**
  String get transactionNotFound;

  /// Go back button text
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// Wallet details page title
  ///
  /// In en, this message translates to:
  /// **'Wallet Details'**
  String get walletDetails;

  /// Error message when wallet is not found
  ///
  /// In en, this message translates to:
  /// **'Wallet not found'**
  String get walletNotFound;

  /// Withdraw button text
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get withdraw;

  /// View transactions button text
  ///
  /// In en, this message translates to:
  /// **'View Transactions'**
  String get viewTransactions;

  /// Error message for failed transaction loading
  ///
  /// In en, this message translates to:
  /// **'Failed to load transactions'**
  String get failedToLoadTransactions;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Create wallet button text
  ///
  /// In en, this message translates to:
  /// **'Create Wallet'**
  String get createWallet;

  /// Success message for deposit
  ///
  /// In en, this message translates to:
  /// **'Deposit successful!'**
  String get depositSuccessful;

  /// Success message for withdrawal
  ///
  /// In en, this message translates to:
  /// **'Withdrawal successful!'**
  String get withdrawalSuccessful;

  /// Deposit funds heading
  ///
  /// In en, this message translates to:
  /// **'Deposit Funds'**
  String get depositFunds;

  /// Withdraw funds heading
  ///
  /// In en, this message translates to:
  /// **'Withdraw Funds'**
  String get withdrawFunds;

  /// Deposit description text
  ///
  /// In en, this message translates to:
  /// **'Add money to your wallet securely and instantly'**
  String get addMoneySecurely;

  /// Processing transaction message
  ///
  /// In en, this message translates to:
  /// **'Processing transaction...'**
  String get processingTransaction;

  /// Security note heading
  ///
  /// In en, this message translates to:
  /// **'Security Note'**
  String get securityNote;

  /// Security note for deposits
  ///
  /// In en, this message translates to:
  /// **'Your deposits are protected with bank-level security. All transactions are encrypted and monitored.'**
  String get depositSecurityNote;

  /// Security note for withdrawals
  ///
  /// In en, this message translates to:
  /// **'Withdrawals are processed securely. Please ensure you have sufficient funds before proceeding.'**
  String get withdrawalSecurityNote;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// Loading message
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Manage digital wallets section title
  ///
  /// In en, this message translates to:
  /// **'Manage Digital Wallets'**
  String get manageDigitalWallets;

  /// Description for wallet management section
  ///
  /// In en, this message translates to:
  /// **'View, edit, and organize your wallets'**
  String get viewEditOrganizeWallets;

  /// Validation message for invalid amount input
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount'**
  String get pleaseEnterValidAmount;

  /// Generic transaction failure message
  ///
  /// In en, this message translates to:
  /// **'Transaction failed'**
  String get transactionFailed;

  /// Message shown when text is copied to clipboard
  ///
  /// In en, this message translates to:
  /// **'copied to clipboard'**
  String get copiedToClipboard;

  /// Created date field label
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// Last updated field label
  ///
  /// In en, this message translates to:
  /// **'Last Updated'**
  String get lastUpdated;

  /// Label for currencies dropdown
  ///
  /// In en, this message translates to:
  /// **'Currencies'**
  String get currencies;

  /// US Dollar currency name
  ///
  /// In en, this message translates to:
  /// **'US Dollar (USD)'**
  String get usdCurrency;

  /// Euro currency name
  ///
  /// In en, this message translates to:
  /// **'Euro (EUR)'**
  String get eurCurrency;

  /// British Pound currency name
  ///
  /// In en, this message translates to:
  /// **'British Pound (GBP)'**
  String get gbpCurrency;

  /// Japanese Yen currency name
  ///
  /// In en, this message translates to:
  /// **'Japanese Yen (JPY)'**
  String get jpyCurrency;

  /// Indonesian Rupiah currency name
  ///
  /// In en, this message translates to:
  /// **'Indonesian Rupiah (IDR)'**
  String get idrCurrency;

  /// Title for create new wallet section
  ///
  /// In en, this message translates to:
  /// **'Create New Wallet'**
  String get createNewWallet;

  /// Currency field label
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// Initial balance field label
  ///
  /// In en, this message translates to:
  /// **'Initial Balance (Optional)'**
  String get initialBalanceOptional;

  /// Wallet information section title
  ///
  /// In en, this message translates to:
  /// **'Wallet Information'**
  String get walletInformation;

  /// Wallet ID field label
  ///
  /// In en, this message translates to:
  /// **'Wallet ID'**
  String get walletId;

  /// Balance field label
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// Transaction ID field label
  ///
  /// In en, this message translates to:
  /// **'Transaction ID'**
  String get transactionId;

  /// Section title for user's wallets list
  ///
  /// In en, this message translates to:
  /// **'Your Wallets'**
  String get yourWallets;

  /// Message shown when user has no wallets
  ///
  /// In en, this message translates to:
  /// **'No wallets yet'**
  String get noWalletsYet;

  /// Message prompting user to create their first wallet
  ///
  /// In en, this message translates to:
  /// **'Create your first wallet to get started'**
  String get createFirstWalletToGetStarted;

  /// Message shown when wallet has no transactions
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get noTransactionsYet;

  /// Message indicating where transactions will be displayed
  ///
  /// In en, this message translates to:
  /// **'Your transactions will appear here'**
  String get transactionsWillAppearHere;

  /// Refresh button text
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// Label for a transaction
  ///
  /// In en, this message translates to:
  /// **'Transaction'**
  String get transaction;

  /// Error message shown when transaction details cannot be displayed
  ///
  /// In en, this message translates to:
  /// **'Error displaying transaction details'**
  String get errorRenderingTransactionDetails;

  /// Amount field label
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// Placeholder text for amount input field
  ///
  /// In en, this message translates to:
  /// **'Enter amount'**
  String get enterAmount;

  /// Validation message for empty amount input
  ///
  /// In en, this message translates to:
  /// **'Please enter an amount'**
  String get pleaseEnterAmount;

  /// Description field label
  ///
  /// In en, this message translates to:
  /// **'Description (Optional)'**
  String get descriptionOptional;

  /// Placeholder text for description input field
  ///
  /// In en, this message translates to:
  /// **'Enter description'**
  String get enterDescription;

  /// Reference ID field label
  ///
  /// In en, this message translates to:
  /// **'Reference ID (Optional)'**
  String get referenceIdOptional;

  /// Placeholder text for reference ID input field
  ///
  /// In en, this message translates to:
  /// **'Enter reference ID'**
  String get enterReferenceId;

  /// Description field label
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Reference ID field label
  ///
  /// In en, this message translates to:
  /// **'Reference ID'**
  String get referenceId;

  /// Created At field label
  ///
  /// In en, this message translates to:
  /// **'Created At'**
  String get createdAt;

  /// Updated At field label
  ///
  /// In en, this message translates to:
  /// **'Updated At'**
  String get updatedAt;

  /// Wallet navigation label
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// Settings navigation label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Login page title
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Login page subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get signInToContinue;

  /// Text shown for users without an account
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// Sign up text for registration link
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// Text shown for users with an existing account
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// Sign in text for login link
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// Register page subtitle
  ///
  /// In en, this message translates to:
  /// **'Register and happy shopping'**
  String get registerAndHappyShopping;

  /// Optional full name field label
  ///
  /// In en, this message translates to:
  /// **'Full Name (Optional)'**
  String get fullNameOptional;

  /// Hint text for full name input
  ///
  /// In en, this message translates to:
  /// **'Your full name'**
  String get yourFullName;

  /// Error message for invalid name
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid name'**
  String get pleaseEnterValidName;

  /// Email address field label
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// Hint text for email address input
  ///
  /// In en, this message translates to:
  /// **'Your email address'**
  String get yourEmailAddress;

  /// Error message for invalid email
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterValidEmail;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Hint text for password input
  ///
  /// In en, this message translates to:
  /// **'Your password (min. 8 characters)'**
  String get yourPasswordMinChars;

  /// Error message for password minimum length
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordMinCharsError;

  /// Message shown when registration is successful
  ///
  /// In en, this message translates to:
  /// **'Registration successful!'**
  String get registrationSuccessful;

  /// Hint text for password input in login form
  ///
  /// In en, this message translates to:
  /// **'Your password'**
  String get yourPassword;

  /// Error message for password minimum length in login form
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'id': return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
