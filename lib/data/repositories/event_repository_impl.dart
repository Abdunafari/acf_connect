import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/models.dart';

class EventRepositoryImpl {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createEvent(EventModel event) async {
    await _firestore.collection('events').doc(event.id).set(event.toMap());
  }

  Stream<List<EventModel>> getEvents() {
    return _firestore.collection('events').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => EventModel.fromMap(doc.data())).toList();
    });
  }

  Future<void> toggleRSVP(String eventId, String userId) async {
    final docRef = _firestore.collection('events').doc(eventId);
    final doc = await docRef.get();
    if (doc.exists) {
      List<String> interested = List<String>.from(doc.data()?['interestedUserIds'] ?? []);
      if (interested.contains(userId)) {
        interested.remove(userId);
      } else {
        interested.add(userId);
      }
      await docRef.update({'interestedUserIds': interested});
    }
  }
}
