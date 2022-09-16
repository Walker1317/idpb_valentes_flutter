import 'package:flutter/material.dart';
import 'package:idpb_valentes_app/models/app_data.dart';
import 'package:idpb_valentes_app/widgets/app_widgets.dart';
import 'package:ionicons/ionicons.dart';
import 'package:url_launcher/url_launcher.dart';

class SobreScreen extends StatefulWidget {
  SobreScreen(this.pageController, this.appData, {super.key});
  PageController pageController;
  AppData appData;

  @override
  State<SobreScreen> createState() => _SobreScreenState();
}

class _SobreScreenState extends State<SobreScreen> {
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
              title: const Text("Sobre o APP"),
              leading: IconButton(
                onPressed: _back,
                icon: const Icon(Icons.arrow_back)
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 180,
                    width: 180,
                    decoration: BoxDecoration(
                      image: const DecorationImage(image: AssetImage("images/idpblogo.png"),),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2)
                    ),
                  ),
                  const SizedBox(height: 10,),
                  const Text(
                    "IDPB Valentes APP",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    ),
                  ),
                  const Text(
                    "Versão: 1.0.0(1)",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40,),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Aplicativo idealizado e desenvolvido em parceria por Interestelar e IDPB Valentes",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey
                      ),
                    ),
                  ),
                  const SizedBox(height: 40,),
                  const Text(
                    "IDPB Valentes®",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    ),
                  ),
                  const SizedBox(height: 10,),
                  const Text(
                    "Interestelar Studios®",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    ),
                  ),
                  const SizedBox(height: 40,),
                  TextButton(
                    onPressed: (){
                      _urlLauncher(widget.appData.site);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "www.idpbvalentes.com",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blue
                          ),
                        ),
                        SizedBox(width: 10,),
                        Icon(Icons.arrow_right_alt_rounded, color: Colors.blue,)
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: (){
                      _urlLauncher(widget.appData.criador);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "www.interestelarstd.com",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blue
                          ),
                        ),
                        SizedBox(width: 10,),
                        Icon(Icons.arrow_right_alt_rounded, color: Colors.blue,)
                      ],
                    ),
                  ),
                  const SizedBox(height: 40,),
                  const Text(
                    "2022",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    ),
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