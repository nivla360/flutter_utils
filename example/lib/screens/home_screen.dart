import 'package:flutter/material.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:example/routes/app_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Utils Examples'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Card(
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.rocket_launch,
                          size: 32.w,
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Flutter Utils v0.1.0',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Write 80% less code with modern Flutter patterns',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Explore comprehensive examples of state management, UI components, extensions, and services that eliminate boilerplate code.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 24.h),
            
            // Features Section
            Text(
              'Features & Examples',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            SizedBox(height: 16.h),
            
            // Feature Cards Grid
            ..._buildFeatureCards(context),
            
            SizedBox(height: 32.h),
            
            // Quick Stats Card
            Card(
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Package Benefits',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatItem(
                            context,
                            '80%',
                            'Less Code',
                            Icons.code,
                            Colors.blue,
                          ),
                        ),
                        Expanded(
                          child: _buildStatItem(
                            context,
                            '50+',
                            'Extensions',
                            Icons.extension,
                            Colors.green,
                          ),
                        ),
                        Expanded(
                          child: _buildStatItem(
                            context,
                            '20+',
                            'Widgets',
                            Icons.widgets,
                            Colors.orange,
                          ),
                        ),
                        Expanded(
                          child: _buildStatItem(
                            context,
                            'Material 3',
                            'Ready',
                            Icons.design_services,
                            Colors.purple,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFeatureCards(BuildContext context) {
    final features = [
      _FeatureCard(
        title: 'Async Controllers',
        description: 'AsyncController with automatic loading, success, and error states',
        icon: Icons.sync,
        color: Colors.blue,
        route: AppRouter.asyncDemo,
        highlights: ['Automatic state management', 'Built-in retry logic', 'Background operations'],
      ),
      _FeatureCard(
        title: 'Persistent State',
        description: 'PersistentController with automatic SharedPreferences saving',
        icon: Icons.save,
        color: Colors.green,
        route: AppRouter.persistentDemo,
        highlights: ['Auto-save on changes', 'Type-safe storage', 'Debounced saves'],
      ),
      _FeatureCard(
        title: 'Quick Widgets',
        description: 'High-level widgets that replace 10+ lines with simple components',
        icon: Icons.widgets,
        color: Colors.orange,
        route: AppRouter.widgetsDemo,
        highlights: ['QuickCard & QuickButton', 'SkeletonLoaders', 'SmartForms'],
      ),
      _FeatureCard(
        title: 'Smart Forms',
        description: 'Declarative forms with built-in validation and styling',
        icon: Icons.dynamic_form,
        color: Colors.purple,
        route: AppRouter.formsDemo,
        highlights: ['Declarative validation', 'Multiple field types', 'Auto-formatting'],
      ),
      _FeatureCard(
        title: 'Extensions',
        description: 'Powerful extensions for DateTime, String, Widget, and more',
        icon: Icons.extension,
        color: Colors.teal,
        route: AppRouter.extensionsDemo,
        highlights: ['50+ DateTime utils', 'Validation helpers', 'Widget shortcuts'],
      ),
      _FeatureCard(
        title: 'Services',
        description: 'Complete service layer with HTTP client, storage, and navigation',
        icon: Icons.cloud,
        color: Colors.indigo,
        route: AppRouter.servicesDemo,
        highlights: ['HTTP with caching', 'Type-safe storage', 'Centralized dialogs'],
      ),
    ];

    return features.map((feature) => _buildFeatureCard(context, feature)).toList();
  }

  Widget _buildFeatureCard(BuildContext context, _FeatureCard feature) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Card(
        child: InkWell(
          onTap: () => context.push(feature.route),
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: feature.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        feature.icon,
                        color: feature.color,
                        size: 24.w,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            feature.title,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            feature.description,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16.w,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: feature.highlights.map((highlight) => Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: feature.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: feature.color.withOpacity(0.3)),
                    ),
                    child: Text(
                      highlight,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: feature.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: color, size: 20.w),
        ),
        SizedBox(height: 8.h),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

class _FeatureCard {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String route;
  final List<String> highlights;

  _FeatureCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.route,
    required this.highlights,
  });
}