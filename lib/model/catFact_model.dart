import 'dart:convert';

CatFact catFactFromJson(String str) {
  final jsonData = json.decode(str);
  return CatFact.fromJson(jsonData);
}

String catFactToJson(CatFact data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}


List<CatFact> allCatsFactsFromJson(String str) {
  final jsonData = json.decode(str);
  return new List<CatFact>.from(jsonData.map((x) => CatFact.fromJson(x)));
}

String allcatFactsToJson(List<CatFact> data) {
  final dyn = new List<dynamic>.from(data.map((x) => x.toJson()));
  return json.encode(dyn);
}

class CatFact {
  String id;
  String text;

  CatFact({
    this.id,
    this.text,
  });

  factory CatFact.fromJson(Map<String, dynamic> json) => new CatFact(
    id: json["_id"],
    text: json["text"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "text":text
  };
}
