import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_ui/firestore_ui.dart';
import 'package:flutter/material.dart';
import 'package:idpb_valentes_app/models/ministerio.dart';

class MinisteriosScreen extends StatefulWidget {
  MinisteriosScreen(this.pageController, {super.key});
  PageController pageController;

  @override
  State<MinisteriosScreen> createState() => _MinisteriosScreenState();
}

class _MinisteriosScreenState extends State<MinisteriosScreen> {
  double opacity = 0;
  Query? query;
  
  _back(){
    widget.pageController.jumpToPage(0);
  }

  _addListener(){
    query = FirebaseFirestore.instance.collection("ministerios").withConverter<Ministerio>(
      fromFirestore: (snapshot, _)=> Ministerio.fromDocumentSnapshot(snapshot),
      toFirestore: (value, options) => null!,
    );
  }

  @override
  void initState() {
    super.initState();
    _addListener();
    Future.delayed(const Duration(milliseconds: 50)).then((value){
      setState(() {
        opacity = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
              title: const Text("Ministérios"),
              leading: IconButton(
                onPressed: _back,
                icon: const Icon(Icons.arrow_back)
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Icon(Icons.handshake_outlined, size: 160,),
                  const Text("A IDPB Valentes, possui alguns ministérios, abaixo você pode saber quais os ministérios e os líderes responsáveis."),
                  const SizedBox(height: 20,),
                  FirestoreAnimatedList(
                    query: query!,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, snapshot, animation, index) {
                      dynamic ministerio = snapshot!.data();
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(10),
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
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ministerio.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                              Text("Responsável: ${ministerio.resp}",),
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