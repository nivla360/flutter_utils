import 'package:flutter/material.dart';
import 'package:flutter_utils/widgets/src/error_view.dart';
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
            ErrorView(
              retryButtonLabel: 'Go to Home Page',
              title: 'Oops...',
              subtitle: 'We couldn\'t find what you are looking for',
              onRetry: (){
                context.go('/');
            },)
          ],
        ),
      ),
    );
  }
}
