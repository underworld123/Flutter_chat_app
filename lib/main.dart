import 'package:flutter/material.dart';
//to build app theme similar to native app

const String defaultUserName = "Rishabh";

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chat Application",
      home: new Chat(),
    );
  }
}
 class Chat extends StatefulWidget {
  @override
   ChatState createState() => new ChatState();
 }

 class ChatState extends State<Chat> with TickerProviderStateMixin{
  List<Msg> _msg = <Msg>[];
  TextEditingController _txtcontroller = new TextEditingController();
  bool _iswriting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Center(
          child: Text("Chat App")
        ),
        //elevation: Theme.of(context).platform = 6.0,
      ),
      body: new Column(
        children: <Widget>[
          new Flexible(
              child: ListView.builder(
                //itemBuilder iterator over all the elements in our _msg List and build the list view according to it.
                  itemBuilder: (_,int index) => _msg[index],
                  itemCount: _msg.length,
                  //To view from bottom to top we use Reverse = true
                  //By default it is false.
                  reverse: true,
                  padding: EdgeInsets.all(5.0),
              )
          ),
          new Divider(height: 1.0),
          new Container(
            child: _buildComposer(),
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
          )
        ],
      )
    );
  }

  Widget _buildComposer() {
    return new IconTheme(
        data: IconThemeData(color: Theme.of(context).accentColor),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 6.0),
          child: new Row(
            children: <Widget>[
              Flexible(
                child: new TextField(
                  controller: _txtcontroller,
                  onChanged: (String txt) {
                    setState(() {
                      _iswriting = txt.length > 0;
                    });
                  },
                  onSubmitted: _submitMsg,
                  decoration: InputDecoration.collapsed(
                      hintText: "Enter your msg",
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 3.0),
                child: new IconButton(
                    icon: new Icon(Icons.message),
                    onPressed: _iswriting ? () => _submitMsg(_txtcontroller.text) : null,
                ),
              )
            ],
          ),
        )
    );
  }

  void _submitMsg(String txt){

    Msg msg = new Msg(
      txt: txt,
      animationController: new AnimationController(
          vsync: this,
        duration: new Duration(milliseconds: 800)
      ),
    );
    setState(() {
      _msg.insert( 0, msg);
      _iswriting = false;
    });
    _txtcontroller.clear();
    msg.animationController.forward();
  }

  @override
   void dispose() {
    for(Msg msg in _msg){
      msg.animationController.dispose();
    }
    super.dispose();
  }
 }

 class Msg extends StatelessWidget {
  String txt;
  AnimationController animationController;
  Msg({this.txt, this.animationController});

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(
        parent: animationController,
        curve: Curves.bounceOut
      ),
      axisAlignment: 0.0,
      child: new Container(
        margin: EdgeInsets.symmetric(vertical: 7.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 18.0),
              child: CircleAvatar(
                child: Text(defaultUserName[0]),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(defaultUserName),
                  Container(
                    margin: EdgeInsets.only(top: 6.0),
                    child: Text(txt),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
 }