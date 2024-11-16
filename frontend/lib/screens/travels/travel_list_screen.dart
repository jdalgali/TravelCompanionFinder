import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/travel_provider.dart';
import '../../widgets/travel_search_bar.dart';
import '../../widgets/travel_list_item.dart';
import '../../widgets/animated_list_item.dart';
import 'create_travel_screen.dart';
import 'travel_detail_screen.dart';

class TravelListScreen extends StatefulWidget {
  static const routeName = '/travel-list';

  const TravelListScreen({super.key});

  @override
  State<TravelListScreen> createState() => _TravelListScreenState();
}

class _TravelListScreenState extends State<TravelListScreen> {
  String _searchQuery = '';
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<TravelProvider>(context, listen: false).fetchTravels();
      }
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Filter Travels'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Start Date'),
              subtitle:
                  Text(_startDate?.toString().substring(0, 10) ?? 'Not set'),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null && mounted) {
                  setState(() => _startDate = picked);
                }
              },
            ),
            ListTile(
              title: const Text('End Date'),
              subtitle:
                  Text(_endDate?.toString().substring(0, 10) ?? 'Not set'),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _startDate ?? DateTime.now(),
                  firstDate: _startDate ?? DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null && mounted) {
                  setState(() => _endDate = picked);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _startDate = null;
                _endDate = null;
              });
              Navigator.of(ctx).pop();
              _applyFilters();
            },
            child: const Text('Clear'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _applyFilters();
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _applyFilters() {
    if (!mounted) return;
    Provider.of<TravelProvider>(context, listen: false).searchTravels(
      destination: _searchQuery.isEmpty ? null : _searchQuery,
      startDate: _startDate,
      endDate: _endDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Travel Listings'),
      ),
      body: Column(
        children: [
          TravelSearchBar(
            onSearch: (query) {
              setState(() => _searchQuery = query);
              _applyFilters();
            },
            onFilterTap: _showFilterDialog,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await Provider.of<TravelProvider>(context, listen: false)
                    .fetchTravels();
              },
              child: Consumer<TravelProvider>(
                builder: (ctx, travelData, child) {
                  if (travelData.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (travelData.error != null) {
                    return Center(child: Text(travelData.error!));
                  }
                  if (travelData.travels.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('No travels found'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context)
                                .pushNamed(CreateTravelScreen.routeName),
                            child: const Text('Create Your First Travel'),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: travelData.travels.length,
                    itemBuilder: (ctx, i) => AnimatedListItem(
                      index: i,
                      child: TravelListItem(
                        travel: travelData.travels[i],
                        key: ValueKey(travelData.travels[i].id),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => TravelDetailScreen(
                                travel: travelData.travels[i],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.of(context)
              .pushNamed(CreateTravelScreen.routeName);
          if (mounted && result != null) {
            // Refresh the list after creating a new travel
            Provider.of<TravelProvider>(context, listen: false).fetchTravels();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Create Travel'),
      ),
    );
  }
}
