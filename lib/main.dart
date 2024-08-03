import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'tictactoe.dart';
import 'tictactoe_board_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
      ),
      darkTheme: ThemeData.from(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.cyan,
          brightness: Brightness.dark,
        ),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TicTacToe game;
  late GameMark currentPlayer;

  @override
  initState() {
    super.initState();

    _resetGame();
  }

  _resetGame() {
    game = TicTacToe.empty();
    currentPlayer = GameMark.cross;
  }

  void onSpaceTap(int index) {
    try {
      markBoardAt(index);

      final winner = game.winner();

      if (winner == null) {
        switchCurrentPlayer();
      } else {
        showResult(winner);
      }
    } catch (e, st) {
      log("Error at onSpaceTap: ", error: e, stackTrace: st);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void markBoardAt(int index) {
    setState(() {
      game.markAt(index: index, mark: currentPlayer);
    });
  }

  void switchCurrentPlayer() {
    setState(() {
      currentPlayer = switch (currentPlayer) {
        GameMark.empty => throw UnimplementedError(),
        GameMark.cross => GameMark.circle,
        GameMark.circle => GameMark.cross,
      };
    });
  }

  void showResult(GameMark winner) {
    restartButtonPressed() {
      setState(() {
        _resetGame();
        Navigator.of(context).pop();
      });
    }

    showAdaptiveDialog(
      context: context,
      builder: (context) => winner == GameMark.empty
          ? TieDialog(onRestartButtonPressed: restartButtonPressed)
          : WinnerDialog(winner: winner, onRestartButtonPressed: restartButtonPressed),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            tooltip: "Restart game",
            onPressed: () => setState(() {
              _resetGame();
            }),
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Current player: ",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                GameMarkIcon(mark: currentPlayer),
              ],
            ),
            Center(
              child: TicTacToeBoardWidget(
                game: game,
                onSpaceTap: onSpaceTap,
              ),
            ),
            TextButton(
              onPressed: () {
                launchUrlString("https://github.com/IguJl15");
              },
              child: const Text("Meet the developer"),
            )
          ],
        ),
      ),
    );
  }
}

class WinnerDialog extends StatelessWidget {
  const WinnerDialog({
    super.key,
    required this.winner,
    required this.onRestartButtonPressed,
  });

  final GameMark winner;
  final VoidCallback onRestartButtonPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("${winner.name} win"),
      content: Text("Congratulation, ${winner.name}"),
      actions: [
        TextButton(
          onPressed: onRestartButtonPressed,
          child: const Text("Restart"),
        )
      ],
    );
  }
}

class TieDialog extends StatelessWidget {
  const TieDialog({super.key, required this.onRestartButtonPressed});

  final VoidCallback onRestartButtonPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("It's a tie!"),
      content: const Text("The game ended without winners"),
      actions: [
        TextButton(
          onPressed: onRestartButtonPressed,
          child: const Text("Restart"),
        )
      ],
    );
  }
}
