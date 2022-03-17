import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:icebreaking_app/src/models/models.dart';
import 'package:icebreaking_app/src/pages/pages.dart';
import 'package:icebreaking_app/src/providers/providers.dart';
import 'package:icebreaking_app/src/services/auth_service.dart';
import 'package:icebreaking_app/src/services/services.dart';
import 'package:icebreaking_app/src/styles/styles.dart';
import 'package:icebreaking_app/src/widgets/widgets.dart';

import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


// ignore: use_key_in_widget_constructors
class FormLogin extends StatefulWidget {
  @override
  _FormLoginState createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {

  String _email = '';

  @override
  void initState() {
    _setEmail(_email);
    super.initState();
  }


   _setEmail(String valor) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('email', valor);
    _email = valor;
    setState(() {});
  }
  
  @override
  Widget build(BuildContext context) {

    final loginForm = Provider.of<FormLoginProvider>(context);
    final providerLogin = Provider.of<AuthClass>(context);
    final authServices = Provider.of<AuthService>(context);


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text('Iniciar sesion', style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold))
        ),
        Form(
            key: loginForm.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                //Input Correo Electronico
                FadeInUp(
                  from: 10,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                      style: const TextStyle(color: Colors.white),
                      cursorColor: MyStyles().colorRojo,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecorations.decorationInput(
                          context: context ,
                          hinText: 'ejemplo@gmail.com',
                          labelTex: 'Correo Electronico',
                          iconData: Icons.alternate_email),
                      onChanged: (value) {
                        loginForm.email = value;
                      },
                      validator: (value) {
                        //Validacion de correo electronico

                        String pattern =
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                      
                        RegExp regExp =  RegExp(pattern);
                      
                        return regExp.hasMatch(value ?? '')
                            ? null
                            : 'Digite un correo electronico valido';
                      },
                    ),
                  ),
                ),
        
                const SizedBox(height: 20),
        
                //Input contraseña
                FadeInUp(
                  from:10,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Stack(
                      children: [
                        TextFormField(
                          style: const TextStyle(color: Colors.white),
                          cursorColor: Colors.red,
                          autocorrect: false,
                          obscureText: loginForm.showPassword,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecorations.decorationInput(
                              context: context ,
                              hinText: '*******',
                              labelTex: 'Contraseña',
                              iconData: Icons.lock_outlined),
                          onChanged: (value) {
                            loginForm.password = value;
                          },
                          validator: (value) {

                            return (value != null && value.length >= 6)
                                ? null
                                : 'La contraseña es incorrecta';
                          },
                        ),
                        Positioned(
                            right: 15,
                            top: 15,
                            child: GestureDetector(
                              onTap: () {
                                loginForm.showPassWord();
                              },
                              child: Icon(
                                loginForm.showPassword
                                    ? Icons.remove_red_eye
                                    : Icons.remove_red_eye_outlined,
                                color: Colors.white54,
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
        
                const SizedBox(height: 10),

                GestureDetector(
                  onTap: () {
                    String email = loginForm.email;
                    providerLogin.resetPassword(email: email);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerRight,
                    width: double.infinity,
                    child: const Text('¿Olvidaste tu contraseña?' , style: TextStyle(color: Colors.white),)),
                ),
                const SizedBox(height: 20),
        
                //Boton de ingresar
        
                FadeInUp(
                  from: 10,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: MaterialButton(
                      onPressed: loginForm.isLoading
                          ? null
                          : () async {
                            
                              FocusScope.of(context).unfocus();
                        
                              final authService =Provider.of<AuthClass>(context, listen: false);
                        
                              if (!loginForm.isvalidForm()) return;
                        
                              loginForm.isLoading = true;
                        
                              final String? errorMessage = await authService.signIN(
                                  loginForm.email, loginForm.password);
                              
                              authService.nombreUsuario = loginForm.name;
                              authService.emailUsuario = loginForm.email;
                              authService.urlImageUsuario = "";

                               _setEmail(loginForm.email);

                              if (errorMessage == "") {

                             final newProfileServices = Provider.of<ProfileServices>(context, listen: false);
                             final socketService = Provider.of<SocketService>(context, listen: false);


                               bool verificacion = await newProfileServices.verificarPerfil(loginForm.email);

                                if (verificacion) {

                                  await authServices.login(loginForm.email);
                                  socketService.connect();
                              
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(builder: (context) => HomePage()),
                                      (route) => false);

                                } else {

                                  newProfileServices.newUser = UserIce(
                                        fullName: loginForm.name,
                                        gender: 0,
                                        email: loginForm.email,
                                        youSearch: 'Amistad',
                                        edadRangeDesde: 18,
                                        edadRangeHasta: 80,
                                        howAmI: 0,
                                        profilePhoto: '',
                                        dateOfBirth: Timestamp.fromDate( DateTime(2000, 01, 01)),
                                        interest: 'Hombres',
                                        likes: 0,
                                        ancestry: '',
                                        biography: '',
                                        languages: [],
                                        myPictures: [],
                                        phoneNumber: '',
                                        profession: '',
                                        socialNetworks: ['','',''],
                                        selfiePhoto: '',
                                        myLikes: [],
                                        likesMe: [],
                                        iceMe: [],
                                        myIces: [],
                                        match: [],
                                        online: false
                                      );

                                  newProfileServices.loadUsersIceProfile(loginForm.email);
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(builder: (context) => NewProfilePage()),
                                      (route) => false);
                                }                             

                                loginForm.isLoading = false;
                        
                              } else {
                                NotificationsService.showSnackBar(
                                    'El correo o la contraseña no son validos');
                                loginForm.isLoading = false;
                              }
                            },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: Colors.white)
                          ),
                      height: 50,
                      color: Colors.transparent,
                      elevation: 0,
                      focusElevation: 0,
                      hoverElevation: 0,
                      highlightElevation: 0,
                      disabledElevation: 0,
                      disabledColor: Colors.grey.shade200,
                      padding: const EdgeInsets.all(0),
                      child: Row(
                        children: [
                         Expanded(child: Text('Ingresar', style: TextStyle(color: loginForm.isLoading 
                         ? MyStyles().colorRojo
                         : Colors.white
                         ), textAlign: TextAlign.center,)
                        ),
                
                          Container(
                            alignment: Alignment.center,
                            height: 50,
                            decoration:  BoxDecoration(
                               gradient: MyStyles().gradientRedToOrange, 
                              borderRadius: const BorderRadius.all(Radius.circular(10))
                            ),
                            padding:  const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                            child: Row(
                              children: [
                                Text(loginForm.isLoading ? 'Espere...' : 'LOG IN',
                                    style: const TextStyle(color: Colors.white)),
                               const SizedBox(width: 10),
                                const Icon(FontAwesomeIcons.arrowAltCircleRight, color: Colors.white,)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )),
      ],
    );
  }
}