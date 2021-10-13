import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/modules/business_screen/business.dart';
import 'package:news_app/modules/science_screen/science.dart';
import 'package:news_app/modules/sports_screen/sports.dart';
import 'package:news_app/shared/network/remote/dio_helper.dart';
import 'package:news_app/shared/news_cubit/states.dart';

class NewsCubit extends Cubit<States> {
  NewsCubit() : super(InitialState());

  static NewsCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  void changeCurrentIndex(int index) {
    currentIndex = index;
    emit(ChangeNavBarState());
  }

  List<Widget> newsScreens = [Business(), Sports(), Science()];

  List<dynamic> businessData = [];
  void getBusinessData() async {
    emit(GetBusinessDataLoadingState());
    await DioHelper.getData(url: 'v2/top-headlines', query: {
      'country': 'eg',
      'category': 'business',
      'apiKey': 'a8680b71f3164c0cac163bfe5b9d9ad9'
    }).then((value) {
      businessData = value.data['articles'];
      print(businessData[0]['title']);
      emit(GetBusinessDataSuccessState());
    }).catchError((error) {
      emit(GetBusinessDataErrorState());
      print(error.toString());
    });
  }

  List<dynamic> sportsData = [];
  void getSportsData() async {
    emit(GetSportsDataLoadingState());
    await DioHelper.getData(url: 'v2/top-headlines', query: {
      'country': 'eg',
      'category': 'sports',
      'apiKey': 'a8680b71f3164c0cac163bfe5b9d9ad9'
    }).then((value) {
      sportsData = value.data['articles'];
      print(sportsData[0]['title']);
      emit(GetSportsDataSuccessState());
    }).catchError((error) {
      emit(GetSportsDataErrorState());
      print(error.toString());
    });
  }

  List<dynamic> scienceData = [];
  void getScienceData() async {
    emit(GetScienceDataLoadingState());
    await DioHelper.getData(url: 'v2/top-headlines', query: {
      'country': 'eg',
      'category': 'science',
      'apiKey': 'a8680b71f3164c0cac163bfe5b9d9ad9'
    }).then((value) {
      scienceData = value.data['articles'];
      print(scienceData[0]['title']);
      emit(GetScienceDataErrorState());
    }).catchError((error) {
      emit(GetScienceDataErrorState());
      print(error.toString());
    });
  }

  List<dynamic> searchData = [];

  void getSearchData(String word) async {
    emit(GetSearchDataLoadingState());
    await DioHelper.getData(
            url: 'v2/everything',
            query: {'q': word,  'apiKey': 'a8680b71f3164c0cac163bfe5b9d9ad9'})
        .then((value) {
      searchData = value.data['articles'];
      print(searchData[0]['title']);
      emit(GetSearchDataErrorState());
    }).catchError((error) {
      emit(GetSearchDataErrorState());
      print(error.toString());
    });
  }
}
