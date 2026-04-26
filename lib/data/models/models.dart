import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { member, wardCoordinator, lgaCoordinator, stateAdmin }

class UserModel {
  final String uid;
  final String phoneNumber;
  final String name;
  final String lga;
  final String ward;
  final UserRole role;
  final String? referralCode;
  final int points;
  final List<String> badges;

  UserModel({
    required this.uid,
    required this.phoneNumber,
    required this.name,
    required this.lga,
    required this.ward,
    required this.role,
    this.referralCode,
    this.points = 0,
    this.badges = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'phoneNumber': phoneNumber,
      'name': name,
      'lga': lga,
      'ward': ward,
      'role': role.name,
      'referralCode': referralCode,
      'points': points,
      'badges': badges,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      name: map['name'] ?? '',
      lga: map['lga'] ?? '',
      ward: map['ward'] ?? '',
      role: UserRole.values.firstWhere((e) => e.name == map['role'], orElse: () => UserRole.member),
      referralCode: map['referralCode'],
      points: map['points'] ?? 0,
      badges: List<String>.from(map['badges'] ?? []),
    );
  }
}

enum MessageType { text, image, voice, video }

class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String content; // This will be encrypted in Firestore
  final DateTime timestamp;
  final MessageType type;
  final bool isRead;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    this.type = MessageType.text,
    this.isRead = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'timestamp': Timestamp.fromDate(timestamp),
      'type': type.name,
      'isRead': isRead,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] ?? '',
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      content: map['content'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      type: MessageType.values.firstWhere((e) => e.name == map['type'], orElse: () => MessageType.text),
      isRead: map['isRead'] ?? false,
    );
  }
}

class EventModel {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final String location;
  final double latitude;
  final double longitude;
  final List<String> interestedUserIds;
  final bool isLive;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.location,
    required this.latitude,
    required this.longitude,
    this.interestedUserIds = const [],
    this.isLive = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateTime': Timestamp.fromDate(dateTime),
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'interestedUserIds': interestedUserIds,
      'isLive': isLive,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      dateTime: (map['dateTime'] as Timestamp).toDate(),
      location: map['location'] ?? '',
      latitude: map['latitude'] ?? 0.0,
      longitude: map['longitude'] ?? 0.0,
      interestedUserIds: List<String>.from(map['interestedUserIds'] ?? []),
      isLive: map['isLive'] ?? false,
    );
  }
}
