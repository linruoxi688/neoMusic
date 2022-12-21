import 'package:audioplayers/audioplayers.dart';
class UserInfo{
  static String? username;
  static String? songListName;
  static String songName = "未知歌曲";
  static String artist = "未知艺术家";
  static int playingIndex = 0;
  static bool bottomFlag = false;
  static AudioPlayer audioPlayer = new AudioPlayer();
//  String getUserName(){
//    return username!;
//  }
}