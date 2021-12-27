import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:take_it_easy_flutter/components/spot_comp.dart';

import 'components/board_comp.dart';
import 'models/board.dart';
import 'models/pool.dart';
import 'models/stone.dart';

class MainGame extends FlameGame with HasTappables{
  // Class instances
  Board boardState = Board({});
  Pool poolState = Pool([]);

  @override
  bool debugMode = true;

  @override
  backgroundColor() {
    return const Color(0xFFD8B26E);
  }
  // Game components
  Stone drawnStone;
  int score;

  // Components
  SpotComp spot0, spot1, spot2, spot3, spot4, spot5, spot6, spot7, spot8, spot9, spot10, spot11, spot12, spot13, spot14, spot15, spot16, spot17, spot18;

  TextComponent currStone;
  TextComponent currScore;

  // Numbers for vertical, rising, falling rows on stones
  List<int> vStoneNumbers = [1,5,9];
  List<int> rStoneNumbers = [2,6,7];
  List<int> fStoneNumbers = [3,4,8];

  // Board rows to count points of complete rows (vertical, rising, falling))
  List<List<int>> vBoardRows = [[3,8,13], [1,6,11,16], [0,4,9,14,18], [2,7,12,17], [5,10,15]];
  List<List<int>> rBoardRows = [[0,1,3], [2,4,6,8], [5,7,9,11,13], [10,12,14,16], [15,17,18]];
  List<List<int>> fBoardRows = [[0,2,5], [1,4,7,10], [3,6,9,12,15], [8,11,14,17], [13,16,18]];

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final width = canvasSize.x;
    final height = canvasSize.y;
    final spotSize = width/6;
    final spotPaddingV = spotSize/4;
    final spotSprite = await Sprite.load('spot.png');

    addSpots(width, height, spotSize, spotPaddingV, spotSprite);

    add(currStone = TextComponent(text: "Current Drawn Stone:")
      ..anchor = Anchor.topRight
      ..x = width
      ..y = 100.0);
    add(currScore= TextComponent(text: "Current Drawn Stone:")
      ..anchor = Anchor.topLeft
      ..x = 0 // size is a property from game
      ..y = 100.0);

