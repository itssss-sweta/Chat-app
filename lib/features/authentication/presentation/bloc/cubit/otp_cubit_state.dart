part of 'otp_cubit_cubit.dart';

sealed class OtpCubitState {}

final class OtpCubitInitial extends OtpCubitState {}

final class OtpLoadingState extends OtpCubitState {}
