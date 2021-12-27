import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game.dart';

void main() {
  final myGame = MainGame();
  runApp(
    GameWidget(game: myGame),
  );
}