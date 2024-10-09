import 'dart:async';
import '../model/game_area_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';  // Import flutter_bloc

class CellBloc {
  final CellState _cellState;
  final _cellStateController = StreamController<CellState>();

  Stream<CellState> get cellStateStream => _cellStateController.stream;

  CellBloc(this._cellState) {
    _cellStateController.add(_cellState);
  }

  bool revealCell(List<CellBloc> allCells) {
    if (!_cellState.isRevealed && !_cellState.isFlagged) {
      _cellState.isRevealed = true;
      _cellStateController.add(_cellState);

      if (_cellState.hasMine) return true;

      // If the revealed cell has no neighboring mines, reveal neighbors
      if (_cellState.neighborMineCount == 0) {
        _revealNeighbors(allCells);
      }
    }
    return false;
  }


  void _revealNeighbors(List<CellBloc> allCells) {
    for (int dx = -1; dx <= 1; dx++) {
      for (int dy = -1; dy <= 1; dy++) {
        if (dx == 0 && dy == 0) continue; // Skip the current cell

        int neighborX = _cellState.x + dx;
        int neighborY = _cellState.y + dy;

        if (_isInBounds(neighborX, neighborY)) {
          int neighborId = _getId(neighborX, neighborY);

          CellBloc? neighborBloc = allCells.firstWhere(
            (cell) => cell._cellState.x == neighborX && cell._cellState.y == neighborY,
            orElse: () => CellBloc(CellState(neighborX, neighborY, hasMine: true)) // Dummy default CellBloc, adjust accordingly
          );

          if (!neighborBloc._cellState.isRevealed && !neighborBloc._cellState.hasMine) {
            neighborBloc.revealCell(allCells);  // Recursively reveal neighbors
          }

        }
      }
    }
  }

  int _getId(int x, int y) => x + y * (_cellState.x + 1);

  bool _isInBounds(int x, int y) {
    return x >= 0 && x < 10 && y >= 0 && y < 10; // Update according to your grid size
  }

  void toggleFlag() {
    if (!_cellState.isRevealed) {
      _cellState.isFlagged = !_cellState.isFlagged;
      _cellStateController.add(_cellState);
    }
  }

  void dispose() {
    _cellStateController.close();
  }
}


class CellCollectionBloc extends Cubit<List<CellBloc>> {
  GameAreaModel _gameAreaModel;

  CellCollectionBloc(this._gameAreaModel) : super([]) {
    _initializeBlocs();
  }

  void _initializeBlocs() {
    final cellBlocs = _gameAreaModel.cells.map((key, cellState) => MapEntry(key, CellBloc(cellState)));
    emit(cellBlocs.values.toList());  // Emit the initial cell blocs
  }

  void initializeGame() {
    _gameAreaModel = GameAreaModel(10, 10); // Reset to a new game area
    _initializeBlocs(); // Reinitialize the cell blocs
  }

  bool checkWinCondition() {
    // Check if all non-mine cells are revealed
    return state.every((cellBloc) => cellBloc._cellState.isRevealed || cellBloc._cellState.hasMine);
  }

  int get gridWidth => _gameAreaModel.width;
  int get gridHeight => _gameAreaModel.height;

  @override
  Future<void> close() {
    // You can manage disposal of individual CellBloc instances here if necessary
    return super.close();
  }
}
