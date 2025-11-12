import 'package:flutter/material.dart';
import 'dart:async';
import '../const/lib_colors.dart';
import '../const/lib_fonts.dart';

class EthiopianTimeViewer extends StatefulWidget {
  final String language; // 'am' for Amharic, 'ao' for Oromo, 'en' for English
  final TextStyle? timeStyle;
  final TextStyle? periodStyle;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  const EthiopianTimeViewer({
    Key? key,
    this.language = 'en',
    this.timeStyle,
    this.periodStyle,
    this.backgroundColor,
    this.padding,
  }) : super(key: key);

  @override
  State<EthiopianTimeViewer> createState() => _EthiopianTimeViewerState();
}

class _EthiopianTimeViewerState extends State<EthiopianTimeViewer> {
  Timer? _timer;
  String _timeString = '';
  String _periodString = '';

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateTime());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      final ethiopianTime = _convertToEthiopianTime(now);
      _timeString = ethiopianTime['time']!;
      _periodString = ethiopianTime['period']!;
    });
  }

  Map<String, String> _convertToEthiopianTime(DateTime dateTime) {
    int hour = dateTime.hour;
    int minute = dateTime.minute;
    int second = dateTime.second;

    // Ethiopian time system:
    // 6 AM Western = 12:00 Day (ቀን) Ethiopian
    // 7 AM Western = 1:00 Day Ethiopian
    // 12 PM Western = 6:00 Day Ethiopian
    // 6 PM Western = 12:00 Night (ሌሊት) Ethiopian
    // 7 PM Western = 1:00 Night Ethiopian
    // 12 AM Western = 6:00 Night Ethiopian

    String period;
    int ethiopianHour;

    if (hour >= 6 && hour < 18) {
      // Day time: 6 AM to 6 PM Western
      period = _getPeriodText('day');
      ethiopianHour = (hour - 6 + 12) % 12;
      if (ethiopianHour == 0) {
        ethiopianHour = 12;
      }
    } else {
      // Night time: 6 PM to 6 AM Western
      period = _getPeriodText('night');
      if (hour >= 18) {
        // 6 PM to midnight
        ethiopianHour = (hour - 18 + 12) % 12;
      } else {
        // Midnight to 6 AM
        ethiopianHour = hour + 6;
      }
      if (ethiopianHour == 0) {
        ethiopianHour = 12;
      }
    }

    String timeString = '${ethiopianHour.toString().padLeft(2, '0')}:'
        '${minute.toString().padLeft(2, '0')}:'
        '${second.toString().padLeft(2, '0')}';

    return {
      'time': timeString,
      'period': period,
    };
  }

  String _getPeriodText(String period) {
    Map<String, Map<String, String>> periods = {
      'en': {
        'day': 'Day',
        'night': 'Night',
      },
      'am': {
        'day': 'ቀን',
        'night': 'ሌሊት',
      },
      'ao': {
        'day': 'Guyyaa',
        'night': 'Halkan',
      },
    };

    return periods[widget.language]?[period] ?? periods['en']![period]!;
  }

  String _getTimeLabel() {
    Map<String, String> labels = {
      'en': 'Ethiopian Time',
      'am': 'የኢትዮጵያ ሰዓት',
      'ao': 'Sa\'aatii Itoophiyaa',
    };

    return labels[widget.language] ?? labels['en']!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding ?? const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? LibColors.whiteColor,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: LibColors.grey300,
          width: 1.0,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _getTimeLabel(),
            style: EthiopianDatePickerFont.textFont().copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: LibColors.grey600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _timeString,
                style: widget.timeStyle ??
                    EthiopianDatePickerFont.textFont().copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: LibColors.blackColor,
                    ),
              ),
              const SizedBox(width: 8),
              Text(
                _periodString,
                style: widget.periodStyle ??
                    EthiopianDatePickerFont.textFont().copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: LibColors.grey700,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}