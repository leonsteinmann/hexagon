import 'dart:ffi';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/input.dart';
import 'package:flame/src/geometry/shape.dart';
import 'package:flutter/material.dart';
import 'package:take_it_easy_flutter/game.dart';


class SpotComp extends SpriteComponent with Tappable, HasHitboxes, HasGameRef<MainGame>{
  int spotNum;

  SpotComp(Vector2 position, Vector2 size, Sprite sprite, int priority, this.spotNum) {
    this.position = position;
    this.size = size;
    this.sprite = sprite;
  }

  Future<void> onLoad() async {
    anchor = Anchor.center;
    addHitbox(HitboxCircle(normalizedRadius: 0.8));
  }

  @override
  bool onTapUp(TapUpInfo event) {
    print("tap up on Spot: $spotNum");
    gameRef.placeStone(spotNum);
    return true;
  }

}

/*class SpotCompHex extends PolygonComponent {

  SpotCompHex(Vector2 position, Vector2 size, Paint paint, int priority) {
    this.position = position;
    this.size = size;
    this.paint = paint;
    //this.priority = priority;
  }

}*/
