import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/shared/bloc_observer.dart';
import 'package:news_app/shared/main_cubit/cubit.dart';
import 'package:news_app/shared/main_cubit/states.dart';
import 'package:news_app/shared/network/local/cache_helper.dart';
import 'package:news_app/shared/network/remote/dio_helper.dart';
import 'package:news_app/shared/news_cubit/cubit.dart';

import 'layout/news layout/news_layout.dart';

void main() async {
  // Ensure that initialization executed before running MyApp
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  Bloc.observer = MyBlocObserver();
  DioHelper.dioInit();
  await CacheHelper.init();
  runApp(MyApp());
}
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => NewsCubit()
            ..getBusinessData()
            ..getSportsData()
            ..getScienceData(),
        ),
        BlocProvider(create: (BuildContext context) => MainCubit()),
      ],
      child: BlocConsumer<MainCubit, States>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            darkTheme: ThemeData(
              textTheme: TextTheme(
                  bodyText1: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white70,
              ),),
              appBarTheme: AppBarTheme(
                iconTheme: IconThemeData(
                  color: Colors.white70,
                ),
                color: Colors.black,
                titleSpacing: 15,
                titleTextStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
                backwardsCompatibility: false,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.black,
                  statusBarIconBrightness: Brightness.light,
                ),
                elevation: 0,
              ),
              scaffoldBackgroundColor: Colors.black,
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  elevation: 0.0,
                  backgroundColor: Colors.black,
                  selectedItemColor: Colors.orange,
                  unselectedItemColor: Colors.white70,),

            ),
            theme: ThemeData(
              textTheme: TextTheme(
                  bodyText1: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              )),
              appBarTheme: AppBarTheme(
                titleSpacing: 15,
                iconTheme: IconThemeData(
                  color: Colors.black54,
                ),
                color: Colors.white,
                titleTextStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                backwardsCompatibility: false,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.white,
                  statusBarIconBrightness: Brightness.dark,
                ),
                elevation: 0,
              ),
              scaffoldBackgroundColor: Colors.white,
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                elevation: 0.0,
                backgroundColor: Colors.white,
                selectedItemColor: Colors.blue,
              ),
            ),
            themeMode: whichTheme(MainCubit.get(context).isDark),
            debugShowCheckedModeBanner: false,
            home: NewsHome(),
          );
        },
      ),
    );
  }

  ThemeMode whichTheme(bool? isDark) {
    if (isDark == null || isDark == false) {
      return ThemeMode.light;
    } else {
      return ThemeMode.dark;
    }
  }
}
