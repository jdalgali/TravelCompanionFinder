import 'package:flutter/material.dart';

class TravelSearchBar extends StatefulWidget {
  final Function(String) onSearch;
  final VoidCallback onFilterTap;

  const TravelSearchBar({
    required this.onSearch,
    required this.onFilterTap,
    super.key,
  });

  @override
  State<TravelSearchBar> createState() => _TravelSearchBarState();
}

class _TravelSearchBarState extends State<TravelSearchBar> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search destinations...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 0,
                ),
              ),
              onChanged: widget.onSearch,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: widget.onFilterTap,
          ),
        ],
      ),
    );
  }
}
