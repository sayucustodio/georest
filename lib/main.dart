import 'package:flutter/material.dart';
import 'package:prueba_1/db/database.dart';
import 'package:prueba_1/home_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized(); 
  await dotenv.load(fileName: ".env");
  var databasesPath = await getDatabasesPath();
   // Inicializar la BD y luego imprimir los restaurantes
  await DatabaseHelper.init(); 
  await imprimirRestaurantes();
print("Ruta de la BD: $databasesPath");
  runApp( MyApp());
}
Future<void> imprimirRestaurantes() async {
  try {
    final db = await DatabaseHelper().database;
    List<Map<String, dynamic>> result = await db.query('restaurants');

    if (result.isNotEmpty) {
      print("Restaurantes en la BD:");
      for (var row in result) {
        print(row); // 🖨️ Imprime cada restaurante
      }
    } else {
      print("⚠️ No hay restaurantes en la base de datos.");
    }
  } catch (e) {
    print("Error al consultar la tabla restaurants: $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prueba restaurante',
      theme: ThemeData(
       
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:  HomeScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
