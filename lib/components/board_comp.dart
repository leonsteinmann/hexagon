import 'package:flame/components.dart';
import 'package:take_it_easy_flutter/models/stone.dart';

import '../game.dart';
import 'spot_comp.dart';

class BoardComp extends PositionComponent with HasGameRef<MainGame>{
  List<SpotComp> spotComps = [];


  BoardComp(Vector2 position, Vector2 size) {
    this.position = position;
    this.size = size;
  }

  Future<void> onLoad() async {
    anchor = Anchor.bottomCenter;
    final spotSprite = await Sprite.load('spot.png');

    final spotSize = Vector2(gameRef.canvasSize.x/4, gameRef.canvasSize.x/4);
    // board is 10x10 coordinates
    final coordinateX = gameRef.canvasSize.x/11.5;
    final coordinateY = gameRef.canvasSize.x/10;
    final marginX = coordinateX*1;

    spotComps.add(SpotComp(Vector2(coordinateX*5,coordinateY*1), spotSize, spotSprite, 1, 0));
    spotComps.add(SpotComp(Vector2(coordinateX*3,coordinateY*2), spotSize, spotSprite, 1, 1));
    spotComps.add(SpotComp(Vector2(coordinateX*7,coordinateY*2), spotSize, spotSprite, 1, 2));
    spotComps.add(SpotComp(Vector2(coordinateX*1,coordinateY*3), spotSize, spotSprite, 1, 3));
    spotComps.add(SpotComp(Vector2(coordinateX*5,coordinateY*3), spotSize, spotSprite, 1, 4));
    spotComps.add(SpotComp(Vector2(coordinateX*9,coordinateY*3), spotSize, spotSprite, 1, 5));
    spotComps.add(SpotComp(Vector2(coordinateX*3,coordinateY*4), spotSize, spotSprite, 1, 6));
    spotComps.add(SpotComp(Vector2(coordinateX*7,coordinateY*4), spotSize, spotSprite, 1, 7));
    spotComps.add(SpotComp(Vector2(coordinateX*1,coordinateY*5), spotSize, spotSprite, 1, 8));
    spotComps.add(SpotComp(Vector2(coordinateX*5,coordinateY*5), spotSize, spotSprite, 1, 9));
    spotComps.add(SpotComp(Vector2(coordinateX*9,coordinateY*5), spotSize, spotSprite, 1, 10));
    spotComps.add(SpotComp(Vector2(coordinateX*3,coordinateY*6), spotSize, spotSprite, 1, 11));
    spotComps.add(SpotComp(Vector2(coordinateX*7,coordinateY*6), spotSize, spotSprite, 1, 12));
    spotComps.add(SpotComp(Vector2(coordinateX*1,coordinateY*7), spotSize, spotSprite, 1, 13));
    spotComps.add(SpotComp(Vector2(coordinateX*5,coordinateY*7), spotSize, spotSprite, 1, 14));
    spotComps.add(SpotComp(Vector2(coordinateX*9,coordinateY*7), spotSize, spotSprite, 1, 15));
    spotComps.add(SpotComp(Vector2(coordinateX*3,coordinateY*8), spotSize, spotSprite, 1, 16));
    spotComps.add(SpotComp(Vector2(coordinateX*7,coordinateY*8), spotSize, spotSprite, 1, 17));
    spotComps.add(SpotComp(Vector2(coordinateX*5,coordinateY*9), spotSize, spotSprite, 1, 18));

    for (var i in spotComps) {
      add(i);
    }


  }

}