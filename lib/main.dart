import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:handling_http_calls_with_flavors/env.dart';
import 'package:handling_http_calls_with_flavors/service/http_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  //create the app environment for the current flavor
  AppEnv.create(
    appName: 'Http Call Prod',
    baseUrl: HttpService.prodBaseUrl,
    flavor: Flavor.prod
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter http Call ',
      theme: ThemeData(
        //This changes the color scheme based on the flavor
        colorScheme: ColorScheme.fromSeed(seedColor: AppEnv.config.flavor == Flavor.dev ? Colors.deepPurple : Colors.deepOrange),
        useMaterial3: true,
      ),
      home: MyHomePage(title: AppEnv.config.appName),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    // TODO: implement initState
    getTheHttpCall();
    super.initState();
  }

  HttpService http = HttpService();
  Future<String>? getTheHttpCall() async {
    try{
      var response = await http.get("/api/v0/en/calendars");
      if (response.statusCode == 200) {
        dynamic body = response.data;
        print(body);
        return "there is data";
      }
    } on DioException catch (e) {
      print("${e.message}");
    }
    return "";
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body:Center(
        child: FutureBuilder(future: getTheHttpCall(), builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data.toString());

          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }else {
            return const CircularProgressIndicator();
          }
        })
      ),
    );
  }
}
