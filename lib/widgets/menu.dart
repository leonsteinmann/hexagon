import 'dart:ui';

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../provider.dart';
import '../single_player.dart';


class Menu extends StatefulWidget{
  BuildContext context;
  SinglePlayer singlePlayer;
  Menu(this.context, this.singlePlayer);

  @override
  _MenuState createState() => _MenuState(context, singlePlayer);

}

class _MenuState extends State<Menu> {
  BuildContext _context;
  SinglePlayer _singlePlayer;
  _MenuState(this._context, this._singlePlayer);


  @override
  void initState(){
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  FlameAudio.play("place_stone.mp3");
                  _singlePlayer.overlays.remove("Menu");
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
                        Icon(Icons.person, color: Colors.white, size: 50,),
                      ],
                    ),
                    Text("solo", style: GoogleFonts.redHatText(),)
                  ],
                ),
              ),
              const SizedBox(height: 25,),
              Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: const [
                      Image(
                        image: AssetImage("assets/images/score_background.png"),
                        height: 100,
                        width: 100,
                        color: Colors.grey,
                      ),
                      Icon(Icons.group, color: Colors.white, size: 50,),
                    ],
                  ),
                  Text("group\n(coming soon)", style: GoogleFonts.redHatText(), textAlign: TextAlign.center,)
                ],
              ),
              const SizedBox(height: 25,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      FlameAudio.play("place_stone.mp3");
                      (menuProvider.isPlayingMusic) ? FlameAudio.bgm.pause() : FlameAudio.bgm.resume();
                      menuProvider.setIsPlayingMusic(!menuProvider.isPlayingMusic);
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image(
                          image: const AssetImage("assets/images/score_background.png"),
                          height: 50,
                          width: 50,
                          color: (menuProvider.isPlayingMusic) ? null : Colors.grey,
                        ),
                        Icon((menuProvider.isPlayingMusic) ? Icons.music_note : Icons.music_off, color: Colors.white, size: 25,),
                      ],
                    ),
                  ),
                  const SizedBox(width: 25,),
                  GestureDetector(
                    onTap: () {
                      FlameAudio.play("place_stone.mp3");
                      menuProvider.setIsPlayingSound(!menuProvider.isPlayingSound);
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image(
                          image: const AssetImage("assets/images/score_background.png"),
                          height: 50,
                          width: 50,
                          color: (menuProvider.isPlayingSound) ? null : Colors.grey,
                        ),
                        Icon((menuProvider.isPlayingSound) ? Icons.volume_up : Icons.volume_off, color: Colors.white, size: 25,),
                      ],
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}