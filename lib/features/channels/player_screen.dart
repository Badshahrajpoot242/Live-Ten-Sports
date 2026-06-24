
import 'package:better_player/better_player.dart';
import 'package:cricket_live_hd/core/models/channel_model.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';

class PlayerScreen extends StatefulWidget {
  final ChannelModel channel;
  const PlayerScreen({required this.channel, Key? key}) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  BetterPlayerController? _betterController;
  YoutubePlayerController? _ytController;
  RTCVideoRenderer? _localRenderer;
  VlcPlayerController? _vlcController;
  WebViewController? _webController;

  @override
  void initState() {
    super.initState();
    _initForType();
  }

  Future<void> _initForType() async {
    final type = widget.channel.streamType.toLowerCase();
    final url = widget.channel.streamUrl;
    switch (type) {
      case 'm3u8':
      case 'hls':
      case 'mp4':
        final dataSource = BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          url,
          headers: _buildHeaders(),
          useAsmsSubtitles: false,
        );
        _betterController = BetterPlayerController(BetterPlayerConfiguration(
          aspectRatio: 16 / 9,
          autoPlay: true,
          looping: false,
          controlsConfiguration: BetterPlayerControlsConfiguration(
            enableSkips: true,
            enablePlaybackSpeed: true,
            enableSubtitles: true,
            enableQualities: true,
            enablePip: true,
            enableFullscreen: true,
          ),
        ));
        _betterController!.setupDataSource(dataSource);
        break;
      case 'youtube':
        final id = YoutubePlayer.convertUrlToId(url) ?? '';
        _ytController = YoutubePlayerController(initialVideoId: id, flags: YoutubePlayerFlags(autoPlay: true, mute: false));
        break;
      case 'iframe':
        // load via WebView
        if (Platform.isAndroid) WebView.platform = AndroidWebView();
        _webController = WebViewController()..loadRequest(Uri.parse(url));
        break;
      case 'webrtc':
        _localRenderer = RTCVideoRenderer();
        await _localRenderer!.initialize();
        // Full WebRTC implementation requires signaling; here we show placeholder that expects external SDP via DB
        break;
      case 'rtmp':
        _vlcController = VlcPlayerController.network(url, hwAcc: HwAcc.FULL);
        break;
      default:
        // fallback to WebView
        if (Platform.isAndroid) WebView.platform = AndroidWebView();
        _webController = WebViewController()..loadRequest(Uri.parse(url));
    }
    setState(() {});
  }

  Map<String, String> _buildHeaders() {
    final headers = <String, String>{};
    if (widget.channel.userAgent != null && widget.channel.userAgent!.isNotEmpty) headers['User-Agent'] = widget.channel.userAgent!;
    if (widget.channel.referer != null && widget.channel.referer!.isNotEmpty) headers['Referer'] = widget.channel.referer!;
    return headers;
  }

  @override
  void dispose() {
    _betterController?.dispose();
    _ytController?.dispose();
    _vlcController?.dispose();
    _localRenderer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final type = widget.channel.streamType.toLowerCase();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.channel.title),
        actions: [
          IconButton(onPressed: () => Share.share(widget.channel.streamUrl), icon: Icon(Icons.share)),
        ],
      ),
      body: Center(
        child: _buildPlayerForType(type),
      ),
    );
  }

  Widget _buildPlayerForType(String type) {
    switch (type) {
      case 'm3u8':
      case 'hls':
      case 'mp4':
        return _betterController != null ? AspectRatio(aspectRatio: 16 / 9, child: BetterPlayer(controller: _betterController!)) : CircularProgressIndicator();
      case 'youtube':
        return _ytController != null ? YoutubePlayer(controller: _ytController!) : CircularProgressIndicator();
      case 'iframe':
        return _webController != null ? WebViewWidget(controller: _webController!) : CircularProgressIndicator();
      case 'webrtc':
        return _localRenderer != null ? RTCVideoView(_localRenderer!) : Text('WebRTC stream requires signaling setup.');
      case 'rtmp':
        return _vlcController != null ? VlcPlayer(controller: _vlcController!, aspectRatio: 16 / 9) : CircularProgressIndicator();
      default:
        return Text('Unsupported stream type: $type');
    }
  }
}
