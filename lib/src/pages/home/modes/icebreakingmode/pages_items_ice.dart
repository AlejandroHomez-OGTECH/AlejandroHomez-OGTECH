import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icebreaking_app/src/models/banderas.dart';
import 'package:icebreaking_app/src/models/models.dart';
import 'package:icebreaking_app/src/providers/formuser_provider.dart';
import 'package:icebreaking_app/src/services/newprofile_service.dart';
import 'package:icebreaking_app/src/services/services.dart';
import 'package:icebreaking_app/src/styles/styles.dart';
import 'package:provider/provider.dart';

class PagesItemsIce extends StatefulWidget {
  @override
  State<PagesItemsIce> createState() => _PagesItemsState();
}

class _PagesItemsState extends State<PagesItemsIce> {

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

  final profileServices = Provider.of<ProfileServices>(context);

    return ChangeNotifierProvider(
      create: (_) => FormProfileProvider(profileServices.tempUser),
      child: SizedBox(
        width: size.width,
        height: size.height * 0.52,
        child: PageView(
          controller: profileServices.pageController,
          scrollDirection: Axis.horizontal,
          onPageChanged: (page) {
            setState(() {
              
            profileServices.setItemSeleccionado = page.toDouble();
            });
          },
          children: [
            _PhotosPage(),
            _BioPage(),
            _OtherPage(),
            _RedesPage()
          ],
        ),
      ),
    );
  }
}

class _PhotosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<ProfileServices>(context).tempUser;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: StaggeredGridView.count(
        padding: const EdgeInsets.all(2),
        physics:
            const BouncingScrollPhysics(parent: NeverScrollableScrollPhysics()),
        shrinkWrap: true,
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        staggeredTiles: const [
          StaggeredTile.count(3, 1),
          StaggeredTile.count(1, 1),
          StaggeredTile.count(1, 1.5),
          StaggeredTile.count(2, 2),
          StaggeredTile.count(1, 2),
          StaggeredTile.count(1, 2),
          StaggeredTile.count(2, 1.5),
          StaggeredTile.count(1, 1.5),
        ],
        children: [
          _FotoMyPictures(user, 0),
          _FotoMyPictures(user, 1),
          _FotoMyPictures(user, 2),
          _FotoMyPictures(user, 3),
          _FotoMyPictures(user, 4),
          _FotoMyPictures(user, 5),
          _FotoMyPictures(user, 6),
          _FotoMyPictures(user, 7),
        ],
      ),
    );
  }

  Container _FotoMyPictures(UserIce user, int index) {
    int valor;

    valor = user.myPictures!.length - 1;

    return Container(
      decoration: const BoxDecoration( borderRadius: BorderRadius.all(Radius.circular(15))),
      child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: user.myPictures!.isEmpty || index > valor
              ? Container(
                padding: const EdgeInsets.all(10),
                color: Colors.grey.shade200,
                child: Opacity( opacity: 0.2, child: Image.asset('assets/logo_fondo_blanco.png')))
              : FadeInImage(
                  placeholder: const AssetImage('assets/loading.gif'),
                  image: NetworkImage(user.myPictures![index]),
                  fit: BoxFit.cover,
                )),
    );
  }
}

class _BioPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<ProfileServices>(context).tempUser;

    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          const Text('Acerca de mi', style: TextStyle(color: Colors.black38, fontSize: 25)),
          const SizedBox(height: 10),
          Text(user.biography! == '' ? 'Aun no hay una descripción' : user.biography! , textAlign: TextAlign.justify),

          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 10),


           const Center(child: Text('Genero', style: TextStyle(color: Colors.black45, fontSize: 30))),
            const SizedBox(height: 10),
           Center(child: Text( user.gender == 0 ? 'Hombre' : 
              user.gender == 1 
              ? 'Mujer'
              : 'No binario' , textAlign: TextAlign.justify)),

           
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 10),

           const Center(child: Text('Me interesan', style: TextStyle(color: Colors.black45, fontSize: 30))),
            const SizedBox(height: 10),
           Center(child: Text( user.interest, textAlign: TextAlign.justify))

        ],
      )
    );
  }


  String convertirFecha(Timestamp fecha) {
  
    List<String> meses = ['Enero' , 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto' , 'Septiembre', 'Octubre' , 'Noviembre', 'Diciembre'];

    int dia = fecha.toDate().day;
    int mes = fecha.toDate().month;
    int year = fecha.toDate().year;

    String mesString = '';

    for (var i = 0; i < meses.length; i++) {
      if ((mes - 1) == i ) {
        mesString =  meses[i];
      }
    }

    return '$dia de $mesString de $year';
  }
}

