import 'package:flutter/foundation.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:example/models/example_models.dart';
import 'package:example/services/example_services.dart';

/// Demonstrates AsyncController with posts and comments management
class PostController extends AsyncController<List<Post>> {
  final MockApiService _apiService = GetIt.instance<MockApiService>();
  
  List<Post> _posts = [];
  Post? _selectedPost;
  List<Comment> _comments = [];
  
  List<Post> get posts => _posts;
  Post? get selectedPost => _selectedPost;
  List<Comment> get comments => _comments;
  
  @override
  void onReady() {
    super.onReady();
    loadPosts();
  }
  
  /// Load all posts
  Future<void> loadPosts({int limit = 20}) async {
    await executeAsync(
      () async {
        final posts = await _apiService.getPosts(limit: limit);
        _posts = posts;
        return posts;
      },
      onSuccess: (posts) {
        if (kDebugMode) {
          print('✅ Loaded ${posts.length} posts successfully');
        }
      },
      onError: (error, stackTrace) {
        if (kDebugMode) {
          print('❌ Failed to load posts: $error');
        }
      },
    );
  }
  
  /// Load more posts (pagination)
  Future<void> loadMorePosts() async {
    if (isLoading) return;
    
    final currentPage = (_posts.length ~/ 20) + 1;
    
    await executeSilently(
      () async {
        final newPosts = await _apiService.getPosts(limit: 20, page: currentPage);
        _posts.addAll(newPosts);
        return _posts;
      },
      onSuccess: (posts) {
        if (kDebugMode) {
          print('✅ Loaded page $currentPage - Total posts: ${posts.length}');
        }
        notifyListeners();
      },
    );
  }
  
  /// Select a post and load its comments
  Future<void> selectPost(String postId) async {
    // Find post in existing list first
    _selectedPost = _posts.firstWhere(
      (post) => post.id == postId,
      orElse: () => Post(
        id: postId,
        title: 'Loading...',
        content: '',
        authorId: '',
        authorName: '',
        createdAt: DateTime.now(),
      ),
    );
    
    notifyListeners();
    
    // Load full post details and comments in parallel
    await Future.wait([
      _loadPostDetails(postId),
      _loadPostComments(postId),
    ]);
  }
  
  /// Load specific post details
  Future<void> _loadPostDetails(String postId) async {
    try {
      final post = await _apiService.getPostById(postId);
      if (post != null) {
        _selectedPost = post;
        // Update post in the main list if it exists
        final index = _posts.indexWhere((p) => p.id == postId);
        if (index != -1) {
          _posts[index] = post;
        }
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to load post details: $e');
      }
    }
  }
  
  /// Load comments for selected post
  Future<void> _loadPostComments(String postId) async {
    try {
      final comments = await _apiService.getComments(postId, limit: 15);
      _comments = comments;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to load comments: $e');
      }
    }
  }
  
  /// Get published posts only
  List<Post> getPublishedPosts() {
    return _posts.where((post) => post.isPublished).toList();
  }
  
  /// Get posts by tag
  List<Post> getPostsByTag(String tag) {
    return _posts.where((post) => post.tags.contains(tag)).toList();
  }
  
  /// Search posts by title or content
  List<Post> searchPosts(String query) {
    if (query.isEmpty) return _posts;
    
    return _posts.where((post) {
      return post.title.toLowerCase().contains(query.toLowerCase()) ||
             post.content.toLowerCase().contains(query.toLowerCase()) ||
             post.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase()));
    }).toList();
  }
  
  /// Get all unique tags from posts
  List<String> getAllTags() {
    final allTags = <String>{};
    for (final post in _posts) {
      allTags.addAll(post.tags);
    }
    return allTags.toList()..sort();
  }
  
  /// Get posts statistics
  Map<String, dynamic> getPostsStats() {
    if (_posts.isEmpty) return {};
    
    final publishedCount = _posts.where((p) => p.isPublished).length;
    final totalLikes = _posts.fold<int>(0, (sum, post) => sum + post.likes);
    final totalComments = _posts.fold<int>(0, (sum, post) => sum + post.commentCount);
    final uniqueAuthors = _posts.map((p) => p.authorId).toSet().length;
    
    return {
      'total': _posts.length,
      'published': publishedCount,
      'draft': _posts.length - publishedCount,
      'total_likes': totalLikes,
      'total_comments': totalComments,
      'unique_authors': uniqueAuthors,
      'average_likes': totalLikes / _posts.length,
      'tags': getAllTags().length,
    };
  }
  
  /// Sort posts by different criteria
  void sortPosts(PostSortOption sortOption) {
    switch (sortOption) {
      case PostSortOption.newest:
        _posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case PostSortOption.oldest:
        _posts.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case PostSortOption.mostLiked:
        _posts.sort((a, b) => b.likes.compareTo(a.likes));
        break;
      case PostSortOption.mostCommented:
        _posts.sort((a, b) => b.commentCount.compareTo(a.commentCount));
        break;
      case PostSortOption.titleAZ:
        _posts.sort((a, b) => a.title.compareTo(b.title));
        break;
    }
    
    notifyListeners();
  }
  
  /// Clear selected post and comments
  void clearSelection() {
    _selectedPost = null;
    _comments.clear();
    notifyListeners();
  }
  
  /// Refresh all data
  Future<void> refreshAll() async {
    _posts.clear();
    _selectedPost = null;
    _comments.clear();
    await loadPosts();
  }
}

enum PostSortOption {
  newest,
  oldest,
  mostLiked,
  mostCommented,
  titleAZ,
}