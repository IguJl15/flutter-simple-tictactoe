import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/tictactoe.dart';

void main() {
  var game = TicTacToe.empty();
  // setUp(() {});

  test('Call mark out of index mark should throw', () async {
    expect(() => game.markAt(index: 10, mark: GameMark.circle), throwsA(isA<AssertionError>()));
  });

  test('Call mark on already marked space should throw', () async {
    // arrange
    game = TicTacToe(List.filled(9, GameMark.circle));
    expect(() => game.markAt(index: 0, mark: GameMark.circle), throwsA(isA<SpaceAlreadyFilledException>()));
  });

  test('markAt should ', () async {
    //Arrange
    game = TicTacToe.empty();
    //Act

    game.markAt(index: 0, mark: GameMark.circle);
    game.markAt(index: 2, mark: GameMark.cross);
    game.markAt(index: 5, mark: GameMark.circle);
    game.markAt(index: 8, mark: GameMark.cross);

    //Assert
    expect(
      game.board,
      equals([
        GameMark.circle, GameMark.empty, GameMark.cross, //
        GameMark.empty, GameMark.empty, GameMark.circle, //
        GameMark.empty, GameMark.empty, GameMark.cross, //
      ]),
    );
  });

  group('Check winners method', () {
    List<TicTacToe> winBoards = [];
    List<TicTacToe> incompleteBoards = [];
    List<TicTacToe> tieBoards = [];

    setUp(() {
      winBoards = [
        TicTacToe(List.filled(9, GameMark.circle)),
        const TicTacToe([
          GameMark.circle, GameMark.cross, GameMark.cross, //
          GameMark.empty, GameMark.circle, GameMark.cross,
          GameMark.empty, GameMark.empty, GameMark.circle,
        ]),
      ];

      incompleteBoards = [
        TicTacToe(List.filled(9, GameMark.empty)),
        const TicTacToe([
          GameMark.circle, GameMark.cross, GameMark.cross, //
          GameMark.empty, GameMark.circle, GameMark.cross,
          GameMark.empty, GameMark.empty, GameMark.empty,
        ]),
      ];

      tieBoards = [
        const TicTacToe([
          GameMark.cross, GameMark.circle, GameMark.cross, //
          GameMark.circle, GameMark.circle, GameMark.cross,
          GameMark.cross, GameMark.cross, GameMark.circle,
        ]),
        const TicTacToe([
          GameMark.circle, GameMark.cross, GameMark.circle, //
          GameMark.cross, GameMark.circle, GameMark.cross,
          GameMark.cross, GameMark.circle, GameMark.cross,
        ]),
      ];
    });

    test('Should detect winners', () async {
      //Act
      final results = winBoards.map((e) => e.winner());

      expect(results, [GameMark.circle, GameMark.circle]);
    });

    test('Should return null if no winner', () async {
      //Act
      final results = incompleteBoards.map((e) => e.winner());

      expect(results, [null, null]);
    });

    test('Should return GameMark.empty if tie', () async {
      //Act
      final results = tieBoards.map((e) => e.winner());

      expect(results, [GameMark.empty, GameMark.empty]);
    });
  });
}
