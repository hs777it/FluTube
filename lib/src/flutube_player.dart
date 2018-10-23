import 'package:flutter/widgets.dart';
import 'package:flutube/chewie/chewie_player.dart';
import 'package:flutube/chewie/chewie_progress_colors.dart';
import 'package:video_player/video_player.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class FluTube extends StatefulWidget {
  /// Youtube URL of the video
  final String videourl;

  /// Initialize the Video on Startup. This will prep the video for playback.
  final bool autoInitialize;

  /// Play the video as soon as it's displayed
  final bool autoPlay;

  /// Start video at a certain position
  final Duration startAt;

  /// Whether or not the video should loop
  final bool looping;

  /// Whether or not to show the controls
  final bool showControls;

  /// The Aspect Ratio of the Video. Important to get the correct size of the
  /// video!
  ///
  /// Will fallback to fitting within the space allowed.
  final double aspectRatio;

  /// The colors to use for controls on iOS. By default, the iOS player uses
  /// colors sampled from the original iOS 11 designs.
  final ChewieProgressColors cupertinoProgressColors;

  /// The colors to use for the Material Progress Bar. By default, the Material
  /// player uses the colors from your Theme.
  final ChewieProgressColors materialProgressColors;

  /// The placeholder is displayed underneath the Video before it is initialized
  /// or played.
  final Widget placeholder;

  FluTube(
    this.videourl, {
    Key key,
    this.aspectRatio,
    this.autoInitialize = false,
    this.autoPlay = false,
    this.startAt,
    this.looping = false,
    this.cupertinoProgressColors,
    this.materialProgressColors,
    this.placeholder,
    this.showControls = true,
  }) : super(key: key);

  @override
  _FluTubeState createState() => _FluTubeState();
}

class _FluTubeState extends State<FluTube>{
  VideoPlayerController _controller;

  @override
  initState() {
    _fetchVideoURL(widget.videourl).then((uri) {
      setState(() {
        _controller = VideoPlayerController.network(uri)
        ..initialize();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _controller == null ?
    Container() :
    Chewie(
      _controller,
      key: widget.key,
      aspectRatio: widget.aspectRatio,
      autoInitialize: widget.autoInitialize,
      autoPlay: widget.autoPlay,
      startAt: widget.startAt,
      looping: widget.looping,
      cupertinoProgressColors: widget.cupertinoProgressColors,
      materialProgressColors: widget.materialProgressColors,
      placeholder: widget.placeholder,
      showControls: widget.showControls,
    );
  }

  Future<String> _fetchVideoURL(String yt) async {
    final response = await http.get("https://you-link.herokuapp.com/?url=$yt");
    final List _all = json.decode(response.body);
    return _all[0]["url"];
  }
}