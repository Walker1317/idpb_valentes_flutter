import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:idpb_valentes_app/models/agenda.dart';
import 'package:idpb_valentes_app/widgets/dialog_services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerTitulo = TextEditingController();
  final TextEditingController _controllerData = TextEditingController();
  final TextEditingController _controllerHora = TextEditingController();
  DateTime? data;

  Future _sendCreatedNotifications(String title , String body , String id) async {
    var serverToken = "" ; 
    await FirebaseMessaging.instance.subscribeToTopic('all');
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers:<String,String>{'Content-Type':'application/json',
      'Authorization':'key=$serverToken',},
      body: jsonEncode(
        <String, dynamic>{
          'topic': "all",
          'data': {
            'via': 'FlutterFire Cloud Messaging!!!',
            'count': "1",
          },
          'notification':<String,dynamic>{
            'body':body.toString(),
            'title':title.toString(),
            'priority':'high',
            'data':<String,dynamic>{
            'click_action':'FLUTTER_NOTIFICATION_CLICK',
            'id':id.toString()},
          },
        }
      )
    );
  }

  _pop(){
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  _uploadEvento(Agenda agenda){
    FirebaseFirestore.instance.collection("agenda")
    .doc(agenda.id).set(agenda.toMap()).then((value) async {
      await _sendCreatedNotifications("Novo evento disponível!", "${agenda.title}", "1");
      _pop();
    }).catchError((e){
      Navigator.of(context).pop();
      DialogServices.showAlertDialog(context, "Tivemos um Problema ao salvar evento.");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Criar Evento"),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10,),
              TextFormField(
                controller: _controllerTitulo,
                validator: (text){
                  if(text!.isEmpty){
                    return "Digite o Título";
                  } else {
                    return null;
                  }
                },
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: "Título",
                ),
              ),
              const SizedBox(height: 10,),
              TextFormField(
                readOnly: true,
                controller: _controllerData,
                validator: (text){
                  if(text!.isEmpty){
                    return "Selecione uma data";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: "Data",
                  suffixIcon: IconButton(
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      DateTime? dateTime = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if(dateTime != null){
                        data = dateTime;
                        String dateFormated = DateFormat(DateFormat.YEAR_NUM_MONTH_DAY, "pt_BR").format(dateTime);
                        String dateFormatedAbbr = DateFormat(DateFormat.WEEKDAY, "pt_BR").format(dateTime).toUpperCase();
                        _controllerData.text = "$dateFormated ($dateFormatedAbbr)";
                      }
                    },
                    icon: const Icon(Icons.calendar_month_outlined, color: Colors.blue,)
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              TextFormField(
                controller: _controllerHora,
                readOnly: true,
                validator: (text){
                  if(text!.isEmpty){
                    return "Selecione a Hora";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: "Hora",
                  suffixIcon: IconButton(
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      TimeOfDay? timeOfDay = await showTimePicker(
                        context: context,
                        initialTime: const TimeOfDay(hour: 00, minute: 00)
                      );
                      if(timeOfDay != null){
                        _controllerHora.text = timeOfDay.format(context).toString();
                      }
                    },
                    icon: const Icon(Icons.timer_outlined, color: Colors.blue,)
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    if(_formKey.currentState!.validate()){
                      DialogServices.loading(context);
                      Agenda agenda = Agenda.gerarId();
                      agenda.title = _controllerTitulo.text;
                      agenda.data = data.toString();
                      agenda.hora = _controllerHora.text;
                      _uploadEvento(agenda);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black
                  ),
                  child: const Text("Criar Evento", style: TextStyle(color: Colors.white),)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}