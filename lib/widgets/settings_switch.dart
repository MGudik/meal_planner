import 'package:flutter/material.dart';

class SettingsSwitch extends StatefulWidget {
  const SettingsSwitch({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() {
    return SettingsSwitchState();
  }
}

class SettingsSwitchState extends State<SettingsSwitch> {
  bool active = false;

  void setStatus(bool status) {
    setState(() {
      active = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Text(widget.title),
          Switch(
              value: active,
              onChanged: (value) {
                setStatus(value);
              }),
        ],
      ),
    );
  }
}
