import 'package:Fluttegram/dto/PostDto.dart';
import 'package:Fluttegram/layout/feed/entity/Post.dart';
import 'package:Fluttegram/service/HttpService.dart';
import 'package:flutter/material.dart';

class PostsPage extends StatelessWidget {
  final HttpService httpService = HttpService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Discover world with Instagram",
          style: TextStyle(
            fontFamily: 'Billabong',
            fontSize: 22,
          ),
        ),
      ),
      body: FutureBuilder(
        future: httpService.getPostsWithImages(),
        builder: (BuildContext context, AsyncSnapshot<List<PostDto>> snapshot) {
          if (snapshot.hasData) {
            List<PostDto> posts = snapshot.data;
            return ListView(
              children: posts
                  .map(
                    (PostDto post) => Post.customized(
                        post.body.substring(0, 20),
                        post.title.substring(0, 7) + " ",
                        post.userImage,
                        post.contentImage),
                  )
                  .toList(),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
