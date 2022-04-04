import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int state = 0;
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final singerController = TextEditingController();
  final musicController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    var view = loginView();
    switch (state) {
      case 0: // login
        view = loginView(); //로그인 뷰
        break;
      case 1: // main
        view = mainView(); //메인 뷰
        break;
      case 2:
        view = joinView(); //회원가입 뷰
        break;
      case 3:
        view = writeView(); //게시글 작성 뷰
        break;
      case 4:
        view = plusView(); //친구추가 뷰
        break;
      case 5:
        view = emogiView();
        break;   //6번 뷰 남았음
      case 7:
        view = plusListView();
        break;
    }

    return Scaffold(
        appBar: null,
        body: view
    );
  }

  void login() async{
    // showError("test");
    var phone = phoneController.text;
    var password = passwordController.text;
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
    var body = convert.jsonEncode({'phone': phone, 'password': password});
    print(phone);

    var response = await http.post(u, headers: {"Content-Type": "application/json"},
        body: body);
    if (response.statusCode == 200) {
      // var res = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
      setState(() {
        state = 1;
      });
    }else if(response.statusCode == 404) {
      showError("계정이 없습니다.");
    }else if(response.statusCode == 401) {
      showError("로그인 실패");
    }else{
      showError("알 수 없는 에러 ${response.statusCode}");
    }
  }

  Widget loginView(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
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
                  '비밀번호: ',
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
              setState(() {
                state=1;
              });
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

  Widget joinView(){
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      '       이름 ',
                      style: TextStyle(fontSize: 20)
                  ),
                  SizedBox(
                      width: 200,
                      height: 30,
                      child: TextField(
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
                      '전화번호 ',
                      style: TextStyle(fontSize: 20)
                  ),
                  SizedBox(
                      width: 200,
                      height: 30,
                      child: TextField(
                        textAlign: TextAlign.center,
                        //obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          // labelText: 'Password',
                        ),
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
                  joinsubmit();
                },
                child:
                Text("회원가입 완료", style: TextStyle(fontSize: 15)),
              ),
            ]
        ));
  }

  void joinsubmit() async{
    Text("회원가입 test", style: TextStyle(fontSize: 15));
    setState(() {
      state = 3;
    });
  }


  Widget plusView(){
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    '전화번호',
                    style: TextStyle(fontSize: 20)
                ),
                SizedBox(
                    width: 200,
                    height: 30,
                    child: TextField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    )
                )
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    '회원번호',
                    style: TextStyle(fontSize: 20)
                ),
                SizedBox(
                    width: 200,
                    height: 30,
                    child: TextField(
                      textAlign: TextAlign.center,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    )
                )
              ],
            ),
            SizedBox(height:20),
            TextButton(
              style : TextButton.styleFrom(primary: Colors.white,backgroundColor: Colors.grey),
              onPressed: (){
                setState((){
                  state = 1;
                });
              },
              child:
              Text("확인", style: TextStyle(fontSize: 15)),
            ),


          ],
        )
    );

  }

  Widget plusListView(){
    return Center(
        child : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Text(
                ' 새로 만들 리스트의 제목을 입력하시오. ',
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
            ),
            SizedBox(height: 20),
            TextButton(
              style: TextButton.styleFrom( primary: Colors.white, backgroundColor: Colors.grey),
              onPressed: () {
                postsubmit();
              },
              child:
              Text("새로운 리스트 추가 완료", style: TextStyle(fontSize: 15)),
            ),
          ],
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
            IconButton(icon: Icon(Icons.refresh), onPressed: () {
              refreshAction();
            }, ),
          ],
        ),
        drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text('대영'), accountEmail: Text('#0000'),currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  //backgroundImage: AssetImage(),
                ),),
                //Text('친구추가'),
                ListTile(
                  leading: Icon(Icons.perm_identity, color: Colors.grey[850],),
                  title: Text('고대영'),
                  trailing: Icon(Icons.chevron_right),
                ),
                ListTile(
                  leading: Icon(Icons.perm_identity, color: Colors.grey[850],),
                  title: Text('김정원'),
                  trailing: Icon(Icons.chevron_right),
                ),
                ListTile(
                  leading: Icon(Icons.perm_identity, color: Colors.grey[850],),
                  title: Text('이재영'),
                  trailing: Icon(Icons.chevron_right),
                ),
                ListTile(
                  leading: Icon(Icons.add, color: Colors.grey[850],),
                  title: Text('친구추가'),
                  onTap: () => {
                    setState((){
                      state = 4;
                    })
                  },
                ),
              ],
            )
        ),


        body: Center(
          child: main_threepart(),
        ),
      ),
    );
  }

  void refreshAction() async{
    setState(() {
      state = 0;
    });
    // setState(() {
    //   _response = http.read(dadJokeApi, headers: httpHeaders);
    // });
  }
  void menuAction() async{
    setState(() {
      state = 4; //걍 state 변한거 확인하려고 로그인 화면으로 가게 함.
    });
  }

