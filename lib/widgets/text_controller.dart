import 'package:flutter/material.dart';

class TextController extends StatefulWidget {
  const TextController({super.key});

  @override
  State<TextController> createState() => TextControllerState();
}

class TextControllerState extends State<TextController> {
  final formControler = TextEditingController();

  @override
  void dispose() {
    formControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: formControler,
    );
  }
}
