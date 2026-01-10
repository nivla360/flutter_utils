import 'package:flutter/material.dart';
import 'package:flutter_utils/flutter_utils.dart';

class FormsDemoScreen extends StatelessWidget {
  const FormsDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forms Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.dynamic_form, size: 64.w, color: Theme.of(context).primaryColor),
            SizedBox(height: 16.h),
            Text(
              'SmartForms Demo',
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