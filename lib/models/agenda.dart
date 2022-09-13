import 'package:cloud_firestore/cloud_firestore.dart';

class Agenda{

  String? _id;
  String? _data;
  String? _title;
  String? _hora;
 String? get id => this._id;

 set id(String? value) => this._id = value;

  get data => this._data;

 set data( value) => this._data = value;

  get title => this._title;

 set title( value) => this._title = value;

  get hora => this._hora;

 set hora( value) => this._hora = value;

  Agenda.gerarId(){
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference abastecimentos = db.collection('agenda');
    this.id = abastecimentos.doc().id;
  }

  Agenda.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    this.title = documentSnapshot["title"];
    this.data = documentSnapshot["data"];
    this.hora = documentSnapshot["hora"];
    this.id = documentSnapshot["id"];
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "title" : this.title,
      "data" : this.data,
      "hora" : this.hora,
      "id" : this.id,
    };
    return map;
 }

}