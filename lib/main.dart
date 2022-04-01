import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

void main()   {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int state = 0;  // 초기값은 0으로 설정
  final phoneController = TextEditingController();    // text를 입력받기 위해서는 TextEditingController 사용
  final passwordController = TextEditingController();  //  동일
  final singerController = TextEditingController();    // 추가
  final musicController = TextEditingController();   // 추가

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    var view = loginView(); // var : 타입을 선언하지 않아도 변수에 할당된 초기값에 따라 타입이 자동으로 추론
    switch (state) {
      case 0: // login
        view = loginView();
        break;
      case 1: // main
        view = mainView();
        break;
      case 2:
        view = writeView();
        break;
    }

    return Scaffold(
        appBar: null,  // 앱 윗부분에 아무것도 없음
        body: view  // 메인 가운데 화면
    );
  }

  void login() async{   // await이랑 짝
    // showError("test");
    var phone = phoneController.text;
    var password = passwordController.text;
    var singer = singerController.text;  //  추가
    var music = musicController.text;   //   추가

    if(phone.length == 0){
      showError("전화번호를 입력해주세요.");
      return;
    }
    if(password.length == 0){
      showError("비밀번호를 입력해주세요.");
      return;
    }

    var postUrl = "http://192.168.213.69/login";
    var u = Uri.parse(postUrl);
    var body = convert.jsonEncode({'phone': phone, 'password': password, 'singer' :singer, 'music': music});  // singer, music 추가
    print(phone);

    var response = await http.post(u, headers: {"Content-Type": "application/json"},
        body: body);
    if (response.statusCode == 200) {   // 성공이면 200번대
      // var res = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
      setState(() {
        state = 1;
      });
    }else if(response.statusCode == 404) {  // 에러 400번대 : 클라이언트 오류
      showError("계정이 없습니다.");
    }else if(response.statusCode == 401) {  // 에러 400번대 : 클라이언트 오류
      showError("로그인 실패");
    }else{
      showError("알 수 없는 에러 ${response.statusCode}");
    }
  }

  Widget loginView(){
    return Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: Column(   // column : 세로로 정렬
        // Column is also a layout widget. It takes a list of children and
        // arranges them vertically. By default, it sizes itself to fit its
        // children horizontally, and tries to be as tall as its parent.
        //
        // Invoke "debug painting" (press "p" in the console, choose the
        // "Toggle Debug Paint" action from the Flutter Inspector in Android
        // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
        // to see the wireframe for each widget.
        //
        // Column has various properties to control how it sizes itself and
        // how it positions its children. Here we use mainAxisAlignment to
        // center the children vertically; the main axis here is the vertical
        // axis because Columns are vertical (the cross axis would be
        // horizontal).
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(    // Row : 가로로 정렬
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  '전화번호 ',
                  style: TextStyle(fontSize: 20)
              ),
              SizedBox(
                  width: 200,
                  height: 30,
                  child: TextField(
                    controller: phoneController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      // labelText: 'Phone',
                    ),
                    // style: TextStyle(fontSize: 20)

                  )
              )
            ],
          ),


          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  '비밀번호 ',
                  style: TextStyle(fontSize: 20)
              ),
              SizedBox(
                  width: 200,
                  height: 30,
                  child: TextField(
                    controller: passwordController,
                    textAlign: TextAlign.center,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      // labelText: 'Password',
                    ),
                  )
              )
            ],
          ),


          SizedBox(height: 20),
          TextButton(
            style: TextButton.styleFrom( primary: Colors.white, backgroundColor: Colors.grey),
            onPressed: () {
              login();
            },
            child:
            Text("로그인", style: TextStyle(fontSize: 15)),
          ),


          SizedBox(height: 5),
          OutlinedButton(
            style: TextButton.styleFrom( primary: Colors.grey, backgroundColor: Colors.white),
            onPressed: () {
              setState(() {
                state = 2;
              });
            },
            child:
            Text("회원가입", style: TextStyle(fontSize: 15)),
          )
        ],
      ),
    );
  }


  // 이재영 게시글쓰기 부분
  Widget writeView() {
    return Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 200,
                width: 200,
                child: Image.asset('assets/music.jpg'),
              ),


              Text(
                  '♫ 노래 : ',
                  style: TextStyle(fontSize: 20)
              ),
              SizedBox(
                  width: 200,
                  height: 40,
                  child: TextField(
                    controller: musicController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      // labelText: 'Password',
                    ),
                  )
              ),


              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                      '🎙️가수 : ',
                      style: TextStyle(fontSize: 20)
                  ),

                  SizedBox(
                      width: 200,
                      height: 40,
                      child: TextField(
                        controller: singerController,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          // labelText: 'Password',
                        ),
                      )
                  )
                ],
              ),


              SizedBox(height: 20),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                        '',
                        style: TextStyle(fontSize: 20)
                    ),
                    SizedBox(
                        width: 400,
                        height: 500,
                        child: TextField(
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            labelText: '코멘트를 남겨주세요',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 5, //
                          minLines: 1, //
                        )

                    )
                  ]
              )
            ]
        )
    );
  }


  Widget mainView(){

    const title = ' 정원 ';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue,
          elevation: 0,
          title: const Text(title),
          //leading: IconButton(icon: Icon(Icons.menu), onPressed: null),
          actions: [
            IconButton(icon: Icon(Icons.refresh), onPressed: null),
            IconButton(icon: Icon(Icons.menu), onPressed: null),
          ],
        ),
        body: Center(
          child: main_threepart(),
        ),
        // body: Container(
        //   margin: const EdgeInsets.symmetric(vertical: 20.0),
        //   height: 200.0,
        //   child: ListView(
        //     // This next line does the trick.
        //     scrollDirection: Axis.horizontal,
        //     children: <Widget>[
        //       Container(
        //         width: 160.0,
        //         color: Colors.red,
        //       ),
        //       Container(
        //         width: 160.0,
        //         color: Colors.blue,
        //       ),
        //       Container(
        //         width: 160.0,
        //         color: Colors.green,
        //       ),
        //       Container(
        //         width: 160.0,
        //         color: Colors.yellow,
        //       ),
        //       Container(
        //         width: 160.0,
        //         color: Colors.orange,
        //       ),
        //     ],
        //   ),
        // ),

      ),
    );
  }


  void showError(message){
    if(ModalRoute.of(context)?.isCurrent != true)   // modalroute 클래스의 한 종류...(?)
      Navigator.of(context, rootNavigator: true).pop();   //  Navigator.pop()을 사용하면 첫 번째 route로 되돌아갈 수 있음

    showDialog(   // 팝업창을 띄울때 사용
        context: context,
        barrierDismissible: false, // 다이얼로그 밖 영역을 터치했을 때 다이얼로그를 Pop시킬지 선택하는 옵션
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                new Text("오류"),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,  // 크기만큼만 차지
              crossAxisAlignment: CrossAxisAlignment.start,  // 왼쪽 위 정렬
              children: <Widget>[
                Text(
                  message,
                ),
              ],
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text("확인"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}

class main_threepart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: ListView(
        children: <Widget>[
          _pageOfTop(), // 상단
          _pageOfMiddle(), // 중단
          _pageOfBottom(), // 하단
        ],
      ),
    );
  }
}
Widget _pageOfTop() {
  return Column(
    children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            children: <Widget>[
              Icon(
                Icons.directions_bike,
                size: 40,
              ),
              Text('자전거'),
            ],
          ),
          Column(
            children: <Widget>[
              Icon(
                Icons.directions_run,
                size: 40,
              ),
              Text('달리기'),
            ],
          ),
          Column(
            children: <Widget>[
              Icon(
                Icons.directions_bus,
                size: 40,
              ),
              Text('버스'),
            ],
          ),
        ],
      ),
      SizedBox(
        height: 30,
      ),
      // Row와 Row사이에 위치시켜서 여백 넣기
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            children: <Widget>[
              Icon(
                Icons.directions_car,
                size: 40,
              ),
              Text('자동차'),
            ],
          ),
          Column(
            children: <Widget>[
              Icon(
                Icons.directions_subway,
                size: 40,
              ),
              Text('지하철'),
            ],
          ),
          Column(
            children: <Widget>[
              Icon(
                Icons.directions_boat,
                size: 40,
              ),
              Text('보트'),
            ],
          ),
        ],
      )
    ],
  );
}

