import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firestore_ui/animated_firestore_list.dart';
import 'package:flutter/material.dart';
import 'package:idpb_valentes_app/models/agenda.dart';
import 'package:idpb_valentes_app/models/usuario.dart';
import 'package:idpb_valentes_app/screens/agenda/create_event.dart';
import 'package:intl/intl.dart';

class AgendaScreen extends StatefulWidget {
  AgendaScreen(this.pageController, this.usuario,{super.key});
  PageController pageController;
  Usuario usuario;

  @override
  State<AgendaScreen> createState() => _AgendaScreenScreenState();
}

class _AgendaScreenScreenState extends State<AgendaScreen> {
  double opacity = 0;
  Query? query;
  
  _back(){
    widget.pageController.jumpToPage(0);
  }

  _addListener(){
    query = FirebaseFirestore.instance.collection("agenda").orderBy("data", descending: false).withConverter<Agenda>(
      fromFirestore: (snapshot, _)=> Agenda.fromDocumentSnapshot(snapshot),
      toFirestore: (value, options) => null!,
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 50)).then((value){
      setState(() {
        opacity = 1;
      });
    });
    _addListener();
  }

  @override
  Widget build(BuildContext context) {
    Widget createButton(){
      return widget.usuario.adm == false ?
      Container() :
      IconButton(
        onPressed: ()=> Navigator.of(context)
        .push(MaterialPageRoute(builder: (_)=> const CreateEvent())),
        icon: const Icon(Icons.add_circle_outline_rounded)
      );
    }
    return WillPopScope(
      onWillPop: () async {
        _back();
        return false;
      },
      child: Container(
        color: Colors.white,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
          opacity: opacity,
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Agenda"),
              leading: IconButton(
                onPressed: _back,
                icon: const Icon(Icons.arrow_back)
              ),
              actions: [
                createButton(),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FirestoreAnimatedList(
                    query: query!,
                    shrinkWrap: true,
                    emptyChild: const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Nao temos nenhum dado para mostrar",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, snapshot, animation, index) {
                      dynamic agenda = snapshot!.data();
                      DateTime date = DateTime.parse(agenda.data);
                      String dateFormated = DateFormat(DateFormat.YEAR_NUM_MONTH_DAY, "pt_BR").format(date);
                      String dateFormatedAbbr = DateFormat(DateFormat.WEEKDAY, "pt_BR").format(date).toUpperCase();
                      return GestureDetector(
                        onLongPress: (){
                          if(widget.usuario.adm == true){
                            showDialog(
                              context: context,
                              builder: (context){
                                return SimpleDialog(
                                  children: [
                                    TextButton(
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                        FirebaseFirestore.instance.collection("agenda").doc(agenda.id).delete();
                                      },
                                      child: const Text("Excluir", style: TextStyle(color: Colors.red),)
                                    ),
                                  ],
                                );
                              }
                            );
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[50]!,
                                blurRadius: 5,
                                spreadRadius: 5,
                                offset: const Offset(-4, -4)
                              ),
                              BoxShadow(
                                color: Colors.grey[300]!,
                                blurRadius: 5,
                                spreadRadius: 5,
                                offset: const Offset(4, 4)
                              ),
                            ]
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(agenda.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                              const SizedBox(height: 10,),
                              Text("Data: $dateFormated ($dateFormatedAbbr)", style: const TextStyle(fontWeight: FontWeight.bold,),),
                              Text("Hora: ${agenda.hora}", style: const TextStyle(fontWeight: FontWeight.bold,),),
                            ],
                          ),
                        ),
                      );
                    }
                  ),
                ],
              ),
            )
          ),
        ),
      ),
    );
  }
}