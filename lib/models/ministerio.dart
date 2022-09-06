import 'package:cloud_firestore/cloud_firestore.dart';

class Ministerio{
  Ministerio();
  String? _title;
  String? _resp;
  String? get title => this._title;

  set title(String? value) => this._title = value;

    get resp => this._resp;

  set resp( value) => this._resp = value;

  Ministerio.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    this.title = documentSnapshot["title"];
    this.resp = documentSnapshot["resp"];
  }

}