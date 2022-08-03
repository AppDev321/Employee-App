import 'package:flutter/cupertino.dart';

class TableCellPadded extends StatelessWidget {
  final EdgeInsets? padding;
  final Widget child;
  final TableCellVerticalAlignment? verticalAlignment;

  const TableCellPadded(
      {Key? key, required this.child, this.padding,  this.verticalAlignment})
      : super(key: key);

  @override
  TableCell build(BuildContext context) => TableCell(
      verticalAlignment: verticalAlignment ?? TableCellVerticalAlignment.middle,
      child: Padding(padding: padding ?? const EdgeInsets.all(5.0), child: child));
}