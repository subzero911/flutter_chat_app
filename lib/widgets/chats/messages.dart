import 'package:chatapp/widgets/chats/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseUser>(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('chat').orderBy('createdAt', descending: true).snapshots(),
          builder: (ctx, chatSnapshot) {
            if (chatSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            final chatDocs = chatSnapshot.data.documents;
            return ListView.builder(
              reverse: true,
              itemCount: chatDocs.length,
              itemBuilder: (ctx, index) => MessageBubble(
                key: ValueKey(chatDocs[index].documentID),
                message: chatDocs[index]['text'],
                userName: chatDocs[index]['username'],
                userImage: chatDocs[index]['userImage'],
                isMe: chatDocs[index]['userId'] == futureSnapshot.data.uid,
              ),
            );
          },
        );
      },
    );
  }
}