void write() async{
    var singer = singerController.text;
    var music = musicController.text;
    var body = convert.jsonEncode({'singer' : singer , 'music' : music});
}

  //재영 글쓰기 뷰
  Widget writeView() {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 100,
                width: 100,
                child: Image.asset('assets/akmu.jpg'), //여기서 뮤직은 사진 저장명 정원:akmu 재영: music
              ),


              SizedBox(height: 20),
              Row(

                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                      '♫ 노래 : ',
                      style: TextStyle(fontSize: 15)
                  ),

                  SizedBox(
                      width: 200,
                      height: 30,
                      child: TextField(
                        controller: singerController,
                        textAlign: TextAlign.start,
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
                      '🎙️가수 : ',
                      style: TextStyle(fontSize: 15)
                  ),

                  SizedBox(
                      width: 200,
                      height: 30,
                      child: TextField(
                        controller: singerController,
                        textAlign: TextAlign.start,
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
                      style: TextStyle(fontSize: 15)
                  ),
                  SizedBox(
                      width: 300,
                      height: 100,
                      child: TextField(
                        textAlign: TextAlign.start,
                        decoration: InputDecoration(
                          labelText: '코멘트를 남겨주세요',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 5, //
                        minLines: 1, //
                      )
                  ),

                ],
              ),
              SizedBox(height: 20),
              TextButton(
                style: TextButton.styleFrom( primary: Colors.white, backgroundColor: Colors.grey),
                onPressed: () {
                  postsubmit();
                },
                child:
                Text("작성 완료", style: TextStyle(fontSize: 15)),
              ),
            ]
        )
    );
  }

  // 재영 공감버튼 부분
  Widget emogiView() {
    return Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[

              Column(
                children: <Widget>[
                  Image.asset('assets/1.jpg'),
                  Text('재영'),

                ],
              ),
              Column(
                children: <Widget>[
                  Image.asset('assets/2.jpg'),
                  Text('대영'),
                ],
              ),
              Column(
                children: <Widget>[
                  Image.asset('assets/3.jpg'),
                  Text(''),
                ],
              ),
              Column(
                children: <Widget>[
                  Image.asset('assets/4.jpg'),
                  Text('정현 진석'),
                ],
              ),
            ],
          ),

          SizedBox(
            height: 30,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Image.asset('assets/5.jpg'),
                  Text(''),
                ],
              ),

              Column(
                children: <Widget>[
                  Image.asset('assets/6.jpg'),
                  Text(''),
                ],
              ),

              Column(
                children: <Widget>[
                  Image.asset('assets/7.jpg'),
                  Text('민기'),
                ],
              ),

              Column(
                children: <Widget>[
                  Image.asset('assets/8.jpg'),
                  Text('수빈'),
                ],

              ),
              SizedBox(height: 20),
              TextButton(
                style: TextButton.styleFrom( primary: Colors.white, backgroundColor: Colors.grey),
                onPressed: () {
                  emogicheck();
                },
                child:
                Text("돌아가기", style: TextStyle(fontSize: 15)),   // 이거 때문에 이모지들 위치가 마음대로 바뀜... 이거 수정필요
              ),

            ],
          ),
        ]
    );
  }

  void postsubmit() async{
    Text("회원가입 test", style: TextStyle(fontSize: 15));
    setState(() {
      state = 1;
    });
  }

  void emogicheck() async{
    Text("이모지 test", style: TextStyle(fontSize: 15));
    setState(() {
      state = 1;
    });
  }

  Widget main_threepart(){
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

  Widget _pageOfTop() {
    return Center(
      child: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: '여기 입력',
            ),

          ),
          SizedBox(
            width: 200,
            height: 50,
          ),
        ],
      ),
    );
  }

  Widget _pageOfMiddle() {
    return Stack(
        children:<Widget>[
          Image.asset('assets/fiveline.jpg',width:1200),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              //Image.asset('assets/fiveline.jpg'),
              //scrollDirection: Axis.horizontal,Image.asset('assets/akmu.jpg')
              //mainAxisAlignment: mainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text("공부"),
                  style: TextButton.styleFrom(
                    primary: Colors.black, //글자색
                    onSurface: Colors.blue, //onpressed 가 null 일때 색상
                    backgroundColor: Colors.white,
                    shadowColor: Colors.orange, //그림자 색상
                    elevation: 1, // 버튼 입체감
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                    padding: EdgeInsets.all(16.0),
                    minimumSize: Size(200, 75), //최소 사이즈
                    side: BorderSide(color: Colors.black, width: 2.0), //선
                    shape:
                    CircleBorder(), // BeveledRectangleBorder(): 각진버튼, CircleBorder : 동그라미버튼, StadiumBorder : 모서리가 둥근버튼,
                    alignment: Alignment.center, //글자위치 변경
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text("잠"),
                  style: TextButton.styleFrom(
                    primary: Colors.black, //글자색
                    onSurface: Colors.blue, //onpressed가 null일때 색상
                    backgroundColor: Colors.white,
                    shadowColor: Colors.orange, //그림자 색상
                    elevation: 1, // 버튼 입체감
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                    padding: EdgeInsets.all(16.0),
                    minimumSize: Size(200, 75), //최소 사이즈
                    side: BorderSide(color: Colors.black, width: 2.0), //선
                    shape:
                    CircleBorder(), // BeveledRectangleBorder(): 각진버튼, CircleBorder : 동그라미버튼, StadiumBorder : 모서리가 둥근버튼,
                    alignment: Alignment.center, //글자위치 변경
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text("휴식"),
                  style: TextButton.styleFrom(
                    primary: Colors.black, //글자색
                    onSurface: Colors.blue, //onpressed가 null일때 색상
                    backgroundColor: Colors.white,
                    shadowColor: Colors.orange, //그림자 색상
                    elevation: 1, // 버튼 입체감
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                    padding: EdgeInsets.all(16.0),
                    minimumSize: Size(200, 75), //최소 사이즈
                    side: BorderSide(color: Colors.black, width: 2.0), //선
                    shape:
                    CircleBorder(), // BeveledRectangleBorder(): 각진버튼, CircleBorder : 동그라미버튼, StadiumBorder : 모서리가 둥근버튼,
                    alignment: Alignment.center, //글자위치 변경
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text("운전"),
                  style: TextButton.styleFrom(
                    primary: Colors.black, //글자색
                    onSurface: Colors.blue, //onpressed가 null일때 색상
                    backgroundColor: Colors.white,
                    shadowColor: Colors.orange, //그림자 색상
                    elevation: 1, // 버튼 입체감
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                    padding: EdgeInsets.all(16.0),
                    minimumSize: Size(200, 75), //최소 사이즈
                    side: BorderSide(color: Colors.black, width: 2.0), //선
                    shape:
                    CircleBorder(), // BeveledRectangleBorder(): 각진버튼, CircleBorder : 동그라미버튼, StadiumBorder : 모서리가 둥근버튼,
                    alignment: Alignment.center, //글자위치 변경
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text("카페"),
                  style: TextButton.styleFrom(
                    primary: Colors.black, //글자색
                    onSurface: Colors.blue, //onpressed가 null일때 색상
                    backgroundColor: Colors.white,
                    shadowColor: Colors.orange, //그림자 색상
                    elevation: 1, // 버튼 입체감
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                    padding: EdgeInsets.all(16.0),
                    minimumSize: Size(200, 75), //최소 사이즈
                    side: BorderSide(color: Colors.black, width: 2.0), //선
                    shape:
                    CircleBorder(), // BeveledRectangleBorder(): 각진버튼, CircleBorder : 동그라미버튼, StadiumBorder : 모서리가 둥근버튼,
                    alignment: Alignment.center, //글자위치 변경
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // setState(() {
                    //   state = 7;
                    //});
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder:(BuildContext context){
                          return AlertDialog(
                            title: Text('팝업 메시지'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text('새로운 리스트 목록을'),
                                  Text('추가하시겠습니까?'), ], ), ),
                            actions: <Widget>[
                              TextButton( child: Text('ok'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    state = 7;
                                  });
                                }, ),
                              TextButton(
                                child: Text('cancel'), onPressed: () {
                                Navigator.of(context).pop();
                              }, ),
                            ], ); } ); },
                  child: Text("+"),
                  style: TextButton.styleFrom(
                    primary: Colors.black, //글자색
                    onSurface: Colors.blue, //onpressed가 null일때 색상
                    backgroundColor: Colors.white,
                    shadowColor: Colors.orange, //그림자 색상
                    elevation: 1, // 버튼 입체감
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                    padding: EdgeInsets.all(16.0),
                    minimumSize: Size(200, 75), //최소 사이즈
                    side: BorderSide(color: Colors.black, width: 2.0), //선
                    shape:
                    CircleBorder(), // BeveledRectangleBorder(): 각진버튼, CircleBorder : 동그라미버튼, StadiumBorder : 모서리가 둥근버튼,
                    alignment: Alignment.center, //글자위치 변경
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text("테스트2"),
                  style: TextButton.styleFrom(
                    primary: Colors.black, //글자색
                    onSurface: Colors.blue, //onpressed가 null일때 색상
                    backgroundColor: Colors.white,
                    shadowColor: Colors.orange, //그림자 색상
                    elevation: 1, // 버튼 입체감
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                    padding: EdgeInsets.all(16.0),
                    minimumSize: Size(200, 75), //최소 사이즈
                    side: BorderSide(color: Colors.black, width: 2.0), //선
                    shape:
                    CircleBorder(), // BeveledRectangleBorder(): 각진버튼, CircleBorder : 동그라미버튼, StadiumBorder : 모서리가 둥근버튼,
                    alignment: Alignment.center, //글자위치 변경
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text("테스트3"),
                  style: TextButton.styleFrom(
                    primary: Colors.black, //글자색
                    onSurface: Colors.blue, //onpressed 가 null 일때 색상
                    backgroundColor: Colors.white,
                    shadowColor: Colors.orange, //그림자 색상
                    elevation: 1, // 버튼 입체감
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                    padding: EdgeInsets.all(16.0),
                    minimumSize: Size(200, 75), //최소 사이즈
                    side: BorderSide(color: Colors.black, width: 2.0), //선
                    shape:
                    CircleBorder(), // BeveledRectangleBorder(): 각진버튼, CircleBorder : 동그라미버튼, StadiumBorder : 모서리가 둥근버튼,
                    alignment: Alignment.center, //글자위치 변경
                  ),
                ),
                SizedBox(
                  width: 200,
                  height: 100,
                ),],
            ),
          )
        ]
    );

  }


  Widget _pageOfBottom(){
    return Center(
        child: Column(
          // padding: const EdgeInsets.all(8),
          children: <Widget>[
            Card(child: ListTile(
              title: Text('♫노래 : 낙하   🎙️가수 : 악동뮤지션'),
              subtitle: Text('레트로하면서도 세련된 \n음악이야 추천해! 아이유가 참여해서 더 독특하고 풍성하게 들리는 것 같아 \n그나저나 악뮤 컴백은 언제..? '),
              leading: Image.network('https://image.bugsm.co.kr/album/images/1000/40586/4058623.jpg'),
              trailing: IconButton(icon: Icon(Icons.favorite, color: Colors.pink.shade200), onPressed: () {
                setState(() {
                  state = 5;
                });
              },),//Icon(Icons.favorite)
            )
            ),


            Card(child: ListTile(
              title: Text('♫노래 : Wannabe   🎙가수 : ITZY'),
              subtitle: Text('노래도 듣고 뮤직비디오도 꼭 보길 바래! \n다들 이 세상 미모가 아니야!! \n우울할 때마다 맨날 듣는 중이야ㅎㅎㅎ'),
              leading: Image.network('https://img.hankyung.com/photo/202009/e03249ed43e314ad0736c8e4f14bfa4b.jpg'),
              trailing: IconButton(icon: Icon(Icons.favorite, color: Colors.pink.shade200), onPressed: () {
                setState(() {
                  state = 6;
                });
              },),//Icon(Icons.favorite)
            )),


            Card(child: ListTile(
              title: Text('♫노래 : 별의 조각   🎙가수 : 윤하'),
              subtitle: Text('윤하 노래는 믿고 들어야되는거 다들 알지?ㅎㅎ \n듣다보면 아주 힐링되는 곡인 것 같아 \n나만 듣기 너무 아까운 곡이랄까..? 궁금하지?? 꼭 들어봥'),
              leading: Image.network('https://thumbnews.nateimg.co.kr/view610///news.nateimg.co.kr/orgImg/tv/2021/11/17/1637116189_1612956.jpg'),
              trailing: IconButton(icon: Icon(Icons.favorite, color: Colors.pink.shade200), onPressed: () {
                setState(() {
                  state = 5;
                });
              },),//Icon(Icons.favorite)
            )),


            Card(child: ListTile(
              title: Text('♫노래 : 되돌리다   🎙가수 : 이승기'),
              subtitle: Text("그때 그 시절 감성 가득가득이야.. 이노래 아는 사람 손...? \n이 노래 모르면 간첩이지~!!"),
              leading: Image.network('http://gaonchart.co.kr/upload_images/board/201411/176AF6BE116B4600B18020BD090D23F1.jpg'),
              trailing: IconButton(icon: Icon(Icons.favorite, color: Colors.pink.shade200), onPressed: () {
                setState(() {
                  state = 5;
                });
              },),//Icon(Icons.favorite)
            )),

            Card(child: ListTile(
              title: Text('♫노래 : INVU   🎙가수 : 태연'),
              subtitle: Text('이번에 나온 태연 신곡인데 들으면 들을수록 중독성있어!! \n음악방송에서 태연이 하는 안무가 너무 멋있더라ㅜㅠ '),
              leading: Image.network('https://t2.genius.com/unsafe/409x409/https%3A%2F%2Fimages.genius.com%2F19ed6351954c2b686b79302ae0c1e55c.1000x1000x1.png'),
              trailing: IconButton(icon: Icon(Icons.favorite, color: Colors.pink.shade200), onPressed: () {
                setState(() {
                  state = 5;
                });
              },),//Icon(Icons.favorite)
            )),

            Card(child: ListTile(
              title: Text('♫노래 : 8282   🎙가수 : 다비치'),
              subtitle: Text('이 노래 다들 노래방 18번곡 아닌가~? \n노래방 갈 때마다 빠지지 않고 부르는 노래지 암암 give me a call~ babe babe~'),
              leading: Image.network('https://image.aladin.co.kr/product/339/50/cover500/923138502x_2.jpg'),
              trailing: IconButton(icon: Icon(Icons.favorite, color: Colors.pink.shade200), onPressed: () {
                setState(() {
                  state = 5;
                });
              },
              ),//Icon(Icons.favorite)
            )
            ),
          ],
        ));
  }


  void showError(message){
    if(ModalRoute.of(context)?.isCurrent != true)
      Navigator.of(context, rootNavigator: true).pop();

    showDialog(
        context: context,
        barrierDismissible: false,
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
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
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