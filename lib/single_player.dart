import 'dart:ffi';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame/widgets.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:take_it_easy_flutter/components/menu_button_comp.dart';
import 'package:take_it_easy_flutter/components/scorecard_comp.dart';
import 'package:take_it_easy_flutter/components/spot_comp.dart';
import 'package:take_it_easy_flutter/components/stone_comp.dart';

import 'components/board_comp.dart';
import 'models/board.dart';
import 'models/pool.dart';
import 'models/stone.dart';
import 'palettes.dart';

class SinglePlayer extends FlameGame with HasTappables{
  // States
  Board boardState = Board({});
  Pool poolState = Pool([]);
  Stone drawnStone;
  int score;
  int highScore;
  int turn;
  bool gamePaused;

  @override
  bool debugMode = false;

  @override
  backgroundColor() {
    return const Color(0xFFD8B26E);
  }

  // Components
  BoardComp boardComp;
  StoneComp drawnStoneComp;
  ScorecardComp currScoreComp;
  ScorecardComp highScoreComp;
  MenuButtonComp menuButton;

  Sprite nineSixEightSprite;
  Sprite spotSprite;
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
    await createGame();
    await drawStone();

    final width = canvasSize.x;
    final height = canvasSize.y;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play("background_music.mp3");

    spotSprite = await Sprite.load('spot.png');
    add(boardComp = BoardComp(Vector2(width/2+25, height-75), Vector2(width,width)));
    add(drawnStoneComp = StoneComp(Vector2(width/2, 140), Vector2(width/3,width/3), spotSprite, 1)
      ..anchor = Anchor.topCenter
    );
    add(currScoreComp = ScorecardComp(Vector2(width, 50), Vector2(50,50), 1, Anchor.topRight, score, "currently"));
    add(highScoreComp = ScorecardComp(Vector2(50, 50), Vector2(50,50), 1, Anchor.topLeft, score, "highscore"));
    add(menuButton = MenuButtonComp(Vector2(width/2, 50), Vector2(50,50), 1, Anchor.topLeft, "cancel"));
    overlays.add("Menu");
  }


  @override
  Future<void> render(Canvas canvas) async {
    super.render(canvas);
    await renderBoardStones();
    await renderDrawnStone();
    currScoreComp.scoreComp.text = score.toString();
    highScoreComp.scoreComp.text = highScore.toString();

  }

  createGame() async {
    // reset counters
    SharedPreferences prefs = await SharedPreferences.getInstance();
    highScore = prefs.getInt("highScore");
    score = 0;
    turn = 0;
    checkNewHighScore();
    // create spots on board
    for (var spot = 0; spot <= 18; spot++) {
      boardState.spots[spot] = null;
    }
    // create pool
    poolState.stonePool = [];
    for (var vNum in vStoneNumbers) {
      for (var rNum in rStoneNumbers) {
        for (var fNum in fStoneNumbers) {
          poolState.stonePool.add(Stone(vNum,fNum,rNum));
        }
      }
    }

  }


  endGame() async {
    await checkNewHighScore();
    overlays.add("GameOver");
  }

  drawStone() async {
    // create Random number between 0 and stones left
    Random rnd = Random();
    int drawPos = rnd.nextInt(poolState.stonePool.length);
    // draw random Stone and remove it from Pool
    drawnStone = poolState.stonePool[drawPos];
    poolState.stonePool.removeAt(drawPos);
  }

  placeStone(int spot) async {

    if (boardState.spots[spot] == null) {
      boardState.spots[spot] = drawnStone;
      await drawStone();
      countPoints();
      turn = turn + 1;

      FlameAudio.play("place_stone.mp3");
      print("turn $turn");
    } else {
      FlameAudio.play("illegal_stone.mp3");
      print("Hier liegt schon ein Stein");
    }
    if (turn >= 19) {
      endGame();
    }
  }

  countPoints() {
    // count vertical rows
    score = countVPoints() + countRPoints() + countFPoints();
    print("current pints: $score");
  }

  checkNewHighScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int oldScore = prefs.getInt("highScore");
    print("Old Highscore: $oldScore");
    if (oldScore == null) {
      await prefs.setInt("highScore", 0);
    }
    if (oldScore < score) {
      await prefs.setInt("highScore", score);
      print("New Highscore: $highScore");
    }
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
      // if row contains only of vNumbers[0] --> update vpoints
      if (sameNumOccurrence == vRow.length) {
        vPoints = vPoints + (vNumbers[0] * sameNumOccurrence);
      }
    }
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

  getImageSource(Stone spot) {
    return "stones/${spot.vertical.toString() + spot.falling.toString() + spot.rising.toString()}.png";
  }

  Future<void> renderDrawnStone() async {
    if (drawnStone != null) {
      var imageSource = getImageSource(drawnStone);
      drawnStoneComp.sprite = await Sprite.load(imageSource);
    } else {
      //TODO create a play menu
    }

  }

  Future<void> renderBoardStones() async {
    for (var spot in boardState.spots.keys) {
      if (boardState.spots[spot] != null) {
        var imageSource = getImageSource(boardState.spots[spot]);
        boardComp.spotComps[spot].sprite = await Sprite.load(imageSource);
      } else {
        boardComp.spotComps[spot].sprite = spotSprite;
      }
    }
  }
}