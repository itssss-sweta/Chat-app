import 'package:chat_app/config/routes/route.dart';
import 'package:chat_app/core/constants/key.dart';
import 'package:flutter/material.dart';

class UserCard extends StatefulWidget {
  final IconData? icon;
  final String? title;
  final String? subtitle;
  final String? date;

  const UserCard({super.key, this.icon, this.title, this.subtitle, this.date});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 0.2,
      child: InkWell(
        onTap: () {
          navigatorKey.currentState?.pushNamed(Routes.chatScreen);
        },
        child: ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: Text(widget.title ?? ''),
          subtitle: Text(
            widget.subtitle ?? '',
            maxLines: 1,
          ),
          trailing: Text(widget.date ?? ''),
        ),
      ),
    );
  }
}
