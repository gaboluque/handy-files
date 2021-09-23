import 'package:flutter/material.dart';

class SafeFunction {
  Function fn;
  BuildContext ctx;

  SafeFunction(this.fn, this.ctx);

  void run() async {
    try {
      print("HERE");
      await fn();
    } catch (e) {
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }
}
