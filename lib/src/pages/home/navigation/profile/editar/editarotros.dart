import 'dart:async';

import 'package:flutter/material.dart';
import 'package:icebreaking_app/src/models/models.dart';
import 'package:icebreaking_app/src/pages/pages.dart';
import 'package:icebreaking_app/src/providers/formuser_provider.dart';
import 'package:icebreaking_app/src/services/newprofile_service.dart';
import 'package:icebreaking_app/src/services/services.dart';
import 'package:icebreaking_app/src/styles/styles.dart';
import 'package:icebreaking_app/src/widgets/widgets.dart';

import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class EditaOtros extends StatelessWidget {
  const EditaOtros({Key? key}) : super(key: key);

   PageRouteBuilder<dynamic> _RutaEditar() {
    return PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secundaryAnimation) => EditarProfile(),
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secundatyAnimation, child) {
          final curvedAnimation =
              CurvedAnimation(parent: animation, curve: Curves.easeIn);

          return SlideTransition(
            position:
                Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero)
                    .animate(curvedAnimation),
            child: child,
          );
        });
  }

  @override
  Widget build(BuildContext context) {

    final profileServices = Provider.of<ProfileServices>(context);

    return ChangeNotifierProvider(
      create: (_) => FormProfileProvider(profileServices.newUser),
      child: Scaffold(
    
        appBar: AppBar(
          elevation: 1,
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          title: const Text('Editar otros'),
          leading: IconButton(
            onPressed:() => Navigator.pushReplacement(context, _RutaEditar()),
            icon: const Icon(Icons.arrow_back_ios_outlined)),
          actions: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: _BotonListo(),
            )
          ],
        ),
    
        body: Stack(
          children: [
            SingleChildScrollView(
              physics:  const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _EditarQueBusco(),
                  _EditarTelefono(),
                  _Profession(),
                  _EditarAscenendia(),
                  _EditarRedesSociales()
                ],
              ),
            ),
            // _BotonListo()

          ],
        ),
      ),
    );
  }
}



class _BotonListo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final profileServices = Provider.of<ProfileServices>(context);
    final formProvider = Provider.of<FormProfileProvider>(context);

    return GestureDetector(
      onTap: () {
        profileServices.setLoadUpdateIce = true;

        Timer(const Duration(seconds: 2), () {
          profileServices.updateUserIce(formProvider.user);
          profileServices.newUser = formProvider.user;
          profileServices.setLoadUpdateIce = false;
        });
      },
      child: AnimatedContainer(
          color: Colors.white,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutBack,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(right: 10),
          alignment: Alignment.center,
          height: 35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              profileServices.loadUpdateIce
                  ? Container(
                      margin: const EdgeInsets.only(right: 5),
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: MyStyles().colorRojo,
                        strokeWidth: 2,
                      ))
                  : const Icon(
                      Icons.check_circle,
                      color: Colors.greenAccent,
                      size: 22,
                    ),
              const SizedBox(width: 5),
              Text(profileServices.loadUpdateIce ? 'Guardando...' : 'Listo'),
            ],
          )),
    );
  }
}


class _EditarQueBusco extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Editar que busco', style: TextStyle(fontSize: 23)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            width: size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ItemQueBuso(index: 0, texto: 'Amistad'),
                _ItemQueBuso(index: 1, texto: 'Algo estable'),
                _ItemQueBuso(index: 2, texto: 'Pasar el rato'),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _ItemQueBuso extends StatelessWidget {
  final int index;
  final String texto;

  _ItemQueBuso({required this.index, required this.texto});

  @override
  Widget build(BuildContext context) {
    final newProfileService = Provider.of<NewProfileServices>(context);
    final formProvider = Provider.of<FormProfileProvider>(context);

    if (formProvider.user.youSearch == texto) {

      return FadeInDown(
        from: 5,
        child: AnimatedContainer(
          margin: const EdgeInsets.symmetric(vertical: 5),
          height: 50,
          duration: const Duration(milliseconds: 100),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              border: Border.all(
                  color: Colors.transparent),
              gradient: LinearGradient(colors: [
                MyStyles().colorAzul,
                 MyStyles().colorRojo
                    
              ])),
          child: Text(texto,
              style: const TextStyle(color: Colors.white)),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        newProfileService.setQueBuco = index;
        formProvider.updateYouSearch(texto);
      },
      child: AnimatedContainer(
        margin: const EdgeInsets.symmetric(vertical: 5),
        height: 50,
        duration: const Duration(milliseconds: 100),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            border: Border.all(
                color: Colors.black,
                width: 0.5),
            gradient: const LinearGradient(colors:  [
               Colors.white,
               Colors.white,
            ])),
        child: Text(texto,
            style: const TextStyle(  color:  Colors.black)),
      ),
    );
  }
}


