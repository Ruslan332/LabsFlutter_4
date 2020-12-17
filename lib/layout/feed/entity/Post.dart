import 'package:Fluttegram/theme/ThemeSettings.dart';
import 'package:Fluttegram/util/Utility.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'photo_post.dart';
import 'ReactionsScreen.dart';

class Post extends StatefulWidget {
  final String username;
  final String userImagePath;
  final String contentImagePath;
  final String description;
  final String postedTime;
  final String tag;
  final bool isImageSrcNetwork;
  Image userImage;
  Image contentImage;

  int nLikes = 0;

  Post(
      [
        this.username = "post_name",
        this.userImagePath = "assets/images/avatar.jpg",
        this.contentImagePath = "assets/images/post.jpg",
        this.isImageSrcNetwork = false,
        this.description = " Chill on seaside )",
        this.postedTime = "3 hours ago"])
      : this.tag = Utility.getRandomTag(9);

  Post.customized(
      this.description, this.username, this.userImage, this.contentImage,
      [this.userImagePath = "",
      this.contentImagePath = "",
      this.isImageSrcNetwork = true,
      this.postedTime = "3 hours ago"])
      : this.tag = Utility.getRandomTag(9);

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        child: Column(
          children: <Widget>[
            buildPostHeader(),
            buildContent(),
            buildSubtitle(),
            buildSeeAllComments(),
            buildPostedTime()
          ],
        ));
  }

  Image _buildAvatar() {
    return widget.isImageSrcNetwork
        ? widget.userImage
        : Image.asset(widget.userImagePath);
  }

  Image _buildContentPhoto() {
    return widget.isImageSrcNetwork
        ? widget.contentImage
        : Image.asset(widget.contentImagePath);
  }

  Widget buildPostHeader() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(child: ClipOval(child:_buildAvatar())),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  widget.username,
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.linear_scale,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  void doLikeFunction(int nLikes) {
    setState(() {
      widget.nLikes += nLikes;
    });
  }

  Widget buildContent() {
    return Column(
      children: <Widget>[
        Container(
          child: Hero(
              tag: widget.tag,
              child: GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PhotoPage(
                              widget.username,
                              widget.tag,
                              _buildContentPhoto(),
                              widget.description,
                              widget.nLikes,
                              doLikeFunction))),
                  child: _buildContentPhoto())),
        ),
        buildInteractionRow()
      ],
    );
  }

  Widget buildInteractionRow() {
    final model = Provider.of<ThemeNotifier>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.favorite_border,
                color: widget.nLikes == 0
                    ? Utility.defineColorDependingOnTheme(!model.isDarkTheme)
                    : Colors.red,
              ),
              onPressed: () {
                doLikeFunction(1);
              },
            ),
            Text(
              'Likes: ${widget.nLikes}',
              style: TextStyle(
                  color: widget.nLikes == 0
                      ? Utility.defineColorDependingOnTheme(!model.isDarkTheme)
                      : Colors.red),
            ),
            IconButton(
              icon: Icon(
                Icons.important_devices, //reactions
              ),
              onPressed: () {
                _navigateToReactions(context);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.mode_comment,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.send,
              ),
              onPressed: () {},
            ),
          ],
        ),
        IconButton(
          icon: Icon(
            Icons.bookmark_border,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  ///hide previous snackbar and show the new result.
  void _navigateToReactions(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReactionScreen()),
    ).then((value) => Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(
          content:
              Text("You reacted with [" + "$value" + "] on this Post."))))
    .catchError((err) => throw "Can not make reaction.");

  }

  Widget buildSubtitle() {
    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Text(
            widget.username,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Flexible(
            child: Text(
              widget.description,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSeeAllComments() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        'See all comments',
        style: TextStyle(color: Colors.grey[700]),
      ),
    );
  }

  Widget buildPostedTime() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        widget.postedTime,
        style: TextStyle(
          fontSize: 8,
          color: Colors.grey[700],
        ),
      ),
    );
  }
}
