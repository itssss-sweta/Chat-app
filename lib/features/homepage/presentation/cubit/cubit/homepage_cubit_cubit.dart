import 'package:bloc/bloc.dart';
import 'package:chat_app/config/routes/route.dart';
import 'package:chat_app/core/constants/key.dart';
import 'package:chat_app/features/homepage/data/model/person_model.dart';
import 'package:chat_app/features/homepage/data/repository/searchnumer.dart';
import 'package:flutter/material.dart';

part 'homepage_cubit_state.dart';

class HomepageCubitCubit extends Cubit<HomepageCubitState> {
  HomepageCubitCubit() : super(HomepageCubitInitial());

  PersonalDetailModel? personalDetailModel;

  Future<void> searchNumber() async {
    emit(HomepageLoadingState());

    final result = await SearchNumber().getData();
    personalDetailModel = personalDetailModelFromJson(result.toString());

    if (result != null) {
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        Routes.homeScreen2,

        //path conflict if Routes.homeScreen as navigating from same screen, so Routes.homeScreen2 created
        ModalRoute.withName('/'),
        arguments: [
          true,
          true,
          personalDetailModel?.name,
          personalDetailModel?.number
        ],
      );
    } else {
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        Routes.homeScreen2,

        //path conflict if Routes.homeScreen as navigating from same screen, so Routes.homeScreen2 created
        ModalRoute.withName('/'),
        arguments: [true, false, '', ''],
      );
    }
    emit(HomepageCubitInitial());
  }
}
