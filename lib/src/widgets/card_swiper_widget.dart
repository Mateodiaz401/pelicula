import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
class CardSwipwer extends StatelessWidget {
  final List<Pelicula> peliculas;

  CardSwipwer({@required this.peliculas});

  @override
  Widget build(BuildContext context) {
    final _screnSize = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(top: 5.0),
      child: Swiper(
          layout: SwiperLayout.STACK,
          itemWidth: _screnSize.width * 0.7,
          itemHeight: _screnSize.height * 0.5,
          itemBuilder: (BuildContext context,int index){
            peliculas[index].uniqueId = '${peliculas[index].id}-targetas';
            return Hero(
              tag: peliculas[index].uniqueId,
                child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: GestureDetector (
                  onTap: ()=> Navigator.pushNamed(context, 'detalle', arguments: peliculas[index]),
                  child: FadeInImage(
                  image: NetworkImage(peliculas[index].getPosterImg()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  fit: BoxFit.cover,
                  ),
                )
              ),
            );
            
          },
          itemCount: peliculas.length,
         /* pagination: new SwiperPagination(),
          control: new SwiperControl(),*/
        ),
    );
  }
}