import 'package:flutter/services.dart';

/// Custom formatter for date input that enforces dd/mm/yyyy format
class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    /// Allow deleting
    if (text.length < oldValue.text.length) {
      return newValue;
    }

    /// Remove any non-digit characters except /
    String cleaned = text.replaceAll(RegExp(r'[^\d/]'), '');

    // Don't allow consecutive slashes
    cleaned = cleaned.replaceAll(RegExp(r'/+'), '/');

    // Split by / to check each part
    List<String> parts = cleaned.split('/');

    // Validate and limit each part
    String formatted = '';

    if (parts.isNotEmpty) {
      // Day - max 2 digits, max value 31
      String day = parts[0];
      if (day.length > 2) {
        day = day.substring(0, 2);
      }
      if (day.isNotEmpty && int.tryParse(day) != null) {
        int dayNum = int.parse(day);
        if (dayNum > 31) {
          day = '31';
        }
      }
      formatted = day;

      // Auto-add slash after 2 digits for day
      if (day.length == 2 && text.endsWith(day) && !text.contains('/')) {
        formatted += '/';
      }
    }

    if (parts.length > 1) {
      // Month - max 2 digits, max value 13 (for Ethiopian calendar)
      String month = parts[1];
      if (month.length > 2) {
        month = month.substring(0, 2);
      }
      if (month.isNotEmpty && int.tryParse(month) != null) {
        int monthNum = int.parse(month);
        if (monthNum > 13) {
          month = '13';
        }
      }
      formatted += '/$month';

      // Auto-add slash after 2 digits for month
      if (month.length == 2 && text.endsWith(month) && parts.length == 2) {
        formatted += '/';
      }
    }

    if (parts.length > 2) {
      // Year - max 4 digits
      String year = parts[2];
      if (year.length > 4) {
        year = year.substring(0, 4);
      }
      formatted += '/$year';
    }

    /// Don't allow more than 3 parts (dd/mm/yyyy)
    if (parts.length > 3) {
      formatted = oldValue.text;
    }

    /// Limit total length (dd/mm/yyyy = 10 characters)
    if (formatted.length > 10) {
      formatted = formatted.substring(0, 10);
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Formatter for Gregorian dates with standard month validation
class GregorianDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    /// Allow deleting
    if (text.length < oldValue.text.length) {
      return newValue;
    }

    /// Remove any non-digit characters except /
    String cleaned = text.replaceAll(RegExp(r'[^\d/]'), '');

    /// Don't allow consecutive slashes
    cleaned = cleaned.replaceAll(RegExp(r'/+'), '/');

    /// Split by / to check each part
    List<String> parts = cleaned.split('/');

    /// Validate and limit each part
    String formatted = '';

    if (parts.isNotEmpty) {
      /// Day - max 2 digits, max value 31
      String day = parts[0];
      if (day.length > 2) {
        day = day.substring(0, 2);
      }
      if (day.isNotEmpty && int.tryParse(day) != null) {
        int dayNum = int.parse(day);
        if (dayNum > 31) {
          day = '31';
        }
      }
      formatted = day;

      /// Auto-add slash after 2 digits for day
      if (day.length == 2 && text.endsWith(day) && !text.contains('/')) {
        formatted += '/';
      }
    }

    if (parts.length > 1) {
      /// Month - max 2 digits, max value 12 (for Gregorian calendar)
      String month = parts[1];
      if (month.length > 2) {
        month = month.substring(0, 2);
      }
      if (month.isNotEmpty && int.tryParse(month) != null) {
        int monthNum = int.parse(month);
        if (monthNum > 12) {
          month = '12';
        }
      }
      formatted += '/$month';

      /// Auto-add slash after 2 digits for month
      if (month.length == 2 && text.endsWith(month) && parts.length == 2) {
        formatted += '/';
      }
    }

    if (parts.length > 2) {
      /// Year - max 4 digits
      String year = parts[2];
      if (year.length > 4) {
        year = year.substring(0, 4);
      }
      formatted += '/$year';
    }

    /// Don't allow more than 3 parts (dd/mm/yyyy)
    if (parts.length > 3) {
      formatted = oldValue.text;
    }

    /// Limit total length (dd/mm/yyyy = 10 characters)
    if (formatted.length > 10) {
      formatted = formatted.substring(0, 10);
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}