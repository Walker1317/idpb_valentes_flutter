import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:idpb_valentes_app/base_screen.dart';
import 'package:idpb_valentes_app/models/usuario.dart';
import 'package:idpb_valentes_app/screens/auth/signup/signup_screen.dart';
import 'package:idpb_valentes_app/widgets/dialog_services.dart';
import 'package:ionicons/ionicons.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _formKey = GlobalKey<FormState>();
  bool obscureText = true;
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerSenha = TextEditingController();
  bool sendedRecoverPass = false;

  Future<String> _signin(Usuario usuario) async {
    String? result;
    FirebaseAuth auth = FirebaseAuth.instance;
    try{
      await auth.signInWithEmailAndPassword(
      email: usuario.email, password: usuario.senha).then((value){
        result = "success";
        print("Sucesso ao criar conta.");
      });
    } on FirebaseAuthException catch(e) {
      switch (e.code) {
        case "email-already-in-use":
          result = "Este email ja está sendo usado.";
          break;
        case "ERROR_WRONG_PASSWORD":
        case "wrong-password":
          result = "Senha inválida";
          break;
        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
          result = "Não achamos nenhum usuário com esse email.";
          break;
        case "ERROR_USER_DISABLED":
        case "user-disabled":
          result = "Usuário desabilitado.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
        case "too-many-requests":
          result = "Muitas solicitações para fazer login nesta conta.";
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
          result = "$e";
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
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
                GestureDetector(
                  onTap: (){
                    snackbar(String title, Color color){
                      ScaffoldMessenger.of(context)
                      .showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 1),
                          backgroundColor: color,
                          content: Text(title)
                        ),
                      );
                    }

                    if(_controllerEmail.text.isEmpty){
                      snackbar("Digite seu E-mail", Colors.red);
                    } else {
                      if(sendedRecoverPass == true){
                        snackbar("Uma requisição ja foi enviada.", Colors.red);
                      } else {
                        sendedRecoverPass = true;
                        FirebaseAuth.instance.sendPasswordResetEmail(email: _controllerEmail.text).then((value){}).catchError((e){});
                        snackbar("Verifique seu E-mail", Colors.blue);
                      }
                    }

                  },
                  child: const Text(
                    "Esqueci minha senha",
                    textAlign: TextAlign.right,
                    style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                  ),
                ),
                const SizedBox(height: 20,),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if(_formKey.currentState!.validate()){
                        FocusScope.of(context).unfocus();
                        DialogServices.loading(context);
                        Usuario usuario = Usuario();
                        usuario.email = _controllerEmail.text;
                        usuario.senha = _controllerSenha.text;

                        String signup = await _signin(usuario);
                        print("O RESULTADO DO LOGIN E: $signup");
                        route(signup);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black
                    ),
                    child: const Text("Entrar", style: TextStyle(color: Colors.white),)
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Não possui conta? "),
                      GestureDetector(
                        onTap: (){
                          FocusScope.of(context).unfocus();
                          showDialog(context: context, builder: (context)=> const SignupScreen());
                        },
                        child: const Text("Cadastre-se ",
                          style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}