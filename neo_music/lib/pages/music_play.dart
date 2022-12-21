import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:audioplayers/audioplayers.dart';

class MusicPlayPage extends StatefulWidget {
  @override
  _MusicPlayPageState createState() => _MusicPlayPageState();
}

class _MusicPlayPageState extends State<MusicPlayPage> {
  bool flag = false; //初始时，默认暂停
  AudioPlayer audioPlayer = AudioPlayer();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          _buildImage(),
          const SizedBox(height: 20),
          _buildWord(),
          const SizedBox(height: 20),
          _buildBar(),
          const SizedBox(height: 20),
          _buildButtons(),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      child: Image.asset("images/Logo.png"),
    );
  }

  Widget _buildWord() {
    return Column(
      children: const <Widget>[
        Text(
          "七里香",
          style: TextStyle(fontSize: 20),
        ),
        Text(
          "周杰伦",
          style:
              TextStyle(fontSize: 14, color: Color.fromRGBO(124, 124, 124, 1)),
        )
      ],
    );
  }

  Widget _buildBar() {
    return Container();
  }

  Widget _buildButtons() {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min, //Container适应内部按钮
        children: <Widget>[
          Image.asset("images/last.png"),
          GestureDetector(
            child: flag
                ? Image.asset(
                    "images/pause.png",
                    width: 100,
                    height: 100,
                    fit: BoxFit.fill,
                  )
                : Image.asset(
                    "images/play.png",
                    width: 100,
                    height: 100,
                    fit: BoxFit.fill,
                  ),
            onTap: () => playMusic(),
          ),
          Image.asset("images/next.png"),
        ],
      ),
    );
  }

  Future playMusic() async {

    if(flag==true){
      int result = await audioPlayer.pause();
      print("暂停");
      setState(() {
        flag = !flag;
      });
    }
    else{
      int result = await audioPlayer.play(
          "http://m8.music.126.net/20220606103050/81605cc1bb72aa0951c50469fdb71a71/ymusic/0fd6/4f65/43ed/a8772889f38dfcb91c04da915b301617.mp3");
      if (result == 1) {
        print("正在播放");
        setState(() {
          flag = !flag;
        });
        // success
      }
    }
  }
}
