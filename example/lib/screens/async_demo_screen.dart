import 'package:flutter/material.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:example/controllers/example_controllers.dart';
import 'package:example/models/example_models.dart';

class AsyncDemoScreen extends StatefulWidget {
  const AsyncDemoScreen({super.key});

  @override
  State<AsyncDemoScreen> createState() => _AsyncDemoScreenState();
}

class _AsyncDemoScreenState extends State<AsyncDemoScreen> {
  final UserController userController = GetIt.instance<UserController>();
  final ProductController productController = GetIt.instance<ProductController>();

  @override
  void initState() {
    super.initState();
    // Controllers will auto-load in onReady
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AsyncController Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showInfoDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildSectionHeader(
              'AsyncController Features',
              'Demonstrates automatic loading, success, and error states with retry logic.',
            ),
            
            SizedBox(height: 24.h),
            
            // Users Section
            _buildUsersSection(),
            
            SizedBox(height: 32.h),
            
            // Products Section  
            _buildProductsSection(),
            
            SizedBox(height: 32.h),
            
            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String description) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Users Management',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            ReactiveWidget<UserController>(
              builder: (context, controller) => Text(
                '${controller.users.length} users',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        
        SizedBox(height: 16.h),
        
        // User List with AsyncBuilder
        SizedBox(
          height: 300.h,
          child: AsyncBuilder<UserController>(
            controller: userController,
            onLoading: (context, controller) => _buildLoadingState(),
            onSuccess: (context, controller) => _buildUsersList(controller.users),
            onError: (context, controller) => _buildErrorState(
              controller.errorMessage ?? 'Failed to load users',
              () => controller.loadUsers(),
            ),
          ),
        ),
        
        SizedBox(height: 16.h),
        
        // User Actions
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => userController.loadUsers(),
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh Users'),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => userController.loadMoreUsers(),
                icon: const Icon(Icons.add),
                label: const Text('Load More'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProductsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Products with Filtering',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        
        SizedBox(height: 16.h),
        
        // Filter Controls
        ReactiveWidget<ProductController>(
          builder: (context, controller) => Column(
            children: [
              // Category Filter
              if (controller.categories.isNotEmpty) ...[
                DropdownButton<String?>(
                  value: controller.selectedCategory,
                  hint: const Text('Select Category'),
                  isExpanded: true,
                  items: [
                    const DropdownMenuItem(value: null, child: Text('All Categories')),
                    ...controller.categories.map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ),
                    ),
                  ],
                  onChanged: (value) => controller.filterByCategory(value),
                ),
                SizedBox(height: 12.h),
              ],
              
              // Search Field
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: controller.searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => controller.searchProducts(''),
                      )
                    : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                onChanged: controller.searchProducts,
              ),
            ],
          ),
        ),
        
        SizedBox(height: 16.h),
        
        // Products Grid
        SizedBox(
          height: 400.h,
          child: AsyncBuilder<ProductController>(
            controller: productController,
            onLoading: (context, controller) => _buildGridLoadingState(),
            onSuccess: (context, controller) => _buildProductsGrid(controller.products),
            onError: (context, controller) => _buildErrorState(
              controller.errorMessage ?? 'Failed to load products',
              () => controller.loadProducts(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AsyncController Actions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            Wrap(
              spacing: 12.w,
              runSpacing: 12.h,
              children: [
                ElevatedButton(
                  onPressed: () => userController.refreshUsers(),
                  child: const Text('Refresh All Users'),
                ),
                ElevatedButton(
                  onPressed: () => productController.refreshProducts(),
                  child: const Text('Refresh Products'),
                ),
                ElevatedButton(
                  onPressed: () => productController.clearFilters(),
                  child: const Text('Clear Filters'),
                ),
                OutlinedButton(
                  onPressed: () => _showStatsDialog(),
                  child: const Text('View Stats'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersList(List<User> users) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Card(
          margin: EdgeInsets.only(bottom: 8.h),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: user.isActive ? Colors.green : Colors.grey,
              child: Text(user.name.substring(0, 1).toUpperCase()),
            ),
            title: Text(user.name),
            subtitle: Text(user.email),
            trailing: user.isActive 
              ? const Icon(Icons.check_circle, color: Colors.green, size: 16)
              : const Icon(Icons.pause_circle, color: Colors.grey, size: 16),
            onTap: () => userController.selectUser(user.id),
          ),
        );
      },
    );
  }

  Widget _buildProductsGrid(List<Product> products) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.8,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.shopping_bag,
                      size: 40.w,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  product.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  product.formattedPrice,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  product.category,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => Card(
        margin: EdgeInsets.only(bottom: 8.h),
        child: ListTile(
          leading: CircleAvatar(backgroundColor: Colors.grey[300]),
          title: Container(height: 16.h, color: Colors.grey[300]),
          subtitle: Container(height: 12.h, color: Colors.grey[200]),
        ),
      ),
    );
  }

  Widget _buildGridLoadingState() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.8,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => Card(
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Container(height: 16.h, color: Colors.grey[300]),
              SizedBox(height: 4.h),
              Container(height: 12.h, width: 60.w, color: Colors.grey[200]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String error, VoidCallback onRetry) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64.w, color: Colors.red),
          SizedBox(height: 16.h),
          Text(
            'Oops! Something went wrong',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            error,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AsyncController Features'),
        content: const Text(
          'This demo shows:\n\n'
          '• Automatic loading, success, and error states\n'
          '• Built-in retry logic with executeAsync()\n'
          '• Background operations with executeSilently()\n'
          '• Real-time state updates with ReactiveWidget\n'
          '• Declarative UI with AsyncBuilder\n'
          '• Error handling and recovery',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _showStatsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Statistics'),
        content: ReactiveWidget<UserController>(
          builder: (context, userController) => ReactiveWidget<ProductController>(
            builder: (context, productController) {
              final userStats = userController.getUserStats();
              final productStats = productController.getProductStats();
              
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Users: ${userStats['total'] ?? 0}'),
                  Text('Active Users: ${userStats['active'] ?? 0}'),
                  const SizedBox(height: 16),
                  Text('Products: ${productStats['total'] ?? 0}'),
                  Text('Categories: ${productStats['categories'] ?? 0}'),
                  if (productStats['average_price'] != null)
                    Text('Avg Price: \$${(productStats['average_price'] as double).toStringAsFixed(2)}'),
                ],
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}