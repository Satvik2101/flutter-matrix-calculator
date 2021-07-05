import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Matrix {
  late int rows;
  late int columns;
  List<List<double>> matrix = [
    [0]
  ];
  Matrix(
    this.rows,
    this.columns,
  ) {
    matrix =
        List.generate(rows, (index) => List.generate(columns, (index) => 0));
  }

  void _matrixupdater() {
    List<List<double>> newMatrix = List.generate(
      rows,
      (i) => List.generate(
        columns,
        (j) {
          if (i < matrix.length && j < matrix[0].length) {
            return matrix[i][j];
          }
          return 0;
        },
      ),
    );
    matrix = newMatrix;
  }

  Matrix.fromList(this.matrix) {
    this.rows = matrix.length;
    this.columns = matrix[0].length;
  }

  void updateValue(int i, int j, double value) {
    matrix[i][j] = value;
  }

  set rowSetter(int val) {
    rows = val;
    _matrixupdater();
  }

  set colSetter(int val) {
    columns = val;
    _matrixupdater();
  }

  set matSetter(List<List<double>> list) {
    matrix = list;
    rows = list.length;
    columns = list[0].length;
  }
  ////////////////////////////////////// TO FIND RANK /////////////////////////////////////////////////////

  int countZeroes(int i) {
    int ans = 0;
    for (double value in matrix[i]) {
      if (value == 0)
        ans++;
      else
        break;
    }
    return ans;
  }

  int _countZeroesList(List<double> lst) {
    int ans = 0;
    for (double i in lst) {
      if (i == 0)
        ans++;
      else
        break;
    }
    return ans;
  }

  void swap() {
    matrix.sort(
      (List<double> a, List<double> b) =>
          (_countZeroesList(a) - _countZeroesList(b)),
    );
  }

  void makeFirstValueOne(int i) {
    int _firstNonZeroAt = countZeroes(i);
    if (_firstNonZeroAt >= matrix[i].length) {
      return;
    }
    if (matrix[i][_firstNonZeroAt] == 1) return;
    double firstNonZeroValue = matrix[i][_firstNonZeroAt];
    for (int j = _firstNonZeroAt; j < matrix[i].length; j++) {
      matrix[i][j] = matrix[i][j] / firstNonZeroValue;
    }
  }

  void makeColumnZero(int i) {
    if (i == matrix.length - 1) {
      return;
    }
    int columnIndex = countZeroes(i);
    if (columnIndex >= matrix[i].length) return;
    for (int j = i + 1; j < matrix.length; j++) {
      if (matrix[j][columnIndex] == 0) continue;
      double multiplier = matrix[j][columnIndex] / matrix[i][columnIndex];
      for (int k = columnIndex; k < matrix[j].length; k++) {
        matrix[j][k] = matrix[j][k] - matrix[i][k] * multiplier;
      }
    }
  }

  int createRowEchelonForm() {
    swap();
    for (int i = 0; i < matrix.length; i++) {
      makeFirstValueOne(i);
      makeColumnZero(i);
    }
    int rank = 0;
    for (int i = 0; i < matrix.length; i++) {
      if (matrix[i].any((element) => element != 0)) rank++;
    }
    return rank;
  }

/////////////////////////////////////////////////RANK FUNCTIONS OVER /////////////////////////////////////

}

class Matrices with ChangeNotifier {
  List<Matrix> matrices = [Matrix(1, 1), Matrix(1, 1)];
  Matrix answerMatrix = Matrix(1, 1);
  void setMatrix(int i, Matrix mat) {
    matrices[i] = mat;
    notifyListeners();
  }

  Matrix _generate() {
    if ((matrices[0].rows != matrices[1].rows) ||
        (matrices[0].columns != matrices[1].columns)) {
      throw Exception("Cannot be added");
    }

    Matrix ans = Matrix(matrices[0].rows, matrices[0].columns);
    return ans;
  }

  void add() {
    Matrix ans = _generate();
    int rows = matrices[0].rows;
    int columns = matrices[0].columns;
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < columns; j++) {
        ans.updateValue(
            i, j, matrices[0].matrix[i][j] + matrices[1].matrix[i][j]);
      }
    }
    answerMatrix = ans;
    print("add update");
    notifyListeners();
  }

  void subtract() {
    Matrix ans = _generate();
    int rows = matrices[0].rows;
    int columns = matrices[0].columns;
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < columns; j++) {
        ans.updateValue(
            i, j, matrices[0].matrix[i][j] - matrices[1].matrix[i][j]);
      }
    }
    print("subtract update");
    answerMatrix = ans;
    notifyListeners();
  }

  void multiply() {
    if (matrices[0].columns != matrices[1].rows) {
      throw Exception("Could not multiply!");
    }
    int rows1 = matrices[0].rows;
    int columns1 = matrices[0].columns; //= rows2
    int columns2 = matrices[1].columns;

    Matrix ans = Matrix(rows1, columns2);
    final matrix1 = matrices[0].matrix;
    final matrix2 = matrices[1].matrix;
    for (int i = 0; i < rows1; i++) {
      List<double> ithRow = matrix1[i];
      for (int j = 0; j < columns2; j++) {
        List<double> jthColumn =
            List.generate(columns1, (index) => matrix2[index][j]);
        double updatedValue = 0;
        for (int k = 0; k < columns1; k++) {
          updatedValue += ithRow[k] * jthColumn[k];
        }
        ans.updateValue(i, j, updatedValue);
      }
    }
    answerMatrix = ans;
    notifyListeners();
    print("multiply update");
  }

  void set answerMatrixSetter(Matrix mat) {
    answerMatrix = mat;
    notifyListeners();
  }

  int findAnswerMatrixRank() {
    Matrix m1 = matrices[0];
    answerMatrixSetter = Matrix.fromList(
        List.generate(m1.matrix.length, (i) => [...m1.matrix[i]]));
    int ans = answerMatrix.createRowEchelonForm();
    notifyListeners();
    return ans;
  }

  void findAnswerMatrixTranspose() {
    Matrix m1 = matrices[0];
    answerMatrixSetter = Matrix.fromList(
      List.generate(
        m1.matrix[0].length,
        (i) => List.generate(m1.matrix.length, (j) => m1.matrix[j][i]),
      ),
    );
    notifyListeners();
  }
}
