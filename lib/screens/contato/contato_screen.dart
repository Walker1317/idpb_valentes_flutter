import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:idpb_valentes_app/models/app_data.dart';
import 'package:url_launcher/url_launcher.dart';

class ContatoScreen extends StatefulWidget {
  ContatoScreen(this.pageController, this.appData, {super.key});
  PageController pageController;
  AppData appData;

  @override
  State<ContatoScreen> createState() => _ContatoScreenState();
}

class _ContatoScreenState extends State<ContatoScreen> {
  double opacity = 0;
  
  _back(){
    widget.pageController.jumpToPage(0);
  }

  Future _urlLauncher(String link) async {
    final Uri url = Uri.parse(link);
    try{
      if(!await launchUrl(url, mode: LaunchMode.externalApplication)){
        throw "Url Inválida";
      }
    } catch (e){
      print("ERRO AO ABRIR LINK: $e");
    }
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
              title: const Text("Contato"),
              leading: IconButton(
                onPressed: _back,
                icon: const Icon(Icons.arrow_back)
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  ListTile(
                    onTap: (){
                      _urlLauncher("mailto:${widget.appData.email}?subject=News&body=");
                    },
                    leading: const Icon(Icons.email_outlined),
                    title: const Text("Email"),
                    subtitle: Text(widget.appData.email),
                  ),
                  ListTile(
                    onTap: (){
                      _urlLauncher("tel:+55${widget.appData.fone}");
                    },
                    leading: const Icon(Icons.phone),
                    title: const Text("Telefone"),
                    subtitle: Text(widget.appData.fone),
                  ),
                  ListTile(
                    onTap: (){
                      FlutterClipboard.copy(widget.appData.endereco!)
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
                    leading: const Icon(Icons.location_pin),
                    title: const Text("Endereço"),
                    subtitle: Text(widget.appData.endereco),
                    trailing: const Icon(Icons.copy, color: Colors.grey,),
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