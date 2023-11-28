import 'dart:developer';
import 'package:chat_app/config/routes/route.dart';
import 'package:chat_app/core/constants/key.dart';
import 'package:chat_app/features/authentication/presentation/bloc/cubit/otp_cubit_cubit.dart';
import 'package:chat_app/features/homepage/data/repository/searchnumber.dart';
import 'package:chat_app/features/homepage/presentation/cubit/cubit/homepage_cubit_cubit.dart';
import 'package:chat_app/features/homepage/presentation/ui/components/dialog.dart';
import 'package:chat_app/features/homepage/presentation/ui/components/options.dart';
import 'package:chat_app/features/homepage/presentation/ui/components/usercard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  final List? arg;
  const HomePage({super.key, this.arg});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool isSearch;
  late bool userIdAvailable;
  late String title;
  late String subTitle;
  late String image;
  String getNumber = '';
  String passNum = '';

  @override
  void initState() {
    super.initState();
    getNumber = checkUser();
    var readCubit = context.read<OtpCubitCubit>();
    readCubit.setPhoneNumber(getNumber);
    passNum = readCubit.number ?? '';
    if (widget.arg != null) {
      setState(() {
        isSearch = widget.arg?[0];

        userIdAvailable = widget.arg?[1];
        title = widget.arg?[2];
        subTitle = widget.arg?[3];
        image = widget.arg?[4] ?? '';
      });
    } else {
      isSearch = false;
      userIdAvailable = false;
      title = '';
      subTitle = '';
      image = '';
    }
  }

  String checkUser() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      String uid = user.uid;
      String phoneNum = user.phoneNumber ?? 'No email available';
      SearchNumber().getData(number: phoneNum);

      log('User is logged in with UID: $uid and Email: $phoneNum');
      return phoneNum;
    } else {
      log('No user is currently logged in.');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    log(isSearch.toString());
    log(userIdAvailable.toString());
    log(title);
    log(subTitle);
    log(image);
    if (image.contains('File:')) {
      image = image.replaceAll("File: ''", "");
      log(image);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade500,
        leading: IconButton(
            onPressed: () {
              navigatorKey.currentState?.pushReplacementNamed(Routes.homeScreen,
                  arguments: [false, false, '', '', '']);
            },
            icon: const Icon(Icons.home)),
        title: const Text('Chat App'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          MenuWidget(number: passNum),
        ],
        elevation: 0.8,
      ),
      body: BlocBuilder<HomepageCubitCubit, HomepageCubitState>(
          builder: (context, state) {
        if (state is HomepageLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return (isSearch)
            ? (userIdAvailable)
                ? ListView.builder(
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return UserCard(
                        file: image,
                        title: title,
                        subtitle: subTitle,
                      );
                    },
                  )
                : const Center(
                    child: Text('No User Found'),
                  )
            : StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .limit(5)
                    .snapshots(),
                builder: (context, snapshot) {
                  log(snapshot.data?.docs.toString() ?? '');
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('No data available'),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    padding: const EdgeInsets.only(top: 10),
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      var userData = snapshot.data!.docs[index].data();

                      var title = userData['name'] ?? '';
                      var subtitle = userData['number'] ?? '';
                      // Replace 'image' with the field name in your Firestore document
                      var image = userData['photo'] ?? '';
                      if (image.contains('File:')) {
                        image = image.replaceAll("File: ''", "");
                        log(image);
                      }
                      var date = userData['date'] ?? '';
                      return UserCard(
                        date: date,
                        subtitle: subtitle,
                        title: title,
                        file: image,
                      );
                    },
                  );
                });
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          displayDialogBox(context);
        },
        backgroundColor: Colors.green.shade500,
        child: const Icon(Icons.phone),
      ),
    );
  }
}
