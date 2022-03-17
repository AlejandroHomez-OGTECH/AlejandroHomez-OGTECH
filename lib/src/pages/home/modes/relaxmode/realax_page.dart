import 'package:flutter/material.dart';

class RelaxPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      child: const Center(
        child: Text('Relax'),
      ),
    );
  }
}
