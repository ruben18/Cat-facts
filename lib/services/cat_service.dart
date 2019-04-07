import 'package:cat_facts/model/catFact_model.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';

String url = 'https://cat-fact.herokuapp.com/facts/random?animal_type=cat&amount=5';

Future<List<CatFact>> getAllCatFacts() async {
  final response = await http.get(url);
  print(response.body);
  return allCatsFactsFromJson(response.body);
}