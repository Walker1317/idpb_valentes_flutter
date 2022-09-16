import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:idpb_valentes_app/models/app_data.dart';
import 'package:idpb_valentes_app/models/usuario.dart';
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
import 'package:idpb_valentes_app/screens/sobre/sobre_screen.dart';
import 'package:idpb_valentes_app/screens/youtube/youtube_screen.dart';
import 'package:idpb_valentes_app/services/messaging/firebase_messaging_services.dart';
import 'package:idpb_valentes_app/services/messaging/notification_service.dart';
import 'package:provider/provider.dart';

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
  Usuario? usuario;
  AppData? appData;

  _recoverUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    print(user);
    if(user != null){
      print("usuario logado");
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection("usuarios").doc(user.uid).get();
      setState(() {
        usuario = Usuario.fromDocumentSnapshot(snapshot);
      });
    } else {
      print("usuario nao logado");
      usuario = Usuario();
      usuario!.adm = false;
    }

    DocumentSnapshot dataSnapshot = await FirebaseFirestore.instance
    .collection("data").doc("links").get();

    setState(() {
      appData = AppData.fromDocumentSnapshot(dataSnapshot);
      _stateManagement();
    });
  }

  _stateManagement(){
    Future.delayed(const Duration(seconds: 0)).then((value){
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

  initializeFirebaseMessaging() async {
    await Provider.of<FirebaseMessagingService>(context, listen: false).initialize();
  }

  checkNotifications() async {
    await Provider.of<NotificationService>(context, listen: false).checkForNotifications();
  }

  @override
  void initState() {
    super.initState();
    initializeFirebaseMessaging();
    checkNotifications();
    _recoverUserData();
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
            HomeScreen(pageController, appData!, usuario!),
            QuemSomos(pageController),
            MinisteriosScreen(pageController),
            CelulasScreen(pageController),
            AgendaScreen(pageController, usuario!),
            EstudosScreen(pageController),
            GaleriaScreen(pageController),
            LocalizacaoScreen(pageController),
            ContatoScreen(pageController, appData!),
            YoutubeScreen(pageController),
            RedesScreen(pageController, appData!),
            ContribuicaoScreen(pageController, appData!),
            SobreScreen(pageController, appData!),
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