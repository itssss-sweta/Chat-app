import 'dart:developer';
import 'package:chat_app/core/constants/edgeinset.dart';
import 'package:chat_app/core/constants/textstyle.dart';
import 'package:chat_app/core/utils/snackbar.dart';
import 'package:chat_app/features/authentication/data/repository/user_store.dart';
import 'package:chat_app/features/authentication/presentation/bloc/cubit/otp_cubit_cubit.dart';
import 'package:chat_app/features/authentication/presentation/ui/textfield.dart';
import 'package:chat_app/features/homepage/data/repository/searchnumber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditWidget extends StatefulWidget {
  final String? phone;
  final String? title;
  // final String? desc;

  const EditWidget({
    super.key,
    this.phone,
    this.title,
  });

  @override
  State<EditWidget> createState() => _EditWidgetState();
}

class _EditWidgetState extends State<EditWidget> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _number = TextEditingController();
  final TextEditingController _desc = TextEditingController();
  late String imagePath = '';
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    log(imagePath);
    imagePath = context.read<OtpCubitCubit>().imagePath ?? '';

    fetchExistingData();
  }

  void fetchExistingData() async {
    SearchNumberResult? searched =
        await SearchNumber().getData(number: widget.phone);
    if (searched?.userFound != null && searched?.userData != null) {
      if (searched?.userFound == true) {
        Map<String, dynamic> searchMap =
            searched?.userData as Map<String, dynamic>;
        log(searchMap.toString());

        _desc.text = searchMap["about"];
        _name.text = searchMap["name"];
        _number.text = searchMap["number"];
        imagePath = searchMap["photo"];
      }
    } else {
      log(widget.phone ?? '');
      _desc.text = '';
      _number.text = widget.phone ?? '';
      _name.text = '';
      imagePath = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    _number.text = widget.phone ?? '';
    var readCubit = context.read<OtpCubitCubit>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? ''),
        elevation: 0.4,
        backgroundColor: Colors.green.shade500,
        actions: [
          GestureDetector(
            onTap: () async {
              if (_key.currentState?.validate() ?? false) {
                StoreUserData()
                    .storeUserData(
                  bio: _desc.text,
                  name: _name.text,
                  number: _number.text,
                  photo: imagePath,
                )
                    .then((value) {
                  log(value);
                  displaySnackBar(color: Colors.green, content: value);
                });
              }
            },
            child: Align(
              child: Text(
                'Done',
                style: doneStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: smallPadding,
          child: Form(
            key: _key,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    readCubit.getImagePath();
                    var path = readCubit.imagePath;
                    log(readCubit.imagePath ?? '');
                    if (path != null && (path.isNotEmpty)) {
                      setState(() {
                        imagePath = path;
                      });
                    }
                  },
                  child: CircleAvatar(
                    maxRadius: 50,
                    backgroundColor: Colors.green.shade50,
                    child: ((imagePath.isNotEmpty) &&
                            !(imagePath.contains('File:')))
                        ? ClipOval(
                            child: Image.network(
                              imagePath,
                              width: 100,
                              height: 100,
                              fit: BoxFit.contain,
                              cacheHeight: 100,
                              cacheWidth: 100,
                              loadingBuilder: (BuildContext ctx, Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                                null &&
                                            loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (context, object, stackTrace) {
                                return const Icon(
                                  Icons.account_circle,
                                  size: 35,
                                );
                              },
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: 70,
                            color: Colors.grey.shade700,
                          ),
                  ),
                ),
                TextFieldRegister(
                  controller: _name,
                  hintText: 'Enter your Name',
                  title: 'Name',
                  type: TextInputType.name,
                  error: (value) {
                    if (value?.isEmpty ?? false) {
                      return 'Required Field';
                    }
                    return null;
                  },
                ),
                TextFieldRegister(
                  controller: _number,
                  hintText: 'Enter your number',
                  title: 'Phone Number',
                  readOnly: true,
                  type: TextInputType.phone,
                  error: (value) {
                    if (value?.isEmpty ?? false) {
                      return 'Required Field';
                    }
                    if ((value?.length)! < 10) {
                      return 'Please enter a 10 digit number';
                    }

                    return null;
                  },
                ),
                TextFieldRegister(
                  controller: _desc,
                  hintText: 'Write a bio',
                  title: 'About',
                  type: TextInputType.text,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
