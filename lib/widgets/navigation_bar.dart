import 'package:flutter/material.dart';

class BotNavBar extends StatefulWidget {
  const BotNavBar({super.key, required this.onChangeScreen});

  final void Function(int index) onChangeScreen;

  @override
  State<StatefulWidget> createState() {
    return _BotNavBarState();
  }
}

class _BotNavBarState extends State<BotNavBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (newIndex) {
        setState(() {
          _selectedIndex = newIndex;
        });
        widget.onChangeScreen(newIndex);
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant),
          label: "Meals",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star),
          label: "Wishes",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: "Settings",
        ),
      ],
    );
  }
}
