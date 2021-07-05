import 'package:flutter/material.dart';

import './number_input.dart';
import '../providers/matrices.dart';

class RowColumnInput extends StatefulWidget {
  const RowColumnInput({
    Key? key,
    required this.matrix,
    required this.setRow,
    required this.setCol,
    this.isDisabledFirst = false,
    this.isDisabledSecond = false,
  }) : super(key: key);

  final Matrix matrix;
  final Function setRow;
  final Function setCol;
  final bool isDisabledFirst;
  final bool isDisabledSecond;

  @override
  RowColumnInputState createState() => RowColumnInputState();
}

final _rowKey = GlobalKey<NumberInputState>();
final _columnKey = GlobalKey<NumberInputState>();

class RowColumnInputState extends State<RowColumnInput> {
  int? rowVal;
  int? colVal;

  void rowValSetter(int newVal) {
    _rowKey.currentState?.updateVal(newVal);
  }

  void colValSetter(int newVal) {
    _columnKey.currentState?.updateVal(newVal);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        NumberInput(
          color: Colors.white,
          key: widget.key == null ? null : _rowKey,
          height: 70,
          width: 70,
          editingCallback: (int val) {
            widget.setRow(widget.matrix, val);
          },
          isInt: true,
          value: widget.matrix.rows.toDouble(),
          isDisabled: widget.isDisabledFirst,
        ),
        const SizedBox(
          width: 30,
          child: Text(
            "X",
            textAlign: TextAlign.center,
          ),
        ),
        NumberInput(
          color: Colors.white,
          key: widget.key == null ? null : _columnKey,
          height: 70,
          width: 70,
          editingCallback: (int val) {
            widget.setCol(widget.matrix, val);
          },
          isLast: true,
          isInt: true,
          value: widget.matrix.columns.toDouble(),
          isDisabled: widget.isDisabledSecond,
        ),
      ],
    );
  }
}
