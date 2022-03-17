import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:icebreaking_app/src/models/models.dart';
import 'package:icebreaking_app/src/pages/home/modes/icebreakingmode/profile_page_icebreking.dart';
import 'package:icebreaking_app/src/pages/pages.dart';
import 'package:icebreaking_app/src/providers/providers.dart';
import 'package:icebreaking_app/src/services/services.dart';
import 'package:icebreaking_app/src/styles/styles.dart';
import 'package:icebreaking_app/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

class IgluSelected extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
   final profileServices = Provider.of<ProfileServices>(context);
    final placeService = Provider.of<PlaceService>(context);

    return ChangeNotifierProvider(
      create: (_) => FormProfileProvider(profileServices.newUser),
      child: Scaffold(
          body: RefreshIndicator(
            color: MyStyles().colorAzul,
            triggerMode: RefreshIndicatorTriggerMode.anywhere,
            onRefresh: () async {

              await placeService.reloadPlaceSelected();
              List<String> listUsersId = placeService.tempPlace.users!;
              await profileServices.loadUsersForPlace(listUsersId, profileServices.newUser.id!);

            },
            child: FutureBuilder(
              future: placeService.reloadPlaceSelected(),
              builder: (BuildContext context, AsyncSnapshot<Place> snapshot) { 

                if (snapshot.data == null) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: MyStyles().colorAzul,
                      color: MyStyles().colorRojo,
                    ),
                  );
                }

                  Place place = snapshot.data!;

                    return  SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Stack(
                          children: [
                            
                      _ListChat(place: place),
                      
                      _Header(),
                      
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: SizedBox(
                          width: 500,
                          height: 80,
                          child: NavigationBarIcBreaking(RutaPersonalizada().rutaPersonalizada(PlacesIcebreaking())),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ),
    );
  }
}

class _Header extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
   final placeService = Provider.of<PlaceService>(context);


    return SizedBox(
      width: size.width,
      height: size.height * 0.25,
      child: Stack(
        children: [


          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: CustomPaint(
              painter: CustomIceBreakingMode(),
            ),
          ),
           Positioned(
            top: 35,
            left: 20,
            child: Container(
              alignment: Alignment.centerLeft,
              width: size.width * 0.47,
              height: 80,
              child: Text(placeService.tempPlace.name, style: 
              const TextStyle(color: Colors.white, fontSize: 30),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,))
            
            ),
      
          _SelfiePhoto(),


        ],
      ),
    );
  }
}

class _SelfiePhoto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final formProvider = Provider.of<FormProfileProvider>(context);

    return Positioned(
      top: 38,
      right: 12,
      child: Container(
        width: 95,
        height: 95,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                image: NetworkImage(formProvider.user.selfiePhoto!),
                fit: BoxFit.cover)),
      ),
    );
  }
}

class _ListChat extends StatelessWidget {

  final Place place;

  const _ListChat({Key? key, required this.place}) : super(key: key);

List<Widget> lista(List<UserIce> userList) {

  List<Widget> lista = [];
  int contador = 0;

  while (contador < userList.length) {
      
    var listItem = ItemUserInIglu(user: userList[contador]);
    lista.add(listItem);
    contador++;

  }
    return lista;
  }

List<StaggeredTile> listStaggeredTile(int value) {
  
  List<StaggeredTile> list = [];
  int contador = 0;

  while (contador < value) {

    bool par = contador % 2 == 0;  

    if (par) {
        var item = const StaggeredTile.count(2, 1.5);
        list.add(item);
        contador++;
    } else {
        var item = const StaggeredTile.count(2, 3);
        list.add(item);
        contador++;
    }
     
  }
  return list;
  }


  @override
  Widget build(BuildContext context) {
    
    final size  = MediaQuery.of(context).size;

    final profileServices = Provider.of<ProfileServices>(context);

    return  FutureBuilder(
      future: profileServices.loadUsersForPlace(place.users!, profileServices.newUser.id!),          
      builder: (BuildContext context, AsyncSnapshot<List<UserIce>> snapshot) {  


        if (snapshot.data == null) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: MyStyles().colorAzul,
              color: MyStyles().colorRojo,
            ),
          );
        }

      List<UserIce> listUsersThisIce = snapshot.data!; 

    return Container(
      margin:  EdgeInsets.only(top: size.height * 0.18),
      width: size.width,
      height: size.height * 0.7,
      child: StaggeredGridView.count(
                padding: const EdgeInsets.all(10),
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 4,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                staggeredTiles: listStaggeredTile(listUsersThisIce.length),
                children: lista(listUsersThisIce),
              )
        );    
      }
    );
  }
}

class ItemUserInIglu extends StatelessWidget {
  
  final UserIce user;
  ItemUserInIglu({required this.user});

  @override
  Widget build(BuildContext context) {

    final profileServices = Provider.of<ProfileServices>(context);

    return GestureDetector(
      onTap: () async {
        profileServices.setLikeProfile = user.likes;
        profileServices.setPrimeraEntrada = true;
        Navigator.push(context, RutaPersonalizada().rutaPersonalizada(ProfilePageIce(user.email)));
      },
      child: Container(
        width: 80,
        height: 150,
        decoration: BoxDecoration(
            color: user.selfiePhoto!.isNotEmpty ? Colors.white : Colors.grey.shade300,
            borderRadius: const BorderRadius.all(Radius.circular(20))   
         ),
         child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),   
                child: user.selfiePhoto!.isNotEmpty
                ? FadeInImage(
                  placeholder: const AssetImage('assets/loading.gif'),
                  image: NetworkImage(user.selfiePhoto!),  fit: BoxFit.cover,
                )
                : Image.asset('assets/logo_fondo_blanco.png', scale: 4)
              )  ,
      ),
    );
  }
}
