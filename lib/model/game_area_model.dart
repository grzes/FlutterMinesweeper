import 'dart:math';

class GameAreaModel {
  final int width;
  final int height;
  final int mineCount;  // Add a field for the number of mines
  late Map<int, CellState> cells;
  final Random _random = Random();  // Use Dart's Random class

  GameAreaModel(this.width, this.height, {this.mineCount = 10}) {
    _initializeCells();
  }

  void _initializeCells() {
    cells = {};
    List<int> minePositions = _generateMinePositions();

    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        final id = _getId(x, y);
        cells[id] = CellState(x, y, hasMine: minePositions.contains(id));
      }
    }

    _calculateNeighborMineCounts();
  }

  int _getId(int x, int y) => x + y * width;

  List<int> _generateMinePositions() {
    List<int> positions = List.generate(width * height, (index) => index);
    positions.shuffle(_random);  // Shuffle the positions list
    return positions.take(mineCount).toList();  // Take the first `mineCount` positions
  }

  void _calculateNeighborMineCounts() {
    cells.forEach((id, cell) {
      if (!cell.hasMine) {
        cell.neighborMineCount = _getNeighborMineCount(cell.x, cell.y);
      }
    });
  }

  int _getNeighborMineCount(int x, int y) {
    int count = 0;
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        if (i == 0 && j == 0) continue;  // Skip the current cell
        int neighborX = x + i;
        int neighborY = y + j;
        if (_isInBounds(neighborX, neighborY)) {
          int neighborId = _getId(neighborX, neighborY);
          if (cells[neighborId]?.hasMine == true) {
            count++;
          }
        }
      }
    }
    return count;
  }

  bool _isInBounds(int x, int y) {
    return x >= 0 && x < width && y >= 0 && y < height;
  }
}

class CellState {
  final int x;
  final int y;
  final bool hasMine;
  bool isRevealed = false;
  bool isFlagged = false;
  int neighborMineCount = 0;

  CellState(this.x, this.y, {required this.hasMine});
}
