import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/models/actores_model.dart';

class PeliculasProvider {
  String _apikey = 'b9d7afefa1607df0a78acdce6f63e99b';
  String _uri = 'api.themoviedb.org';
  String _language = 'es-ES';
  int _popularesPage = 0;
  bool _cargando = false;

  List<Pelicula> _populares = new List();

  final _popularesStreamController =
      StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSikn =>
      _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream =>
      _popularesStreamController.stream;

  void disposeStreams() {
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decoderData = json.decode(resp.body);
    final peliculas = new Peliculas.fromJsonList(decoderData['results']);
    return peliculas.items;
  }

  Future<List<Pelicula>> getEncines() async {
    final url = Uri.https(_uri, '3/movie/now_playing', {
      'api_key': _apikey,
      'language': _language,
    });
    return await _procesarRespuesta(url);
  }

  Future<List<Pelicula>> getPopulares() async {
    if(_cargando) return [];
    _cargando = true;
    _popularesPage++;
    final url = Uri.https(_uri, '3/movie/popular', {
      'api_key': _apikey,
      'language': _language,
      'page': _popularesPage.toString()
    });
    final resp = await _procesarRespuesta(url);
    _populares.addAll(resp);
    popularesSikn(_populares);
    _cargando = false;
    return resp;
  }

  Future<List<Actor>> getCast(String peliId) async{
    final url = Uri.http(_uri, '3/movie/$peliId/credits',
    {
      'api_key': _apikey,
      'language': _language,
    });
    final resp = await http.get(url);
    final decodedData = json.decode( resp.body);
    final cast = new Cast.fromJsonList(decodedData['cast']);

    return cast.actores;
  }

   Future<List<Pelicula>> buscarPelicula( String query) async {
    final url = Uri.https(_uri, '3/search/movie', {
      'api_key': _apikey,
      'language': _language,
      'query' : query,
    });
    return await _procesarRespuesta(url);
  }
}
