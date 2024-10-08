import 'package:flutter/material.dart';
import 'widgets.dart';
import 'blocs/bloc_provider.dart';
import 'blocs/cell_bloc.dart';
import 'model/game_area_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      child: MaterialApp(
        title: 'Minesweeper',
        home: Scaffold(
          appBar: AppBar(title: Text('Minesweeper')),
          body: MinesweeperGrid(),
        ),
      ),
      bloc: CellCollectionBloc(GameAreaModel(10, 10)),  // Example with a 10x10 grid
    );
  }
}
