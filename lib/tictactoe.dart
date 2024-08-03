enum GameMark {
  empty,
  cross,
  circle;
}

class TicTacToe {
  final List<GameMark> board;

  const TicTacToe(this.board);

  factory TicTacToe.empty() => TicTacToe(List.filled(9, GameMark.empty, growable: false));

  void markAt({required int index, required GameMark mark}) {
    assert(index < board.length, IndexError.withLength(index, board.length, name: "mark index"));

    final currentMark = board.elementAtOrNull(index);
    if (currentMark != null && currentMark != GameMark.empty) {
      throw SpaceAlreadyFilledException();
    }

    board[index] = mark;
  }

  GameMark? winner() {
    final indexGroups = [
      // horizontal
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      // vertical
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      // Diagonal
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var group in indexGroups) {
      final mutualMark = group.fold<GameMark?>(
        null, // null indicates nothing was found yet
        (previousValue, index) {
          final markOnSpace = board[index];
          if (previousValue != null) {
            return markOnSpace == previousValue ? markOnSpace : GameMark.empty;
          } else {
            return markOnSpace;
          }
        },
      );

      if (mutualMark == null || mutualMark == GameMark.empty) continue;

      return mutualMark;
    }

    if (board.any((element) => element == GameMark.empty)) {
      return null;
    } else {
      return GameMark.empty;
    }
  }
}

class SpaceAlreadyFilledException {
  @override
  String toString() {
    return "Space already filled up";
  }
}
