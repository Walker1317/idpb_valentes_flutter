import 'package:flutter/material.dart';
import 'package:idpb_valentes_app/models/app_data.dart';
import 'package:idpb_valentes_app/widgets/app_widgets.dart';
import 'package:ionicons/ionicons.dart';
import 'package:url_launcher/url_launcher.dart';

class RedesScreen extends StatefulWidget {
  RedesScreen(this.pageController, this.appData, {super.key});
  PageController pageController;
  AppData appData;

  @override
  State<RedesScreen> createState() => _RedesScreenState();
}

class _RedesScreenState extends State<RedesScreen> {
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
              title: const Text("Redes Sociais"),
              leading: IconButton(
                onPressed: _back,
                icon: const Icon(Icons.arrow_back)
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                children: [
                  AppWidgets().homeTile(Ionicons.logo_facebook, "Facebook", ()=> _urlLauncher(widget.appData.facebook)),
                  AppWidgets().homeTile(Ionicons.logo_instagram, "Instagram", ()=> _urlLauncher(widget.appData.instagram)),
                ],
              ),
            )
          ),
        ),
      ),
    );
  }
}