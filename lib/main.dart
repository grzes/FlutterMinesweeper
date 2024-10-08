import 'package:flutter/material.dart';
import 'widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';  // Import flutter_bloc
import 'blocs/cell_bloc.dart';
import 'model/game_area_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minesweeper',
      home: BlocProvider<CellCollectionBloc>(
        create: (context) => CellCollectionBloc(GameAreaModel(10, 10)), // Create your bloc
        child: BlocBuilder<CellCollectionBloc, List<CellBloc>>(
          builder: (context, cellBlocs) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Minesweeper ?'),
                actions: [
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      // Call the restart game function
                      context.read<CellCollectionBloc>().initializeGame(); // Use read method from flutter_bloc
                    },
                  ),
                ],
              ),
              body: MinesweeperGrid(),
            );
          },
        ),
      ),
    );
  }
}
