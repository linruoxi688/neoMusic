import 'package:flutter/material.dart';
import 'package:neomusic/pages/music_play.dart';
import 'package:neomusic/pages/recommend.dart';
import 'package:neomusic/pages/song_list_detail.dart';
import 'pages/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
      routes: {
        'login':(context)=>LoginPage(),
        'recommend':(context)=>RecommendPage(),
        'songlistdetail':(context)=>SongListDetailPage(),
        'musicplay':(context)=>MusicPlayPage(),
      },
    );
  }
}

