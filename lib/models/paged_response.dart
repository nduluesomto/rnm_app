import 'character_model.dart';

class PagedResponse {
  final List<Character> results;
  final int? nextPage; // null если нет следующей

  PagedResponse(this.results, this.nextPage);
}