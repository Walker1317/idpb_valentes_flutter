import 'package:flutter/material.dart';
import 'package:idpb_valentes_app/screens/agenda/agenda_screen.dart';
import 'package:idpb_valentes_app/screens/celulas/celulas_screen.dart';
import 'package:idpb_valentes_app/screens/contato/contato_screen.dart';
import 'package:idpb_valentes_app/screens/contribuicao/contribuicao_screen.dart';
import 'package:idpb_valentes_app/screens/estudos/estudos_screen.dart';
import 'package:idpb_valentes_app/screens/galeria/galeria_screen.dart';
import 'package:idpb_valentes_app/screens/home/home_screen.dart';
import 'package:idpb_valentes_app/screens/localizacao/localizacao_screen.dart';
import 'package:idpb_valentes_app/screens/quem_somos/quem_somos.dart';
import 'package:idpb_valentes_app/screens/ministerios/ministerios_screen.dart';
import 'package:idpb_valentes_app/screens/redes/redes_screen.dart';
import 'package:idpb_valentes_app/screens/youtube/youtube_screen.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  double opacity = 0;
  double opacityLoading = 1;
  PageController pageController = PageController();
  bool loading = true;

  _stateManagement(){
    Future.delayed(const Duration(seconds: 2)).then((value){
      setState(() {
        opacityLoading = 0;
        _setHomeOpacity();
      });
    });
  }

  _setHomeOpacity(){
    loading = false;
    Future.delayed(const Duration(milliseconds: 50)).then((value){
      setState(() {
        opacity = 1;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _stateManagement();
  }

  @override
  Widget build(BuildContext context) {

    Widget loadingState(){
      return Center(
        child: AnimatedOpacity(
          duration: const Duration(seconds: 1),
          opacity: opacityLoading,
          curve: Curves.ease,
          child: const CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      );
    }

    Widget homeState(){
      return AnimatedOpacity(
        duration: const Duration(seconds: 1),
        opacity: opacity,
        curve: Curves.ease,
        child: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            HomeScreen(pageController),
            QuemSomos(pageController),
            MinisteriosScreen(pageController),
            CelulasScreen(pageController),
            AgendaScreen(pageController),
            EstudosScreen(pageController),
            GaleriaScreen(pageController),
            LocalizacaoScreen(pageController),
            ContatoScreen(pageController),
            YoutubeScreen(pageController),
            RedesScreen(pageController),
            ContribuicaoScreen(pageController),
          ],
        ),
      );
    }

    if(loading == true){
      return loadingState();
    } else {
      return homeState();
    }
  }
}