import 'package:flutter/material.dart';
import 'package:icebreaking_app/src/services/services.dart';
import 'package:icebreaking_app/src/styles/styles.dart';
import 'package:icebreaking_app/src/widgets/route.dart';
import 'package:icebreaking_app/src/widgets/widgets.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

class ButtomIceAnimation extends StatelessWidget {

 
  @override
  Widget build(BuildContext context) {

  final profileServices = Provider.of<ProfileServices>(context);


    return LikeButton(
      size: 80,
      isLiked: profileServices.iceThisUser,
      circleColor: CircleColor(start: MyStyles().colorNaranja, end: MyStyles().colorNaranja),
      bubblesColor: BubblesColor(dotPrimaryColor: MyStyles().colorAzul, dotSecondaryColor: MyStyles().colorRojo),
      likeBuilder: (isIce) {
          return Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.grey.shade200, Colors.white])
          ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              profileServices.iceThisUser 
                  ?  'assets/llamas_4.png'
                  :  'assets/logo_fondo_blanco.png',
              height: 45,
            ),
            const Text('Ice')
          ],
        ),
        );
      },
      onTap: (isIce) async {

          switch (isIce) {
            case true : {
              await profileServices.ice(true);
              profileServices.setIceThisUser = false;

              break;
            }
            case false : {
              await profileServices.ice(false);
              profileServices.setIceThisUser = true ;
              profileServices.boolMatch 
                  ? Navigator.push(context, RutaPersonalizada().rutaPersonalizada(MatchWiget()))
                  : null ; 
              break;
            }
          }
        return !isIce;
      },
    );
  }
}

