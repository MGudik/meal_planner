import 'package:flutter/material.dart';

class NewItemWidget extends StatefulWidget {
  NewItemWidget({super.key, required this.onAdd, this.onDelete});

  final void Function(String title) onAdd;
  final void Function()? onDelete;

  @override
  State<StatefulWidget> createState() {
    return _NewItemWidgetState();
  }
}

class _NewItemWidgetState extends State<NewItemWidget> {
  final _messageController = TextEditingController();

  void submitItem() {
    final enteredMessage = _messageController.text.trim();
    if (enteredMessage.isEmpty) {
      return;
    }
    widget.onAdd(enteredMessage);

    if (context.mounted) FocusScope.of(context).unfocus();
    _messageController.clear();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          child: TextField(
        controller: _messageController,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
            label: Text(
          "Enter title...",
          style: TextStyle(fontSize: 12),
        )),
      )),
      IconButton(onPressed: submitItem, icon: Icon(Icons.send)),
      if (widget.onDelete != null)
        IconButton(
            onPressed: () {
              widget.onDelete!();
            },
            icon: Icon(Icons.delete_forever))
    ]);
  }
}
