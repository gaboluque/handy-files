import 'package:flutter/material.dart';

class SafeFunction {
  Function fn;
  BuildContext ctx;

  SafeFunction(this.fn, this.ctx);

  void run() async {
    try {
      await fn();
    } catch (e) {
      // print(e);
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }
}
