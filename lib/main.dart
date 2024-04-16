// import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gastos_personales_app/firebase_options.dart';
import 'package:gastos_personales_app/graph_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control de gastos App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage()
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  PageController _controller = PageController();
  int currentPage = 9;

  @override
  void initState() { //Para el controller que cree en la línea 33 uso el initialState para deifnir que al inciiar la app se acomoda en la página 9 y que cada nombre de la PageView, que es la de los meses, va tomar el 40% del espacio horizontal
    super.initState();

    _controller = PageController(
      initialPage:  currentPage,
      viewportFraction: 0.4,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomAppBar( //Con esta propiedad y widget creamos la barra inferior de botones, esta es la opcion ideal cuando necesitramos crear una barra de botones así
          notchMargin: 8.0,
          shape: const CircularNotchedRectangle(),
          child: Row( //Pasamos una fila ya que asi arreglamos los multiples botones dentro de la BottonAppBar
            mainAxisAlignment: MainAxisAlignment.spaceBetween, //Para que se alineen entre si
            children: [
              _bottomAction(Icons.work_history),
              _bottomAction(Icons.pie_chart),
              const SizedBox(height: 40,), // Como tenemos un boton central, el floatingActionButton, si no podemos esta caja vacia va a quedar ese boton central muy junto respecto a los dos botones de la barra, por eso la agregamos, para que de espacio
              _bottomAction(Icons.wallet),
              _bottomAction(Icons.settings),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, //Esta propiedad es la que me permite meter el boton dentro de la barra de botones
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () {  },
          child: const Icon(Icons.add),
        ),
        body: _body(),
      );
  }

  Widget _bottomAction (IconData icon) {
  return InkWell(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Icon(icon),
    ),
    onTap: () {},
  );
  }

Widget _body() {
  return SafeArea(
    child: Column(
      children: [
        _selector(),
        _expenses(),
        _graphics(),
        Container(
          color: Colors.blueAccent.withOpacity(0.15),
          height:  24.0,
        ),
        _list(),
      ],));
}

Widget _selector() {
  return SizedBox(
    height: 70,
    child: PageView(
      onPageChanged: (newPage) { //IMPORTANTE: La propuedad onPageChanged es la que me permite acutalizar el currentPage y asi actualizar los estilos, cada que cambie el mes se cambia el color y el centrado, es esta propiedad la que me permite controlar o escuchar ese cambio
        setState(() {
          currentPage = newPage;
        });
      },
      controller: _controller, //Llamamos el controller desde aquí para se aplique el initialSatate a este Widget
      children: [
        _pageItem(name: 'Enero', position: 0),
        _pageItem(name: 'Febrero', position: 1),
        _pageItem(name: 'Marzo', position: 2),
        _pageItem(name: 'Abril', position: 3),
        _pageItem(name: 'Mayo', position: 4),
        _pageItem(name: 'Junio', position: 5),
        _pageItem(name: 'Julio', position: 6),
        _pageItem(name: 'Agosto', position: 7),
        _pageItem(name: 'Septiembre', position: 8),
        _pageItem(name: 'Octubre', position: 9),
        _pageItem(name: 'Noviembre', position: 10),
        _pageItem(name: 'Diciembre', position: 11),
      ],
    ),
  );
}

Widget _pageItem({required String name, required int position}){
  
  const selected = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.blueGrey,
  );

  final unselected = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.blueGrey.withOpacity(0.4)
  );
  
  var _alignment;

  if(position == currentPage){
    _alignment = Alignment.center;
  } else if (position > currentPage){
    _alignment = Alignment.centerRight;
  } else {
    _alignment = Alignment.centerLeft;
  }

  return Align(//Align es el widget que me ayuda a centrar el item activo y que los otros dos queden en los lados
    alignment: _alignment,
    child: Text(
      name, style: position == currentPage ? selected : unselected,
    )
  );
} 

Widget _expenses() {
  return const Column(
    children: [
      Text('\$21312,00', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
      Text('Total expenses', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey),)
    ],
  );
}

Widget _graphics() {
  return Container(
    height: 250,
    child: const GraphWidget());
}

Widget _list() {
  return Expanded(
    child: ListView.separated( //Importante: Este widget ListView junto con el ListTitle al agregar mucho elementos a la lista ya estan configurados para permitirme scrollear entre los elementos de la lista, con la opcion que teniamos antes con Colum y demás no podiamos scrollear, al agregar mucho elementos el diseño se dañaba, tener en cuenta.
      //Inicialmente teniamos el Widget ListView normal, con eso podiamos llamar muchas veces al widget _items y funcionaba bien, sin embargo los tarjetas salen juntas, y necesitamos que salgan con un espacio entre cada una,  por eso cambiamos a ListView.separated, esta forma ya no usal el child[], si no que recibe tres propiedades, el itemCount, la cantidad de tarjetas, el itemBuilder donde la funcion retorna el widget, y el separatorBuilder donde la función retorna la contruccion de un separador mediante un Container
      itemCount: 15,
      itemBuilder: (context, index) => _item(icon: Icons.shop, name: 'Shoping', percent: 14, value: 145.12,),
      separatorBuilder: (context, index) {
        return Container(
          color: Colors.blueAccent.withOpacity(0.15),
          height:  8.0,
        );
      },
    ),
  );
}

Widget _item ({required IconData icon, required String name, required int percent, required double value  }) {
  return ListTile( //Vemos como en comparacion con la solucion que propusimos abajo con ListTile el codigo se reduce demasiado y el resultado es el mismo. Este widget ListTitle es el que me permite construir la tarjeta
    leading: Icon(icon, size: 32.0,),
    title: Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
    subtitle: Text('$percent% of expenses', style: const TextStyle(fontSize: 16, color: Colors.blueGrey),),
    trailing: Container(
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.3),
        borderRadius: BorderRadius.circular(3.0)
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text('\$$value', style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),),
      )),
  );
}
}

//ESTA FUE MI SOLUCIÓN Y AUNQUE FUNCIONÓ TIENE DEMSIADAS LÍNEAS DE CODIGO, con ListView y ListTile se ahorran muuuuchas líneas, lo cual mejora la eficiencia del código y el mantenimiento.
// Widget _list() {
//   return const Column(
//     children:[ 
//       _item(icon: Icons.shop, text1: 'Shoping', text2: '14% of expenses', price: 145.12,),
//       // _elements(),
//   ]);
// }
// class _item extends StatelessWidget {

//   final IconData icon;
//   final String text1;
//   final String text2;
//   final double price; 

//   const _item({ required this.icon, required this.text1, required this.text2, required this.price});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 3),
//     child: Row(
//         children: [ 
//           Expanded(
//             child: Container(
//               color: Colors.white,
//               child: Row(
//                 children:[
//                   Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Icon(icon),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(text1, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, ),),
//                         Text(text2),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(width: 90,),
//                   Container(
//                     color: Colors.lightBlueAccent,
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(price.toString(), style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
//                     )),
//                 ]
//               )
//             )
//           ),
//         ]
//       ),
//   ); 
// }
// }
