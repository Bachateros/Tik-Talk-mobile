import 'package:flutter/material.dart';
import 'package:tik_talk/presintation/theme/theme_background.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  // Обязательно — указываем желаемую высоту AppBar
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool _isSearching = false;
  final TextEditingController _controller = TextEditingController();

  final List<String> _mockSuggestions = [
    'Anton',
    'Flutter Devs',
    'Team Chat',
    'General',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ThemeAssets.searchBar(context)),
            fit: BoxFit.fitWidth,
            alignment: Alignment.topLeft,
          ),
        ),
        child:AppBar(
          leading: Builder(
            builder: (context) => IconButton(
              icon:  Image.asset(ThemeAssets.logo(context)),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          backgroundColor: Colors.transparent,
        title: !_isSearching
            ? const Text(
                'Tik-Talk',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )
            : _buildSearchField(context),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) _controller.clear();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue value) {
        if (value.text.isEmpty) return const Iterable<String>.empty();
        return _mockSuggestions.where((s) =>
            s.toLowerCase().contains(value.text.toLowerCase()));
      },
      onSelected: (selection) {
        debugPrint('Выбрано: $selection');
        setState(() => _isSearching = false);
      },
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Поиск...',
            hintStyle: TextStyle(color: Colors.white54),
            border: InputBorder.none,
          ),
        );
      },
    );
  }
}