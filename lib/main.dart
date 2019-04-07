import 'dart:convert';

import 'package:cat_facts/services/cat_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cat_facts/model/catFact_model.dart';

const jsonCatFact =
    '{"text": "In an average year, cat owners in the United States spend over 2 billion on cat food.","_id":"591f98803b90f7150a19c229"}';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(home: Home());
  }
}

class Home extends StatelessWidget {
  callAPI() {
    getAllCatFacts().then((response) {
      if (response.statusCode > 200)
        print(response.body);
      else
        print(response.statusCode);
    }).catchError((error) {
      print('error : $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("A list of cat facts")
        ),
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
                      return ListTile(
                        title: new Text(catFacts[index].text),
                      );
                    });
              } else
                return CircularProgressIndicator();
            }));
  }
}
