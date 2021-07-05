import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/matrices.dart';
import '../widgets/number_input.dart';
import '../widgets/row_column_input.dart';
import '../widgets/matrix_input.dart';

class MatrixInputScreen extends StatefulWidget {
  const MatrixInputScreen({
    Key? key,
  }) : super(key: key);

  @override
  _MatrixInputScreenState createState() => _MatrixInputScreenState();
}

final _rowColInputKey = GlobalKey<RowColumnInputState>();

class _MatrixInputScreenState extends State<MatrixInputScreen> {
  Matrix matrix1 = Matrix(1, 1);
  Matrix matrix2 = Matrix(1, 1);
  bool _showAnswerMatrix = false;
  bool _secondRowSet = false;
  bool _secondColumnSet = false;
  String? chosenOperation;
  int? rank;
  late double screenHeight;
  late double screenWidth;
  bool get showSecondMatrix {
    return chosenOperation != null &&
        chosenOperation != "Rank" &&
        chosenOperation != "Transpose";
  }

  @override
  void initState() {
    screenHeight = double.infinity;
    screenWidth = double.infinity;
    super.initState();
  }

  final ScrollController _scrollController = ScrollController();
  Widget calculateAnswerButton(Matrices matricesData) {
    return Center(
      child: ElevatedButton(
        child: const Text("Calculate Answer"),
        onPressed: () {
          setState(() {
            if (chosenOperation == "Addition") {
              debugPrint("add");
              matricesData.add();
            } else if (chosenOperation == "Subtraction") {
              debugPrint("sub");
              matricesData.subtract();
            } else if (chosenOperation == "Multiplication") {
              debugPrint("mul");
              matricesData.multiply();
            } else if (chosenOperation == "Rank") {
              rank = matricesData.findAnswerMatrixRank();
            } else if (chosenOperation == "Transpose") {
              matricesData.findAnswerMatrixTranspose();
            } else {
              return;
            }
            _showAnswerMatrix = true;
          });
          FocusManager.instance.primaryFocus?.unfocus();
          _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 500),
              curve: Curves.ease);
        },
      ),
    );
  }

  void setRow(Matrix matrix, int val) {
    setState(() {
      matrix.rowSetter = val;
      final matricesData = Provider.of<Matrices>(context, listen: false);
      int i;
      if (matrix == matrix1)
        i = 0;
      else
        i = 1;
      matricesData.setMatrix(i, matrix);
      _chooseOperation(chosenOperation, matricesData);
    });
  }

  void setCol(Matrix matrix, int val) {
    setState(() {
      matrix.colSetter = val;
      final matricesData = Provider.of<Matrices>(context, listen: false);
      int i;
      if (matrix == matrix1)
        i = 0;
      else
        i = 1;
      matricesData.setMatrix(i, matrix);
      _chooseOperation(chosenOperation, matricesData);
    });
  }

  void _chooseOperation(String? newValue, Matrices matricesData) {
    if (newValue == null) return;
    setState(() {
      chosenOperation = newValue;
      _showAnswerMatrix = false;
    });
    Matrix firstMatrix = matricesData.matrices[0];
    if (newValue == "Multiplication") {
      _rowColInputKey.currentState?.rowValSetter(firstMatrix.columns);
      setState(() {
        matrix2.rowSetter = firstMatrix.columns;
        _secondRowSet = true;
        _secondColumnSet = false;
      });
    } else if (newValue == "Addition" || newValue == "Subtraction") {
      _rowColInputKey.currentState?.colValSetter(firstMatrix.columns);
      _rowColInputKey.currentState?.rowValSetter(firstMatrix.rows);
      setState(() {
        matrix2.rowSetter = firstMatrix.rows;
        matrix2.colSetter = firstMatrix.columns;
        _secondRowSet = true;
        _secondColumnSet = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    bool isWide = width > 500;
    Matrices matricesData = Provider.of<Matrices>(context);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Matrix Calculator"),
        ),
        body: Stack(
          children: [
            Image.network(
              "https://as2.ftcdn.net/jpg/01/16/72/61/500_F_116726161_IVodnaYDEjn9Nzp9NNwFt6UtRS7fVOpd.jpg",
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
              color: Colors.blue[50],
              colorBlendMode: BlendMode.lighten,
            ),
            ListView(
              controller: _scrollController,
              scrollDirection: isWide ? Axis.horizontal : Axis.vertical,
              children: [
                SizedBox(height: 16, width: 16),
                FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        FittedBox(
                          child: Column(
                            children: [
                              RowColumnInput(
                                matrix: matrix1,
                                setCol: setCol,
                                setRow: setRow,
                              ),
                              const SizedBox(height: 30, width: 30),
                              MatrixInput(
                                color: Colors.orange[50]!,
                                isWide: isWide,
                                matrix: matrix1,
                                matrixIndex: 0,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          child: DropdownButton<String?>(
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                            value: chosenOperation,
                            hint: const Text("Choose operation"),
                            onChanged: (String? newValue) {
                              _chooseOperation(newValue, matricesData);
                            },
                            items: [
                              'Multiplication',
                              'Addition',
                              'Subtraction',
                              'Rank',
                              'Transpose'
                            ].map((String value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        if (chosenOperation == "Rank" ||
                            chosenOperation == "Transpose")
                          calculateAnswerButton(matricesData),
                      ],
                    ),
                  ),
                ),
                if (showSecondMatrix) const SizedBox(height: 20, width: 50),
                if (showSecondMatrix)
                  FittedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 1, width: 1),
                          RowColumnInput(
                            key: _rowColInputKey,
                            matrix: matrix2,
                            setRow: setRow,
                            setCol: setCol,
                            isDisabledFirst: _secondRowSet,
                            isDisabledSecond: _secondColumnSet,
                          ),
                          const SizedBox(height: 25),
                          MatrixInput(
                            color: Colors.amber[50]!,
                            isWide: isWide,
                            matrix: matrix2,
                            matrixIndex: 1,
                          ),
                          const SizedBox(height: 20),
                          if (chosenOperation != null)
                            calculateAnswerButton(matricesData),
                        ],
                      ),
                    ),
                  ),
                if (showSecondMatrix) const SizedBox(height: 20, width: 50),
                if (_showAnswerMatrix)
                  FittedBox(
                    child: Column(
                      children: [
                        SizedBox(
                          width: 1,
                          height: 1,
                        ),
                        SizedBox(
                          height: isWide ? 110 : 45,
                          child: Center(
                            child: Text(
                              chosenOperation == "Rank"
                                  ? "Row Echelon Matrix"
                                  : "Answer Matrix",
                              style: TextStyle(
                                fontSize: 30,
                              ),
                            ),
                          ),
                        ),
                        if (_showAnswerMatrix)
                          MatrixInput(
                            color: Colors.grey[200]!,
                            isWide: isWide,
                            matrix: matricesData.answerMatrix,
                            matrixIndex: 2,
                            isMatrixDisabled: true,
                          ),
                        SizedBox(
                          height: isWide ? 50 : 0,
                          width: 1,
                        ),
                        if (!showSecondMatrix && _showAnswerMatrix)
                          Text(
                            chosenOperation == "Rank"
                                ? "Rank = $rank"
                                : "                   ",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        SizedBox(height: 16, width: 16),
                      ],
                    ),
                  ),
                SizedBox(height: 16, width: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
