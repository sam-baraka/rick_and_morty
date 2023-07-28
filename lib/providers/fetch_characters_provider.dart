import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rick_and_morty/models/characters/character.dart';
import 'package:rick_and_morty/providers/fetch_characters_state.dart';

final fetchCharactersProvider =
    StateNotifierProvider<FetchCharactersProvider, FetchCharactersState>(
        (ref) => FetchCharactersProvider(FetchCharactersState.initial())
          ..fetchCharacters());

class FetchCharactersProvider extends StateNotifier<FetchCharactersState> {
  FetchCharactersProvider(super.state);

  fetchCharacters() async {
    state = FetchCharactersState.fetching();
    try {
      Dio dio = Dio();
      var response =
          await dio.post('https://rickandmortyapi.com/graphql', data: {
        'query': r'''
              query {
              characters{
              results{
                id
                name
                image
                status
                }
              }
            }
      '''
      });
      List<dynamic> responseData =
          response.data['data']['characters']['results'];
      state = FetchCharactersState.fetched(
          responseData.map((e) => Character.fromJson(e)).toList());
    } on DioException catch (e) {
      state = FetchCharactersState.failed(e.message!);
    } catch (e) {
      state = FetchCharactersState.failed('Failed to fetch Characters');
    }
  }
}
