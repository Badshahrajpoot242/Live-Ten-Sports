class ChannelModel {
  final String id;
  final String subcategoryId;
  final String title;
  final String imageUrl;
  final String description;
  final String streamType;
  final String streamUrl;
  final String? userAgent;
  final String? referer;
  final bool isActive;
  final int order;

  ChannelModel({
    required this.id,
    required this.subcategoryId,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.streamType,
    required this.streamUrl,
    this.userAgent,
    this.referer,
    required this.isActive,
    required this.order,
  });

  factory ChannelModel.fromMap(Map<dynamic, dynamic> map) {
    return ChannelModel(
      id: map['id'].toString(),
      subcategoryId: map['subcategory_id'].toString(),
      title: map['title'] ?? '',
      imageUrl: map['image_url'] ?? '',
      description: map['description'] ?? '',
      streamType: map['stream_type'] ?? 'm3u8',
      streamUrl: map['stream_url'] ?? '',
      userAgent: map['user_agent'],
      referer: map['referer'],
      isActive: map['is_active'] == true,
      order: (map['order'] ?? 0) as int,
    );
  }
}
