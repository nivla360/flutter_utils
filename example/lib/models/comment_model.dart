class Comment {
  final String id;
  final String postId;
  final String content;
  final String authorId;
  final String authorName;
  final String? authorAvatarUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int likes;
  final String? parentId; // For nested comments
  final List<Comment> replies;

  const Comment({
    required this.id,
    required this.postId,
    required this.content,
    required this.authorId,
    required this.authorName,
    this.authorAvatarUrl,
    required this.createdAt,
    this.updatedAt,
    this.likes = 0,
    this.parentId,
    this.replies = const [],
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as String,
      postId: json['postId'] as String,
      content: json['content'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      authorAvatarUrl: json['authorAvatarUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      likes: json['likes'] as int? ?? 0,
      parentId: json['parentId'] as String?,
      replies: (json['replies'] as List<dynamic>?)
              ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'content': content,
      'authorId': authorId,
      'authorName': authorName,
      'authorAvatarUrl': authorAvatarUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'likes': likes,
      'parentId': parentId,
      'replies': replies.map((e) => e.toJson()).toList(),
    };
  }

  Comment copyWith({
    String? id,
    String? postId,
    String? content,
    String? authorId,
    String? authorName,
    String? authorAvatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? likes,
    String? parentId,
    List<Comment>? replies,
  }) {
    return Comment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      content: content ?? this.content,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorAvatarUrl: authorAvatarUrl ?? this.authorAvatarUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      likes: likes ?? this.likes,
      parentId: parentId ?? this.parentId,
      replies: replies ?? this.replies,
    );
  }

  bool get isReply => parentId != null;
  bool get hasReplies => replies.isNotEmpty;
  bool get isEdited => updatedAt != null && updatedAt!.isAfter(createdAt);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Comment && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Comment(id: $id, authorName: $authorName, likes: $likes, replies: ${replies.length})';
  }
}