class _EditarTelefono extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<ProfileServices>(context).newUser;
    final formProvider = Provider.of<FormProfileProvider>(context);

    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            const SizedBox(height: 5),

            //Nombre
            const Text('Editar telefono', style: TextStyle(fontSize: 23)),
            Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white,
                        Colors.grey.shade100,
                      ])),
              child: TextFormField(
                style: const TextStyle(
                    color: Colors.black, fontFamily: 'Roboto2', fontSize: 15),
                initialValue: user.phoneNumber,
                keyboardType: TextInputType.phone,
                cursorColor: MyStyles().colorRojo,
                autocorrect: false,
                decoration: InputDecorationEditar.decorationInput(
                    iconData: Icons.phone_android_rounded,
                    context: context,
                    hinText: '',
                    labelTex: ''),
                onChanged: (value) {
                  formProvider.updatePhoneNumer(value);
                },
                validator: (value) {
                  return (value != null && value.length >= 5)
                      ? null
                      : 'Ingrese un valor con mas de 5 caracteres';
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _Profession extends StatefulWidget {
  @override
  State<_Profession> createState() => _ProfesionState();
}

class _ProfesionState extends State<_Profession> {

  var items = [
    '',
    'A',
    'Abogado',
    'Académico',
    'Adjunto',
    'Administrador',
    'Administrativo',
    'Agrónomo',
    'Alergista',
    'Alergóloga',
    'Alergólogo',
    'Almacenera',
    'Almacenero',
    'Almacenista',
    'Anatomista',
    'Anestesióloga',
    'Anestesiólogo',
    'Anestesista',
    'Antologista',
    'Antropólogo',
    'Arabista',
    'Archivero',
    'Arqueólogo',
    'Arquitecto',
    'Asesor',
    'Asistente',
    'Astrofísico',
    'Astrólogo',
    'Astrónomo',
    'Atleta',
    'ATS',
    'Autor',
    'Auxiliar',
    'Avicultor',
    'B',
    'Bacteriólogo',
    'Bedel',
    'Bibliógrafo',
    'Bibliotecario',
    'Biofísico',
    'Biógrafo',
    'Biólogo',
    'Bioquímico',
    'Botánico',
    'C',
    'Cancerólogo',
    'Cardiólogo',
    'Cartógrafo',
    'Castrador',
    'Catedrático',
    'Cirujano',
    'Citólogo',
    'Climatólogo',
    'Codirector',
    'Comadrón',
    'Consejero',
    'Conserje',
    'Conservador',
    'Coordinador',
    'Cosmógrafo',
    'Cosmólogo',
    'Criminalista',
    'Cronólogo',
    'D',
    'Decano',
    'Decorador',
    'Defensor',
    'Delegado',
    'Delineante',
    'Demógrafo',
    'Dentista',
    'Dermatólogo',
    'Dibujante',
    'Directivo',
    'Director',
    'Dirigente',
    'Doctor',
    'Documentalista',
    'E',
    'Ecólogo',
    'Economista',
    'Educador',
    'Egiptólogo',
    'Endocrinólogo',
    'Enfermero',
    'Enólogo',
    'Entomólogo',
    'Epidemiólogo',
    'Especialista',
    'Espeleólogo',
    'Estadista',
    'Estadístico',
    'Etimóloga',
    'Etimologista',
    'Etimólogo',
    'Etnógrafo',
    'Etnólogo',
    'Etólogo',
    'Examinador',
    'F',
    'Facultativo',
    'Farmacéutico',
    'Farmacólogo',
    'Filólogo',
    'Filósofo',
    'Fiscal',
    'Físico',
    'Fisiólogo',
    'Fisioterapeuta',
    'Fonetista',
    'Foníatra',
    'Fonólogo',
    'Forense',
    'Fotógrafo',
    'Funcionario',
    'G',
    'Gemólogo',
    'Genetista',
    'Geobotánica',
    'Geodesta',
    'Geofísico',
    'Geógrafo',
    'Geólogo',
    'Geomántico',
    'Geómetra',
    'Geoquímica',
    'Gerente',
    'Geriatra',
    'Gerontólogo',
    'Gestor',
    'Grabador',
    'Graduado',
    'Grafólogo',
    'Gramático',
    'H',
    'Hematólogo',
    'Hepatólogo',
    'Hidrogeólogo',
    'Hidrógrafo',
    'Hidrólogo',
    'Higienista',
    'Hispanista',
    'Historiador',
    'Homeópata',
    'I',
    'Informático',
    'Ingeniero',
    'Inmunólogo',
    'Inspector',
    'Interino',
    'Interventor',
    'Investigador',
    'J',
    'Jardinero',
    'Jefe',
    'Juez',
    'L',
    'Latinista',
    'Lector',
    'Letrado',
    'Lexicógrafo',
    'Lexicólogo',
    'Licenciado',
    'Lingüista',
    'Logopeda',
    'M',
    'Maestro',
    'Matemático',
    'Matrón',
    'Medico',
    'Meteorólogo',
    'Micólogo',
    'Microbiológico',
    'Microcirujano',
    'Mimógrafo',
    'Mineralogista',
    'Monitor',
    'Musicólogo',
    'N',
    'Naturópata',
    'Nefrólogo',
    'Neumólogo',
    'Neuroanatomista',
    'Neurobiólogo',
    'Neurocirujano',
    'Neuroembriólogo',
    'Neurofisiólogo',
    'Neurólogo',
    'Nutrólogo',
    'O',
    'Oceanógrafo',
    'Odontólogo',
    'Oficial',
    'Oficinista',
    'Oftalmólogo',
    'Oncólogo',
    'Óptico',
    'Optometrista',
    'Ordenanza',
    'Orientador',
    'Ornitólogo',
    'Ortopédico',
    'Ortopedista',
    'Osteólogo',
    'Osteópata',
    'Otorrinolaringólogo',
    'P',
    'Paleobiólogo',
    'Paleobotánico',
    'Paleógrafo',
    'Paleólogo',
    'Paleontólogo',
    'Patólogo',
    'Pedagogo',
    'Pediatra',
    'Pedicuro',
    'Periodista',
    'Perito',
    'Piscicultor',
    'Podólogo',
    'Portero',
    'Prehistoriador',
    'Presidente',
    'Proctólogo',
    'Profesor',
    'Programador',
    'Protésico',
    'Proveedor',
    'Psicoanalista',
    'Psicofísico',
    'Psicólogo',
    'Psicopedagogo',
    'Psicoterapeuta',
    'Psiquiatra',
    'Publicista',
    'Publicitario',
    'Puericultor',
    'Q',
    'Químico',
    'Quiropráctico',
    'R',
    'Radioastrónomo',
    'Radiofonista',
    'Radiólogo',
    'Radiotécnico',
    'Radiotelefonista',
    'Radiotelegrafista',
    'Radioterapeuta',
    'Rector',
    'S',
    'Sanitario',
    'Secretario',
    'Sexólogo',
    'Sismólogo',
    'Sociólogo',
    'Subdelegado',
    'Subdirector',
    'Subsecretario',
    'T',
    'Técnico',
    'Telefonista',
    'Teólogo',
    'Terapeuta',
    'Tocoginecólogo',
    'Tocólogo',
    'Toxicólogo',
    'Traductor',
    'Transcriptor',
    'Traumatólogo',
    'Tutor',
    'U',
    'Urólogo',
    'V',
    'Veterinario',
    'Vicedecano',
    'Vicedirector',
    'Vicegerente',
    'Vicepresidente',
    'Vicerrector',
    'Vicesecretario',
    'Virólogo',
    'Viticultor',
    'Vulcanólogo',
    'X',
    'Xilógrafo',
    'YZ',
    'Zoólogo',
    'Zootécnico',
  ];
  String valoriniciarl = '';

  
  Iterable<DropdownMenuItem<String>> listamap() {
   var listaMap =  items.map((String items) {
                  return DropdownMenuItem(
                    alignment: Alignment.center,
                    value: items,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      alignment: items.length == 1 ? Alignment.center : null,
                      width: 150,
                      color: items.length == 1 ? Colors.red : Colors.transparent,
                      child: Text(items, style: TextStyle(color: items.length == 1 ? Colors.white : Colors.black),)),
                  );
                });

      return listaMap;
}
 
  @override
  Widget build(BuildContext context) {

    final profileSerices = Provider.of<ProfileServices>(context);
    final formProvider = Provider.of<FormProfileProvider>(context);


    // valoriniciarl = profileSerices.newUser.profession!;

    return  Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

           const Divider(),
           const SizedBox(height: 5),

           const Text('Editar Profesion', style: TextStyle(fontSize: 23)),

            Row(
              children: [
                Text('Tu profesion es: ', style: MyStyles().subtitleStyle1),
                Text(profileSerices.newUser.profession!, style: MyStyles().subtitleStyle,)

              ],
            ),

            Container(
              alignment: Alignment.center,
              width: double.infinity,
              
              child: Row(
                children: [

                 Text('¿Quieres cambiarla?: ', style: MyStyles().subtitleStyle1),

                  DropdownButton(
                    style: const TextStyle(fontFamily: 'Roboto2', color: Colors.black),
                    underline: Container(
                      height: 2,
                      color: MyStyles().colorRojo,
                    ),
                    value:  valoriniciarl,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: listamap().toList(),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    onChanged: (value) {
                      setState(() {
                        valoriniciarl = value.toString();
                        profileSerices.newUser.profession = value.toString();
                        formProvider.updateProfession(value.toString());
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  }
}



class _EditarAscenendia extends StatelessWidget {

  late String edad;

  String getEdad(UserIce user) {
    DateTime fecha = user.dateOfBirth.toDate();
    DateTime hoy = DateTime.now();

    edad = (hoy.year - fecha.year).toString();

    return edad;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<ProfileServices>(context).newUser;
    final formProvider = Provider.of<FormProfileProvider>(context);

    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            const SizedBox(height: 5),

            //Nombre
            const Text('Editar Ascendencia', style: TextStyle(fontSize: 23)),
            Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white,
                        Colors.grey.shade100,
                      ])),
              child: TextFormField(
                style: const TextStyle(
                    color: Colors.black, fontFamily: 'Roboto2', fontSize: 15),
                initialValue: user.ancestry,
                keyboardType: TextInputType.text,
                cursorColor: MyStyles().colorRojo,
                autocorrect: false,
                decoration: InputDecorationEditar.decorationInput(
                    iconData: Icons.account_tree_rounded,
                    context: context,
                    hinText: '',
                    labelTex: ''),
                onChanged: (value) {
                  formProvider.updateAncestry(value);
                },
                validator: (value) {
                  return (value != null && value.length >= 5)
                      ? null
                      : 'Ingrese un valor con mas de 5 caracteres';
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditarRedesSociales extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<ProfileServices>(context).newUser;
    final formProvider = Provider.of<FormProfileProvider>(context);

    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
            const Divider(),
            const SizedBox(height: 5),

            const Text('Editar Redes sociales', style: TextStyle(fontSize: 23)),
            const SizedBox(height:10),


            Row(
              children: [
                const Icon(Icons.facebook, size: 35, color: Colors.blue),
                const SizedBox(width: 5),
                Expanded(
                  child: Container(
                    decoration:   BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white,
                            Colors.grey.shade100,
                          ])),
                    child: TextFormField(
                    style: const TextStyle(
                        color: Colors.black, fontFamily: 'Roboto2', fontSize: 15),
                    initialValue: user.socialNetworks![0],
                    keyboardType: TextInputType.text,
                    cursorColor: MyStyles().colorRojo,
                    autocorrect: false,
                    decoration: InputDecorationEditar.decorationInput(
                        context: context,
                        hinText: '',
                        labelTex: ''),
                    onChanged: (value) {
                      formProvider.updateSocialNetWorks(user.socialNetworks!);
                      user.socialNetworks![0] = value;
                      formProvider.user.socialNetworks![0] = value;
                    },
                    ),
                  ),
                ),

              ],
            ),


            Row(
              children: [
                Icon(FontAwesomeIcons.instagram, size: 35, color: MyStyles().colorRojo),
                const SizedBox(width: 5),
                Expanded(
                  child: Container(
                    decoration:   BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white,
                            Colors.grey.shade100,
                          ])),
                    child: TextFormField(
                    style: const TextStyle(
                        color: Colors.black, fontFamily: 'Roboto2', fontSize: 15),
                    initialValue: user.socialNetworks![1],
                    keyboardType: TextInputType.text,
                    cursorColor: MyStyles().colorRojo,
                    autocorrect: false,
                    decoration: InputDecorationEditar.decorationInput(
                        context: context,
                        hinText: '',
                        labelTex: ''),
                    onChanged: (value) {
                      formProvider.updateSocialNetWorks(user.socialNetworks!);
                      user.socialNetworks![1] = value;
                      formProvider.user.socialNetworks![1] = value;
                    },
         
                              ),
                  ),
                ),

              ],
            ),

            Row(
              children: [
                const Icon(FontAwesomeIcons.twitter, size: 35, color: Colors.blue),
                const SizedBox(width: 5),
                Expanded(
                  child: Container(
                    decoration:   BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white,
                            Colors.grey.shade100,
                          ])),
                    child: TextFormField(
                    style: const TextStyle(
                        color: Colors.black, fontFamily: 'Roboto2', fontSize: 15),
                    initialValue: user.socialNetworks![2],
                    keyboardType: TextInputType.text,
                    cursorColor: MyStyles().colorRojo,
                    autocorrect: false,
                    decoration: InputDecorationEditar.decorationInput(
                        context: context,
                        hinText: '',
                        labelTex: ''),
                    onChanged: (value) {
                      formProvider.updateSocialNetWorks(user.socialNetworks!);
                      user.socialNetworks![2] = value;
                      formProvider.user.socialNetworks![2] = value;
                    },
                              ),
                  ),
                ),

              ],
            ),
            
            

        ],
      ),
    );
  }
}