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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey), //5.button scheme
        ),
        home: MyHomePage(), //6.the home page of the app is MyHomePage
      ),
    );
  }
}

class MyAppState extends ChangeNotifier { //MyApp state defines the data the app needs to function, ChangeNotifier can notify others about its own changes, so if a current word pair changes some widgets in the app would need to know this
  var current = WordPair.random(); //it initializes the word randomly at start of the app
  var randomname = WordPair.random();//initizaling the random name at start
  void getNext() { //reassigns current with a new random Word pair
    current = WordPair.random();
    notifyListeners(); //peopel who listen to me must know about this change
  }
  void getNewName() { //reassigns random_name with a new random Word pair
    randomname = WordPair.random();
    notifyListeners(); //peopel who listen to me must know about this change
  }
} //wordpair comes from the package english words



class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>(); //I want to rebuild everytime this app state gets updated or changed
    var pair = appState.current; 
    return Scaffold( 
      body: Center(
        child: Column(  //By default, columns lump their children to the top, which is why the text is shown to be at the top of the app
          mainAxisAlignment: MainAxisAlignment.center, //centers the children inside the column
          children: [
            Text('Cool Names:'),
          //  Text(appState.current.asLowerCase), //take the current that is on top and it renders it as lowercase
            BigCard(pair: pair),
            SizedBox(height: 10), //adds space between card and button
            ElevatedButton(
              onPressed: () {
                appState.getNext();
              },
              child: Text('Next'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: (){
                appState.getNewName();
              },
              child: Text('Last Name'),
            ),
            Text('Cool Last Names: ${appState.randomname.asLowerCase}'),
          ],
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair; 

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); //requests the app's current theme
    final style = theme.textTheme.displayMedium!.copyWith( //(theme.textTheme) access the themes font, (.copywith) copies the text but with changes deifned, (!)assures Dart you know what you're doing
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      color: theme.colorScheme.primary, //defines the card's color to be the same as the theme's colorScheme property, primary is the strongest color
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}", //this will allow screen readers to correctly pronounce each geneerated word 
        ),
      ),
    );
  }
}