import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/constants.dart';

class GamificationRepositoryImpl {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addPoints(String userId, int points) async {
    await _firestore.collection('users').doc(userId).update({
      'points': FieldValue.increment(points),
    });
  }

  Future<void> recordDailyLogin(String userId) async {
    await addPoints(userId, AppConstants.pointsDailyLogin);
  }

  Stream<List<Map<String, dynamic>>> getLeaderboard() {
    return _firestore
        .collection('users')
        .orderBy('points', descending: true)
        .limit(20)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}
