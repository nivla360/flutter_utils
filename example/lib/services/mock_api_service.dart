import 'dart:math';
import 'package:example/models/example_models.dart';

class MockApiService {
  final Random _random = Random();
  
  // Simulate network delay
  Future<void> _delay([int? milliseconds]) async {
    await Future.delayed(
      Duration(milliseconds: milliseconds ?? _random.nextInt(1000) + 500),
    );
  }
  
  // Mock user data
  Future<List<User>> getUsers({int limit = 10, int page = 1}) async {
    await _delay();
    
    final startIndex = (page - 1) * limit;
    return List.generate(limit, (index) {
      final id = startIndex + index + 1;
      return User(
        id: id.toString(),
        name: _generateName(),
        email: 'user$id@example.com',
        avatarUrl: 'https://picsum.photos/200/200?random=$id',
        bio: _generateBio(),
        createdAt: DateTime.now().subtract(Duration(days: _random.nextInt(365))),
        isActive: _random.nextBool(),
      );
    });
  }
  
  Future<User?> getUserById(String id) async {
    await _delay();
    
    return User(
      id: id,
      name: _generateName(),
      email: 'user$id@example.com',
      avatarUrl: 'https://picsum.photos/200/200?random=$id',
      bio: _generateBio(),
      createdAt: DateTime.now().subtract(Duration(days: _random.nextInt(365))),
      isActive: _random.nextBool(),
    );
  }
  
  // Mock product data
  Future<List<Product>> getProducts({int limit = 10, int page = 1, String? category}) async {
    await _delay();
    
    final startIndex = (page - 1) * limit;
    return List.generate(limit, (index) {
      final id = startIndex + index + 1;
      final productCategory = category ?? _getRandomCategory();
      return Product(
        id: id.toString(),
        name: _generateProductName(productCategory),
        description: _generateProductDescription(),
        price: _random.nextDouble() * 100 + 10,
        imageUrl: 'https://picsum.photos/300/300?random=$id',
        category: productCategory,
        stock: _random.nextInt(100),
        isAvailable: _random.nextBool(),
        rating: _random.nextDouble() * 5,
        reviewCount: _random.nextInt(500),
      );
    });
  }
  
  Future<Product?> getProductById(String id) async {
    await _delay();
    
    final category = _getRandomCategory();
    return Product(
      id: id,
      name: _generateProductName(category),
      description: _generateProductDescription(),
      price: _random.nextDouble() * 100 + 10,
      imageUrl: 'https://picsum.photos/300/300?random=$id',
      category: category,
      stock: _random.nextInt(100),
      isAvailable: _random.nextBool(),
      rating: _random.nextDouble() * 5,
      reviewCount: _random.nextInt(500),
    );
  }
  
  // Mock post data
  Future<List<Post>> getPosts({int limit = 10, int page = 1}) async {
    await _delay();
    
    final startIndex = (page - 1) * limit;
    return List.generate(limit, (index) {
      final id = startIndex + index + 1;
      return Post(
        id: id.toString(),
        title: _generatePostTitle(),
        content: _generatePostContent(),
        authorId: (_random.nextInt(10) + 1).toString(),
        authorName: _generateName(),
        createdAt: DateTime.now().subtract(Duration(days: _random.nextInt(30))),
        updatedAt: _random.nextBool() 
          ? DateTime.now().subtract(Duration(days: _random.nextInt(10)))
          : null,
        tags: _generateTags(),
        likes: _random.nextInt(100),
        commentCount: _random.nextInt(50),
        isPublished: _random.nextBool(),
      );
    });
  }
  
  Future<Post?> getPostById(String id) async {
    await _delay();
    
    return Post(
      id: id,
      title: _generatePostTitle(),
      content: _generatePostContent(),
      authorId: (_random.nextInt(10) + 1).toString(),
      authorName: _generateName(),
      createdAt: DateTime.now().subtract(Duration(days: _random.nextInt(30))),
      updatedAt: _random.nextBool() 
        ? DateTime.now().subtract(Duration(days: _random.nextInt(10)))
        : null,
      tags: _generateTags(),
      likes: _random.nextInt(100),
      commentCount: _random.nextInt(50),
      isPublished: _random.nextBool(),
    );
  }
  
  // Mock comment data
  Future<List<Comment>> getComments(String postId, {int limit = 10}) async {
    await _delay();
    
    return List.generate(limit, (index) {
      final id = '${postId}_comment_${index + 1}';
      return Comment(
        id: id,
        postId: postId,
        content: _generateCommentContent(),
        authorId: (_random.nextInt(10) + 1).toString(),
        authorName: _generateName(),
        authorAvatarUrl: 'https://picsum.photos/100/100?random=${index + 1}',
        createdAt: DateTime.now().subtract(Duration(hours: _random.nextInt(24))),
        likes: _random.nextInt(20),
        replies: _random.nextBool() ? _generateReplies(id, postId) : [],
      );
    });
  }
  
  // Mock form submission
  Future<bool> submitForm(Map<String, dynamic> formData) async {
    await _delay(2000); // Longer delay to simulate form processing
    
    // Simulate occasional failures
    if (_random.nextDouble() < 0.1) {
      throw Exception('Form submission failed. Please try again.');
    }
    
    return true;
  }
  
  // Simulate API errors
  Future<void> simulateError() async {
    await _delay();
    throw Exception('Simulated API error for testing error states');
  }
  
