part of 'nfc_poll_bloc.dart';

@immutable
abstract class NfcPollEvent {}

// TODO: 1. Add the ReadEvent class.
class ReadEvent extends NfcPollEvent {}

// TODO: 2. Add the UpdateDataEvent class.
/// The class should have the following parameters as the inputs:
/// - NFCTag? metadata
/// - NDEFRecord? data
class UpdateDataEvent extends NfcPollEvent {
  UpdateDataEvent({this.metadata, this.data});
  final NFCTag? metadata;
  final NDEFRecord? data;
}

// TODO: 3. Add the WriteEvent class.
/// The class should have the following parameters as the inputs:
/// - Assignment assignment
class WriteEvent extends NfcPollEvent {
  WriteEvent({required this.assignment});
  final Assignment assignment;
}
