import 'package:flutter/material.dart';

class GaleriaScreen extends StatefulWidget {
  GaleriaScreen(this.pageController, {super.key});
  PageController pageController;

  @override
  State<GaleriaScreen> createState() => _GaleriaScreenState();
}

class _GaleriaScreenState extends State<GaleriaScreen> {
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
              title: const Text("Galeria"),
              leading: IconButton(
                onPressed: _back,
                icon: const Icon(Icons.arrow_back)
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: const [

                ],
              ),
            )
          ),
        ),
      ),
    );
  }
}