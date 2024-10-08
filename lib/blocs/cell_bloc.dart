import 'dart:async';
import '../model/game_area_model.dart';

class CellBloc {
  final CellState _cellState;
  final _cellStateController = StreamController<CellState>();

  Stream<CellState> get cellStateStream => _cellStateController.stream;

  CellBloc(this._cellState) {
    _cellStateController.add(_cellState);
  }

  void revealCell() {
    if (!_cellState.isRevealed && !_cellState.isFlagged) {
      _cellState.isRevealed = true;
      _cellStateController.add(_cellState);
    }
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


class CellCollectionBloc {
  final GameAreaModel _gameAreaModel;
  final List<CellBloc> _cellBlocs = [];

  final _cellCollectionController = StreamController<List<CellBloc>>();

  Stream<List<CellBloc>> get cellsStream => _cellCollectionController.stream;

  int get gridWidth => _gameAreaModel.width;
  int get gridHeight => _gameAreaModel.height;

  CellCollectionBloc(this._gameAreaModel) {
    _initializeBlocs();
    _cellCollectionController.add(_cellBlocs);
  }

  void _initializeBlocs() {
    _gameAreaModel.cells.forEach((key, cellState) {
      _cellBlocs.add(CellBloc(cellState));
    });
  }

  void dispose() {
    _cellBlocs.forEach((bloc) => bloc.dispose());
    _cellCollectionController.close();
  }
}