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
  var favorites = <WordPair>[]; //property getting initialized as an empty list, also specified that it can only contain wordpairs (GENERICS)
  void toggleFavorites(){
    if(favorites.contains(current)){
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
  void getNewName() { //reassigns random_name with a new random Word pair
    randomname = WordPair.random();
    notifyListeners(); //peopel who listen to me must know about this change
  }
} //wordpair comes from the package english words

// ...

class MyHomePage extends StatefulWidget { 
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> { //now it can manage itself, the underscore (_) at the start of _MyHomePageState makes that class private
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return LayoutBuilder(
      builder: (context, constraints) { //callback is called every time the constraints change eg: phone rotated, user resizes page
        return Scaffold(
          body: Row(
            children: [
              SafeArea( //ensures that its child is not obscured by a hardware notch or a status bar. In this app, the widget wraps around NavigationRail to prevent the navigation buttons from being obscured by a mobile status bar.
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(//The navigation rail has two destinations (Home and Favorites), with their respective icons and labels.
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination( 
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                  ],
                  selectedIndex: selectedIndex, // It also defines the current selectedIndex. A selected index of zero selects the first destination.
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              Expanded( //lets you express layouts where some children take only as much space as they need, and some widgets take as much as possible (greedy)
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer, //changes the big containers color
                  child: page,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}


class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorites();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: (){
                  appState.getNewName();
                },
                child: Text('More'),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'Other: ${appState.randomname.asUpperCase}', 
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.pink)),
          Icon(
            Icons.account_circle_rounded,
            color: Colors.pink
          ),
        ],
      ),
    );
  }
}

// ...

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
      ],
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