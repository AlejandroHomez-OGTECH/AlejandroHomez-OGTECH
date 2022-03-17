import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icebreaking_app/src/models/models.dart';
import 'package:like_button/like_button.dart';

import 'package:flutter/cupertino.dart';
import 'package:icebreaking_app/src/pages/home/modes/icebreakingmode/pages_items_Ice.dart';
import 'package:icebreaking_app/src/services/profile_service.dart';
import 'package:icebreaking_app/src/styles/styles.dart';
import 'package:icebreaking_app/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ProfilePageIce extends StatelessWidget {

  final String email;

  ProfilePageIce(this.email); 
      
    @override
    Widget build(BuildContext context) {

    final profileServices = Provider.of<ProfileServices>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: profileServices.loadUsersIceProfileIce(email),
        builder: (context ,  AsyncSnapshot<UserIce> snap){


          if (snap.data == null) {
            return Center(child: CircularProgressIndicator(
              backgroundColor: MyStyles().colorAzul,
              color: MyStyles().colorRojo,
            ));
          }
          
          UserIce user = snap.data!;

          return SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
              children: [
                _HeaderProfile(user: user ),
                _UserName(user: user),
                _ButtomSProfile(),
                _ComoSoy(),
                _InformationProfile(),
                ItemsProfile(),
                PagesItemsIce()
                ],
              ),
            ),
          );

        },
       
      ),

      // bottomNavigationBar: _NavigationBar(),
    );
   }
}

class _InformationProfile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

  final user = Provider.of<ProfileServices>(context).tempUser;

    return SizedBox(
      width: double.infinity,
      child: _ItemInformation(
              title: 'Likes',
              subtitle: '${user.likes}'),

    );
  }
}

class _ItemInformation extends StatelessWidget {

  final String title;
  final String subtitle;
  _ItemInformation({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title , style: const TextStyle( color: Colors.black38, fontSize: 15)),
        const SizedBox(height: 5),
        FadeInDown(
          from: 5,
          child: Text(int.parse(subtitle) >= 10000 ? '${int.parse(subtitle) / 1000} k' : subtitle , style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),)
        )
      ],
    );
  }
}

class _ButtomSProfile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {


    return Container(
      margin: const EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ButtomIceAnimation(),
          SizedBox(width: MyStyles().kPadding * 5),
          _ButtomLike()

        ],
      ),
    );
  }

}

class _ButtomLike extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

  final profileServices = Provider.of<ProfileServices>(context);
    
    return LikeButton(
      size: 80,
      isLiked: profileServices.likeThisUser,
      likeBuilder: (isLiked) {
        const color = Colors.grey;

          return Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
              Colors.grey.shade200,
              Colors.white
            ])
          ),
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/emoji.png', height: 45,),
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (rect) {
                  return isLiked
                    ? MyStyles().gradientHorizontal.createShader(rect)
                    : const LinearGradient(colors: [color, color]).createShader(rect);
                },
                child: const Text('Wink'))
            ],
          ),
        );
      },
      onTap: (isLiked) async {

        switch (isLiked) {

          case true : {
            profileServices.like(true);
            profileServices.setLikeThisUser = false;
            break;
          }
          case false : {
            profileServices.like(false);
            profileServices.setLikeThisUser = true;
            break;
          }
        }
        return !isLiked;
      },
    );
    
    // GestureDetector(
    //   onTap: () => profileServices.like(),
    //   child: Container(
    //     width: 80,
    //     height: 80,
    //     decoration: BoxDecoration(
    //       shape: BoxShape.circle,
    //       gradient: LinearGradient(
    //         begin: Alignment.topCenter,
    //         end: Alignment.bottomCenter,
    //         colors: [
    //         Colors.grey.shade200,
    //         Colors.white
    //       ])
    //     ),
        // child:  Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Image.asset('assets/emoji.png', height: 45,),
        //     ShaderMask(
        //       blendMode: BlendMode.srcIn,
        //       shaderCallback: (rect) {
        //         return profileServices.likeThisUser 
        //           ? const LinearGradient(colors: [Colors.black, Colors.black]).createShader(rect)
        //           : MyStyles().gradientHorizontal.createShader(rect);
        //       },
        //       child: const Text('Wink'))
        //   ],
        // ),
    //     ),
    // );
  }
}


//Data Profile

class _UserName extends StatelessWidget {

  final UserIce user;
  late String edad;
  _UserName({required this.user});

  String getEdad(){

   DateTime fecha = user.dateOfBirth.toDate();
   DateTime hoy = DateTime.now();

   edad = (hoy.year - fecha.year).toString();

  return edad;
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.only(top: 50),
      width: double.infinity,
      child: Text(user.fullName + ' - ' + getEdad(), style: MyStyles().titleStyle.copyWith(
        fontSize: 30
      ), maxLines: 2,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,),
    );
  }
}

class _HeaderProfile extends StatelessWidget {
  
