// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  runApp(const PlatformViewApp());
}

class PlatformViewApp extends StatefulWidget {
  const PlatformViewApp({super.key});

  @override
  PlatformViewAppState createState() => PlatformViewAppState();
}

class PlatformViewAppState extends State<PlatformViewApp> {
  AdWidget _getBannerWidget() {
    // Test IDs from Admob:
    // https://developers.google.com/admob/ios/test-ads
    // https://developers.google.com/admob/android/test-ads
    final String bannerId = Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/6300978111'
        : 'ca-app-pub-3940256099942544/2934735716';
    final BannerAd bannerAd = BannerAd(
      adUnitId: bannerId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: const BannerAdListener(),
    );
    bannerAd.load();
    return AdWidget(ad: bannerAd);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced Layout',
      home: Scaffold(
        appBar: AppBar(title: const Text('Platform View Ad Banners')),
        body: ListView.builder(
          key: const Key('platform-views-scroll'), // This key is used by the driver test.
          itemCount: 250,
          itemBuilder: (BuildContext context, int index) {
            if (index.isEven) {
              // Workaround: Limit banners to prevent crash when more than 5 are on screen.
              // Only show banners at spaced intervals to ensure max 5 visible at once.
              // See: https://github.com/flutter/flutter/issues/144339
              // With 150px spacing items and 50px banners, showing every 6th even index
              // (every 12th item) ensures max 5 banners visible (assuming ~800px viewport).
              final int bannerIndex = index ~/ 2;
              if (bannerIndex % 6 == 0 && bannerIndex < 30) {
                // Use 320x50 Admob standard banner size.
                return SizedBox(width: 320, height: 50, child: _getBannerWidget());
              } else {
                // Replace additional banners with placeholder to prevent crash.
                return const SizedBox(height: 50, child: ColoredBox(color: Colors.grey));
              }
            } else {
              // Adjust the height to control number of platform views on screen.
              return const SizedBox(height: 150, child: ColoredBox(color: Colors.yellow));
            }
          },
        ),
      ),
    );
  }
}
