import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Piedra Papel Tijera Lagarto Spock',
      home: Game(),
    );
  }
}

enum GameOption {
  piedra('assets/piedra.png'),
  papel('assets/papel.png'),
  tijera('assets/tijera.png'),
  lagarto('assets/lagarto.png'),
  spock('assets/spock.png');

  const GameOption(this.assetPath);

  final String assetPath;

  // a func thAt returns who won
  GameOption? whoWon(GameOption other) {
    if (this == other) return null;

    switch (this) {
      case GameOption.piedra:
        return other == GameOption.tijera || other == GameOption.lagarto
            ? this
            : other;
      case GameOption.papel:
        return other == GameOption.piedra || other == GameOption.spock
            ? this
            : other;
      case GameOption.tijera:
        return other == GameOption.papel || other == GameOption.lagarto
            ? this
            : other;
      case GameOption.lagarto:
        return other == GameOption.papel || other == GameOption.spock
            ? this
            : other;
      case GameOption.spock:
        return other == GameOption.piedra || other == GameOption.tijera
            ? this
            : other;
    }
  }
}

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  GameOption? _player1Option;
  GameOption? _player2Option;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Piedra Papel Tijera Lagarto Spock'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              PickOption(
                selectedOption: _player1Option,
                onOptionSelected: (GameOption option) =>
                    setState(() => _player1Option = option),
              ),
              PickOption(
                selectedOption: _player2Option,
                onOptionSelected: (GameOption option) =>
                    setState(() => _player2Option = option),
              ),
            ],
          ),
          TextButton(
            child: const Text('Play'),
            onPressed: () {
              if (_player1Option == null || _player2Option == null) return;
              final winner = _player1Option!.whoWon(_player2Option!);
              final winnerName = winner == _player1Option
                  ? 'Player 1'
                  : winner == _player2Option
                      ? 'Player 2'
                      : null;
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    winnerName == null
                        ? 'Draw'
                        : 'Winner is $winnerName (${winner?.name} > ${_player2Option?.name})',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        // buton that makes the game play
      ),
    );
  }
}

class PickOption extends StatefulWidget {
  const PickOption({
    super.key,
    required this.selectedOption,
    required this.onOptionSelected,
  });

  // on option selected

  final GameOption? selectedOption;

  final ValueChanged<GameOption> onOptionSelected;

  @override
  State<PickOption> createState() => _PickOptionState();
}

class _PickOptionState extends State<PickOption> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final option in GameOption.values)
          Row(
            children: [
              Radio(
                value: option,
                groupValue: widget.selectedOption,
                onChanged: (GameOption? value) {
                  widget.onOptionSelected(value!);
                },
              ),
              Image.asset(
                option.assetPath,
                width: 50,
              ),
            ],
          ),
      ],
    );
  }
}
