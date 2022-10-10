import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  ExpandableText(this.text);

  final String text;
  bool isExpanded = false;

  @override
  _ExpandableTextState createState() => new _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText>
    with TickerProviderStateMixin<ExpandableText> {
  @override
  Widget build(BuildContext context) {
    return  Column(children: <Widget>[
       AnimatedSize(
          vsync: this,
          duration: const Duration(milliseconds: 500),
          child:  ConstrainedBox(
              constraints: widget.isExpanded
                  ?  const BoxConstraints()
                  :  const BoxConstraints(maxHeight: 50.0),
              child:  Text(
                widget.text,
                softWrap: true,
                overflow: TextOverflow.fade,
              ))),
      widget.isExpanded
          ?  ConstrainedBox(constraints:  const BoxConstraints())
          :  ElevatedButton(
              child: const Text('...'),
              onPressed: () => setState(() => widget.isExpanded = true))
    ]);
  }
}
