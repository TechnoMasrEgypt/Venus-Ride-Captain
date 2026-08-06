import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/location_service.dart';
import '../widgets/ProgressDialog.dart';

class HelperMethods {
  static String formatBalance(dynamic amount) {
    final num value = (amount is num ? amount : double.tryParse(amount.toString()) ?? 0) / 100;
    return NumberFormat('#,##0.00', 'en_US').format(value);
  }
  static void disableLocationUpdates() {
    LocationService.instance.pauseTracking();
  }

  static void cancleLocationUpdates() {
    LocationService.instance.stopTracking();
  }

  static void enableLocationUpdates() {
    LocationService.instance.resumeTracking();
  }

  static void showProgressDialog(context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) =>
          ProgressDialog(status: 'Please wait...'),
    );
  }

  static Future<void> openMap(double lat, double long) async {
    String googleMapUrl = 'google.navigation:&q=$lat,$long';
    if (await canLaunchUrl(Uri.parse(googleMapUrl))) {
      await launchUrl(Uri.parse(googleMapUrl));
    }
  }

  static String parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }
}
