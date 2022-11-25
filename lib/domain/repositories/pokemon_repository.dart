import 'package:dartz/dartz.dart';

import 'package:flutter_pokemon_clean_architecture/core/errors/failure.dart';
import 'package:flutter_pokemon_clean_architecture/domain/entities/pokemon.dart';

abstract class PokemonRepository {
  Future<Either<Failure, List<Pokemon>>> getPokemonList();
  Future<Either<Failure, Pokemon>> getPokemon(String name);
}