    createGame();
    drawStone();
  }

  @override
  void update(double dt) {
    super.update(dt);
    currStone.text = "Stone: \n" + drawnStone.vertical.toString() + drawnStone.rising.toString() + drawnStone.falling.toString();
    currScore.text = "Score: \n" + score.toString();
  }

  @override
  Future<void> render(Canvas canvas) async {
    super.render(canvas);
    /*for (var spot in boardState.spots.keys) {
      if (boardState.spots[spot] != null) {
        spot0.sprite = await Sprite.load('profile.png');
      }
    }

    if (boardState.spots[0] != null) {
      spot0.sprite = await Sprite.load('profile.png');
    }*/
  }

  void addSpots(double width, double height, double spotSize, double spotPaddingV, Sprite spotSprite) {
    add(spot0 = SpotComp(Vector2(width/2,height/2-(spotSize+spotPaddingV)*2), Vector2(spotSize*1.5,spotSize*1.5), spotSprite, 1, 0));
    add(spot1 = SpotComp(Vector2(width/2-spotSize,height/2-(spotSize+spotPaddingV)*1.5), Vector2(spotSize*1.5,spotSize*1.5), spotSprite, 1, 1));
    add(spot2 = SpotComp(Vector2(width/2+spotSize,height/2-(spotSize+spotPaddingV)*1.5), Vector2(spotSize*1.5,spotSize*1.5), spotSprite, 1, 2));
    add(spot3 = SpotComp(Vector2(width/2-spotSize*2,height/2-(spotSize+spotPaddingV)*1), Vector2(spotSize*1.5,spotSize*1.5), spotSprite, 1, 3));
    add(spot4 = SpotComp(Vector2(width/2,height/2-(spotSize+spotPaddingV)*1), Vector2(spotSize*1.5,spotSize*1.5), spotSprite, 1, 4));
    add(spot5 = SpotComp(Vector2(width/2+spotSize*2,height/2-(spotSize+spotPaddingV)*1), Vector2(spotSize*1.5,spotSize*1.5), spotSprite, 1, 5));
    add(spot6 = SpotComp(Vector2(width/2-spotSize,height/2-(spotSize+spotPaddingV)*0.5), Vector2(spotSize*1.5,spotSize*1.5), spotSprite, 1, 6));
    add(spot7 = SpotComp(Vector2(width/2+spotSize,height/2-(spotSize+spotPaddingV)*0.5), Vector2(spotSize*1.5,spotSize*1.5), spotSprite, 1, 7));
    add(spot8 = SpotComp(Vector2(width/2-spotSize*2,height/2-(spotSize+spotPaddingV)*0), Vector2(spotSize*1.5,spotSize*1.5), spotSprite, 1, 8));
    add(spot9 = SpotComp(Vector2(width/2,height/2-(spotSize+spotPaddingV)*0), Vector2(spotSize*1.5,spotSize*1.5), spotSprite, 1, 9));
    add(spot10 = SpotComp(Vector2(width/2+spotSize*2,height/2-(spotSize+spotPaddingV)*0), Vector2(spotSize*1.5,spotSize*1.5), spotSprite, 1, 10));
    add(spot11 = SpotComp(Vector2(width/2-spotSize,height/2-(spotSize+spotPaddingV)*-0.5), Vector2(spotSize*1.5,spotSize*1.5), spotSprite, 1, 11));
    add(spot12 = SpotComp(Vector2(width/2+spotSize,height/2-(spotSize+spotPaddingV)*-0.5), Vector2(spotSize*1.5,spotSize*1.5), spotSprite, 1, 12));
    add(spot13 = SpotComp(Vector2(width/2-spotSize*2,height/2-(spotSize+spotPaddingV)*-1), Vector2(spotSize*1.5,spotSize*1.5), spotSprite, 1, 13));
    add(spot14 = SpotComp(Vector2(width/2,height/2-(spotSize+spotPaddingV)*-1), Vector2(spotSize*1.5,spotSize*1.5), spotSprite, 1, 14));
    add(spot15 = SpotComp(Vector2(width/2+spotSize*2,height/2-(spotSize+spotPaddingV)*-1), Vector2(spotSize*1.5,spotSize*1.5), spotSprite, 1, 15));
    add(spot16 = SpotComp(Vector2(width/2-spotSize,height/2-(spotSize+spotPaddingV)*-1.5), Vector2(spotSize*1.5,spotSize*1.5), spotSprite, 1, 16));
    add(spot17 = SpotComp(Vector2(width/2+spotSize,height/2-(spotSize+spotPaddingV)*-1.5), Vector2(spotSize*1.5,spotSize*1.5), spotSprite, 1, 17));
    add(spot18 = SpotComp(Vector2(width/2,height/2-(spotSize+spotPaddingV)*-2), Vector2(spotSize*1.5,spotSize*1.5), spotSprite, 1, 18));
  }


  createGame() {
    // create spots on board
    for (var spot = 0; spot <= 18; spot++) {
      boardState.spots[spot] = null;
    }
    // create pool
    for (var vNum in vStoneNumbers) {
      for (var rNum in rStoneNumbers) {
        for (var fNum in fStoneNumbers) {
          poolState.stonePool.add(Stone(vNum,rNum,fNum));
        }
      }
    }
  }

  drawStone() {
    // create Random number between 0 and stones left
    Random rnd = Random();
    int drawPos = rnd.nextInt(poolState.stonePool.length);
    // draw random Stone and remove it from Pool
    //print("Anzahl an Steinen vor Ziehen: " + poolState.stonePool.length.toString());
    drawnStone = poolState.stonePool[drawPos];
    poolState.stonePool.removeAt(drawPos);
    //print("Anzahl an Steinen nach Ziehen: " + poolState.stonePool.length.toString());
    //print("Gezogener Stein: " + drawnStone.vertical.toString() + drawnStone.rising.toString() + drawnStone.falling.toString());

  }

  placeStone(int spot) {
    if (boardState.spots[spot] == null) {
      boardState.spots[spot] = drawnStone;
      drawStone();
      print(boardState.spots);
    } else {
      print("Hier liegt schon ein Stein");
    }
    countPoints();
  }

  countPoints() {
    //TODO - count points of current Board situation
    // count vertical rows
    score = countVPoints() + countRPoints() + countFPoints();
    print("current pints: $score");
  }

  int countVPoints() {
    int vPoints = 0;
    // check each row of the board
    for (var vRow in vBoardRows) {
      // add the vertical number of each stone to a list
      List<int> vNumbers = [];
      for (var vSpot in vRow) {
        if (boardState.spots[vSpot] != null) {
          vNumbers.add(boardState.spots[vSpot].vertical);
        } else {
          vNumbers.add(0);
        }
      }
      // check how often vNumbers[0] occurred in list of vertical numbers in that row
      int sameNumOccurrence = vNumbers.map((element) => element == vNumbers[0] ? 1 : 0).reduce((value, element) => value + element);
      print("the number: ${vNumbers[0]}, occurred: $sameNumOccurrence times, in a row with ${vRow.length} spots");
      // if row contains only of vNumbers[0] --> update vpoints
      if (sameNumOccurrence == vRow.length) {
        vPoints = vPoints + (vNumbers[0] * sameNumOccurrence);
      }
    }
    print("vertical points added: $vPoints");
    return vPoints;
  }

  // same as countVPoints() for rising
  int countRPoints() {
    int rPoints = 0;
    for (var rRow in rBoardRows) {
      List<int> rNumbers = [];
      for (var rSpot in rRow) {
        if (boardState.spots[rSpot] != null) {
          rNumbers.add(boardState.spots[rSpot].rising);
        } else {rNumbers.add(0);}
      }
      int sameNumOccurrence = rNumbers.map((element) => element == rNumbers[0] ? 1 : 0).reduce((value, element) => value + element);
      if (sameNumOccurrence == rRow.length) {
        rPoints = rPoints + (rNumbers[0] * sameNumOccurrence);
      }
    }
    return rPoints;
  }

  // same as countVPoints() for falling
  int countFPoints() {
    int fPoints = 0;
    for (var fRow in fBoardRows) {
      List<int> fNumbers = [];
      for (var fSpot in fRow) {
        if (boardState.spots[fSpot] != null) {
          fNumbers.add(boardState.spots[fSpot].falling);
        } else {fNumbers.add(0);}
      }
      int sameNumOccurrence = fNumbers.map((element) => element == fNumbers[0] ? 1 : 0).reduce((value, element) => value + element);
      if (sameNumOccurrence == fRow.length) {
        fPoints = fPoints + (fNumbers[0] * sameNumOccurrence);
      }
    }
    return fPoints;
  }

  endGame() {
    //TODO - save high score
  }

}