Widget _pageOfMiddle() {
  return Column(
    // child: Container(
    //       margin: const EdgeInsets.symmetric(vertical: 20.0),
    //       height: 200.0,
    //       child: ListView(
    //         // This next line does the trick.
    //         scrollDirection: Axis.horizontal,
    //         children: <Widget>[
    //           Container(
    //             width: 160.0,
    //             color: Colors.red,
    //           ),
    //           Container(
    //             width: 160.0,
    //             color: Colors.blue,
    //           ),
    //           Container(
    //             width: 160.0,
    //             color: Colors.green,
    //           ),
    //           Container(
    //             width: 160.0,
    //             color: Colors.yellow,
    //           ),
    //           Container(
    //             width: 160.0,
    //             color: Colors.orange,
    //           ),
    //         ],
    //       ),
    //     ),
  );
}

Widget _pageOfBottom() {
  final items = List.generate(15, (i) {
    var num = i + 1;
    return ListTile(
      leading: Icon(Icons.notifications),
      title: Text('$num번째 ListTile'),
    );
  });
  return ListView(
    physics: NeverScrollableScrollPhysics(), // 해당 리스트의 스크롤 금지
    shrinkWrap: true, // 상위 리스트 위젯이 별도로 있다면 true 로 설정해야 스크롤이 가능
    children: items,
  );
}