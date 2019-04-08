import 'dart:convert';

import 'package:cat_facts/services/cat_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cat_facts/model/catFact_model.dart';

void main() => runApp(
      FavoritesInherited(child: MyApp()),
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
      appBar: AppBar(title: Text("A list of cat facts")),
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
                        leading:  Icon(Icons.add_circle),
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
        ],
      ),
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
