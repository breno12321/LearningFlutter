import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage(this.data, this.mine);

  final Map<String, dynamic> data;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CircleAvatar(
              backgroundImage: NetworkImage(data['senderPhotoURL'] ??
                  "https://profissaopilates.com.br/wp-content/uploads/2019/03/avatar-icon.png"),
            ),
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              data['imgURL'] != null
                  ? Image.network(
                      data['imgURL'],
                      width: 250,
                    )
                  : Text(
                      data['text'],
                      style: TextStyle(fontSize: 16),
                    ),
              Text(
                data['senderName'] ?? "Anonymous",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ))
        ],
      ),
    );
  }
}
