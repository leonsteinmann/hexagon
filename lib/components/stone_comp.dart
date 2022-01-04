import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../palettes.dart';
import '../single_player.dart';


class StoneComp extends SpriteComponent with HasGameRef<SinglePlayer>{

  StoneComp(Vector2 position, Vector2 size, Sprite sprite, int priority) {
    this.position = position;
    this.size = size;
    this.sprite = sprite;
  }

  @override
  Future<void> onLoad() {
    add(TextComponent(
        anchor: Anchor.topCenter,
        position: Vector2(size.x/2, size.y),
        size: Vector2(50,50),
        text: "next",
        textRenderer: TextPaint(style: GoogleFonts.redHatText(fontSize: 14, color: Palette.blueMain.color, fontWeight: FontWeight.normal))
    ));
    return super.onLoad();

  }

}
