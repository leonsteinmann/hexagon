import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/input.dart';
import 'package:flame/src/geometry/shape.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:take_it_easy_flutter/game.dart';
import 'package:take_it_easy_flutter/palettes.dart';


class ScorecardComp extends PositionComponent with HasGameRef<MainGame>{
  int score;
  String name;

  SpriteComponent backgroundComp;
  TextComponent scoreComp;
  TextComponent nameComp;

  ScorecardComp(Vector2 position, Vector2 size, int priority, Anchor anchor, this.score, this.name) {
    this.position = position;
    this.size = size;
    this.anchor = anchor;
  }

  Future<void> onLoad() async {
    final scoreBackground = await Sprite.load('score_background.png');

    add(backgroundComp = SpriteComponent(
      anchor: Anchor.topCenter,
      position: Vector2(0,0),
      size: Vector2(50,50),
      sprite: scoreBackground,
    )..add(scoreComp = TextComponent(
      anchor: Anchor.center,
        position: Vector2(25,25),
        size: Vector2(50,50),
        text: score.toString(),
      textRenderer: TextPaint(style: GoogleFonts.redHatText(fontSize: 18, fontWeight: FontWeight.bold))
    ))
    );
    add(nameComp = TextComponent(
        anchor: Anchor.center,
        position: Vector2(0,60),
        size: Vector2(50,50),
        text: name,
        textRenderer: TextPaint(style: GoogleFonts.redHatText(fontSize: 14, color: Palette.blueMain.color, fontWeight: FontWeight.normal))
    ));
  }

}