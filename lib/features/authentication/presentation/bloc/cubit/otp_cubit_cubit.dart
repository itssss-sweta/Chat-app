import 'package:bloc/bloc.dart';

part 'otp_cubit_state.dart';

class OtpCubitCubit extends Cubit<OtpCubitState> {
  OtpCubitCubit() : super(OtpCubitInitial());

  Future getOtp() async {
    emit(OtpLoadingState());

    emit(OtpCubitInitial());
  }
}
