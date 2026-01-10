import 'package:flutter/material.dart';
import 'package:flutter_utils/flutter_utils.dart';

class ServicesDemoScreen extends StatelessWidget {
  const ServicesDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud, size: 64.w, color: Theme.of(context).primaryColor),
            SizedBox(height: 16.h),
            Text(
              'Services Demo',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 8.h),
            Text(
              'Coming Soon...',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}