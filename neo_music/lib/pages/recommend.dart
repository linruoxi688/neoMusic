
import 'package:flutter/material.dart';
import 'package:neomusic/pages/song_list.dart';
import 'package:neomusic/pages/song_list_detail.dart';
import 'package:dio/dio.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neomusic/utils/widget/AppTool.dart';

import '../models/UserInfo.dart';

TextEditingController textEditingController = TextEditingController();

class RecommendPage extends StatefulWidget {
  @override
  _RecommendPageState createState() => _RecommendPageState();
}

class _RecommendPageState extends State<RecommendPage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;


  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);

//    textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        // ignore: sized_box_for_whitespace
        Container(
//              alignment: Alignment.topLeft, 怎么让它左对齐？
          width: 120,
          child: TabBar(
//              isScrollable: true,
            indicatorColor: const Color.fromRGBO(184, 191, 255, 1),
            tabs: const <Widget>[
              Tab(
                child: Text(
                  "发现",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Tab(
                child: Text(
                  "我的",
                  style: TextStyle(color: Colors.black),
                ),
              )
            ],
            controller: tabController,
          ),
        ),
        Flexible(
          child: TabBarView(
            controller: tabController,
            children: [
              _buildRecommend(),
              _buildMySongList(),
            ],
          ),
        ),
      ],
    ));
  }

  _buildRecommend() {
    return Column(
      children: <Widget>[
        _buildSearchBar(), //顶部搜索框
        _buildSongList(), //主体歌曲列表
      ],
    );
  }

  _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(240, 240, 243, 1), //底色,阴影颜色
              offset: Offset(1.5, 1.5), //阴影位置,从什么位置开始
              blurRadius: 0, // 阴影模糊层度
              spreadRadius: 0, //阴影模糊大小
            ),
          ],
          color: Colors.white,
        ),
        height: 46,
        child: TextField(
          controller: textEditingController,
          decoration: InputDecoration(
            prefixIcon:
                IconButton(icon: const Icon(Icons.search), onPressed: search),
            hintText: "搜索",
            prefixIconColor: const Color.fromRGBO(194, 191, 255, 1),
            hintStyle: const TextStyle(
                fontSize: 14, color: Color.fromRGBO(124, 124, 124, 1)),
            enabledBorder: const OutlineInputBorder(
              /*边角*/
              borderRadius: BorderRadius.all(
                Radius.circular(22),
              ),
              borderSide: BorderSide(
                color: Color.fromRGBO(240, 240, 243, 1),
                width: 2,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(22),
                ),
                borderSide: BorderSide(
                  color: Color.fromRGBO(240, 240, 243, 1),
                  width: 2,
                )),
          ),
        ),
      ),
    );
  }

  _buildSongList() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            //外层的List背景卡片Container
            height: 445,
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
                        onLongPress: () => addToSongList(
                            songListData[index]["id"],
                            songListData[index]["name"],
                            songListData[index]["artists"][0]["name"]),
                        onTap: () =>
                            playListMusic(songListData[index]["name"],songListData[index]["artists"][0]["name"],songListData[index]["id"], index),
                        //箭头函数，传参必须加()=>,平时可以省略
                        child: ListTile(
                            dense: true,
                            trailing: flag[index]
                                ? Image.asset("images/pause.png")
                                : Image.asset("images/play.png"),
                            title: Row(
                              children: <Widget>[
                                Container(
                                  width: 0,
                                  child: Text(
                                      songListData[index]["id"].toString()),
                                ),
                                Container(
                                  width: 120,
                                  child: Text(songListData[index]["name"],
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 16)),
                                ),
                                Container(
                                  width: 80,
                                  child: Text(
                                    songListData[index]["artists"][0]["name"],
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color:
                                            Color.fromRGBO(124, 124, 124, 0.8)),
                                  ),
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                const SizedBox(width: 120),
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
    );
  }

  _buildMySongList() {
    return SongListPage();
  }

  Future search() async {
    Response? response;
    print(textEditingController.text);
    response = await Dio().get("http://music.cyrilstudio.top/search",
        queryParameters: {"keywords": textEditingController.text, "limit": 10});
    var result = response.data;
    print(result);
    var code = result["code"];
    var songs = result["result"]["songs"];
    var artist = songs[0]["artists"][0]["name"];
    var pic = songs[0]["artists"][0]["img1v1Url"];
    print(code); //状态码，200为成功;
    setState(() {
      for(int i = 0;i<flag.length;i++){
        flag[i] = false;
      }
      audioPlayer.stop();
      UserInfo.bottomFlag = false;
      songListData = songs;
    });
  }

  Future playListMusic(String name,String artist,int id, int number) async {
    await audioPlayer.stop();
    setState(() {
      for(int i = 0;i<flag.length;i++){
        flag[i] = false;
      }
      UserInfo.bottomFlag = false;
    });

    //播放当前ListTile的歌曲，根据歌曲id去请求mp3文件
    print("playListMusic called");
    if (flag[number] == true) {
      int result = await audioPlayer.pause();
      print("暂停");
      setState(() {
        flag[number] = !flag[number];
        UserInfo.bottomFlag = false;
      });
    } else {
      print(id);
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
          UserInfo.bottomFlag = true;
        });
        // success
      }
    }
  }

  Future initSongList() async {
    mySongListName.clear();
    Response responese;
    String userName = UserInfo.username!;
    print("缓存中数据为：" + userName);
    responese = await Dio().get(
      "http://101.201.34.135:8012/mydb/getGedan/'$userName'",
    );
    setState(() {
      mySongListData = responese.data;
    });
    print("initSongList!");
    print(mySongListData);
    String name; //存储索引歌单名的临时变量
    for (int i = 0; i < mySongListData.length; i++) {
      name = mySongListData[i]["歌单名"];
      mySongListName.add(name);
    }
    setState(() {});
  }

  addToSongList(songId, songName, artist) {
    initSongList().then((value) => pushBar());//想办法让它更早的执行
    this.songId = songId.toString();
    this.songName = songName;
    this.artist =artist;

  }

  void pushBar(){
    print(mySongListData);
    print(mySongListName);
    List songList = [];
    for(int i = 0;i<5;i++){
      songList.add(" ");
    }
    for(int i = 0;i<mySongListName.length;i++){
      songList[i] = mySongListName[i];
    }

    AppTool().showBottomAlert(
      context, songListconfirmCallback, "请选择歌单", "${songList[0]}", "${songList[1]}","${songList[2]}","${songList[3]}","${songList[4]}");
  }

  Future songListconfirmCallback(value) async{
    print(value);
    String userName = UserInfo.username!;
    Response response =await Dio().get("http://101.201.34.135:8012/mydb/addMusic/'$songId'/'$songName'/'$artist'/'$userName'/'$value'");
    print(response.data);
  }

  Future changePlayerState() async{
    print("playListMusic called");
    if (UserInfo.bottomFlag == true) {
      int result = await audioPlayer.pause();
      print("暂停");
      setState(() {
        UserInfo.bottomFlag = !UserInfo.bottomFlag;
        flag[UserInfo.playingIndex] = !flag[UserInfo.playingIndex];
      });
    } else {
      int result = await audioPlayer.resume();
      if (result == 1) {
        print("正在播放");
        setState(() {
          UserInfo.bottomFlag = !UserInfo.bottomFlag;
          flag[UserInfo.playingIndex] = !flag[UserInfo.playingIndex];
        });
        // success
      }
    }
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
  String songId = "";
  String songName = "";
  String artist = "";
  List mySongListName = [];
  List mySongListData = [];
  List songListData = [
//    {
//      "name": "周杰伦",
//      "artists": [
//        {
//          "name": "Beyond",
//        }
//      ],
//    }
  ];
}

//基本思路：搜索到的歌曲，点击整个ListTile将开始播放，同时替换底部播放的音乐。音乐播放页面只能通过点击底部音乐栏展开。默认播放时，只播放一首
//播放歌单时，将循环播放歌单里的歌曲。
//歌单里的歌是下载的，存储在用户本机中。考虑使用缓存
//长按搜索到的歌曲，可以提示加入歌单。跳转至创建歌单页，输入歌单名称，选择图片
//长按歌单中的歌曲，可以提示删除

//播放搜索到的歌曲时，根据歌曲id在线请求mp3地址在线播放
