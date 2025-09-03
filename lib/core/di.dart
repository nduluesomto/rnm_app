import 'package:hive/hive.dart';
import '../data/api/rm_api_service.dart';
import '../data/repositories/character_repository.dart';
import '../data/storage/hive_boxes.dart';
import '../presentation/cubits/theme_cubit.dart';


class DI {
  DI(this.api, this.repo, this.themeCubit);
  final RMApiService api;
  final CharacterRepository repo;
  final ThemeCubit themeCubit;
}


Future<DI> initDI() async {
  final api = RMApiService();
  final repo = CharacterRepository(api);
  final themeCubit = ThemeCubit(Hive.box(HiveBoxes.settings));
  return DI(api, repo, themeCubit);
}


Future<void> initHiveBoxes() async {
  await Hive.openBox(HiveBoxes.characters); // pages cache
  await Hive.openBox(HiveBoxes.favorites); // set<int> ids
  await Hive.openBox(HiveBoxes.settings); // theme mode etc
}