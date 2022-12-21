import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:neomusic/models/UserInfo.dart';
import '../utils/widget/CustomFloatingActionButtonLoaction.dart';

class SongListPage extends StatefulWidget {
  @override
  _SongListPageState createState() => _SongListPageState();
}

TextEditingController newSongListController = TextEditingController();

class _SongListPageState extends State<SongListPage> {
  @override
  void initState() {
    initSongList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: CustomFloatingActionButtonLocation(
          FloatingActionButtonLocation.endFloat, -10, -80),
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: null,
        child: IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              newSongList(context);
            }),
        tooltip: "单击添加自定义歌单",
        backgroundColor: Color.fromRGBO(240, 240, 243, 1),
        foregroundColor: Color.fromRGBO(149, 209, 140, 1),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              //外层的List背景卡片Container
              height: 530,

              child: ListView.builder(
//                  shrinkWrap: true,
                  itemCount: mySongListData.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () => navigateToSongDetail(
                            mySongListData[index]["歌单名"]),
                        //根据歌单名跳转，可以做成根据歌单id？
                        child: Container(
                          //这是包裹每个ListTile的Container
                          height: 90,
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
                          child: mySongListData.isEmpty
                              ? Container(
                                  height: 100,
                                  width: 100,
                                  color: Colors.lightBlue,
                                )
                              : Row(
                                  children: [
                                    Container(
                                      child: Image.asset("images/album1.png"),
                                    ),
                                    const SizedBox(width: 20),
                                    Column(
                                      children: <Widget>[
                                        const SizedBox(height: 20),
                                        Text(
                                          (mySongListData.isEmpty)
                                              ? "0"
                                              : mySongListData[index]["歌单名"],
                                          style: const TextStyle(
                                            color: Color.fromRGBO(
                                                124, 124, 124, 1),
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          (mySongListData.isEmpty)
                                              ? "0首"
                                              : mySongListNum[index].toString()+"首",
                                          style: const TextStyle(
                                            color: Color.fromRGBO(
                                                124, 124, 124, 1),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 40),
                                    GestureDetector(
                                      child: Image.asset("images/delete.png"),
                                      onTap: () => deleteSongList(
                                          mySongListData[index]["歌单名"]),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    );
                  }),
            ),
          ),
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

  navigateToSongDetail(String songListName) {
    UserInfo.songListName = songListName;
    print(UserInfo.songListName);
    Navigator.of(context).pushNamed("songlistdetail");
  }

  Future newSongList(context) async {
    print("new a songlist");
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('新建歌单'),
            content: Card(
              elevation: 0.0,
              child: Column(
                children: <Widget>[
                  Text('输入歌单名称'),
                  CupertinoTextField(
                    controller: newSongListController,
                  ),
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
                  commitNewSongList(newSongListController.text).then((value) => initSongList());
                  Navigator.pop(context);
                },
                child: Text('确定'),
              ),
            ],
          );
        });
  }

  Future commitNewSongList(songListName) async {
    Response response;
    String userName = UserInfo.username!;
    response = await Dio().get(
      "http://101.201.34.135:8012/mydb/addgedan/'$userName'/'$songListName'",
    );
    if (response.data == 1) {
      return true;
    }
  }

  Future deleteSongList(songListName) async {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('删除歌单'),
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
                  commitDelete(songListName).then((value) => initSongList());
                  Navigator.pop(context);
                },
                child: Text('确定'),
              ),
            ],
          );
        });
  }

  Future commitDelete(songListName) async {
    Response response;
    String userName = UserInfo.username!;
    response = await Dio().get(
        "http://101.201.34.135:8012/mydb/delGedan/'$userName'/'$songListName'");
  }

  Future initSongList() async {
    Response responese;
    String userName = UserInfo.username!;
    print("缓存中数据为：" + userName);
    responese = await Dio().get(
      "http://101.201.34.135:8012/mydb/getGedan/'$userName'",
    );
    mySongListData = responese.data;
      print(mySongListData);

    String name; //存储索引歌单名的临时变量
    for (int i = 0; i < mySongListData.length; i++) {
      name = mySongListData[i]["歌单名"];
      responese = await Dio().get(
        "http://101.201.34.135:8012/mydb/getMusicnum/'$userName'/'$name'",
      );
      mySongListNum.add(responese.data);
    }
    setState(() {});
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
  List mySongListNum = [];
  List mySongListData = [
//    {
//      "歌单名": "学习听的歌",
//    },
  ];
}
//bug：删除，或新建后，无法及时刷新?有时刷新，有时不刷新？bug or 异步没有处理好