    final UserIce user;
   String urlPhoto = "https://thumbs.dreamstime.com/b/icono-gris-de-perfil-usuario-s%C3%ADmbolo-empleado-avatar-web-y-dise%C3%B1o-ilustraci%C3%B3n-signo-aislado-en-fondo-blanco-191067342.jpg";

  _HeaderProfile({required this.user});

  String dropdownvalue = 'Editar';
   

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    
    final user = Provider.of<ProfileServices>(context).tempUser;

    final providerLogin = Provider.of<AuthClass>(context);

    return Stack(
      children: [
        SizedBox(
          width: size.width,
          height: size.height * 0.3,
          child: ClipPath(
            clipper: CustomProfile(),
            child: Stack(
              children: [
                FadeInImage(
                  placeholder: const AssetImage('assets/fondo_negro.jpg'), 
                  image: NetworkImage(user.profilePhoto == '' ? urlPhoto : user.profilePhoto),
                  width: double.infinity,
                  fit: BoxFit.cover,
                  ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    color: Colors.black45,
                  ),
                  
                ),
              ],
            )
          ),
        ),

        Positioned(
          bottom: 0,
          child: SizedBox(
            width: size.width,
            child: Stack(
              alignment: Alignment.center,
              children: [
                _ImagenProfile(),
                _MenuEllipsis()

              ],
            ),
          )),
        
        Positioned(
          top: 5,
          left: 0,
          right: 0,
          child: Container(
              padding: const EdgeInsets.only(top: 30, bottom: 10),
              child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
        
        
            IconButton(
              onPressed: () {
      
              Navigator.pop(context);

              }, 
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 28,
                color: Colors.white
              )),
          
            Text('Perfil', style: MyStyles().titleStyle.copyWith(
              color: Colors.white
            )),

           const SizedBox(width: 20)
          ],
              ),
              ),
        )
      ],
    );
  }

}

class _MenuEllipsis extends StatefulWidget {


  @override
  State<_MenuEllipsis> createState() => _MenuEllipsisState();
}

class _MenuEllipsisState extends State<_MenuEllipsis> {

  double _height = 0.0;

  @override
  Widget build(BuildContext context) {
   
    return Positioned(
        right: 3,
        top: 40,
        child: Stack(
          alignment: Alignment.centerRight,
          children: [

            FloatingActionButton(
              mini: true,
              onPressed: () {
                const altura = 40.0;
                setState(() {
                  if (_height == 0) {
                    _height = altura;
                  } else {
                    _height = 0.0;
                  }
                });
              },
              child: const Icon(FontAwesomeIcons.ellipsisV, color: Colors.black),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            
            AnimatedContainer(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              margin: const EdgeInsets.only(right: 35),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutQuart,
              height: _height,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(5),
                  ),
              child: GestureDetector(
                  onTap: () {},
                  child: const Text('Reportar', style: TextStyle(color: Colors.white),)
              ),
            ),
          ],
        ));
  }

}

class _ImagenProfile extends StatelessWidget {

  String photoProfile = "https://thumbs.dreamstime.com/b/icono-gris-de-perfil-usuario-s%C3%ADmbolo-empleado-avatar-web-y-dise%C3%B1o-ilustraci%C3%B3n-signo-aislado-en-fondo-blanco-191067342.jpg";

  @override
  Widget build(BuildContext context) {

  final user = Provider.of<ProfileServices>(context).tempUser;

    return Hero(
      tag: user.id!,
      child: Container(
        alignment: Alignment.bottomRight,
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow:const [
             BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 15))
          ],
          shape: BoxShape.circle,
          image: DecorationImage(
            // ignore: prefer_if_null_operators
            image: NetworkImage( user.profilePhoto == '' 
            ? photoProfile 
            : user.profilePhoto), fit: BoxFit.cover)
        ),
        ),
    );
  }
}

class _NavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: MyStyles().gradientHorizontal),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Crear usuraio',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Icon(Icons.navigate_next_rounded, color: Colors.white, size: 35),
            ],
          ),
      ),
    );
  }
}

class _ComoSoy extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

  final user = Provider.of<ProfileServices>(context).tempUser;

   
    return Container(
      width: 300,
      height: 75,
      child: Column(
        children: [
        
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Timido',
                style: MyStyles().subtitleStyle,
              ),
              Text(
                'Lanzado',
                style: MyStyles().subtitleStyle,
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
               const Text('0'),
                Expanded(
                  child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackShape: const GradientRectSliderTrackShape(),
                      ),
                      child: Slider(
                        activeColor: MyStyles().colorRojo,
                        inactiveColor: Colors.grey.shade300,
                        label: '${user.howAmI}',
                        min: 0,
                        max: 10,
                        value: user.howAmI.toDouble(),
                        onChanged: (double value) {
                  
                        },
                      )),
                ),
                Text(user.howAmI.toString()),
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}