class _OtherPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    final user = Provider.of<ProfileServices>(context).tempUser;
    final newProfileService = Provider.of<NewProfileServices>(context);
    
    final size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
   
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment:user.ancestry != ''? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  const Text('Que busco',
                      style: TextStyle(color: Colors.black45, fontSize: 30)),
                  Text(user.youSearch, textAlign: TextAlign.justify),
                ],
              ),

              user.ancestry != ''

              ? Column(
                children: [
                  const Text('Ascendencia',
                      style: TextStyle(color: Colors.black45, fontSize: 30)),
                  Text('${user.ancestry}', textAlign: TextAlign.justify),
                ],
              )
              : Container()
          
            ],
          ),

          
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 10),


          const Text('Idiomas que manejo', style: TextStyle(color: Colors.black45, fontSize: 30)), 
          const SizedBox(height: 5),

          AnimatedContainer(
            duration: const Duration(seconds: 1),
            width: double.infinity,
            height:size.height * 0.3,
            child: user.languages!.isEmpty
                ? ZoomIn(
                    child: Center(
                        child: Text(
                    'Aun no tienes idiomas',
                    style: MyStyles().subtitleStyle1,
                  )))
                : GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: user.languages!.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 3 / 1,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 5),
                    itemBuilder: (context, index) {

                      return FutureBuilder(
                        future: newProfileService.loadIdiomas(user.languages!),
                        builder: (BuildContext context, AsyncSnapshot<List<Bandera>> snapshot) {  

                          if (snapshot.data == null) {
                            return const Center(child:  Text('Cargando...'));
                          }

                          List<Bandera> listaBanderas = snapshot.data!;

                            return ItemMisIdiomas(
                            index: index,
                            bandera: listaBanderas[index]);
                        },
                     
                      );
                    }),
          ),
        ],
      ),
    );
  }
}

class ItemMisIdiomas extends StatelessWidget {
  final int index;
  final Bandera bandera;

  ItemMisIdiomas({required this.index, required this.bandera});

  @override
  Widget build(BuildContext context) {

    return FadeInUp(
      from: 5,
      child: AnimatedContainer(
        margin: const EdgeInsets.symmetric(vertical: 5),
        height: 50,
        duration: const Duration(milliseconds: 100),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            borderRadius:  BorderRadius.all(Radius.circular(20)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 10)
            ]
        ),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              width: 30,
              child: FadeInImage(
                placeholder: const AssetImage('assets/loading.gif'),
                image: NetworkImage(bandera.bandera),
              ),
            ),
            Text(bandera.idioma, style: const TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }
}

class _RedesPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<ProfileServices>(context).tempUser;

    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [

          const SizedBox(height: 30),


        user.socialNetworks![0] != ''
          //Facebook
          ? Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10), 
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 10)
            ]
          ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(FontAwesomeIcons.facebook, color: Colors.blue),
                const SizedBox(width: 5),
                Text(user.socialNetworks!.isEmpty ? '' : user.socialNetworks![0])
              ],
            ),
          )
          : Container(),

          const SizedBox(height: 10),

        user.socialNetworks![1] != ''
        //Instagram
          ?Container(
            padding: const EdgeInsets.all(10),
             margin: const EdgeInsets.all(10), 
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 10)
                ]
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(FontAwesomeIcons.instagram, color: Colors.red),
                const SizedBox(width: 5),
                Text(user.socialNetworks!.isEmpty ? '' : user.socialNetworks![1])
              ],
            ),
          )
          : Container(),

          const SizedBox(height: 10),

          //Twitter
        user.socialNetworks![2] != ''

          ?Container(
            padding: const EdgeInsets.all(10),
             margin: const EdgeInsets.all(10), 
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 10)
                ]
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(FontAwesomeIcons.twitter, color: Colors.blue),
                const SizedBox(width: 5),
                Text(user.socialNetworks!.isEmpty ? '' : user.socialNetworks![2])
              ],
            ),
          )
          : Container()


        ],
      ),
    );
  }
}