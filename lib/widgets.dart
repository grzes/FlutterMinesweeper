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
          print("loss");
        }
      },

      onLongPress: () {
        bloc.toggleFlag();
        if (cellCollectionBloc.checkWinCondition()) {
          print("win");
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
}
