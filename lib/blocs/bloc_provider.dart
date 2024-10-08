import 'package:flutter/widgets.dart';

class BlocProvider<T> extends InheritedWidget {
  final T bloc;

  BlocProvider({Key? key, required Widget child, required this.bloc})
      : super(key: key, child: child);

  static T of<T>(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<BlocProvider<T>>()!).bloc;
  }

  @override
  bool updateShouldNotify(BlocProvider oldWidget) => true;
}
