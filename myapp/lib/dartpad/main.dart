import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

//route names
const String HomeViewRoute = '/';
const String OtherPageRoute = 'other';

//route logic
Route<dynamic> generateRoute(RouteSettings settings) {
  switch(settings.name) {
      case HomeViewRoute:
        return MaterialPageRoute(builder: (context) => MyHomePage());
    case OtherPageRoute:
      return MaterialPageRoute(builder: (context) => OtherPage());
    default:
      return MaterialPageRoute(builder: (context) => UnknownPage(name: settings.name));
  }
}

//quick other page
class OtherPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Text('Other Page'),
        ),
    );
  }
}

//for when route is unknown page
class UnknownPage extends StatelessWidget {
  final String name;
  const UnknownPage({Key key, this.name}) : super(key:key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Text('Route for $name is not defined'),
        ),
    );
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //debug flag begone
      title: 'Flutter Demo',
      onGenerateRoute: generateRoute,
      initialRoute: HomeViewRoute,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  //MyHomePage({Key key, this.title}) : super(key: key);

  final String title = 'Flutter Demo Home Page';

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
