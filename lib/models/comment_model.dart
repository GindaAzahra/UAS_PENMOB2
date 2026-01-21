class Comment {
  final String id;
  final String userId;
  final String userName;
  final String userImage;
  final String content;
  final DateTime createdAt;
  final List<Comment> replies;
  int likeCount;
  bool isLikedByUser;

  Comment({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.content,
    required this.createdAt,
    this.replies = const [],
    this.likeCount = 0,
    this.isLikedByUser = false,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userImage': userImage,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'replies': replies.map((r) => r.toJson()).toList(),
      'likeCount': likeCount,
      'isLikedByUser': isLikedByUser,
    };
  }

  // Create from JSON
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      userImage: json['userImage'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      replies: (json['replies'] as List<dynamic>?)
              ?.map((r) => Comment.fromJson(r as Map<String, dynamic>))
              .toList() ??
          [],
      likeCount: json['likeCount'] ?? 0,
      isLikedByUser: json['isLikedByUser'] ?? false,
    );
  }

  // Copy with method
  Comment copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userImage,
    String? content,
    DateTime? createdAt,
    List<Comment>? replies,
    int? likeCount,
    bool? isLikedByUser,
  }) {
    return Comment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userImage: userImage ?? this.userImage,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      replies: replies ?? this.replies,
      likeCount: likeCount ?? this.likeCount,
      isLikedByUser: isLikedByUser ?? this.isLikedByUser,
    );
  }

  // Format time elapsed
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inSeconds < 60) {
      return 'Baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m yang lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h yang lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d yang lalu';
    } else {
      return createdAt.toString().split(' ')[0];
    }
  }
}
