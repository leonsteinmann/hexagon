import 'dart:ffi';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/input.dart';
import 'package:flame/src/geometry/shape.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:take_it_easy_flutter/single_player.dart';

import '../palettes.dart';


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
