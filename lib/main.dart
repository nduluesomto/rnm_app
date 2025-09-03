import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rnm_app/presentation/cubits/favorities_cubit.dart';
import 'models/character_model.dart';
import 'presentation/app_shell.dart';
import 'presentation/cubits/character_list_cubit.dart';
import 'presentation/cubits/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(CharacterAdapter());

  final charactersBox = await Hive.openBox<Character>('characters');
  final favoritesBox = await Hive.openBox<Character>('favorites');
  final settingsBox = await Hive.openBox('settings'); // для темы

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => ThemeCubit(settingsBox)),
      BlocProvider(create: (_) => CharacterListCubit(charactersBox)),
      BlocProvider(create: (_) => FavoritesCubit(favoritesBox)),
    ],
    child: const AppShell(),
  ));
}


