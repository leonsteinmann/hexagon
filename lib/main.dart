import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flame/widgets.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:take_it_easy_flutter/widgets/gameOver.dart';

import 'single_player.dart';
import 'provider.dart';
import 'widgets/menu.dart';

void main() {
  final singlePlayer = SinglePlayer();
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider<MenuProvider>(create: (context) => MenuProvider()),
        ],
        child: MaterialApp(
          home: GameWidget(
            game: singlePlayer,
            overlayBuilderMap: {
              "Menu": (BuildContext context, SinglePlayer singlePlayer) {
                return Menu(context, singlePlayer);
              },
              "GameOver": (BuildContext context, SinglePlayer singlePlayer) {
                return GameOver(context, singlePlayer);
              }
            },
          ),
        ),
    )
  );
}