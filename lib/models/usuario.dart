import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario{
  Usuario();

  String? _nome;
  String? _email;
  String? _senha;
  String? _id;
  String? _link;
  bool? adm;
 String? get nome => this._nome;

 set nome(String? value) => this._nome = value;

  get email => this._email;

 set email( value) => this._email = value;

  get senha => this._senha;

 set senha( value) => this._senha = value;

  get id => this._id;

 set id( value) => this._id = value;

  get link => this._link;

 set link( value) => this._link = value;

  get getAdm => this.adm;

 set setAdm( adm) => this.adm = adm;
 

 Usuario.fromDocumentSnapshot(DocumentSnapshot snapshot){
  this.nome = snapshot["nome"];
  this.email = snapshot["email"];
  this.adm = snapshot["adm"];
  this.id = snapshot["id"];
  this.link = snapshot["link"];
 }

 Map<String, dynamic> toMap(){
  Map<String, dynamic> map = {
    "nome" : this.nome,
    "email" : this.email,
    "id" : this.id,
    "adm" : this.adm,
    "link" : this.link,
  };
  return map;
 }

}