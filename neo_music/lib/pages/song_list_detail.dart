import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:neomusic/models/UserInfo.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:fluttertoast/fluttertoast.dart';
class SongListDetailPage extends StatefulWidget {
@override
  _SongListDetailPageState createState() => _SongListDetailPageState();
}
String args = '';
//写在state里面就是不行？
class _SongListDetailPageState extends State<SongListDetailPage> {


  @override
  void initState(){
    args = UserInfo.songListName!;
    initMySongList();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0,20,200,20),
            child: Text(args,style: const TextStyle(fontSize: 16)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              //外层的List背景卡片Container
              height: 510,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(240, 240, 243, 0.5),
                border: Border.all(
                    color: const Color.fromRGBO(240, 240, 243, 1), width: 1.0),
                borderRadius: BorderRadius.circular(8.0),
              ),

              child: ListView.builder(
//                  shrinkWrap: true,
                  itemCount: songListData.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        //这是包裹每个ListTile的Container
                        height: 54,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(240, 240, 243, 1),
                          border: Border.all(
                              color: const Color.fromRGBO(240, 240, 243, 0.8),
                              width: 1.0),
                          borderRadius: BorderRadius.circular(22.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(234, 234, 242, 0.8),
                              //底色,阴影颜色
                              offset: Offset(1.5, 2.0),
                              //阴影位置,从什么位置开始
                              blurRadius: 0,
                              // 阴影模糊层度
                              spreadRadius: 0, //阴影模糊大小
                            ),
                          ],
                        ),
//                      padding: const EdgeInsets.all(10.0),
                        child: GestureDetector(
                          onLongPress: ()=>deleteMusic(songListData[index]["MusicID"],UserInfo.username!,args),
                          onTap: () =>
                              playListMusic(songListData[index]["MusicID"],songListData[index]["音乐名"],songListData[index]["歌手"], index),
                          child: ListTile(
                              dense: true,
                              trailing: flag[index]
                                  ? Image.asset("images/pause.png")
                                  : Image.asset("images/play.png"),
                              title: Row(
                                children: <Widget>[
                                  Text(songListData[index]["音乐名"],
                                      style: const TextStyle(fontSize: 16)),
                                  const SizedBox(width: 20),
                                  Text(
                                    songListData[index]["歌手"],
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Color.fromRGBO(124, 124, 124, 0.8)),
                                  )
                                ],
                              )),
                        ),
                      ),
                    );
                  }),
            ),
          ),
//        SizedBox(height: 30),
          Container(
            height: 60,
            decoration: BoxDecoration(
                color: const Color.fromRGBO(240, 240, 243, 1),
                borderRadius: BorderRadius.circular(22.0)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 6, 6, 6),
              child: Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(UserInfo.songName, style: const TextStyle(fontSize: 14)),
                      Text(
                        UserInfo.artist,
                        style: const TextStyle(
                            fontSize: 12,
                            color: Color.fromRGBO(124, 124, 124, 0.8)),
                      )
                    ],
                  ),
                  const SizedBox(width: 180),
//                Image.asset("images/last.png"),
                  GestureDetector(
                    child: UserInfo.bottomFlag
                        ? Image.asset("images/pause.png")
                        : Image.asset("images/play.png"),
//                    onTap: () => playMusic(),
                    onTap: changePlayerState,
                  ),
//                Image.asset("images/next.png"),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future initMySongList() async{
    String userName = UserInfo.username!;
    print(args);
    Response response = await Dio().get("http://101.201.34.135:8012/mydb/getMusic/'$userName'/'$args'");
    print(response.data);
    setState(() {
      songListData = response.data;
    });
  }


  Future playListMusic(String id, String name,String artist,int number) async {
    //播放当前ListTile的歌曲，根据歌曲id去请求mp3文件
    print("playListMusic called");
    if (flag[number] == true) {
      int result = await audioPlayer.pause();
      print("暂停");
      setState(() {
        flag[number] = !flag[number];
        UserInfo.bottomFlag = !UserInfo.bottomFlag;
      });
    } else {
      Response? response;
      response = await Dio()
          .get("http://music.cyrilstudio.top/song/url", queryParameters: {
        "id": id,
      });
      var songMp3 = response.data;
      print(songMp3);
      print(id);
      String url = (songMp3["data"][0]["url"]);
      if (url == null) {
        Fluttertoast.showToast(
            msg: "歌曲资源暂时下架了哦",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 12.0);
      }
      int result = await audioPlayer.play(url);
      if (result == 1) {
        print("正在播放");
        setState(() {
          UserInfo.playingIndex = number;
          UserInfo.songName = name;
          UserInfo.artist = artist;
          flag[number] = !flag[number];
          UserInfo.bottomFlag = !UserInfo.bottomFlag;
        });
        // success
      }
    }
  }

  Future deleteMusic(String songId,String userName,String songList) async{
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('从此歌单移除'),
            content: Card(
              elevation: 0.0,
              child: Column(
                children: const <Widget>[
                  Text('您确定要删除吗？'),
                ],
              ),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('取消'),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  commitDelete( songId,userName,songList).then((value) => initMySongList());
                  Navigator.pop(context);
                  setState(() {});
                },
                child: Text('确定'),
              ),
            ],
          );
        });
  }
  Future commitDelete(String songId,String userName,String songList) async{
    await Dio().get("http://101.201.34.135:8012/mydb/delMusic/'$songId'/'$userName'/'$songList'");
  }

  Future changePlayerState() async{//两个页面，如何共享音乐控制器？
//    print("playListMusic called");
//    if (UserInfo.bottomFlag == true) {
//      int result = await audioPlayer.pause();
//      print("暂停");
//      setState(() {
//        UserInfo.bottomFlag = !UserInfo.bottomFlag;
//      });
//    } else {
//      int result = await audioPlayer.resume();
//      if (result == 1) {
//        print("正在播放");
//        setState(() {
//          UserInfo.bottomFlag = !UserInfo.bottomFlag;
//        });
//        // success
//      }
//    }
  }

  var flag = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ]; //初始时，默认播放
  AudioPlayer audioPlayer = AudioPlayer();
  List songListData = [
    {
      "音乐名": "七里香",
      "歌手": "周杰伦",
    },
  ];
}
