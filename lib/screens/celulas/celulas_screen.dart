import 'package:flutter/material.dart';

class CelulasScreen extends StatefulWidget {
  CelulasScreen(this.pageController, {super.key});
  PageController pageController;

  @override
  State<CelulasScreen> createState() => _CelulasScreenState();
}

class _CelulasScreenState extends State<CelulasScreen> {
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
              title: const Text("Células"),
              leading: IconButton(
                onPressed: _back,
                icon: const Icon(Icons.arrow_back)
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: const [
                  Icon(Icons.real_estate_agent_rounded, size: 160,),
                  SizedBox(height: 20,),
                  Text(
                    "Uma célula de igreja é grupo formado por poucas pessoas (de cinco a quinze, em média) que se reúne toda semana, sempre no mesmo dia e horário, para estudar a Bíblia, adorar a Deus com músicas e orar. Em geral, os encontros ocorrem na casa de alguém, mas também podem acontecer em locais pré-determinados.\n\nAssim como as células do corpo humano são sua unidade básica e têm papel fundamental para o bom funcionamento do corpo, as células da igreja sustentam a congregação e desempenham uma função muito importante na integração do corpo de Cristo.\n\nEntre os objetivos das células estão comunhão com Deus, comunhão com os irmãos da igreja, edificação espiritual, discipulado e evangelização.",
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