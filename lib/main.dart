import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/matrices.dart';

import './screens/matrix_input_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Matrices(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.blueAccent[700],
        ),
        routes: {},
        home: MatrixInputScreen(),
      ),
    );
  }
}
