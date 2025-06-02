import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:h8_fli_nfc_starter/manager/nfc_poll_bloc.dart';
import 'package:h8_fli_nfc_starter/service/nfc_service.dart';
import 'package:h8_fli_nfc_starter/view/nfc_poll_view.dart';

/// MARK: Setup Platform (Android).
// TODO: 1. Update minSDK inside android/app/build.gradle.kts to 28.

/// MARK: Setup Platform (iOS).
// TODO: 1. Activate developer mode on your iOS real device.
// TODO: 2. Enable "Automatically manage signing" and select team on XCode.
// TODO: 3. Add "Near Field Communication Tag Reading" capability on XCode.
// TODO: 4. Update minimum iOS version inside ios/Podfile to 14.

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // TODO: 1. Init the dependencies: NfcService & NfcPollBloc.
  late final NfcService _nfcService;
  late final NfcPollBloc _nfcPollBloc;

  @override
  void initState() {
    _nfcService = NfcService();
    _nfcPollBloc = NfcPollBloc(_nfcService);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: 2. Provide the bloc by wrap the MaterialApp with BlocProvider.
    return BlocProvider(
      create: (context) => _nfcPollBloc,
      child: MaterialApp(
        title: 'NFC Hands-On',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: NfcPollView(),
      ),
    );
  }
}
