import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
export 'package:flutter/cupertino.dart';

class CupertinoWidget extends StatelessWidget {
  const CupertinoWidget({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      child: child,
    );
  }
}
