import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen(this.pageController, {super.key});
  PageController pageController;

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

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: true,
        child: Center(
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
                    homeTile(Icons.file_copy_outlined, "Estudos", 5),
                    homeTile(Icons.photo_album, "Galeria", 6),
                    homeTile(Icons.location_on_rounded, "Localização", 7),
                    homeTile(Icons.phone, "Contato", 8),
                    homeTile(Ionicons.logo_youtube, "Culto Online", 9),
                    homeTile(Icons.hub_rounded, "Redes Sociais", 10),
                    homeTile(Icons.people_alt_rounded, "Contribuição", 11),
                  ],
                ),
                const Text("www.idpbvalentes.com", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}