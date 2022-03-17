import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icebreaking_app/src/blocs/blocs.dart';
import 'package:icebreaking_app/src/pages/home/modes/icebreakingmode/maps_screen.dart';
import 'package:icebreaking_app/src/styles/styles.dart';

class IceBreakingPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {


    return  BlocBuilder<GpsBloc, GpsState>(
      builder: (context, state) {
        return state.isAllGranted
        ? MapScreen()
        : GpsAccesScreen();
      },
    );
  }
}

class GpsAccesScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.only(bottom: 50),
      width: size.width,
      child:  Center(
        child: BlocBuilder< GpsBloc, GpsState>(
          builder: (context, state) {
            return !state.isGpsEnable
            ?  _EnableGpsMessage()
            :  _AccessButton();
          },
        )
        // _AccessButton(),
      ),
    );
  }
}

class _AccessButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       const Text('Es necesario el acceso a GPS'),

        MaterialButton(
          onPressed: () {

            final gpsBloc = BlocProvider.of<GpsBloc>(context);
            gpsBloc.askGpsAcces();

          },
          child: const Text('Solicitar acceso', style: TextStyle(color: Colors.white)),
          elevation: 0,
          shape: const StadiumBorder(),
          splashColor: Colors.transparent,
          color: MyStyles().colorRojo,
          )

      ],
    );
  }
}

class _EnableGpsMessage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return const Text('Debe habilitar el GPS');
  }
}
