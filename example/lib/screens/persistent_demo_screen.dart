import 'package:flutter/material.dart';
import 'package:flutter_utils/flutter_utils.dart';

class PersistentDemoScreen extends StatelessWidget {
  const PersistentDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Persistent State Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.save, size: 64.w, color: Theme.of(context).primaryColor),
            SizedBox(height: 16.h),
            Text(
              'PersistentController Demo',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 8.h),
            Text(
              'Coming Soon...',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 24.h),
            const Text('This will demonstrate:'),
            SizedBox(height: 8.h),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• Automatic state persistence'),
                Text('• SharedPreferences integration'),
                Text('• Settings management'),
                Text('• Auto-save on changes'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}