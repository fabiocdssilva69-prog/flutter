import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'video_call_controller.g.dart';

class VideoCallSession {
  final String id;
  final String callerId;
  final String receiverId;
  final String callerName;
  final String receiverName;
  final String status; // waiting, active, ended
  final DateTime createdAt;
  final String? roomId;

  VideoCallSession({
    required this.id,
    required this.callerId,
    required this.receiverId,
    required this.callerName,
    required this.receiverName,
    required this.status,
    required this.createdAt,
    this.roomId,
  });
}

@riverpod
class VideoCallController extends _$VideoCallController {
  @override
  Future<VideoCallSession?> build() async {
    return null;
  }

  Future<VideoCallSession> initiateCall({
    required String callerId,
    required String receiverId,
    required String callerName,
    required String receiverName,
  }) async {
    final docRef = await FirebaseFirestore.instance.collection('video_calls').add({
      'callerId': callerId,
      'receiverId': receiverId,
      'callerName': callerName,
      'receiverName': receiverName,
      'status': 'waiting',
      'createdAt': FieldValue.serverTimestamp(),
      'roomId': '${callerId}_${receiverId}_${DateTime.now().millisecondsSinceEpoch}',
    });

    final doc = await docRef.get();
    final data = doc.data()!;

    final session = VideoCallSession(
      id: doc.id,
      callerId: data['callerId'],
      receiverId: data['receiverId'],
      callerName: data['callerName'],
      receiverName: data['receiverName'],
      status: data['status'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      roomId: data['roomId'],
    );

    state = AsyncValue.data(session);
    return session;
  }

  Future<void> acceptCall(String sessionId) async {
    await FirebaseFirestore.instance.collection('video_calls').doc(sessionId).update({'status': 'active'});

    ref.invalidateSelf();
  }

  Future<void> endCall(String sessionId) async {
    await FirebaseFirestore.instance.collection('video_calls').doc(sessionId).update({
      'status': 'ended',
      'endedAt': FieldValue.serverTimestamp(),
    });

    state = const AsyncValue.data(null);
  }
}
