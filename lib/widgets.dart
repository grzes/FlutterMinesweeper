import 'package:flutter/material.dart';
import 'blocs/cell_bloc.dart';
import 'model/game_area_model.dart';
import 'blocs/bloc_provider.dart';

// Grid widget
class MinesweeperGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cellBloc = BlocProvider.of<CellCollectionBloc>(context);

    return StreamBuilder<List<CellBloc>>(
      stream: cellBloc.cellsStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final cells = snapshot.data!;
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cellBloc.gridWidth,
          ),
          itemCount: cells.length,
          itemBuilder: (context, index) {
            return CellWidget(bloc: cells[index]);
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
    return GestureDetector(
      onTap: () {
        final cellCollectionBloc = BlocProvider.of<CellCollectionBloc>(context);
        bloc.revealCell(cellCollectionBloc.currentCells); // Pass all cells
      },



      onLongPress: () => bloc.toggleFlag(),
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
