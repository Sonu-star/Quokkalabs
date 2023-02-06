import 'package:flutter/material.dart';

void onLatestLoading(bool status,BuildContext context) {
  if(status) {
    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (_) => Center( // Aligns the container to center
            child: Container( // A simplified version of dialog.
              width: 200.0,
              height: 200.0,
              color: Colors.transparent,
              child: Image.asset('images/loader.gif',width: 150,height: 150,),
            )
        )
    );
  } else{
    Navigator.of(context).pop();

  }
}
