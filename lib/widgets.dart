import 'package:flutter/material.dart';
import 'blocs/cell_bloc.dart';
import 'model/game_area_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MinesweeperGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: NoScrollbarScrollBehavior(),
      child: BlocBuilder<CellCollectionBloc, List<CellBloc>>(
        builder: (context, cellBlocs) {
          if (cellBlocs.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          // Fixed height and width for the entire grid
          return Center(
            child: Container(
              width: 220, // 10 cells * 20 pixels + spacing
              height: 220, // 10 cells * 20 pixels + spacing
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 2), // Border around the entire grid
              ),
              child: GridView.count(
                crossAxisCount: 10, // Fixed number of cells in a row
                childAspectRatio: 1, // Ensure the cells maintain a square aspect ratio
                crossAxisSpacing: 2, // Minimal spacing between cells
                mainAxisSpacing: 2, // Minimal spacing between cells
                physics: NeverScrollableScrollPhysics(), // Disable scrolling for the grid
                children: cellBlocs.map((cellBloc) => CellWidget(bloc: cellBloc)).toList(), // Generate cells
              ),
            ),
          );
        },
      ),
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
        if (bloc.revealCell(cellCollectionBloc.state)) {
          _showGameOverDialog(context, cellCollectionBloc);
        }
        if (cellCollectionBloc.checkWinCondition()) {
          _showWinDialog(context, cellCollectionBloc);
        }
      },
      onLongPress: () {
        bloc.toggleFlag();
        final cellCollectionBloc = BlocProvider.of<CellCollectionBloc>(context);
        if (cellCollectionBloc.checkWinCondition()) {
          _showWinDialog(context, cellCollectionBloc);
        }
      },
      child: StreamBuilder<CellState>(
        stream: bloc.cellStateStream,
        builder: (context, snapshot) {
          final state = snapshot.data;

          if (state == null) return Container();

          return SizedBox(
            width: 20, // Fixed width for each cell (20x20)
            height: 20, // Fixed height for each cell
            child: Container(
              decoration: BoxDecoration(
                color: state.isRevealed
                    ? Colors.grey[300] // Revealed cell background
                    : Colors.grey[400], // Hidden cell background
                border: Border.all(
                  color: Colors.grey[600]!, // Border around each cell
                  width: 1.5,
                ),
                boxShadow: state.isRevealed
                    ? null // No shadow on revealed cells
                    : [
                        // Light shadow for top-left bevel
                        BoxShadow(
                          color: Colors.white,
                          offset: Offset(-2, -2),
                          blurRadius: 2,
                          spreadRadius: 1,
                        ),
                        // Dark shadow for bottom-right bevel
                        BoxShadow(
                          color: Colors.black38,
                          offset: Offset(2, 2),
                          blurRadius: 2,
                          spreadRadius: 1,
                        ),
                      ],
              ),
              child: Center(
                child: state.isFlagged
                    ? Icon(Icons.flag, color: Colors.red, size: 12) // Smaller flag icon for fixed cells
                    : state.isRevealed
                        ? _buildRevealedContent(state) // Content for revealed cells
                        : null,
              ),
            ),
          );
        },
      ),
    );
  }

  // Build the content for revealed cells
  Widget _buildRevealedContent(CellState state) {
    if (state.hasMine) {
      return Icon(Icons.circle, color: Colors.black, size: 12); // Smaller mine icon
    }

    if (state.neighborMineCount > 0) {
      return Text(
        '${state.neighborMineCount}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12, // Smaller font size for fixed cells
          color: _getMineCountColor(state.neighborMineCount), // Color-coding based on count
        ),
      );
    }

    return SizedBox.shrink(); // Empty cell if no neighboring mines
  }

  // Helper method to get color based on neighboring mine count
  Color _getMineCountColor(int count) {
    switch (count) {
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 3:
        return Colors.red;
      case 4:
        return Colors.deepPurple;
      case 5:
        return Colors.brown;
      case 6:
        return Colors.cyan;
      case 7:
        return Colors.black;
      case 8:
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  void _showGameOverDialog(BuildContext context, CellCollectionBloc cellCollectionBloc) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Game Over"),
        content: Text("You hit a mine!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              cellCollectionBloc.initializeGame();
            },
            child: Text("Restart"),
          ),
        ],
      ),
    );
  }

  void _showWinDialog(BuildContext context, CellCollectionBloc cellCollectionBloc) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Congratulations!"),
        content: Text("You won the game!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              cellCollectionBloc.initializeGame();
            },
            child: Text("Play Again"),
          ),
        ],
      ),
    );
  }
}

// Custom scroll behavior to hide scrollbars
class NoScrollbarScrollBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child; // Return the child without a scrollbar
  }

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child; // Return the child without overscroll indicators
  }
}