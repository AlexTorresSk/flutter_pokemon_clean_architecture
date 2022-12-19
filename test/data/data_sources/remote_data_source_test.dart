import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' show Response;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_pokemon_clean_architecture/src/core/errors/exceptions.dart';
import 'package:flutter_pokemon_clean_architecture/src/core/network/client_service.dart';
import 'package:flutter_pokemon_clean_architecture/src/data/data_sources/remote_data_source.dart';
import 'package:flutter_pokemon_clean_architecture/src/data/models/models.dart';

@GenerateNiceMocks([MockSpec<ClientService>()])
import 'remote_data_source_test.mocks.dart';

void main() async {
  late MockClientService mockClient;
  late RemoteDataSourceImpl remoteDataSourceImpl;

  TestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'assets/env/.env.test');

  setUp(() {
    mockClient = MockClientService();
    remoteDataSourceImpl = RemoteDataSourceImpl(client: mockClient);
  });

  group('getPokemonList', () {
    test('should return a list of PokemonModel', () async {
      when(mockClient.get(any)).thenAnswer(
        (_) async => Response(
          '{"results" : [{"name": "bulbasaur", "url": "https://pokeapi.co/api/v2/pokemon/1/"}]}',
          200,
        ),
      );

      final result = await remoteDataSourceImpl.getPokemonList(1, 0);

      expect(result, isA<List<PokemonModel>>());
    });

    test('should throw a ServerException when the response code is not 200',
        () async {
      when(mockClient.get(any)).thenAnswer((_) async => Response('', 404));

      final call = remoteDataSourceImpl.getPokemonList;

      expect(() => call(1, 0), throwsA(isA<ServerException>()));
    });
  });

  group('getPokemon', () {
    test('should return a list of PokemonModel', () async {
      when(mockClient.get(any)).thenAnswer(
        (_) async => Response(
          '{"name": "bulbasaur", "url": "https://pokeapi.co/api/v2/pokemon/1/"}',
          200,
        ),
      );

      final result = await remoteDataSourceImpl.getPokemon('bulbasaur');

      expect(result, isA<List<PokemonModel>>());
    });

    test('should throw a ServerException when the response code is not 200',
        () async {
      when(mockClient.get(any)).thenAnswer((_) async => Response('', 404));

      final call = remoteDataSourceImpl.getPokemon;

      expect(() => call('bulbasaur'), throwsA(isA<ServerException>()));
    });
  });
}
