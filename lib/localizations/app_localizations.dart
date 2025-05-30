import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    final localizations = Localizations.of<AppLocalizations>(context, AppLocalizations);
    if (localizations == null) {
      // Return a default instance with English locale if localization is not yet initialized
      return AppLocalizations(const Locale('en'));
    }
    return localizations;
  }

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'personal_details': 'Personal Details',
      'notifications': 'Notifications',
      'faq': 'FAQ',
      'contact_us': 'Contact Us',
      'privacy_terms': 'Privacy and Terms',
      'logout': 'Logout',
      'loading': 'Loading...',
      'error_loading_car': 'Error loading car',
      'unknown_car': 'Unknown Car',
      'charging_trucks': 'Charging Trucks Near You',
      'select_service': 'Select Service',
      'electric_charging': 'Electric Charging',
      'gasoline': 'Gasoline',
      'light_maintenance': 'Light Maintenance',
      'selected': 'Selected',
      'enter_location': 'Enter Location or City',
      'available_trucks': 'Available Trucks',
      'no_trucks_available': 'No trucks available or location not detected',
      'service_type': 'Service',
      'distance': 'Distance',
      'request': 'Request',
      'in': 'in',
      'minutes': 'min',
    },
    'ar': {
      'personal_details': 'البيانات الشخصية',
      'notifications': 'الإشعارات',
      'faq': 'الأسئلة الشائعة',
      'contact_us': 'اتصل بنا',
      'privacy_terms': 'الخصوصية والشروط',
      'logout': 'تسجيل الخروج',
      'loading': 'جاري التحميل...',
      'error_loading_car': 'خطأ في تحميل بيانات السيارة',
      'unknown_car': 'سيارة غير معروفة',
      'charging_trucks': 'شاحنات الشحن القريبة منك',
      'select_service': 'اختر الخدمة',
      'electric_charging': 'شحن كهربائي',
      'gasoline': 'بنزين',
      'light_maintenance': 'صيانة خفيفة',
      'selected': 'تم اختيار',
      'enter_location': 'أدخل الموقع أو المدينة',
      'available_trucks': 'الشاحنات المتوفرة',
      'no_trucks_available': 'لا توجد شاحنات متوفرة أو لم يتم تحديد الموقع',
      'service_type': 'الخدمة',
      'distance': 'المسافة',
      'request': 'طلب',
      'in': 'في',
      'minutes': 'دقيقة',
    },
  };

  String get(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
} 