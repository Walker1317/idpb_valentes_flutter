import 'package:flutter/material.dart';

class QuemSomos extends StatefulWidget {
  QuemSomos(this.pageController, {super.key});
  PageController pageController;

  @override
  State<QuemSomos> createState() => _QuemSomosState();
}

class _QuemSomosState extends State<QuemSomos> {
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
              title: const Text("Quem Somos"),
              leading: IconButton(
                onPressed: _back,
                icon: const Icon(Icons.arrow_back)
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: const [
                  Icon(Icons.people_outline_rounded, size: 160,),
                  Text(
                    "Nós somos a Igreja de Deus Pentecostal do Brasil no Amazonas.\n\nA IDPB é uma igreja que acredita em Jesus, que ama a Deus e as pessoas. Acreditamos que somos amados por Deus. Ele demonstrou isso ao renunciar livremente Seu único filho Jesus, por você e por mim.\n\nQuando entendemos essa verdade, somos transformados por Sua graça de dentro para fora. Essa é a beleza de acreditar e viver na graça de nosso Pai celestial! Não importa de onde você é ou de onde você vem, há sempre um lugar para você em nossa família!",
                    textAlign: TextAlign.justify,
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