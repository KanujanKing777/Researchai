import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  PostList();
  }
}

class PostList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('researches').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final posts = snapshot.data!.docs;

        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return PostItem(
              author: post['author'],
              content: post['overview'][0],
              title: post['Title'],
            );
          },
        );
      },
    );
  }
}

class PostItem extends StatelessWidget {
  final String author;
  final String title;
  final String content;

  PostItem({
    required this.author,
    required this.content,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: <Widget>[
    Center(
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    ),
    SizedBox(height: 10.0),
    Align(
      alignment: Alignment.centerLeft,
      child: Text(
        content,
        style: TextStyle(
          fontSize: 16.0,
        ),
        textAlign: TextAlign.justify,
      ),
    ),
    SizedBox(height: 10.0),
    Align(
      alignment: Alignment.centerRight,
      child: Text(
        author,
        style: TextStyle(
          fontSize: 14.0,
          fontStyle: FontStyle.italic,
        ),
        textAlign: TextAlign.right,
      ),
    ),
  ],
)

      ),
    );
  }
}
