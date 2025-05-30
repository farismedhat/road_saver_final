import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // Auth
      'login': 'Login',
      'signup': 'Sign Up',
      'welcome_back': 'Glad you\'re back!',
      'email': 'Email',
      'password': 'Password',
      'forgot_password': 'Forgot Password?',
      'remember_me': 'Remember Me',
      'dont_have_account': 'Don\'t have an account?',
      'create_account': 'Create Account',
      
      // Map Page
      'road_map': 'Road Map',
      'settings': 'Settings',
      'personal_details': 'Personal Details',
      'notifications': 'Notifications',
      'faq': 'FAQ',
      'contact_us': 'Contact Us',
      'privacy_terms': 'Privacy and Terms',
      'logout': 'Logout',
      'select_service': 'Select Service',
      'electric_charging': 'Electric Charging',
      'gasoline': 'Gasoline',
      'light_maintenance': 'Light Maintenance',
      'charging_trucks': 'Charging Trucks Near You',
      'enter_location': 'Enter Location or City',
      'available_trucks': 'Available Trucks',
      'request': 'Request',
      'unknown_car': 'Unknown Car',
      'loading': 'Loading...',
      'error_loading_car': 'Error loading car',
      'no_trucks_available': 'No trucks available or location not detected',
      'service_type': 'Service Type',
      'distance': 'Distance',
      'estimated_time': 'Estimated Time',
      'minutes': 'minutes',
      
      // Settings
      'language': 'Language',
      'theme': 'Theme',
      'dark_mode': 'Dark Mode',
      'light_mode': 'Light Mode',
      
      // Validation Messages
      'enter_email': 'Please enter your email',
      'enter_valid_email': 'Please enter a valid email',
      'enter_password': 'Please enter your password',
      'password_length': 'Password must be at least 6 characters',
      
      // Error Messages
      'location_disabled': 'Location Services Disabled',
      'enable_location': 'Please enable location services from device settings and try again.',
      'location_permission_denied': 'Location Permission Denied',
      'allow_location': 'Please allow location permission from app settings.',
      'error': 'Error',
      'ok': 'OK',
      'cancel': 'Cancel',
      
      // Signup Page
      'create_new_account': 'Create New Account',
      'full_name': 'Full Name',
      'phone_number': 'Phone Number',
      'car_name': 'Car Name',
      'car_type': 'Car Type',
      'birth_date': 'Birth Date',
      'confirm_password': 'Confirm Password',
      'select_car_type': 'Select Car Type',
      'electric_car': 'Electric Car',
      'gasoline_car': 'Gasoline Car',
      'signup_with_google': 'Sign up with Google',
      'already_have_account': 'Already have an account?',
      'enter_name': 'Please enter your name',
      'enter_phone': 'Please enter your phone number',
      'enter_car_name': 'Please enter your car name',
      'select_birth_date': 'Please select your birth date',
      'passwords_dont_match': 'Passwords don\'t match',
      'select_car_type_message': 'Please select your car type',
      'signup_success': 'Signup completed! Please verify your email before logging in.',
      'email_already_registered': 'This email is already registered.',
      'error_occurred': 'An error occurred during signup.',
      'google_signup_error': 'An error occurred during Google signup.',
      'unexpected_error': 'Unexpected error: ',
      
      // Reset Password
      'reset_password': 'Reset Password',
      'reset_password_title': 'Forgot your password?',
      'reset_password_subtitle': 'Enter your email address and we\'ll send you a link to reset your password.',
      'send_reset_link': 'Send Reset Link',
      'reset_email_sent': 'Password reset email has been sent. Please check your inbox.',
      'back_to_login': 'Back to Login',
      'invalid_email': 'Invalid email address',
      'reset_email_error': 'Error sending reset email',
      'user_not_found': 'No user found with this email',
      
      // Login Error Messages
      'verify_email_message': 'Please verify your email before logging in.',
      'tap_to_resend_verification': 'Tap here to resend verification email.',
      'verification_email_sent': 'Verification email sent! Check your inbox.',
      'verification_email_error': 'Error sending verification email',
      'wrong_password': 'Incorrect password.',
      'login_error': 'An error occurred during login.',
    },
    'ar': {
      // Auth
      'login': 'تسجيل الدخول',
      'signup': 'إنشاء حساب',
      'welcome_back': 'سعداء بعودتك!',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'forgot_password': 'نسيت كلمة المرور؟',
      'remember_me': 'تذكرني',
      'dont_have_account': 'ليس لديك حساب؟',
      'create_account': 'إنشاء حساب',
      
      // Map Page
      'road_map': 'خريطة الطريق',
      'settings': 'الإعدادات',
      'personal_details': 'البيانات الشخصية',
      'notifications': 'الإشعارات',
      'faq': 'الأسئلة الشائعة',
      'contact_us': 'اتصل بنا',
      'privacy_terms': 'الخصوصية والشروط',
      'logout': 'تسجيل الخروج',
      'select_service': 'اختر الخدمة',
      'electric_charging': 'شحن كهربائي',
      'gasoline': 'بنزين',
      'light_maintenance': 'صيانة خفيفة',
      'charging_trucks': 'شاحنات الشحن القريبة منك',
      'enter_location': 'أدخل الموقع أو المدينة',
      'available_trucks': 'الشاحنات المتوفرة',
      'request': 'طلب',
      'unknown_car': 'سيارة غير معروفة',
      'loading': 'جاري التحميل...',
      'error_loading_car': 'خطأ في تحميل بيانات السيارة',
      'no_trucks_available': 'لا توجد شاحنات متوفرة أو لم يتم تحديد الموقع',
      'service_type': 'نوع الخدمة',
      'distance': 'المسافة',
      'estimated_time': 'الوقت المتوقع',
      'minutes': 'دقائق',
      
      // Settings
      'language': 'اللغة',
      'theme': 'المظهر',
      'dark_mode': 'الوضع الداكن',
      'light_mode': 'الوضع الفاتح',
      
      // Validation Messages
      'enter_email': 'الرجاء إدخال البريد الإلكتروني',
      'enter_valid_email': 'الرجاء إدخال بريد إلكتروني صحيح',
      'enter_password': 'الرجاء إدخال كلمة المرور',
      'password_length': 'كلمة المرور يجب أن تكون 6 أحرف على الأقل',
      
      // Error Messages
      'location_disabled': 'خدمات الموقع معطلة',
      'enable_location': 'الرجاء تفعيل خدمات الموقع من إعدادات الجهاز والمحاولة مرة أخرى.',
      'location_permission_denied': 'تم رفض إذن الموقع',
      'allow_location': 'الرجاء السماح بإذن الموقع من إعدادات التطبيق.',
      'error': 'خطأ',
      'ok': 'موافق',
      'cancel': 'إلغاء',
      
      // Signup Page
      'create_new_account': 'إنشاء حساب جديد',
      'full_name': 'الاسم الكامل',
      'phone_number': 'رقم الهاتف',
      'car_name': 'اسم السيارة',
      'car_type': 'نوع السيارة',
      'birth_date': 'تاريخ الميلاد',
      'confirm_password': 'تأكيد كلمة المرور',
      'select_car_type': 'اختر نوع السيارة',
      'electric_car': 'سيارة كهربائية',
      'gasoline_car': 'سيارة بنزين',
      'signup_with_google': 'التسجيل باستخدام جوجل',
      'already_have_account': 'لديك حساب بالفعل؟',
      'enter_name': 'الرجاء إدخال اسمك',
      'enter_phone': 'الرجاء إدخال رقم هاتفك',
      'enter_car_name': 'الرجاء إدخال اسم سيارتك',
      'select_birth_date': 'الرجاء اختيار تاريخ ميلادك',
      'passwords_dont_match': 'كلمات المرور غير متطابقة',
      'select_car_type_message': 'الرجاء اختيار نوع سيارتك',
      'signup_success': 'تم إنشاء الحساب! الرجاء التحقق من بريدك الإلكتروني قبل تسجيل الدخول.',
      'email_already_registered': 'هذا البريد الإلكتروني مسجل بالفعل.',
      'error_occurred': 'حدث خطأ أثناء التسجيل.',
      'google_signup_error': 'حدث خطأ أثناء التسجيل باستخدام جوجل.',
      'unexpected_error': 'خطأ غير متوقع: ',
      
      // Reset Password
      'reset_password': 'إعادة تعيين كلمة المرور',
      'reset_password_title': 'نسيت كلمة المرور؟',
      'reset_password_subtitle': 'أدخل عنوان بريدك الإلكتروني وسنرسل لك رابطًا لإعادة تعيين كلمة المرور.',
      'send_reset_link': 'إرسال رابط إعادة التعيين',
      'reset_email_sent': 'تم إرسال بريد إعادة تعيين كلمة المرور. يرجى التحقق من صندوق الوارد الخاص بك.',
      'back_to_login': 'العودة إلى تسجيل الدخول',
      'invalid_email': 'عنوان البريد الإلكتروني غير صالح',
      'reset_email_error': 'خطأ في إرسال بريد إعادة التعيين',
      'user_not_found': 'لم يتم العثور على مستخدم بهذا البريد الإلكتروني',
      
      // Login Error Messages
      'verify_email_message': 'يرجى التحقق من بريدك الإلكتروني قبل تسجيل الدخول.',
      'tap_to_resend_verification': 'انقر هنا لإعادة إرسال بريد التحقق.',
      'verification_email_sent': 'تم إرسال بريد التحقق! تحقق من صندوق الوارد الخاص بك.',
      'verification_email_error': 'خطأ في إرسال بريد التحقق',
      'wrong_password': 'كلمة المرور غير صحيحة.',
      'login_error': 'حدث خطأ أثناء تسجيل الدخول.',
    },
  };

  String get(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
} 