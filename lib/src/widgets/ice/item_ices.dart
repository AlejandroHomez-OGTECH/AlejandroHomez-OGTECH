import 'package:flutter/material.dart';
import 'package:icebreaking_app/src/models/usericebreaking_model.dart';
import 'package:icebreaking_app/src/pages/home/modes/icebreakingmode/profile_page_icebreking.dart';
import 'package:icebreaking_app/src/services/services.dart';
import 'package:icebreaking_app/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ItemIceNavigation extends StatelessWidget {
  
   ItemIceNavigation({
    Key? key,
    required this.user,
  }) : super(key: key);

  final UserIce user;
  late String edad;

  @override
  Widget build(BuildContext context) {

    const borderRadius1 =  BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(20),
          bottomLeft: Radius.circular(0),
        );

      String getEdad() {
      DateTime fecha = user.dateOfBirth.toDate();
      DateTime hoy = DateTime.now();

      edad = (hoy.year - fecha.year).toString();

      return edad;
    }
    final profileServices = Provider.of<ProfileServices>(context);

    return GestureDetector(
      onTap: () async {
          profileServices.setLikeProfile = user.likes;
          profileServices.setPrimeraEntrada = true;
          Navigator.push(context,RutaPersonalizada().rutaPersonalizada(ProfilePageIce(user.email)));
      },
      child: Container(
        margin: const EdgeInsets.all(20) ,
        width: 300,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: borderRadius1
        ),
        child: Stack(
    
          children: [
    
            SizedBox(
              width: 300,
              height: 150,
              child: Hero(
                tag: user.id!,
                child: ClipRRect(
                      borderRadius: borderRadius1,
                      child: user.profilePhoto.isEmpty 
                        ? Image.asset('assets/logo_fondo_blanco.png')
                        : FadeInImage(
                          placeholder: const AssetImage('assets/loading.gif'), 
                          image: NetworkImage(user.profilePhoto),
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                          )
                        
                  ),
              ),
            ),
    
              Container(
                width: 300,
                height: 150,
                decoration: const BoxDecoration(
                  borderRadius: borderRadius1,
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black87,
                      Colors.black12
                    ]) ,              
                ),
    
                child: Row(
                  children: [
    
                    Container(
                      margin: const EdgeInsets.only(left: 5),
                      width: 110,
                      child: Text(user.fullName, 
                        style: const TextStyle(color: Colors.white, fontSize: 25),
                        maxLines: 1, 
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.right,
                        )
                    ),
                    SizedBox(
                      width: 50,
                      child: Text(', ' + getEdad(), 
                        style: const TextStyle(color: Colors.white, fontSize: 25)
                        )
                    ),
                    const Spacer(),
    
                    Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(5),
                      width: 100 ,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle
                      ),
                      child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(150)),
                          child: user.profilePhoto.isEmpty 
                            ? Image.asset('assets/logo_fondo_blanco.png')
                            : FadeInImage(
                              placeholder: const AssetImage('assets/loading.gif'), 
                              image: NetworkImage(user.profilePhoto),
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                        )
                      
                      ),
                    )
                  ],
                ),
    
              )
          ],
        )),
    );
  }
}
