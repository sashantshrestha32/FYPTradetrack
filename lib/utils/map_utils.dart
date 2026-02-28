import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  static Future<void> openMapDirections({
    double? lat,
    double? lng,
    String? address,
    String? title,
  }) async {
    // Direct start navigation as requested
    await openExternalMap(lat: lat, lng: lng, address: address);
  }

  static Future<void> openExternalMap({
    double? lat,
    double? lng,
    String? address,
  }) async {
    Uri uri;

    if (lat != null && lng != null) {
      if (Platform.isAndroid) {
        uri = Uri.parse('google.navigation:q=$lat,$lng');
      } else if (Platform.isIOS) {
        uri = Uri.parse('https://maps.apple.com/?daddr=$lat,$lng');
      } else {
        uri = Uri.parse(
          'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng',
        );
      }
    } else if (address != null && address.isNotEmpty) {
      final encodedAddress = Uri.encodeComponent(address);
      if (Platform.isAndroid) {
        uri = Uri.parse('google.navigation:q=$encodedAddress');
      } else if (Platform.isIOS) {
        uri = Uri.parse('https://maps.apple.com/?daddr=$encodedAddress');
      } else {
        uri = Uri.parse(
          'https://www.google.com/maps/dir/?api=1&destination=$encodedAddress',
        );
      }
    } else {
      return;
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      final webUri = lat != null && lng != null
          ? Uri.parse(
              'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng',
            )
          : Uri.parse(
              'https://www.google.com/maps/dir/?api=1&destination=${Uri.encodeComponent(address!)}',
            );

      if (await canLaunchUrl(webUri)) {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch map';
      }
    }
  }
}
