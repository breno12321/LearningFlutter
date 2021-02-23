import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextComposer extends StatefulWidget {
  TextComposer(this.sendMessage);

  final Function({String message, File img}) sendMessage;

  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  bool _isComposing = false;

  final messageControlller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.photo_camera),
            onPressed: () async {
              PickedFile img =
                  await ImagePicker().getImage(source: ImageSource.camera);
              if (img == null) {
                return;
              }
              File imgFile = File(img.path);
              widget.sendMessage(img: imgFile);
            },
          ),
          Expanded(
            child: TextField(
              controller: messageControlller,
              decoration: InputDecoration.collapsed(hintText: "Enviar msg"),
              onChanged: (value) {
                setState(() {
                  _isComposing = value.isNotEmpty;
                });
              },
              onSubmitted: (value) {},
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _isComposing
                ? () {
                    widget.sendMessage(message: messageControlller.text);
                    setState(() {
                      messageControlller.clear();
                      _isComposing = false;
                    });
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