  // Helper methods for generating mock data
  String _generateName() {
    final firstNames = ['John', 'Jane', 'Mike', 'Sarah', 'David', 'Emma', 'Chris', 'Lisa', 'Tom', 'Amy'];
    final lastNames = ['Smith', 'Johnson', 'Brown', 'Davis', 'Wilson', 'Moore', 'Taylor', 'Anderson', 'Thomas', 'Jackson'];
    return '${firstNames[_random.nextInt(firstNames.length)]} ${lastNames[_random.nextInt(lastNames.length)]}';
  }
  
  String _generateBio() {
    final bios = [
      'Passionate developer who loves creating amazing apps.',
      'Coffee enthusiast and code writer.',
      'Building the future one line at a time.',
      'Tech lover, problem solver, dream chaser.',
      'Making the world better through technology.',
    ];
    return bios[_random.nextInt(bios.length)];
  }
  
  String _getRandomCategory() {
    final categories = ['Electronics', 'Clothing', 'Books', 'Home & Garden', 'Sports', 'Toys', 'Beauty', 'Automotive'];
    return categories[_random.nextInt(categories.length)];
  }
  
  String _generateProductName(String category) {
    final productNames = {
      'Electronics': ['Smartphone', 'Laptop', 'Tablet', 'Headphones', 'Smart Watch'],
      'Clothing': ['T-Shirt', 'Jeans', 'Sneakers', 'Jacket', 'Dress'],
      'Books': ['Mystery Novel', 'Cookbook', 'Biography', 'Science Fiction', 'Self-Help'],
      'Home & Garden': ['Coffee Maker', 'Plant Pot', 'Lamp', 'Cushion', 'Vase'],
      'Sports': ['Running Shoes', 'Yoga Mat', 'Water Bottle', 'Gym Bag', 'Fitness Tracker'],
      'Toys': ['Building Blocks', 'Puzzle', 'Action Figure', 'Board Game', 'Stuffed Animal'],
      'Beauty': ['Face Cream', 'Lipstick', 'Shampoo', 'Perfume', 'Face Mask'],
      'Automotive': ['Car Phone Mount', 'Dash Cam', 'Car Charger', 'Seat Covers', 'Air Freshener'],
    };
    
    final names = productNames[category] ?? ['Generic Product'];
    final baseName = names[_random.nextInt(names.length)];
    final adjectives = ['Premium', 'Professional', 'Deluxe', 'Ultra', 'Pro', 'Advanced'];
    
    return _random.nextBool() 
      ? '${adjectives[_random.nextInt(adjectives.length)]} $baseName'
      : baseName;
  }
  
  String _generateProductDescription() {
    final descriptions = [
      'High-quality product with excellent features and design.',
      'Perfect for everyday use with durable construction.',
      'Premium materials and craftsmanship ensure long-lasting performance.',
      'Innovative design meets practical functionality.',
      'Experience the difference with this exceptional product.',
    ];
    return descriptions[_random.nextInt(descriptions.length)];
  }
  
  String _generatePostTitle() {
    final titles = [
      'Getting Started with Flutter Development',
      'Best Practices for State Management',
      'Building Responsive UIs with Flutter',
      'Advanced Animation Techniques',
      'Testing Your Flutter Applications',
      'Performance Optimization Tips',
      'Material Design in Flutter',
      'Navigation and Routing Guide',
      'Custom Widget Development',
      'Flutter vs Other Frameworks',
    ];
    return titles[_random.nextInt(titles.length)];
  }
  
  String _generatePostContent() {
    return '''
Flutter is Google's UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase. 

In this post, we'll explore various aspects of Flutter development and share insights that will help you build better applications. Whether you're a beginner or an experienced developer, there's always something new to learn in the Flutter ecosystem.

Key points covered:
• Understanding the Flutter architecture
• Best practices for widget composition  
• State management strategies
• Performance optimization techniques
• Testing methodologies

The Flutter community continues to grow, and with each release, we see improvements in performance, developer experience, and the overall ecosystem. Stay tuned for more updates and tutorials!
''';
  }
  
  List<String> _generateTags() {
    final allTags = ['flutter', 'dart', 'mobile', 'development', 'ui', 'widgets', 'state-management', 'animation', 'testing', 'performance'];
    final tagCount = _random.nextInt(4) + 1;
    final shuffled = allTags..shuffle(_random);
    return shuffled.take(tagCount).toList();
  }
  
  String _generateCommentContent() {
    final comments = [
      'Great post! Thanks for sharing these insights.',
      'This is really helpful. I learned something new today.',
      'I have a question about the implementation...',
      'Excellent explanation. Looking forward to more content like this.',
      'Could you elaborate more on this topic?',
      'This solved my problem perfectly. Thank you!',
      'Interesting approach. Have you considered alternative solutions?',
      'Well written and easy to understand.',
    ];
    return comments[_random.nextInt(comments.length)];
  }
  
  List<Comment> _generateReplies(String parentId, String postId) {
    final replyCount = _random.nextInt(3) + 1;
    return List.generate(replyCount, (index) {
      return Comment(
        id: '${parentId}_reply_${index + 1}',
        postId: postId,
        content: _generateCommentContent(),
        authorId: (_random.nextInt(10) + 1).toString(),
        authorName: _generateName(),
        authorAvatarUrl: 'https://picsum.photos/100/100?random=${_random.nextInt(100)}',
        createdAt: DateTime.now().subtract(Duration(minutes: _random.nextInt(60))),
        likes: _random.nextInt(5),
        parentId: parentId,
      );
    });
  }
}