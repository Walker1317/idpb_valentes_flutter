import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:idpb_valentes_app/models/app_data.dart';
import 'package:idpb_valentes_app/models/usuario.dart';
import 'package:idpb_valentes_app/screens/auth/signin/signin_screen.dart';
import 'package:idpb_valentes_app/screens/perfil_screen/perfil_screen.dart';
import 'package:idpb_valentes_app/widgets/app_widgets.dart';
import 'package:ionicons/ionicons.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen(this.pageController, this.appData, this.usuario, {super.key});
  PageController pageController;
  Usuario usuario;
  AppData appData;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    Widget homeTile(IconData icon, String title, int screenNav){
      return ElevatedButton(
        onPressed: (){
          widget.pageController.jumpToPage(screenNav);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.black,),
            const SizedBox(height: 10,),
            Text(
              title,
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        )
      );
    }

    Future _urlLauncher(String link) async {
      final Uri url = Uri.parse(link);
      try{
        if(!await launchUrl(url, mode: LaunchMode.externalNonBrowserApplication)){
          throw "Url Inválida";
        }
      } catch (e){
        print("ERRO AO ABRIR LINK: $e");
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("IDPB Valentes"),
        actions: [
          IconButton(
            onPressed: (){
              User? user = FirebaseAuth.instance.currentUser;
              showDialog(
                context: context,
                builder: (context)=> user == null ? const SigninScreen() : PerfilScreen(widget.usuario)
              );
            },
            icon: const Icon(Icons.person)
          ),
        ],
      ),
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
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
              const SizedBox(height: 20,),
              GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                children: [
                  homeTile(Icons.people_alt_rounded, "Quem Somos", 1),
                  homeTile(Icons.handshake_rounded, "Ministérios", 2),
                  homeTile(Icons.real_estate_agent_rounded, "Células", 3),
                  homeTile(Icons.calendar_month_rounded, "Agenda", 4),
                  AppWidgets().homeTile(Icons.file_copy_outlined, "Estudos", ()=> _urlLauncher(widget.appData.estudos)),
                  AppWidgets().homeTile(Icons.location_on_rounded, "Localização", ()=> _urlLauncher(widget.appData.local)),
                  homeTile(Icons.phone, "Contato", 8),
                  AppWidgets().homeTile(Ionicons.logo_youtube, "Culto Online", ()=> _urlLauncher(widget.appData.youtube)),
                  homeTile(Icons.hub_rounded, "Redes Sociais", 10),
                  homeTile(Icons.savings_outlined, "Contribuição", 11),
                ],
              ),
              const SizedBox(height: 20,),
              const Text("www.idpbvalentes.com", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
            ],
          ),
        ),
      ),
    );
  }
}