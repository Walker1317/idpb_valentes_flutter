import 'package:cloud_firestore/cloud_firestore.dart';

class AppData{

  String? _banco;
  String? _email;
  String? _endereco;
  String? _facebook;
  String? _fone;
  String? _instagram;
  String? _local;
  String? _pix;
  String? _tiktok;
  String? _youtube;
  String? _estudos;
  String? _criador;
  String? _site;
 String? get banco => this._banco;

 set banco(String? value) => this._banco = value;

  get email => this._email;

 set email( value) => this._email = value;

  get endereco => this._endereco;

 set endereco( value) => this._endereco = value;

  get facebook => this._facebook;

 set facebook( value) => this._facebook = value;

  get fone => this._fone;

 set fone( value) => this._fone = value;

  get instagram => this._instagram;

 set instagram( value) => this._instagram = value;

  get local => this._local;

 set local( value) => this._local = value;

  get pix => this._pix;

 set pix( value) => this._pix = value;

  get tiktok => this._tiktok;

 set tiktok( value) => this._tiktok = value;

  get youtube => this._youtube;

 set youtube( value) => this._youtube = value;

  get estudos => this._estudos;

 set estudos( value) => this._estudos = value;

  get criador => this._criador;

 set criador( value) => this._criador = value;

  get site => this._site;

 set site( value) => this._site = value;

 AppData.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    this.banco = documentSnapshot["banco"];
    this.email = documentSnapshot["email"];
    this.endereco = documentSnapshot["endereco"];
    this.facebook = documentSnapshot["facebook"];
    this.fone = documentSnapshot["fone"];
    this.instagram = documentSnapshot["instagram"];
    this.local = documentSnapshot["localizacao"];
    this.pix = documentSnapshot["pix"];
    this.tiktok = documentSnapshot["tiktok"];
    this.youtube = documentSnapshot["youtube"];
    this.estudos = documentSnapshot["estudos"];
    this.criador = documentSnapshot["criador"];
    this.site = documentSnapshot["site"];
  }

}