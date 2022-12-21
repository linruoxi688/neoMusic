import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:dio/dio.dart';
import 'package:neomusic/models/UserInfo.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController userNameController = new TextEditingController();
  final TextEditingController passWordController = new TextEditingController();

  @override
  void initState() {
    super.initState();
//    String userName = userNameController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          children: <Widget>[
            _buildLogo(), //Logo
            const SizedBox(height: 15),
            _buildWord(), //标语
            const SizedBox(height: 20),
            _buildUserName(), //账号输入框
            const SizedBox(height: 15),
            _buildPasswd(), //密码输入
            const SizedBox(height: 40),
            _buildButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset('images/Logo.png');
  }

  Widget _buildWord() {
    return Column(
      children: const <Widget>[
        Text("NeoMusic", style: TextStyle(fontSize: 20)),
        Text(
          "新时代简约风音乐",
          style:
              TextStyle(fontSize: 16, color: Color.fromRGBO(124, 124, 124, 1)),
        )
      ],
    );
  }

  Widget _buildUserName() {
    return Container(
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
      height: 56,
      child: TextField(
        controller: userNameController,
        decoration: const InputDecoration(
          hintText: "账号",
          hintStyle:
              TextStyle(fontSize: 20, color: Color.fromRGBO(124, 124, 124, 1)),
          enabledBorder: OutlineInputBorder(
            /*边角*/
            borderRadius: BorderRadius.all(
              Radius.circular(22),
            ),
            borderSide: BorderSide(
              color: Color.fromRGBO(240, 240, 243, 1),
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(22),
              ),
              borderSide: BorderSide(
                color: Color.fromRGBO(240, 240, 243, 1),
                width: 2,
              )),
        ),
      ),
    );
  }

  Widget _buildPasswd() {
    return Container(
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
      height: 56,
      child: TextField(
        controller: passWordController,
        decoration: const InputDecoration(
          hintText: "密码",
          hintStyle:
              TextStyle(fontSize: 20, color: Color.fromRGBO(124, 124, 124, 1)),
          enabledBorder: OutlineInputBorder(
            /*边角*/
            borderRadius: BorderRadius.all(
              Radius.circular(22),
            ),
            borderSide: BorderSide(
              color: Color.fromRGBO(240, 240, 243, 1),
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(22),
              ),
              borderSide: BorderSide(
                color: Color.fromRGBO(240, 240, 243, 1),
                width: 2,
              )),
        ),
      ),
    );
  }

  Widget _buildButton() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(240, 240, 243, 1), //底色,阴影颜色
            offset: Offset(2, 2), //阴影位置,从什么位置开始
            blurRadius: 0, // 阴影模糊层度
            spreadRadius: 0, //阴影模糊大小
          ),
        ],
      ),
      height: 42,
      width: 110,
      child: ElevatedButton(
        onPressed: login,
        style: ButtonStyle(
          textStyle: MaterialStateProperty.all(TextStyle(fontSize: 30)),
          backgroundColor:
              MaterialStateProperty.all(Color.fromRGBO(221, 221, 235, 1)),
        ),
        child: const Text(
          "登录",
          style: TextStyle(
            fontSize: 20,
            color: Color.fromRGBO(124, 124, 124, 1),
          ),
        ),
      ),
    );
  }

  Future login() async {
    Response response;
    String userName = userNameController.text;
    String password = passWordController.text;
    response = await Dio().get(
      "http://101.201.34.135:8012/mydb/addUser/$userName/$password",
    );
    var code = response.data; //1为成功，0为失败
    print(code);
    if (code == 0) {
      //注册失败，尝试登录
      response = await Dio().get(
        "http://101.201.34.135:8012/mydb/login/$userName/$password",
      );
      code = response.data;
      if (code == 0) {
        //登录失败，弹框提示
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('提示'),
                content: const Text('用户名或密码错误！'),
                actions: <Widget>[
                  ElevatedButton(
                    child: const Text('确认'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            });
      } else if (code == 1) {
        //登录成功
        print("登录成功");
        UserInfo.username = userName;
        print(UserInfo.username);
        Navigator.of(context).pushNamed("recommend");
      }
    } else if (code == 1) {
      //注册成功
      print("注册成功");
      UserInfo.username = userName;
      Navigator.of(context).pushNamed("recommend");
    } else
      print("out of 01");
  }
}
