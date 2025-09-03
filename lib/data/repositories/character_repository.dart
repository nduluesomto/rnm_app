import 'package:hive/hive.dart';
import '../../models/character_model.dart';
import '../../models/paged_response.dart';
import '../api/rm_api_service.dart';
import '../storage/hive_boxes.dart';


class CharacterRepository {
  CharacterRepository(this._api);
  final RMApiService _api;
  final _cache = Hive.box(HiveBoxes.characters);


  Future<PagedResponse> getPage(int page, {bool preferCache = false}) async {
    final key = 'page_$page';


// 1) если есть кеш и preferCache=true — отдаем сразу
    if (preferCache && _cache.containsKey(key)) {
      final list = List<Map>.from(_cache.get(key) as List);
      final results = list.map((e) => Character.fromJson(Map<String, dynamic>.from(e))).toList();
      final next = _cache.get('next_$page') as int?;
      return PagedResponse(results, next);
    }


// 2) пробуем сеть, при ошибке — fallback к кешу
    try {
      final data = await _api.getCharactersPage(page);
      final results = (data['results'] as List)
          .map((e) => Character.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      final info = Map<String, dynamic>.from(data['info'] as Map);
      final nextUrl = info['next'] as String?;
      final nextPage = _extractPage(nextUrl);


// положим в кеш
//       _cache.put(key, results.map((e) => e.toJson()).toList());
      _cache.put('next_$page', nextPage);


      return PagedResponse(results, nextPage);
    } catch (_) {
      if (_cache.containsKey(key)) {
        final list = List<Map>.from(_cache.get(key) as List);
        final results = list.map((e) => Character.fromJson(Map<String, dynamic>.from(e))).toList();
        final next = _cache.get('next_$page') as int?;
        return PagedResponse(results, next);
      }
      rethrow;
    }
  }


  int? _extractPage(String? url) {
    if (url == null) return null;
    final uri = Uri.tryParse(url);
    final p = uri?.queryParameters['page'];
    return p == null ? null : int.tryParse(p);
  } }