import 'package:flutter/material.dart';

class UserCard extends StatefulWidget {
  final IconData? icon;
  const UserCard({super.key, this.icon});

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
        onTap: () {},
        child: const ListTile(
          leading: CircleAvatar(child: Icon(Icons.person)),
          title: Text('Title'),
          subtitle: Text(
            'Subtitle',
            maxLines: 1,
          ),
          trailing: Text('Date'),
        ),
      ),
    );
  }
}
