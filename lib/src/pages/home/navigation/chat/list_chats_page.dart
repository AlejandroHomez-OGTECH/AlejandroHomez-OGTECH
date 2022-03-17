import 'package:flutter/material.dart';
import 'package:icebreaking_app/src/models/models.dart';
import 'package:icebreaking_app/src/models/usuario.dart';
import 'package:icebreaking_app/src/pages/pages.dart';
import 'package:icebreaking_app/src/providers/providers.dart';
import 'package:icebreaking_app/src/services/services.dart';
import 'package:icebreaking_app/src/services/usuarios_services.dart';
import 'package:icebreaking_app/src/styles/styles.dart';
import 'package:icebreaking_app/src/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ListChatsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {   
    final profileServices = Provider.of<ProfileServices>(context);
    final chatServices = Provider.of<ChatServices>(context);

    return ChangeNotifierProvider(
      create: (_) => FormProfileProvider(profileServices.newUser),
      child: Scaffold(
        body: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: [
                    
                  _ListChat(),
                  _Header(),
                  
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Stack(
                      children: [
                        NavigationBarChat(),
                        _LogoICeBreaking(),
                      ],
                    ))
                      
                ],
              ),
            ),
      )
               
      );

  }
}

class _LogoICeBreaking extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Center(
         child: ShaderMask(
             blendMode: BlendMode.srcIn,
             shaderCallback: (rect) {
               return const LinearGradient(
                       colors: [Colors.white, Colors.white])
                   .createShader(rect);
             },
             child: Image.asset(
               'assets/logo_fondo_blanco.png',
               height: 53,
             ))
       ),
    );
  }
}

class _ListChat extends StatefulWidget {


  @override
  State<_ListChat> createState() => _ListChatState();
}

class _ListChatState extends State<_ListChat> {

  final usuarioServices = UsuariosService();
  List<Usuario> usuarios = [];

  @override
  void initState() {
    super.initState();
    _cargarUsuarios();
  }


List<Widget> lista(List<UserIce> userList) {

  List<Widget> lista = [];
  int contador = 0;
  late Usuario usuario;

  while (contador < userList.length) {
    
    for (var i = 0; i < usuarios.length; i++) {

        if (usuarios[i].idFirebase == userList[contador].id) {

          usuario = usuarios[i];
          var listItem = _ItemListChat(userList[contador], usuario);
          lista.add(listItem); 
          break;         
        }
    }
    
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
    final chatServices = Provider.of<ChatServices>(context);
    final profileServices = Provider.of<ProfileServices>(context);

   return FutureBuilder(
        future: chatServices.loadUserChat(profileServices.newUser.match!),
        builder: (BuildContext context, AsyncSnapshot<List<UserIce>> snapshot) { 

          if (snapshot.data == null) {
            return  Center(
                  child: CircularProgressIndicator(
                backgroundColor: MyStyles().colorAzul,
                color: MyStyles().colorRojo,
              )
            );
          } else if (snapshot.data!.isEmpty) {
            return  const Center(
                  child: Text('No has hecho match con ningun usuario')
            );
          }

        List<UserIce> users = snapshot.data!;
                
        return Container(
        margin:  EdgeInsets.only(top: size.height * 0.18),
        width: size.width,
        height: size.height * 0.7,
        child: RefreshIndicator(
          onRefresh: () => profileServices.loadUsersIceProfile(profileServices.newUser.email),
          child: StaggeredGridView.count(
                    padding: const EdgeInsets.all(10),
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 4,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    staggeredTiles: listStaggeredTile(users.length),
                    children: lista(users),
                      ),
               ),
             );
            }
        );

  }

    _cargarUsuarios() async {

     usuarios = await usuarioServices.getUsuarios();
     setState(() {});
    
  }
}

class _ItemListChat extends StatelessWidget {

  final Usuario usuario;
  final UserIce user;
  _ItemListChat(this.user, this.usuario);

  @override
  Widget build(BuildContext context) {

    final chatServices = Provider.of<ChatServices>(context);
    final chatServicesPara = Provider.of<ChatServicePara>(context);
    final socketService = Provider.of<SocketService>(context);
    final profileService = Provider.of<ProfileServices>(context);
    final size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () async {
        
        chatServicesPara.usuarioPara = usuario;
        chatServices.userChatSelected = user;
        Navigator.push(context,RutaPersonalizada().rutaPersonalizadaScale(ChatSelected()));

      },
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: user.profilePhoto.isEmpty 
                ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Opacity(
                    opacity: 0.5,
                    child: Image.asset('assets/logo_fondo_blanco.png',)),
                )
                : ClipRRect(
                  borderRadius:const BorderRadius.all(Radius.circular(20)),
                  child: FadeInImage(
                      placeholder: const AssetImage('assets/loading.gif'), 
                      image: NetworkImage(user.profilePhoto),
                      fit: BoxFit.cover,)
                  )
          ),      
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                  Colors.black87,
                  Colors.transparent,
                  Colors.black87
                ]),
                borderRadius: BorderRadius.all(Radius.circular(20))
              ),
    
            child: Column(
              children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 5,
                        child: Icon(
                          Icons.circle, 
                          color: usuario.online  
                                ? Colors.green : MyStyles().colorRojo , size: 10,)
                        ),
                      const SizedBox(width: 5),

                      SizedBox(
                        width: 125,
                        child: Text(user.fullName, style: const TextStyle(color: Colors.white), 
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                    Icon(Icons.message_rounded, color: MyStyles().colorNaranja,),
                    SizedBox(
                      width: size.width * 0.3,
                      child: Text('Chat con ${usuario.nombre}', 
                      style: const TextStyle(color: Colors.white60, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      ))
                  ],)
              ],
            ),
            ),
        ],
      ),
    );
  }
}



class _Header extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

   final size = MediaQuery.of(context).size;

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
            top: size.height * 0.04,
            left: 20,
            child: Container(
              alignment: Alignment.centerLeft,
              width: size.width * 0.5,
              height: 80,
              child: const Center(
                child: Text('Tus Chats', style: 
                      TextStyle(color: Colors.white, fontSize: 30),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
              ))
            
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
        decoration: const BoxDecoration(
            shape: BoxShape.circle,
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              child:  formProvider.user.profilePhoto.isEmpty  
              ? Image.asset('assets/logo_fondo_blanco.png')
              : FadeInImage(
              placeholder: const AssetImage('assets/loading.gif'), 
              image: NetworkImage(formProvider.user.profilePhoto),
              fit: BoxFit.cover,
              height: 95,
              )
          )
      ),
    );
  }
}