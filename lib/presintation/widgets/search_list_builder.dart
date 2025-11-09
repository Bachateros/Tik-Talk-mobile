part of 'custom_app_bar.dart';
class SearchItem {
  final String id;
  final String displayName;
  final SearchItemType type;
  final String? subtitle;

  const SearchItem({
    required this.id,
    required this.displayName,
    required this.type,
    this.subtitle,
  });
}

enum SearchItemType {
  user,
  groupChat,
  directChat,
  channel,
}
