import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:idpb_valentes_app/models/app_data.dart';

class ContribuicaoScreen extends StatefulWidget {
  ContribuicaoScreen(this.pageController, this.appData, {super.key});
  PageController pageController;
  AppData appData;

  @override
  State<ContribuicaoScreen> createState() => _ContribuicaoScreenState();
}

class _ContribuicaoScreenState extends State<ContribuicaoScreen> {
  double opacity = 0;
  
  _back(){
    widget.pageController.jumpToPage(0);
  }

  @override
  void initState() {
    super.initState();
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
              title: const Text("Contribuição"),
              leading: IconButton(
                onPressed: _back,
                icon: const Icon(Icons.arrow_back)
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.pix),
                    title: const Text("PIX"),
                    trailing: IconButton(
                      onPressed: (){
                        FlutterClipboard.copy(widget.appData.pix)
                        .then((value){
                          print("Copiado!");
                          ScaffoldMessenger.of(context)
                            .showSnackBar(
                            const SnackBar(
                              duration: Duration(seconds: 1),
                              backgroundColor: Colors.blue,
                              content: Text("Copiado")
                            ),
                          );
                        })
                        .catchError((e)=> print("Erro ao copiar"));
                      },
                      icon: const Icon(Icons.copy_outlined)
                    ),
                    subtitle: Text(widget.appData.pix),
                  ),
                  ListTile(
                    leading: const Icon(Icons.balance_outlined),
                    title: const Text("Tranferência Bancária"),
                    trailing: IconButton(
                      onPressed: (){
                        FlutterClipboard.copy(widget.appData.banco!)
                        .then((value){
                          print("Copiado!");
                          ScaffoldMessenger.of(context)
                            .showSnackBar(
                            const SnackBar(
                              duration: Duration(seconds: 1),
                              backgroundColor: Colors.blue,
                              content: Text("Copiado")
                            ),
                          );
                        })
                        .catchError((e)=> print("Erro ao copiar"));
                      },
                      icon: const Icon(Icons.copy_outlined)
                    ),
                    subtitle: Text(widget.appData.banco!),
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