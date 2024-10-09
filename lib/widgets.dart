import 'package:flutter/material.dart';
import 'blocs/cell_bloc.dart';
import 'model/game_area_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';  // Import flutter_bloc

class MinesweeperGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CellCollectionBloc, List<CellBloc>>(
      builder: (context, cellBlocs) {
        print('MinesweeperGrid rebuilt with ${cellBlocs.length} cells.');
        if (cellBlocs.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 10, // Adjust based on your grid size
          ),
          itemCount: cellBlocs.length,
          itemBuilder: (context, index) {
            return CellWidget(bloc: cellBlocs[index]); // Adjust as per your logic
          },
        );
      },
    );
  }
}

// Individual cell widget
class CellWidget extends StatelessWidget {
  final CellBloc bloc;

  CellWidget({required this.bloc});

  @override
  Widget build(BuildContext context) {
    final cellCollectionBloc = BlocProvider.of<CellCollectionBloc>(context);
    return GestureDetector(
      onTap: () {
        if (bloc.revealCell(cellCollectionBloc.state)) { // Pass all cells
          _showGameOverDialog(context, cellCollectionBloc);
        }
      },

      onLongPress: () {
        bloc.toggleFlag();
        if (cellCollectionBloc.checkWinCondition()) {
          _showWinDialog(context, cellCollectionBloc);
        }
      },

      child: StreamBuilder<CellState>(
        stream: bloc.cellStateStream,
        builder: (context, snapshot) {
          final state = snapshot.data;

          if (state == null) return Container();

          return Container(
            margin: EdgeInsets.all(1),
            color: state.isRevealed
                ? (state.hasMine ? Colors.red : Colors.grey[300])
                : Colors.blue,
            child: Center(
              child: state.isFlagged
                  ? Icon(Icons.flag, color: Colors.red)
                  : state.isRevealed
                      ? Text(state.neighborMineCount > 0
                          ? '${state.neighborMineCount}'
                          : '')
                      : null,
            ),
          );
        },
      ),
    );
  }


    // Game Over dialog
  void _showGameOverDialog(BuildContext context, CellCollectionBloc game) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text('You revealed a mine!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                game.initializeGame();
              },
              child: Text('Restart'),
            ),
          ],
        );
      },
    );
  }

  // Win dialog
  void _showWinDialog(BuildContext context, CellCollectionBloc game) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('You Win!'),
          content: Text('Congratulations, you revealed all safe cells!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                game.initializeGame();
              },
              child: Text('Restart'),
            ),
          ],
        );
      },
    );
  }
}
