import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/input.dart';
import 'package:flame/src/geometry/shape.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../palettes.dart';
import '../single_player.dart';


class MenuButtonComp extends PositionComponent with Tappable, HasGameRef<SinglePlayer>{
  String label;

  SpriteComponent iconComp;
  TextComponent<TextPaint> labelComp;

  MenuButtonComp(Vector2 position, Vector2 size, int priority, Anchor anchor, this.label) {
    this.position = position;
    this.size = size;
    this.anchor = anchor;
  }

  Future<void> onLoad() async {
    final scoreBackground = await Sprite.load('cancel.png');

    add(iconComp = SpriteComponent(
      anchor: Anchor.topCenter,
      size: Vector2(50,50),
      sprite: scoreBackground,
    ));
    add(labelComp = TextComponent(
        anchor: Anchor.center,
        position: Vector2(0,60),
        size: Vector2(50,50),
        text: label,
        textRenderer: TextPaint(style: GoogleFonts.redHatText(fontSize: 14, color: Palette.blueMain.color, fontWeight: FontWeight.normal)),
    ));
  }

  @override
  bool onTapUp(TapUpInfo event) {
    gameRef.overlays.add("Menu");
    return true;
  }

}