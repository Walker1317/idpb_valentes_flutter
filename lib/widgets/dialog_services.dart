import 'package:flutter/material.dart';

class DialogServices {

  DialogServices.showAlertDialog(
    BuildContext context, String content,
    {String? title, Function()? onPermissed , Function()? onDenied,
       String? buttonTitle, String? buttonTitle2,
       Color? colorButton, Color? colorButton2,
    })
  {
    showDialog(
      context: context, 
      builder: (context){
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
          ),
          title: Text(title ?? 'Oops!'),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: onPermissed ?? ()=> Navigator.of(context).pop(),
              child: Text(buttonTitle ?? 'OK', style: TextStyle(color: colorButton ?? Colors.blue),)
            ),
            buttonTitle2 == null?
            Container():
            TextButton(
              onPressed: onDenied ?? ()=> Navigator.of(context).pop(),
              child: Text(buttonTitle2, style: TextStyle(color: colorButton2 ?? Colors.blue),)
            ),
          ],
        );
      }
    );
  }

  DialogServices.loading(BuildContext context, {bool barrierDemissible = false}){

    showDialog(
      context: context,
      barrierDismissible: barrierDemissible,
      builder: (context){
        return WillPopScope(
          onWillPop: () async {
            return true;
          },
          child: Center(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: const Padding(
                padding: EdgeInsets.all(40),
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        );
      }
    );
  }

}