import 'dart:convert';

import 'package:Fluttegram/dto/PostDto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class HttpService {
  final String postsURL = "https://jsonplaceholder.typicode.com/posts";
  final String imagesURL =
      "https://kaleidosblog.s3-eu-west-1.amazonaws.com/flutter_gallery/data.json";

  Future<List<PostDto>> getPosts() async {
    Response res = await get(postsURL);

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);

      List<PostDto> posts = body
          .map(
            (dynamic item) => PostDto.fromJson(item),
          )
          .toList();

      return posts;
    } else {
      throw "Can't get posts.";
    }
  }

  Future<List<PostDto>> getPostsWithImages() async {
    List<PostDto> posts = await getPosts();
    List<Image> images = await getImages();

    posts.forEach((element) {
      element.userImage = (images..shuffle()).first;
      element.contentImage = (images..shuffle()).first;
      return element;
    });

    return posts;
  }

  Future<List<Image>> getImages() async {
    Response res = await get(imagesURL);

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);

      List<Image> images = body.map((dynamic item) {
        try {
          return Image.network(item);
        } catch (e) {
          return Image.asset("assets/images/post.jpg");
        }
      }).toList();

      return images;
    } else {
      throw "Can't get posts.";
    }
  }
}
