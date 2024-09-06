import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() { //main function tells flutter to run the app defined in MyApp
  runApp(MyApp());
}
//myapp is considered the top widget
class MyApp extends StatelessWidget { 
  const MyApp({super.key});
  @override //1.every widget has a build method which tells flutter what the widget contains
  Widget build(BuildContext context) {
    return ChangeNotifierProvider( //2.it contains a changenotifier provider
      create: (context) => MyAppState(), //3.we create state for the whole app
      child: MaterialApp( //4.Material which means it has a name
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true, 
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange), //5.button scheme
        ),
        home: MyHomePage(), //6.the home page of the app is MyHomePage
      ),
    );
  }
}

class MyAppState extends ChangeNotifier { //MyApp state defines the data the app needs to function, ChangeNotifier can notify others about its own changes, so if a current word pair changes some widgets in the app would need to know this
  var current = WordPair.random(); //it initializes the word randomly at start of the app

  void getNext() { //reassigns current with a new random Word pair
    current = WordPair.random();
    notifyListeners(); //peopel who listen to me must know about this change
  }
} //wordpair comes from the package english words



class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>(); //I want to rebuild everytime this app state gets updated or changed
    var pair = appState.current; 
    return Scaffold( 
      body: Column( 
        children: [
          Text('Erick smells:'),
        //  Text(appState.current.asLowerCase), //take the current that is on top and it renders it as lowercase
          Text(pair.asLowerCase),
          ElevatedButton(
            onPressed: () {
              appState.getNext();
            },
            child: Text('Next'),
          ),
        ],
      ),
    );
  }
}