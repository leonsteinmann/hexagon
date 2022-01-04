import 'dart:ui';

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../palettes.dart';
import '../provider.dart';
import '../single_player.dart';


class GameOver extends StatefulWidget{
  BuildContext context;
  SinglePlayer singlePlayer;
  GameOver(this.context, this.singlePlayer);

  @override
  _GameOverState createState() => _GameOverState(context, singlePlayer);

}

class _GameOverState extends State<GameOver> {
  BuildContext _context;
  SinglePlayer _singlePlayer;
  _GameOverState(this._context, this._singlePlayer);


  @override
  void initState(){
    super.initState();

  }

  @override
  Widget build(BuildContext _context) {
    final menuProvider = Provider.of<MenuProvider>(_context, listen: true);

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/menu_background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: null /* add child content here */,
          ),
          SizedBox(
            width: MediaQuery.of(_context).size.width,
            height: MediaQuery.of(_context).size.height,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
              child: Container(
                color: Colors.black.withOpacity(0.0),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text((
                  _singlePlayer.score > _singlePlayer.highScore) ? "new highscore" : "your score:",
                  style: GoogleFonts.redHatText(fontSize: 24, color: Palette.blueMain.color)
              ),
              Text(
                _singlePlayer.score.toString(),
                style: GoogleFonts.redHatText(fontSize: 48, fontWeight: FontWeight.bold, color: Palette.blueMain.color),
              ),
              SizedBox(height: 50,),
              GestureDetector(
                onTap: () {
                  FlameAudio.play("place_stone.mp3");
                  _singlePlayer.overlays.remove("GameOver");
                  _singlePlayer.createGame();
                },
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: const [
                        Image(
                          image: AssetImage("assets/images/score_background.png"),
                          height: 100,
                          width: 100,
                        ),
                        Icon(Icons.repeat, color: Colors.white, size: 35,),
                      ],
                    ),
                    Text("play again", style: GoogleFonts.redHatText(),)
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  FlameAudio.play("place_stone.mp3");
                  _singlePlayer.overlays.remove("GameOver");
                  _singlePlayer.overlays.add("Menu");
                },
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: const [
                        Image(
                          image: AssetImage("assets/images/cancel.png"),
                          height: 100,
                          width: 100,
                        ),
                        Icon(Icons.repeat, color: Colors.white, size: 35,),
                      ],
                    ),
                    Text("back to menu", style: GoogleFonts.redHatText(),)
                  ],
                ),
              ),
              SizedBox(height: 100,),
            ],
          )
        ],
      ),
    );
  }
}