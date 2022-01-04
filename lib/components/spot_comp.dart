import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/input.dart';

import '../single_player.dart';



class SpotComp extends SpriteComponent with Tappable, HasHitboxes, HasGameRef<SinglePlayer>{
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
    gameRef.placeStone(spotNum);
    return true;
  }

}
