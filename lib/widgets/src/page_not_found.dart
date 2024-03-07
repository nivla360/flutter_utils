import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Oops..',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
            ),
            const Text('We couldn\'t find what you are looking for'),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () {
                  context.go('/');
                }, child: const Text('Go To Home Page'))
          ],
        ),
      ),
    );
  }
}
