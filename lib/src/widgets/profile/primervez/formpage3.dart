
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icebreaking_app/src/providers/formuser_provider.dart';
import 'package:icebreaking_app/src/services/profile_service.dart';
import 'package:icebreaking_app/src/styles/styles.dart';
import 'package:icebreaking_app/src/widgets/input_decorations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class FormPage3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final profileService = Provider.of<ProfileServices>(context);

    return Container(
      margin: const EdgeInsets.only(top: 25, left: 20, right: 20, bottom: 15),
      padding: const EdgeInsets.all(1.5),
      decoration:  BoxDecoration(
          gradient: MyStyles().gradientHorizontal,
          borderRadius: const BorderRadius.all(Radius.circular(15)),          
            ),
      width: double.infinity,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
        child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                  _Titulo(),
                  _ComoSoy()
    
              ],
            )),
      ),
    );
  }
}


class _Titulo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 155,
      child: Image.asset('assets/llamas.png', height: double.infinity),
    );
  }
}


class _ComoSoy extends StatefulWidget {

  @override
  State<_ComoSoy> createState() => _ComoSoyState();
}

class _ComoSoyState extends State<_ComoSoy> {

  double valorComosoy = 0.0;


  @override
  Widget build(BuildContext context) {

    final formProvider = Provider.of<FormProfileProvider>(context);

    return SizedBox(
      width: 300,
      height: 300,
      child: Column(
        children: [
          Text('¡Que tan Lanzado te consideras', style: MyStyles().titleNewProfileStyle,),
          const Spacer(),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Timido', style: MyStyles().subtitleStyle,),
              Text('Lanzado', style: MyStyles().subtitleStyle,),
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
                        label: '${valorComosoy.toInt()}',
                        min: 0,
                        max: 10,
                        value: valorComosoy,
                        onChanged: (double value) {
                          setState(() {
                            valorComosoy = value;
                            formProvider.updateHowAmI(value.toInt());
                          });
                        },
                      )),
                ),
                Text('${valorComosoy.toInt()}'),
                
              ],
            ),
          ),
           const Spacer(),

          _Edad(),


        ],
      ),
    );
  }
}



class _Edad extends StatefulWidget {
  @override
  State<_Edad> createState() => _EdadState();
}

class _EdadState extends State<_Edad> {


  TextEditingController _inputField = TextEditingController();

  final maximaFecha     =  DateTime.now().year - 18;
  final minimaFecha     =  DateTime.now().year - 98;
  String _fecha = "1 ene. 2000";
  String _edad  = "";
  

   Widget _crearFecha(BuildContext context) {

    return Column(
      children: [

        GestureDetector(
          onTap: () {
             FocusScope.of(context).requestFocus( FocusNode());
            _selectDate(context);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: InputDecorator(
              decoration: InputDecorationsProfile.decorationInput(
                context: context, 
                hinText: 'Fecha de nacimiento', 
                labelTex: ''
                ).copyWith(
                  enabledBorder:   UnderlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: MyStyles().colorAzul)
                    ),
                ),
                child: Center(child: Text(_fecha)) ,
              ),
          ),
        ),

  
      ],
    );
  }

  _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime(maximaFecha),
        firstDate: DateTime(minimaFecha),
        lastDate: DateTime(maximaFecha),
        locale: const Locale('es', 'ES'),
        builder: (context, child) {
          return Theme(
              data: ThemeData.light().copyWith(
                    primaryColor: MyStyles().colorRojo,
                    colorScheme: ColorScheme.light(primary:MyStyles().colorRojo),
                    buttonTheme:  ButtonThemeData(
                    colorScheme: ColorScheme.light(primary: MyStyles().colorAzul),
                    buttonColor: MyStyles().colorAzul,
                    textTheme: ButtonTextTheme.accent,
                  ),
              ),
          child: child!,
          )
        }     
        );

    if (picked != null) {
      setState(() {

      final formProvider = Provider.of<FormProfileProvider>(context, listen: false);

          formProvider.updateDateOfBirthday(Timestamp.fromDate(picked));

          Intl.defaultLocale = 'es';
         _fecha = DateFormat.yMMMd().format(picked);
         _edad = (DateTime.now().year - picked.year ).toString();
        // _fecha = picked.toString();
        _inputField.text = _fecha;
      });
    }
  }

  @override
  Widget build(BuildContext context) {


    return Column(
      children: [
        Text('Fecha de nacimiento', style: MyStyles().titleNewProfileStyle),
        const SizedBox(height: 10),
        _crearFecha(context),
      ],
    );
  }

 

}


