import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:icebreaking_app/src/blocs/blocs.dart';
import 'package:icebreaking_app/src/providers/providers.dart';
import 'package:icebreaking_app/src/pages/pages.dart';
import 'package:icebreaking_app/src/models/models.dart';
import 'package:icebreaking_app/src/preferencias/preferencias_usuario.dart';
import 'package:icebreaking_app/src/services/services.dart';
import 'package:icebreaking_app/src/widgets/widgets.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'src/pages/Login/login_number.dart';

void main() async {

    
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp();
  final pref = PreferenciasUsurario();
  await pref.initPref();

  runApp( MultiBlocProvider(
        providers: [
          BlocProvider(  create: (context) => GpsBloc()),
          BlocProvider(  create: (context) => LocationBloc()),
          BlocProvider(  create: (context) => MapBloc(locationBloc: BlocProvider.of<LocationBloc>(context))),
        ],
        child: MyApp(),
      )
    );
} 

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthClass()),
        ChangeNotifierProvider(create: (context) => FormLoginProvider()),
        ChangeNotifierProvider(create: (context) => ProfileServices()),
        ChangeNotifierProvider(create: (context) => NewProfileServices()),
        ChangeNotifierProvider(create: (context) => OnBoardingProvider()),
        ChangeNotifierProvider(create: (context) => HomeProvider()),
        ChangeNotifierProvider(create: (context) => PlaceService()),
        ChangeNotifierProvider(create: (context) => PhonePageProvider()),
        ChangeNotifierProvider(create: (context) => MarkerProvider()),
        ChangeNotifierProvider(create: (context) => ChatServices()),
        ChangeNotifierProvider(create: (context) => SocketService()),
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => ChatServicePara()),
      ],

      child: MaterialApp(
        title: 'Material App',
        initialRoute: 'splash',
        routes: {
          'OnBoarding': (_) => OnBoardingPage(),

          'splash'    : (_) => Splash(),

          'login'     : (_) => LoginPage(),
          'createAcount': (_) => BodyHomeCrateAcount(),

          'home': (_) => HomePage(),

        },

        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
           Locale('en', 'US'), // English, no country code
           Locale('es', 'ES'), // Spanish, no country code
        ],
        scaffoldMessengerKey: NotificationsService.messagerKey,
        theme: ThemeData(fontFamily: 'Roboto'),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}