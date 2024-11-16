import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/travel_provider.dart';
import '../../models/travel.dart';
import '../../app_theme.dart';
import 'create_travel_screen.dart';

class TravelListScreen extends StatefulWidget {
  const TravelListScreen({super.key});

  @override
  State<TravelListScreen> createState() => _TravelListScreenState();
}

class _TravelListScreenState extends State<TravelListScreen> {
  @override
  void initState() {
    super.initState();
    _loadTravels();
  }

  Future<void> _loadTravels() async {
    if (!mounted) return;
    await context.read<TravelProvider>().loadTravels();
  }

  void _showFilterDialog() {
    // Implement filter dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Travels'),
        content: const Text('Filter options coming soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _navigateToTravelDetails(Travel travel) {
    // Implement navigation to details
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Travel details coming soon')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Travel Listings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Consumer<TravelProvider>(
        builder: (context, travelProvider, child) {
          if (travelProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (travelProvider.error != null) {
            return Center(child: Text('Error: ${travelProvider.error}'));
          }

          if (travelProvider.travels.isEmpty) {
            return const Center(child: Text('No travels found'));
          }

          return RefreshIndicator(
            onRefresh: _loadTravels,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: travelProvider.travels.length,
              itemBuilder: (context, index) {
                final travel = travelProvider.travels[index];
                return TravelCard(
                  travel: travel,
                  onTap: () => _navigateToTravelDetails(travel),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateTravelScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TravelCard extends StatelessWidget {
  final Travel travel;
  final VoidCallback onTap;

  const TravelCard({
    super.key,
    required this.travel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                travel.destination,
                style: AppTheme.headline,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    travel.title,
                    style: AppTheme.title,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    travel.description,
                    style: AppTheme.body2,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 16, color: AppTheme.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${travel.startDate.toString().split(' ')[0]} - ${travel.endDate.toString().split(' ')[0]}',
                        style: AppTheme.caption,
                      ),
                      const Spacer(),
                      Icon(Icons.group, size: 16, color: AppTheme.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${travel.acceptedCompanions.length}/${travel.maxCompanions}',
                        style: AppTheme.caption,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
