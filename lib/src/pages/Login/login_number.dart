import 'dart:math';
import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icebreaking_app/src/models/models.dart';
import 'package:icebreaking_app/src/models/prefijos.dart';
import 'package:icebreaking_app/src/pages/pages.dart';
import 'package:icebreaking_app/src/providers/providers.dart';
import 'package:icebreaking_app/src/services/auth_service.dart';
import 'package:icebreaking_app/src/services/services.dart';
import 'package:icebreaking_app/src/styles/styles.dart';
import 'package:icebreaking_app/src/widgets/widgets.dart';


import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum MobileVerificationState {
  // ignore: constant_identifier_names
  SHOW_MOBILE_FORM_STATE,
  // ignore: constant_identifier_names
  SHOW_OTRP_FROM_STATE
}

class Login_phoneNumber extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    return BodyHome();
  
  }
}

class BodyHome extends StatefulWidget {

  @override
  State<BodyHome> createState() => _BodyHomeState();
}

class _BodyHomeState extends State<BodyHome> {

  MobileVerificationState currenState = MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  late String _verificationId;
  late int _resendToken;
  bool showLoading = false;

  
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

  void signInWithPhoneAuthCredential(PhoneAuthCredential phoneAuthCredential) async {

    setState(() {
      showLoading = true;
    });

    try {

      final authCredential = await _auth.signInWithCredential(phoneAuthCredential); 
    
      final TextEditingController emailController = TextEditingController();

      if (authCredential.user != null) {

         await _Dialog(emailController);
    
          } else {
            NotificationsService.showSnackBar(
                'El correo o la contraseña no son validos');        
      }


    } on FirebaseAuthException catch (e) {

      setState(() {
        showLoading = false;
      });

      _scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(e.message!)));
    }

  }

  Future<void> _Dialog(TextEditingController emailController) {
    return showDialog(
          context: context, 
          builder: (context) {

        final loginForm = Provider.of<FormLoginProvider>(context);
        final authService = Provider.of<AuthService>(context);


            return AlertDialog(
              content: TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecorations.decorationInput(
                  context: context, 
                  hinText: 'Email', 
                  labelTex: '' 
                ),
                onChanged: (value) {
                  _setEmail(value);

                  loginForm.email = value;

                },

                validator: (value) {

                  String pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

                  RegExp regExp = RegExp(pattern);

                  return regExp.hasMatch(value ?? '')
                      ? null
                      : 'Digite un correo electronico valido';
                },
              ),

              actions: [
                TextButton(
                  onPressed: ()  async {
                            
                      final loginForm = Provider.of<FormLoginProvider>(context, listen: false);
                      final newProfileServices = Provider.of<ProfileServices>(context, listen: false);
                      final socketService = Provider.of<SocketService>(context, listen: false);
                        
                      
                        bool verificacion = await newProfileServices.verificarPerfil(loginForm.email);

                        if (verificacion) {

                         await authService.login(emailController.text);
                         socketService.connect();

                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => HomePage()),
                              );

                        } else {
                          
                            newProfileServices.newUser = UserIce(
                                fullName: "",
                                gender: 0,
                                email: emailController.text,
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
                                phoneNumber: phoneController.text,
                                profession: '',
                                socialNetworks: ['','',''],
                                selfiePhoto: '',
                                myLikes: [],
                                likesMe: [],
                                online: false

                              );

                          await newProfileServices.loadUsersIceProfile(emailController.text);
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => NewProfilePage()),
                              );
                        }


                  }, child: const Text('Ingresar')
                ),

                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  }, child: const Text('cancelar')
                ),
              ],
            );
          });
  }

   getMobileFormWidgeti(context) {

    final phoneProvider = Provider.of<PhonePageProvider>(context);

    return SizedBox(
      width: double.infinity,
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          const Padding(
              padding: EdgeInsets.all(20),
              child: Text('Ingresa tu numero de celular',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold))
            ),

            Container(
              margin: const EdgeInsets.symmetric(vertical:20),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: 400,
              child: Row(
                children: [


                  GestureDetector(
                    onTap: () {

                      showDialog(
                        context: context, 
                        builder: (context) {
                          return AlertDialog(
                            contentPadding: const EdgeInsets.all(0),
                            title: const Text('Seleccione un Prefijo', textAlign: TextAlign.center,),

                            content: ListView.builder(
                              itemCount: listaPrefijos().length,
                              itemBuilder: (_, index) => _ItemPrefijos(listaPrefijos()[index])),
                          );
                        }
                      );
                      
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: Colors.white)
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 40,
                            child: SvgPicture.network(phoneProvider.prefijoSelected.bandera, height: 28,)),
                          const SizedBox(width: 5),
                          Text(phoneProvider.prefijoSelected.numeroPref, style: const TextStyle(color: Colors.white, fontSize: 20),)
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.phone,
                      controller: phoneController,
                      decoration: InputDecorations.decorationInput(
                        context: context,
                        labelTex: '',
                        iconData: Icons.phone,
                        hinText: "Número de telfono"
                      ).copyWith(
                        hintStyle: const TextStyle(fontSize: 14, color: Colors.white54)
                      ),
                    ),
                  ),


                ],
              ),
            ),

            FadeInUp(
            from: 10,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: MaterialButton(
                onPressed: () async {

                      FocusScope.of(context).unfocus();

                      setState(() {
                        showLoading = true;
                      });
                    
                      String phoneNumer = phoneProvider.prefijoSelected.numeroPref + phoneController.text;

                      await  _auth.verifyPhoneNumber(
                          phoneNumber: phoneNumer, 
                          verificationCompleted: (phoneCredential) async {
                              setState(() {
                                showLoading = false;
                              });
                              _auth.signInWithCredential(phoneCredential);
                            // signInWithPhoneAuthCredential(phoneCredential);
                          }, 
                          verificationFailed: (verificationFailed) async {
                         
                            _scaffoldKey.currentState!.showSnackBar(
                              SnackBar(content: Text(verificationFailed.message!))
                            );

                               setState(() {
                                showLoading = false;
                              });

                          }, 
                          codeSent: (verificationId, resendingToken) async {

                            int smsCode = Random().nextInt(8999) + 1000;

                            setState(() {
                                showLoading = false;
                                currenState = MobileVerificationState.SHOW_OTRP_FROM_STATE;
                                _verificationId =  verificationId;
                            });
                            //  PhoneAuthCredential credential =
                            //  PhoneAuthProvider.credential( verificationId: verificationId,
                            //     smsCode: smsCode.toString());

                            // await _auth.signInWithCredential(credential);

                          }, 
                          codeAutoRetrievalTimeout: (verificationId) async {

                          }
                          );

                      },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: MyStyles().colorRojo)),
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
                   const Expanded(
                        child: Text(
                      'Enviar',
                      style: TextStyle(
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    )),
                    Container(
                      alignment: Alignment.center,
                      height: 50,
                      decoration: BoxDecoration(
                          color: MyStyles().colorRojo,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 10),
                      child: Row(
                        children: const [
                           Text('Enviar Codigo', style:  TextStyle(color: Colors.white)),
                           SizedBox(width: 10),
                           Icon(
                            FontAwesomeIcons.arrowAltCircleRight,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )

        ],
      ),
    );
  }

   getOtpFormWidget(context) {
    
    return SizedBox(
      width: double.infinity,
      height: 350,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
              padding: EdgeInsets.all(20),
              child: Text('Ingresa el codigo enviado a tu celular',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold))),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              controller: otpController,
              decoration: InputDecorations.decorationInput(
                  context: context,
                  labelTex: '',
                  iconData: Icons.phone,
                  hinText: "Ingresa el codigo enviado"),
            ),
          ),
          FadeInUp(
            from: 10,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: MaterialButton(
                onPressed: () async {

                  FocusScope.of(context).unfocus();

                  PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
                    verificationId: _verificationId, 
                    smsCode: otpController.text
                  );

                  signInWithPhoneAuthCredential(phoneAuthCredential);


                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: MyStyles().colorRojo)),
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
                    const Expanded(
                        child: Text(
                      'Verificar',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    )),
                    Container(
                      alignment: Alignment.center,
                      height: 50,
                      decoration: BoxDecoration(
                          color: MyStyles().colorRojo,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 10),
                      child: Row(
                        children: const [
                          Text('Verificar codigo',
                              style: TextStyle(color: Colors.white)),
                          SizedBox(width: 10),
                          Icon(
                            FontAwesomeIcons.arrowAltCircleRight,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),


          SizedBox(
            width: double.infinity ,
            height: 50,
            child: TextButton(onPressed: () async {

              FocusScope.of(context).unfocus();

                  setState(() {
                    showLoading = true;
                  });

                  await _auth.verifyPhoneNumber(
                      phoneNumber: phoneController.text,
                      forceResendingToken: _resendToken,
                      verificationCompleted: (phoneCredential) async {
                        setState(() {
                          showLoading = false;
                        });
                            _auth.signInWithCredential(phoneCredential);

                      },
                      verificationFailed: (verificationFailed) async {
                        setState(() {
                          showLoading = false;
                        });
                        _scaffoldKey.currentState!.showSnackBar(SnackBar(
                            content: Text(verificationFailed.message!)));
                      },
                      codeSent: (verificationId, resendingToken) async {
                        setState(() {
                          showLoading = false;
                          currenState =
                              MobileVerificationState.SHOW_OTRP_FROM_STATE;
                          _verificationId = verificationId;
                        });
                      },
                      codeAutoRetrievalTimeout: (verificationId) async {});
            
            }, 
            
            child: const Text('Reenviar codigo', style: TextStyle(color: Colors.white),)),
          )
        ],
      ),
    );
  }

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();


  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
    key: _scaffoldKey,
    body: BackgroundLogin(
      child: Container(
        alignment: Alignment.center,
        height: size.height,
        child: Stack(
          children: [
            //Logo
            Positioned(top: 0, left: 0, right: 0, child: _LogoIceBreaking()),

            //Formulario
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Stack(
                children: [
                  SizedBox(
                    width: size.width,
                    height: size.height * 0.608,
                    child: ClipPath(
                      clipper: CustomLogin(),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                        child: Container(
                          width: 100,
                          height: 100,
                          color: Colors.black45,
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                const SizedBox(height: 50),

                                showLoading 
                                ? SizedBox(
                                  width: double.infinity,
                                  height: 300,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      backgroundColor:
                                                  MyStyles().colorAzul,
                                              color: MyStyles().colorRojo,
                                  )),
                                ) 
                                : currenState == MobileVerificationState.SHOW_MOBILE_FORM_STATE 
                                  ? getMobileFormWidgeti(context)
                                  : getOtpFormWidget(context)


                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  //
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class _ItemPrefijos extends StatefulWidget {

  final Prefijo prefijo;
  _ItemPrefijos(this.prefijo);

  @override
  State<_ItemPrefijos> createState() => _ItemPrefijosState();
}

class _ItemPrefijosState extends State<_ItemPrefijos> {
  @override
  Widget build(BuildContext context) {

    final phoneProvider = Provider.of<PhonePageProvider>(context);

    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        phoneProvider.setPrefijoSelected = widget.prefijo;
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        child: ListTile(
          leading: SvgPicture.network(widget.prefijo.bandera, height: 25),
          title: Text(widget.prefijo.pais),
          trailing: Text(widget.prefijo.numeroPref)
        )
       
      ),
    );
  }
}

class _LogoIceBreaking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        padding: const EdgeInsets.all(40),
        width: double.infinity,
        height: size.height * 0.456,
        decoration: const BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40))),
        child: Stack(
          children: [
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(45),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ZoomIn(
                  child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 80,
                      child: Image.asset(
                        'assets/logo_fondo_blanco.png',
                        height: 130,
                        fit: BoxFit.contain,
                      )),
                )),

            //Linea interior
            Spin(
              duration: const Duration(seconds: 2),
              spins: 1,
              child: SizedBox(
                width: double.infinity,
                child: CustomPaint(
                  size: Size.infinite,
                  painter: CustomLineLogo1(),
                ),
              ),
            ),

            //Linea Medio

            Spin(
              duration: const Duration(seconds: 2),
              spins: -1,
              child: SizedBox(
                width: double.infinity,
                child: CustomPaint(
                  size: Size.infinite,
                  painter: CustomLineLogo2(),
                ),
              ),
            ),

            //Linea Exterior

            Spin(
              duration: const Duration(seconds: 2),
              spins: 1,
              child: SizedBox(
                width: double.infinity,
                child: CustomPaint(
                  size: Size.infinite,
                  painter: CustomLineLogo3(),
                ),
              ),
            )
          ],
        ));
  }
}

class PhonePageProvider extends ChangeNotifier {

Prefijo _prefijoSelected = listaPrefijos()[0]; 

Prefijo get prefijoSelected => _prefijoSelected;
set setPrefijoSelected(Prefijo prefijo) {
  _prefijoSelected =  prefijo;
  notifyListeners();
}


}