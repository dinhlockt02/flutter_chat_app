import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String id;
  final String idFrom;
  final String idTo;
  final String message;
  final Timestamp timestamp;

  const ChatMessage({
    required this.id,
    required this.idFrom,
    required this.idTo,
    required this.message,
    required this.timestamp,
  });

  ChatMessage.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options)
      : id = snapshot.id,
        idFrom = snapshot.data()?["idFrom"],
        idTo = snapshot.data()?["idTo"],
        message = snapshot.data()?["message"],
        timestamp = snapshot.data()?["timestamp"];

  Map<String, dynamic> toFirestore() {
    return {
      if (idFrom != null) "idFrom": idFrom,
      if (idTo != null) "idTo": idTo,
      if (message != null) "message": message,
      "timestamp": FieldValue.serverTimestamp(),
    };
  }
}
