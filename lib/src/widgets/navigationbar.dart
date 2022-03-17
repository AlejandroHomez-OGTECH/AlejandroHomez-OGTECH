import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:icebreaking_app/src/pages/pages.dart';
import 'package:icebreaking_app/src/services/services.dart';
import 'package:icebreaking_app/src/styles/styles.dart';
import 'package:icebreaking_app/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

class NavigationBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 15),
      height: 70,
      color: MyStyles().colorNaranja,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
              _Explorar(null),
              _Ices( () => Navigator.pushAndRemoveUntil(context, RutaPersonalizada().rutaPersonalizada(ListIcePage()), (route) => false)),
              const SizedBox(width: 30),
              _Chats(() {
                Navigator.push(context,
                    RutaPersonalizada().rutaPersonalizada(ListChatsPage()));
              }),
              _Mas()
        ],
      )
      
      // CustomPaint(
      //   painter: CustomNavBar(),
      //   child: Padding(
      //     padding: const EdgeInsets.only(top: 28),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceAround,
      //       children: [

      //         _Explorar(null),
      //         _Ices(),
      //         const SizedBox(width: 30),
      //         _Chats(),
      //         _Mas()
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}

class NavigationBarChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 15),
        height: 70,
        decoration: BoxDecoration(
          gradient:  LinearGradient(
            stops: const [ 0.4 , 0.6],
            colors: [
                MyStyles().colorAzul,
                MyStyles().colorRojo
          ])
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _Explorar(null),

            _Ices( () => Navigator.pushAndRemoveUntil(context, RutaPersonalizada().rutaPersonalizada(ListIcePage()), (route) => false)),

            const SizedBox(width: 30),
            _Chats(() {}),
            _Mas()
          ],
        )
      );
  }
}

class NavigationBarIce extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 15),
        height: 70,
        decoration: BoxDecoration(
          gradient:  LinearGradient(
            stops: const [ 0.4 , 0.6],
            colors: [
                MyStyles().colorAzul,
                MyStyles().colorRojo
          ])
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _Explorar(null),
            _Ices( () {} ),

            const SizedBox(width: 30),
            _Chats(() async {

                Navigator.push(context,
                    RutaPersonalizada().rutaPersonalizada(ListChatsPage()));
              }),
            _Mas()
          ],
        )
      );
  }
}

class NavigationBarIcBreaking extends StatelessWidget {

  final Route? route;
  NavigationBarIcBreaking(this.route);
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 80,
      child: CustomPaint(
        painter: CustomNavBarIceBreaking(),
        child: Padding(
          padding: const EdgeInsets.only(top: 28),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _Explorar(route),

              _Ices( () => Navigator.pushAndRemoveUntil(context, RutaPersonalizada().rutaPersonalizada(ListIcePage()), (route) => false)),

              _Chats(() {
                Navigator.push(context,
                    RutaPersonalizada().rutaPersonalizada(ListChatsPage()));
              }),
              _Mas()
            ],
          ),
        ),
      ),
    );
  }
}

class _Mas extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {

        Navigator.push(context,
        
         PageRouteBuilder(
           pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secundaryAnimation) =>  SettingPage(),
           transitionDuration: const Duration(milliseconds: 300),
           transitionsBuilder: (context, animation , secundatyAnimation, child) {
             
             final curvedAnimation = CurvedAnimation(parent: animation, curve: Curves.easeIn);

             return SlideTransition(
               position: Tween<Offset>(begin: const Offset(1.0, 1.0) , end: Offset.zero).animate(curvedAnimation),
               child: child,
              );
           }   
        )
      );

      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: const [
            Icon(Icons.settings, size:  30, color: Colors.white,),
            Text('Mas', style: TextStyle(color: Colors.white),)
          ],
        ),
      ),
    );
  }
}

class _Chats extends StatelessWidget {

   final VoidCallback? onTap;
  const _Chats( this.onTap);

  @override
  Widget build(BuildContext context) {
  
 
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset('assets/icons/chat icon.png', height: 25,),
          const SizedBox(height: 5),
           const Text('Chat', style: TextStyle(color: Colors.white),)
    
        ],
      ),
    );
  }
}

class _Ices extends StatelessWidget {

  final VoidCallback? onTap;
  const _Ices( this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ,
      child: Column(
        children: const [
            Icon(Icons.group_outlined, color: Colors.white, size: 30,),
            Text('Ice', style: TextStyle(color: Colors.white),)
    
        ],
      ),
    );
  }
}

class _Explorar extends StatelessWidget {

  final Route? route;
  _Explorar(this.route);

  @override
  Widget build(BuildContext context) {
    final newProfileService = Provider.of<NewProfileServices>(context);
    final user = Provider.of<ProfileServices>(context).newUser;

    return GestureDetector(
      onTap: ()  async {
        await newProfileService.loadIdiomas(user.languages!);
        // ignore: unnecessary_null_comparison
        if (route == null) {
            Navigator.pushAndRemoveUntil(context, RutaPersonalizada().rutaPersonalizada(HomePage()), (route) => false );
        } else {
            Navigator.pushAndRemoveUntil(context, route!, (route) => false);
        }
      },
      child: Column(
        children: [
          SvgPicture.asset('assets/icons/radar_white_24dp.svg',color: Colors.white, height: 25),
          const SizedBox(height: 5),
          const Text('Explorar',  style: TextStyle(color: Colors.white),)
        ],
      ),
    );
  }
}