import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chat_app/config/routes/route.dart';
import 'package:chat_app/core/constants/key.dart';
import 'package:chat_app/features/homepage/data/repository/searchnumber.dart';
import 'package:flutter/material.dart';

part 'homepage_cubit_state.dart';

class HomepageCubitCubit extends Cubit<HomepageCubitState> {
  HomepageCubitCubit() : super(HomepageCubitInitial());

  // PersonalDetailModel? personalDetailModel;

  Future<void> searchNumber({String? number}) async {
    emit(HomepageLoadingState());

    final result = await SearchNumber().getData(number: number);
    log(result.toString());

    if (result != null && result.userData != null) {
      log(result.toString());
      Map<String, dynamic> resultMap = result.userData as Map<String, dynamic>;

      // personalDetailModel = personalDetailModelFromJson(result.toString());//the output i.e result is not in json format at all
      var num = resultMap['number'];
      var name = resultMap['name'];
      var image = resultMap['photo'];
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        Routes.homeScreen2,

        //path conflict if Routes.homeScreen as navigating from same screen, so Routes.homeScreen2 created
        ModalRoute.withName('/'),
        arguments: [true, true, name, num, image, ''],
      );
    } else {
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        Routes.homeScreen2,

        //path conflict if Routes.homeScreen as navigating from same screen, so Routes.homeScreen2 created
        ModalRoute.withName('/'),
        arguments: [true, false, '', '', '', ''],
      );
    }
    emit(HomepageCubitInitial());
  }
}
