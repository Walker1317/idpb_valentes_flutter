import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:idpb_valentes_app/base_screen.dart';
import 'package:idpb_valentes_app/models/usuario.dart';
import 'package:idpb_valentes_app/widgets/dialog_services.dart';
import 'package:ionicons/ionicons.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  bool obscureText = true;
  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerSenha = TextEditingController();

  Future<String> _signup(Usuario usuario) async {
    String? result;
    FirebaseAuth auth = FirebaseAuth.instance;
    try{
      await auth.createUserWithEmailAndPassword(
      email: usuario.email, password: usuario.senha).then((value){
        result = "success";
        print("Sucesso ao criar conta.");
      });
    } on FirebaseAuthException catch(e) {
      switch (e.code) {
        case "email-already-in-use":
          result = "Este email ja está sendo usado.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
        case "operation-not-allowed":
          result = "Erro no servidor, tente novamente mais tarde.";
          break;
        case "ERROR_INVALID_EMAIL":
        case "invalid-email":
          result = "Email inválido";
          break;
        default:
          result = "Erro ao fazer login, por favor tente novamente.";
          break;
      }
    }
    return result!;
  }

  route(String signup){
    if(signup != "success"){
      Navigator.of(context).pop();
      DialogServices.showAlertDialog(
        context,
        signup,
      );
    } else {
      Navigator.of(context).pop();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=> const BaseScreen()), (route) => false);
    }
  }

  Future uploadData(Usuario usuario) async{
    User? user = FirebaseAuth.instance.currentUser;
    usuario.id = user!.uid;
    FirebaseFirestore.instance.collection("usuarios")
    .doc(user.uid).set(usuario.toMap()).then((value){})
    .catchError((e){});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastro"),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _controllerNome,
                  validator: (text){
                    if(text!.isEmpty){
                      return "Digite seu nome";
                    } else if(text.length < 5){
                      return "Nome muito curto";
                    } else {
                      return null;
                    }
                  },
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(20),
                  ],
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: "Nome de Usuário",
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  controller: _controllerEmail,
                  validator: (text){
                    if(text!.isEmpty){
                      return "Digite seu email";
                    } else if(!text.contains("@")){
                      return "Email inválido";
                    } else {
                      return null;
                    }
                  },
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(50),
                  ],
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  controller: _controllerSenha,
                  validator: (text){
                    if(text!.isEmpty){
                      return "Digite sua senha";
                    } else if(text.length < 6){
                      return "Senha muito curta";
                    } else {
                      return null;
                    }
                  },
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(50),
                  ],
                  obscureText: obscureText,
                  decoration: InputDecoration(
                    labelText: "Senha",
                    prefixIcon: const Icon(Icons.key),
                    suffixIcon: IconButton(
                      onPressed: (){
                        setState(() {
                          if(obscureText == true){
                            obscureText = false;
                          } else {
                            obscureText = true;
                          }
                        });
                      },
                      icon: Icon(obscureText == true ? Ionicons.eye_outline : Ionicons.eye_off_outline)
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if(_formKey.currentState!.validate()){
                        FocusScope.of(context).unfocus();
                        DialogServices.loading(context);
                        Usuario usuario = Usuario();
                        usuario.nome = _controllerNome.text;
                        usuario.email = _controllerEmail.text;
                        usuario.senha = _controllerSenha.text;
                        usuario.adm = false;
                        usuario.link = "";

                        String signup = await _signup(usuario);
                        if(signup == "success"){
                          await uploadData(usuario);
                        }
                        print("O RESULTADO DO LOGIN E: $signup");
                        route(signup);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black
                    ),
                    child: const Text("Cadastrar", style: TextStyle(color: Colors.white),)
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}