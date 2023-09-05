import 'package:flutter/material.dart';

import '../../model/class_code.dart';

class CodeScreen extends StatefulWidget {
  final ClassCodeModel classCodeModel;
  const CodeScreen({required this.classCodeModel});

  @override
  State<CodeScreen> createState() => _CodeScreenState();
}

class _CodeScreenState extends State<CodeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(widget.classCodeModel.class_code),
          Text(widget.classCodeModel.status.toString()),
          Text(widget.classCodeModel.batch_name),
          Text(widget.classCodeModel.batch_id),
          Text(widget.classCodeModel.msg),
        ],
      ),
    );
  }
}
