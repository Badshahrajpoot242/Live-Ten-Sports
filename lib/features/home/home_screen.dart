import 'package:cricket_live_hd/core/models/category_model.dart';
import 'package:cricket_live_hd/core/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/app_providers.dart';
import '../categories/category_list_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../core/models/settings_model.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Stream<List<CategoryModel>> categoriesStream;

  @override
  void initState() {
    super.initState();
    categoriesStream = ref.read(firebaseServiceProvider).categoriesStream();
  }

  Future<bool> _checkConnection() async {
    final status = await Connectivity().checkConnectivity();
    return status != ConnectivityResult.none;
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider).value;
    return Scaffold(
      appBar: AppBar(
        title: Text(settings?.appName ?? 'Cricket Live HD'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) => _handleMenu(v, settings),
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'privacy', child: Text('Privacy Policy')),
              const PopupMenuItem(value: 'share', child: Text('Share App')),
              const PopupMenuItem(value: 'about', child: Text('About Us')),
              const PopupMenuItem(value: 'whatsapp', child: Text('WhatsApp Support')),
            ],
          )
        ],
      ),
      body: StreamBuilder<List<CategoryModel>>(
        stream: categoriesStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return _buildShimmer();
          }
          final categories = snapshot.data!;
          if (categories.isEmpty) {
            return Center(child: Text('No categories available'));
          }
          return Stack(
            children: [
              if (settings?.backgroundImageUrl != null && settings!.backgroundImageUrl.isNotEmpty)
                Positioned.fill(child: Image.network(settings.backgroundImageUrl, fit: BoxFit.cover)),
              GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.2, crossAxisSpacing: 12, mainAxisSpacing: 12),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final c = categories[index];
                  return GestureDetector(
                    onTap: () async {
                      final ok = await _checkConnection();
                      if (!ok) {
                        _showNoInternet();
                        return;
                      }
                      Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryListScreen(category: c)));
                    },
                    child: Card(
                      color: Colors.black54,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(child: c.imageUrl.isNotEmpty ? Image.network(c.imageUrl, fit: BoxFit.cover) : Container(color: Colors.grey)),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(c.title, style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(c.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.grey.shade600,
      child: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.2, crossAxisSpacing: 12, mainAxisSpacing: 12),
        itemCount: 6,
        itemBuilder: (_, __) => Card(color: Colors.black54),
      ),
    );
  }

  void _showNoInternet() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('No internet connection')));
  }

  void _handleMenu(String v, SettingsModel? settings) async {
    switch (v) {
      case 'privacy':
        if (settings?.privacyPolicyUrl != null && settings!.privacyPolicyUrl.isNotEmpty) {
          final uri = Uri.parse(settings.privacyPolicyUrl);
          if (await canLaunchUrl(uri)) await launchUrl(uri);
        }
        break;
      case 'share':
        // share play store link
        break;
      case 'about':
        showAboutDialog(context: context, applicationName: settings?.appName);
        break;
      case 'whatsapp':
        final wa = settings?.whatsappNumber ?? '';
        if (wa.isNotEmpty) {
          final url = Uri.parse('https://wa.me/$wa');
          if (await canLaunchUrl(url)) await launchUrl(url);
        }
        break;
    }
  }
}
