import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PostDto {
  final int userId;
  final int id;
  final String title;
  final String body;
  Image userImage;
  Image contentImage;


  PostDto({
    @required this.userId,
    @required this.id,
    @required this.title,
    @required this.body,
  });

  factory PostDto.fromJson(Map<String, dynamic> json) {
    return PostDto(
      userId: json['userId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }

}