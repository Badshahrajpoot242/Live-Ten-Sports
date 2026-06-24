import 'package:cricket_live_hd/core/models/channel_model.dart';
import 'package:cricket_live_hd/core/models/subcategory_model.dart';
import 'package:cricket_live_hd/core/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/app_providers.dart';
import 'player_screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ChannelListScreen extends ConsumerStatefulWidget {
  final SubcategoryModel subcategory;
  const ChannelListScreen({required this.subcategory, Key? key}) : super(key: key);

  @override
  ConsumerState<ChannelListScreen> createState() => _ChannelListScreenState();
}

class _ChannelListScreenState extends ConsumerState<ChannelListScreen> {
  late Stream<List<ChannelModel>> stream;
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    stream = ref.read(firebaseServiceProvider).channelsStream(widget.subcategory.id);
    final ads = ref.read(adsProvider).value;
    if (ads?.showBanner == true && (ads?.bannerAdUnitId ?? '').isNotEmpty) {
      _bannerAd = BannerAd(
        adUnitId: ads!.bannerAdUnitId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(onAdLoaded: (_) {}, onAdFailedToLoad: (_, __) {}),
      );
      _bannerAd!.load();
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fs = ref.read(firebaseServiceProvider);
    return Scaffold(
      appBar: AppBar(title: Text(widget.subcategory.title)),
      body: StreamBuilder<List<ChannelModel>>(
        stream: stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final channels = snapshot.data!;
          return Column(
            children: [
              if (_bannerAd != null) SizedBox(height: 50, child: AdWidget(ad: _bannerAd!)),
              Expanded(
                child: ListView.builder(
                  itemCount: channels.length,
                  itemBuilder: (context, index) {
                    final ch = channels[index];
                    return ListTile(
                      leading: ch.imageUrl.isNotEmpty ? Image.network(ch.imageUrl, width: 64, fit: BoxFit.cover) : null,
                      title: Text(ch.title),
                      subtitle: Text(ch.description),
                      onTap: () async {
                        // handle interstitial ad click count in AdManager (not shown)
                        Navigator.push(context, MaterialPageRoute(builder: (_) => PlayerScreen(channel: ch)));
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
