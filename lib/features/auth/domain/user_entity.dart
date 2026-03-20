import 'package:equatable/equatable.dart';

/// User entity representing authenticated user
class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime? lastActive;

  const UserEntity({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    required this.createdAt,
    this.lastActive,
  });

  /// Create UserEntity from Firebase User
  factory UserEntity.fromFirebaseUser({
    required String uid,
    required String email,
    String? displayName,
    String? photoUrl,
  }) {
    return UserEntity(
      id: uid,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
      createdAt: DateTime.now(),
      lastActive: DateTime.now(),
    );
  }

  /// Create UserEntity from Firestore document
  factory UserEntity.fromFirestore(Map<String, dynamic> data, String id) {
    return UserEntity(
      id: id,
      email: data['email'] as String,
      displayName: data['displayName'] as String?,
      photoUrl: data['photoUrl'] as String?,
      createdAt: (data['createdAt'] as dynamic).toDate() as DateTime,
      lastActive: data['lastActive'] != null
          ? (data['lastActive'] as dynamic).toDate() as DateTime
          : null,
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'createdAt': createdAt,
      'lastActive': lastActive ?? DateTime.now(),
    };
  }

  /// Copy with updated fields
  UserEntity copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? lastActive,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    displayName,
    photoUrl,
    createdAt,
    lastActive,
  ];
}
