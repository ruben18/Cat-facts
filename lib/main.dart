import 'dart:convert';

import 'package:cat_facts/services/cat_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cat_facts/model/catFact_model.dart';
import 'package:toast/toast.dart';


void main() => runApp(
      FavoritesInherited(favorites: [], child: MyApp()),
    );

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FavoritesInherited favorite =
        context.ancestorWidgetOfExactType(FavoritesInherited);
    return new MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => ListCatFacts(),
        '/favorites': (context) => ListFavorites(),
      },
    );
  }
}

class ListCatFacts extends StatelessWidget {
  callAPI() {
    getAllCatFacts().then((response) {
      print(response);
    }).catchError((error) {
      print('error : $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    FavoritesInherited favorite =
        context.ancestorWidgetOfExactType(FavoritesInherited);

    return Scaffold(
      appBar: AppBar(title: Text("A list of cat facts"), actions: <Widget>[
        IconButton(
          icon: Icon(Icons.favorite),
          onPressed: () {
            Navigator.pushNamed(context, "/favorites");
          },
        ),
      ]),
      body: FutureBuilder<List<CatFact>>(
          future: getAllCatFacts(),
          builder: (context, snapshot) {
            callAPI();
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text("Error");
              }
              List<CatFact> catFacts = snapshot.data;
              return ListView.builder(
                  itemCount: catFacts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CatFactInfo(catFact: catFacts[index]),
                          ),
                        );
                      },
                      child: new ListTile(
                        title: Text(catFacts[index].text),
                        leading: Icon(Icons.info),
                      ),
                    );
                  });
            } else
              return CircularProgressIndicator();
          }),
    );
  }
}

class CatFactInfo extends StatelessWidget {
  CatFact catFact;
  CatFactInfo({this.catFact});

  @override
  Widget build(BuildContext context) {
    FavoritesInherited favorite =
        context.ancestorWidgetOfExactType(FavoritesInherited);

    return Scaffold(
      appBar: AppBar(title: Text("Cat Fact")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Transform.scale(
                scale: 2.0,
                child: Text("A Cat Fact"),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("#ID: " + this.catFact.id.toString()),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("Text: " + this.catFact.text),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: new GestureDetector(
                onTap: () {
                  favorite.favorites.add(this.catFact);
                  Toast.show("Cat fact added to favorites.",context);
                },
                child: Icon(Icons.favorite),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ListFavorites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FavoritesInherited favorite =
        context.ancestorWidgetOfExactType(FavoritesInherited);

    return Scaffold(
      appBar: AppBar(
        title: Text("A list of my favorites cat facts"),
      ),
      body: ListView.builder(
          itemCount: favorite.favorites.length,
          itemBuilder: (BuildContext context, int index) {
            return new ListTile(
              title: Text(favorite.favorites[index].text),
              leading: Icon(Icons.favorite),
            );
          }),
    );
  }
}

class FavoritesInherited extends InheritedWidget {
  final List<CatFact> favorites;

  const FavoritesInherited({
    this.favorites,
    Widget child,
  }) : super(child: child);

  @override
  bool updateShouldNotify(FavoritesInherited oldWidget) => true;
}
