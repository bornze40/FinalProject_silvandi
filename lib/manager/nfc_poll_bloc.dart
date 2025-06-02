import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:h8_fli_nfc_starter/model/assignment.dart';
import 'package:h8_fli_nfc_starter/service/nfc_service.dart';
import 'package:meta/meta.dart';
import 'package:ndef/ndef.dart';

part 'nfc_poll_event.dart';
part 'nfc_poll_state.dart';

class NfcPollBloc extends Bloc<NfcPollEvent, NfcPollState> {
  // TODO: 1. Add NfcService as the dependency.
  final NfcService service;
  NfcPollBloc(this.service) : super(NfcPollState()) {
    // TODO: 2. Add the events implementation.
    on<ReadEvent>((event, emit) async {
      emit(state.copyWith(status: "Waiting For NFC.."));
      await service.pollTag();
      emit(state.copyWith(status: "NFC card detectd.."));
    });

    on<UpdateDataEvent>((event, emit) {
      Assignment? assignment;
      if (event.data != null) {
        final payload = event.data?.payload;
        if (payload != null) {
          try {
            final payloadString = utf8.decode(
              payload.sublist(1),
            ); // skip prefix byte
            log('Decoded payload: $payloadString');
            assignment = Assignment.fromJson(json.decode(payloadString));
          } catch (e) {
            log('Error decoding payload: $e');
          }
        }
      }

      emit(
        state.copyWith(
          metadata: event.metadata ?? state.metadata,
          data: event.data ?? state.data,
          assignment: assignment ?? state.assignment,
        ),
      );
    });

    on<WriteEvent>((event, emit) async {
      emit(state.copyWith(status: "writing.."));
      final ndefRecord = NDEFRecord(
        tnf: TypeNameFormat.nfcWellKnown,
        type: utf8.encode('UTF-8'),
        id: utf8.encode(event.assignment.staffId),
        payload: utf8.encode(json.encode(event.assignment.toJson())),
      );

      await service.writeTag(ndefRecord);
      emit(state.copyWith(status: 'Data Writing to NFC Card'));
    });

    // TODO: 3. Listen to NFCTag data stream, then update state.
    service.nfcTagStream.listen((nfcTag) {
      add(UpdateDataEvent(metadata: nfcTag));
    });

    // TODO: 4. Listen to NDEFRecords data stream, then update state.
    service.ndefRecordsStream.listen((ndefRecords) {
      add(UpdateDataEvent(data: ndefRecords.firstOrNull));
    });
  }
}
