import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

abstract class StatelessView<T extends Object> extends StatelessWidget {
  const StatelessView({Key? key}) : super(key: key);

  T get controller => GetIt.I.get<T>();

  @override
  Widget build(BuildContext context);
}