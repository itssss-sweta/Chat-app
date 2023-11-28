import 'package:chat_app/config/routes/route.dart';
import 'package:chat_app/core/constants/key.dart';
import 'package:flutter/material.dart';

class UserCard extends StatefulWidget {
  final String? file;
  final String? title;
  final String? subtitle;
  final String? date;

  const UserCard({super.key, this.title, this.subtitle, this.date, this.file});

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
          navigatorKey.currentState
              ?.pushNamed(Routes.chatScreen, arguments: widget.subtitle);
        },
        child: ListTile(
          leading: CircleAvatar(
              child: ClipOval(
                  child: (widget.file?.isNotEmpty ?? false)
                      ? Image.network(
                          widget.file ?? '',
                          fit: BoxFit.contain,
                          width: 100,
                          height: 100,
                          cacheHeight: 100,
                          cacheWidth: 100,
                          loadingBuilder: (BuildContext ctx, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                            null &&
                                        loadingProgress.expectedTotalBytes !=
                                            null
                                    ? loadingProgress.cumulativeBytesLoaded /
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
                        )
                      : const Icon(Icons.person))),
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
