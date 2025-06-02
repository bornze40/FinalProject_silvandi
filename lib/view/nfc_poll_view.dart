import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:h8_fli_nfc_starter/manager/nfc_poll_bloc.dart';
import 'package:h8_fli_nfc_starter/model/assignment.dart';
import 'dart:convert';
import 'dart:typed_data';

String decodePayload(Uint8List? payload) {
  if (payload == null) return 'Payload not found';
  try {
    final decoded = utf8.decode(payload.sublist(1)); // skip prefix byte
    final jsonMap = jsonDecode(decoded);
    return const JsonEncoder.withIndent('  ').convert(jsonMap);
  } catch (e) {
    return 'Invalid payload: $e';
  }
}

class NfcPollView extends StatelessWidget {
  const NfcPollView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),

          // TODO: 1. Wrap this widget tree with the BlocBuilder.
          child: BlocBuilder<NfcPollBloc, NfcPollState>(
            builder: (context, state) {
              return Column(
                spacing: 16.0,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: () {
                      // TODO: 2. Call a bloc event to start read the NFC tag.
                      context.read<NfcPollBloc>().add(ReadEvent());
                    },
                    child: Text('Read NFC'),
                  ),
                  Text('Status...'),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.brown),
                      color: Colors.brown.shade50,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'NFC Tag Metadata',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        Divider(height: 0.0, color: Colors.brown),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          // TODO: 3. Display the detected NFC metadata.
                          child: Text(
                            state.metadata?.toJson().toString() ??
                                'Data Not Found',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.brown),
                      color: Colors.brown.shade50,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'NFC Tag NDEF Data',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        Divider(height: 0.0, color: Colors.brown),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          // TODO: 4. Display the detected NFC NDEF data.
                          child: Text(
                            state.data != null
                                ? decodePayload(state.data!.payload)
                                : 'Data Not Found',
                            style: const TextStyle(fontFamily: 'monospace'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.brown),
                      color: Colors.brown.shade50,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Assignment',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        Divider(height: 0.0, color: Colors.brown),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            state.assignment != null
                                ? JsonEncoder.withIndent(
                                  '  ',
                                ).convert(state.assignment!.toJson())
                                : 'Data Not Found',
                            style: const TextStyle(fontFamily: 'monospace'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// MARK: Notes
                  /// Write NFC button should be visible only then the NFC tag
                  /// has NDEF records to write data.
                  FilledButton(
                    onPressed: () {
                      final startDate = DateTime.now();
                      final endDate = startDate.add(Duration(hours: 3));
                      // TODO: 5. Call a bloc event to start write data to NFC tag.
                      context.read<NfcPollBloc>().add(
                        WriteEvent(
                          assignment: Assignment(
                            staffId: 'ST-001',
                            taskDate: startDate.toString().split(' ').first,
                            taskStartTime: startDate.toString().split(' ').last,
                            taskEndTime: endDate.toString().split(' ').last,
                          ),
                        ),
                      );
                    },
                    child: Text('Write NFC'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
