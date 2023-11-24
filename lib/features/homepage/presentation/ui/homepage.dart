import 'dart:developer';

import 'package:chat_app/config/routes/route.dart';
import 'package:chat_app/core/constants/key.dart';
import 'package:chat_app/features/homepage/presentation/cubit/cubit/homepage_cubit_cubit.dart';
import 'package:chat_app/features/homepage/presentation/ui/components/dialog.dart';
import 'package:chat_app/features/homepage/presentation/ui/components/options.dart';
import 'package:chat_app/features/homepage/presentation/ui/components/usercard.dart';
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

  String _selectedValue = '1';

  @override
  void initState() {
    super.initState();
    if (widget.arg != null) {
      setState(() {
        isSearch = widget.arg?[0];

        userIdAvailable = widget.arg?[1];
        title = widget.arg?[2];
        subTitle = widget.arg?[3];
        image = widget.arg?[4];
      });
    } else {
      isSearch = false;
      userIdAvailable = false;
      title = '';
      subTitle = '';
      image = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    log(isSearch.toString());
    log(userIdAvailable.toString());
    log(title);
    log(subTitle);
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
          PopupMenuButton<String>(
            onSelected: (String value) {
              setState(() {
                _selectedValue = value;
              });
            },
            position: PopupMenuPosition.under,
            elevation: 0.8,
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: '1',
                child: PopUpItemOptions(
                  icon: Icons.person,
                  text: 'Profile',
                ),
              ),
              const PopupMenuItem(
                value: '2',
                child: PopUpItemOptions(
                  icon: Icons.logout_outlined,
                  text: 'Logout',
                ),
              ),
            ],
          )
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
            : ListView.builder(
                itemCount: 16,
                padding: const EdgeInsets.only(top: 10),
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return const UserCard(
                    date: 'Date',
                    subtitle: 'Subtitle',
                    title: 'Title',
                  );
                },
              );
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
