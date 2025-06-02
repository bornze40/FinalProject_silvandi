part of 'nfc_poll_bloc.dart';

// TODO: 1. Complete the state class implementation.
/// The class should have the following parameters as the states:
/// - NFCTag? metadata
/// - NDEFRecord? data
/// - Assignment? assignment
/// - String? status
@immutable
class NfcPollState {
  final NFCTag? metadata;
  final NDEFRecord? data;
  final Assignment? assignment;
  final String? status;

  const NfcPollState({this.metadata, this.data, this.assignment, this.status});

  NfcPollState copyWith({
    NFCTag? metadata,
    NDEFRecord? data,
    Assignment? assignment,
    String? status,
  }) {
    return NfcPollState(
        metadata: metadata ?? this.metadata,
        data: data ?? this.data,
        assignment: assignment ?? this.assignment,
        status: status ?? this.status);
  }
}
