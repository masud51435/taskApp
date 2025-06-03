import 'package:flutter/material.dart';
import 'package:taskapp/core/app_colors.dart';

class AirlineReviewAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const AirlineReviewAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: whiteColor,
      elevation: 0,
      title: Text(
        'Airline Review',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          icon: Badge.count(
            count: 2,
            backgroundColor: blackColor,
            child: Icon(Icons.notifications_outlined),
          ),
          onPressed: () {},
        ),

        // Profile picture
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3'),
          ),
        ),

        // Menu icon
        IconButton(
          icon: Icon(Icons.menu, color: blackColor),
          onPressed: () {},
        ),
      ],
    );
  }
}
