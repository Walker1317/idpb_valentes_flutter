import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:idpb_valentes_app/models/usuario.dart';
import 'package:url_launcher/url_launcher.dart';

class PerfilScreen extends StatefulWidget {
  PerfilScreen(this.usuario, {super.key});
  Usuario usuario;

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil"),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 10,),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text("Nome"),
              subtitle: Text(widget.usuario.nome!),
            ),
            ListTile(
              leading: const Icon(Icons.email_outlined),
              title: const Text("Email"),
              subtitle: Text(widget.usuario.email!),
            ),
            widget.usuario.link.isEmpty ? Container() :
            ListTile(
              onTap: (){
                _urlLauncher(widget.usuario.link);
              },
              leading: const Icon(Icons.link_outlined),
              title: const Text("Link próprio"),
            ),
            ListTile(
              onTap: (){
                showDialog(
                  context: context,
                  builder: (context){
                    return AlertDialog(
                      title: const Text("Tem certeza?"),
                      content: const Text("Você irá deslogar da sua conta."),
                      actions: [
                        TextButton(
                          onPressed: (){
                            FirebaseAuth.instance.signOut();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          child: const Text("Sim", style: TextStyle(color: Colors.red),)
                        ),
                        TextButton(
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                          child: const Text("Não")
                        ),
                      ],
                    );
                  }
                );
              },
              leading: const Icon(Icons.logout_outlined, color: Colors.red,),
              title: const Text("Sair", style: TextStyle(color: Colors.red),),
            ),
          ],
        ),
      ),
    );
  }
}