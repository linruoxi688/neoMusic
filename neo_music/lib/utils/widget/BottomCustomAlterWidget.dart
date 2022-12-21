import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class BottomCustomAlterWidget extends StatefulWidget {
  final confirmCallback;
  final title;
  final option1;
  final option2;
  final option3;
  final option4;
  final option5;

  const BottomCustomAlterWidget(
      this.confirmCallback, this.title, this.option1, this.option2,this.option3,this.option4,this.option5);

  @override
  _BottomCustomAlterWidgetState createState() =>
      _BottomCustomAlterWidgetState();
}

class _BottomCustomAlterWidgetState extends State<BottomCustomAlterWidget> {
  @override
  final controller = TextEditingController();
  String inputValuue = "";

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      ///底部弹出的提⽰框
      title: Text(
        widget.title,
        style: TextStyle(fontSize: 22),
      ),
      actions: [
        CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              widget.confirmCallback(widget.option1);
            },
            child: Text(widget.option1)),
        CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              widget.confirmCallback(widget.option2);
            },
            child: Text(widget.option2)),
        CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              widget.confirmCallback(widget.option3);
            },
            child: Text(widget.option3)),
        CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              widget.confirmCallback(widget.option4);
            },
            child: Text(widget.option4)),
        CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              widget.confirmCallback(widget.option5);
            },
            child: Text(widget.option5)),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('取消'),
      ),
    );
  }
}
