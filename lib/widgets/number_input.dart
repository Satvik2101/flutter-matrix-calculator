import 'package:flutter/material.dart';

class NumberInput extends StatefulWidget {
  NumberInput({
    Key? key,
    required this.height,
    required this.width,
    this.isLast = false,
    required this.editingCallback,
    this.isDisabled = false,
    this.isInt = false,
    required this.value,
    required this.color,
  }) : super(key: key);

  final double height;
  final double width;
  final bool isLast;
  final Function editingCallback;
  final bool isDisabled;
  final bool isInt;
  final double value;
  final Color color;
  @override
  NumberInputState createState() => NumberInputState();
}

class NumberInputState extends State<NumberInput> {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  late String ogVal;

  void updateVal(int newVal) {
    setState(() {
      _textController.text = newVal.toString();
    });
  }

  String get valueString {
    if (widget.value == widget.value.toInt()) {
      return widget.value.toInt().toString();
    }
    return widget.value.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  bool _reset(FocusScopeNode node) {
    if (_textController.text.isEmpty) {
      _textController.text = ogVal;
      widget.isLast ? node.unfocus() : node.nextFocus();
      return true;
    }
    return false;
  }

  @override
  void initState() {
    _textController.text = valueString;
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        ogVal = _textController.text;
        _textController.clear();
      }
      if (!_focusNode.hasFocus && _textController.text.isEmpty) {
        _textController.text = ogVal;
      }
    });

    super.initState();
  }

  dynamic customTryParse(String val) {
    if (widget.isInt) {
      return int.tryParse(val);
    } else
      return double.tryParse(val);
  }

  dynamic customParse(String val) {
    if (widget.isInt) {
      return int.parse(val);
    } else
      return double.parse(val);
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    if (!_focusNode.hasFocus) _textController.text = valueString;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: widget.isDisabled ? Colors.grey[200] : widget.color,
        border: Border.all(color: Colors.black),
      ),
      height: widget.height,
      width: widget.width,
      child: Center(
        child: Expanded(
          child: TextField(
            enabled: !widget.isDisabled,
            controller: _textController,
            textAlignVertical: TextAlignVertical.center,
            style: TextStyle(
              fontSize: widget.height * 0.35,
            ),
            textInputAction:
                widget.isLast ? TextInputAction.done : TextInputAction.next,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            onChanged: (val) {
              if (_textController.text.isEmpty) return;

              if ((customTryParse(val) == null && val != "-") ||
                  (widget.isInt && _textController.text == "0")) {
                print("cleared");
                _textController.clear();
              } else {
                widget.editingCallback(customParse(val));
              }
            },
            focusNode: _focusNode,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            onEditingComplete: () {
              if (_reset(node)) return;
              widget.editingCallback(customParse(_textController.text));
              widget.isLast ? node.unfocus() : node.nextFocus();
            },
          ),
        ),
      ),
    );
  }
}
