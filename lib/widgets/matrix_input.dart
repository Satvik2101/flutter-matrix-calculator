import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/matrices.dart';
import './number_input.dart';

class MatrixInput extends StatelessWidget {
  const MatrixInput({
    Key? key,
    required this.matrixIndex,
    required this.matrix,
    this.isMatrixDisabled = false,
    required this.isWide,
    required this.color,
  }) : super(key: key);

  final int matrixIndex;
  final Matrix matrix;
  final bool isMatrixDisabled;
  final bool isWide;
  final Color color;
  @override
  Widget build(BuildContext context) {
    final matricesData = Provider.of<Matrices>(context);

    double sideLength = isWide
        ? (MediaQuery.of(context).size.height * 0.5 / matrix.rows)
        : MediaQuery.of(context).size.width * 0.8 / matrix.columns;
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: List.generate(
            matrix.rows,
            (i) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                matrix.columns,
                (j) => Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: NumberInput(
                    color: color,
                    isDisabled: isMatrixDisabled,
                    height: sideLength,
                    width: sideLength,
                    editingCallback: (double val) {
                      if (!isMatrixDisabled) {
                        matrix.updateValue(i, j, val);

                        matricesData.setMatrix(matrixIndex, matrix);
                      }
                    },
                    isLast: (i == matrix.rows - 1) && (j == matrix.columns - 1),
                    value: matrix.matrix[i][j],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
