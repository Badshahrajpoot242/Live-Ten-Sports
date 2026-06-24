import 'package:cricket_live_hd/core/models/category_model.dart';
import 'package:cricket_live_hd/core/models/subcategory_model.dart';
import 'package:cricket_live_hd/core/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../channels/channel_list_screen.dart';
import '../../core/app_providers.dart';
import 'package:shimmer/shimmer.dart';

class CategoryListScreen extends ConsumerWidget {
  final CategoryModel category;
  const CategoryListScreen({required this.category, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fs = ref.watch(firebaseServiceProvider);
    return Scaffold(
      appBar: AppBar(title: Text(category.title)),
      body: StreamBuilder<List<SubcategoryModel>>(
        stream: fs.subcategoriesStream(category.id),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return _shimmer();
          }
          final subcats = snapshot.data!;
          if (subcats.isEmpty) return Center(child: Text('No subcategories'));
          return ListView.builder(
            itemCount: subcats.length,
            itemBuilder: (context, index) {
              final s = subcats[index];
              return ListTile(
                leading: s.imageUrl.isNotEmpty ? Image.network(s.imageUrl, width: 64, fit: BoxFit.cover) : null,
                title: Text(s.title),
                subtitle: Text(s.description),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChannelListScreen(subcategory: s))),
              );
            },
          );
        },
      ),
    );
  }

  Widget _shimmer() {
    return Shimmer.fromColors(baseColor: Colors.grey.shade800, highlightColor: Colors.grey.shade600,
      child: ListView.builder(itemCount: 6, itemBuilder: (_, __) => ListTile(title: Container(height: 16, color: Colors.white))));
  }
}
