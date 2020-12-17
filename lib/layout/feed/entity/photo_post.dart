import 'package:Fluttegram/theme/ThemeSettings.dart';
import 'package:Fluttegram/util/Utility.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PhotoPage extends StatefulWidget {
  final String username;
  final String tag;
  final Image image;
  final String description;

  ///lifting state up approach
  final Function doLikeFunction;
  int nLikes;

  PhotoPage(this.username, this.tag, this.image, this.description,
      this.nLikes, this.doLikeFunction);

  @override
  _PhotoPageState createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  @override
  Widget build(BuildContext context) {
    double iconRadius = 100;
    final model = Provider.of<ThemeNotifier>(context,  listen: false);

    return Scaffold(
      backgroundColor: Utility.defineColorDependingOnTheme(model.isDarkTheme),
      appBar: AppBar(
        title: Text('${widget.username}'),
      ),
      body: Column(children: <Widget>[
        Stack(
          children: [
            Container(
              child: Hero(
                tag: '${widget.tag}',
                child: widget.image,
              ),
            ),
            _overflowingHeartSign(context, iconRadius),
          ],
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _commentLikeDirect(),
          ),
        ),
        Expanded(
            flex: 3,
            child: Padding(
                padding: EdgeInsets.all(40),
                child: Text(
                  widget.description,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color:
                          Utility.defineColorDependingOnTheme(model.isDarkTheme)),
                )))
      ]),
      floatingActionButton: _downloadBtn(),
    );
  }

  Positioned _overflowingHeartSign(BuildContext context, double iconRadius) {
    return Positioned(
      left: (MediaQuery.of(context).size.width / 2) - iconRadius,
      top: iconRadius,
      child: FlatButton(
          onPressed: () {
            int randomLikeQuantity = Utility.next(1, 10);
            setState(() {
              widget.nLikes += randomLikeQuantity;
            });
            widget.doLikeFunction(randomLikeQuantity);
          },
          child: Icon(
            Icons.favorite_border,
            color: Color.fromRGBO(255, 255, 255, 0.35),
            size: iconRadius * 2,
          )),
    );
  }

  List<Widget> _commentLikeDirect() {
    final model = Provider.of<ThemeNotifier>(context,  listen: false);
    return [
      IconButton(
        icon: Icon(
          Icons.favorite,
          color: widget.nLikes == 0
              ? Utility.defineColorDependingOnTheme(!model.isDarkTheme)
              : Colors.red,
        ),
        onPressed: () {
          setState(() {
            widget.nLikes += 1;
          });
          widget.doLikeFunction(1);
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
    ];
  }

  FloatingActionButton _downloadBtn() {
    return FloatingActionButton(
      onPressed: () {},
      tooltip: 'download',
      child: Icon(Icons.file_download, color: Colors.green),
    );
  }
}
