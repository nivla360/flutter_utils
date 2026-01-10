class Post {
  final String id;
  final String title;
  final String content;
  final String authorId;
  final String authorName;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<String> tags;
  final int likes;
  final int commentCount;
  final bool isPublished;

  const Post({
    required this.id,
    required this.title,
    required this.content,
    required this.authorId,
    required this.authorName,
    required this.createdAt,
    this.updatedAt,
    this.tags = const [],
    this.likes = 0,
    this.commentCount = 0,
    this.isPublished = true,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      likes: json['likes'] as int? ?? 0,
      commentCount: json['commentCount'] as int? ?? 0,
      isPublished: json['isPublished'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'authorId': authorId,
      'authorName': authorName,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'tags': tags,
      'likes': likes,
      'commentCount': commentCount,
      'isPublished': isPublished,
    };
  }

  Post copyWith({
    String? id,
    String? title,
    String? content,
    String? authorId,
    String? authorName,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? tags,
    int? likes,
    int? commentCount,
    bool? isPublished,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
      likes: likes ?? this.likes,
      commentCount: commentCount ?? this.commentCount,
      isPublished: isPublished ?? this.isPublished,
    );
  }

  String get excerpt {
    if (content.length <= 150) return content;
    return '${content.substring(0, 150)}...';
  }

  bool get hasComments => commentCount > 0;
  bool get hasTags => tags.isNotEmpty;
  bool get isEdited => updatedAt != null && updatedAt!.isAfter(createdAt);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Post && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Post(id: $id, title: $title, authorName: $authorName, likes: $likes)';
  }
}