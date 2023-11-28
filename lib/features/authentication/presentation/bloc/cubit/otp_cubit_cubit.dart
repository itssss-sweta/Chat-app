import 'package:bloc/bloc.dart';
import 'package:chat_app/features/authentication/data/model/user_model.dart';
import 'package:chat_app/features/authentication/data/repository/filepicker.dart';

part 'otp_cubit_state.dart';

class OtpCubitCubit extends Cubit<OtpCubitState> {
  OtpCubitCubit() : super(OtpCubitInitial());

  UserModel? userModel;

  Future getOtp() async {
    emit(OtpLoadingState());

    emit(OtpCubitInitial());
  }

  String? number;
  void setPhoneNumber(String phone) {
    number = phone;
    emit(PhoneNumberState());
  }

  String? imagePath;
  void getImagePath() async {
    var result = await ImageUploadService.pickFile();
    imagePath = result;
    emit(ImagePickedState());
  }
}
