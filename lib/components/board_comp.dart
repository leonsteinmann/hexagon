import 'package:flame/components.dart';
import 'package:take_it_easy_flutter/models/stone.dart';

class BoardComp extends SpriteComponent {

  BoardComp(Vector2 position, Vector2 size, Sprite sprite) {
    this.position = position;
    this.size = size;
    this.sprite = sprite;
  }

}