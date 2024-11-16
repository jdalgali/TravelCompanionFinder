import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/travel.dart';
import '../../providers/auth_provider.dart';
import 'create_travel_screen.dart';

class TravelDetailScreen extends StatelessWidget {
  static const routeName = '/travel-detail';
  final Travel travel;

  const TravelDetailScreen({
    required this.travel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isCreator =
        context.read<AuthProvider>().user?['id'] == travel.creatorId;

    return Scaffold(
      appBar: AppBar(
        title: Text(travel.title),
        actions: [
          if (isCreator)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  CreateTravelScreen.routeName,
                  arguments: {'travel': travel},
                );
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image or Map Preview
            Container(
              height: 200,
              width: double.infinity,
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Center(
                child: Icon(
                  Icons.landscape,
                  size: 64,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Destination and Dates
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.place),
                            title: Text(
                              travel.destination,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          ListTile(
                            leading: const Icon(Icons.calendar_today),
                            title: Text(
                              'From: ${travel.startDate.toString().substring(0, 10)}',
                            ),
                            subtitle: Text(
                              'To: ${travel.endDate.toString().substring(0, 10)}',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Description
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(travel.description),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Preferences
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Travel Preferences',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _PreferenceItem(
                            icon: Icons.speed,
                            label: 'Activity Level',
                            value: travel.preferences.activityLevel,
                          ),
                          _PreferenceItem(
                            icon: Icons.account_balance_wallet,
                            label: 'Budget',
                            value: travel.preferences.budget,
                          ),
                          _PreferenceItem(
                            icon: Icons.category,
                            label: 'Travel Style',
                            value: travel.preferences.travelStyle.join(', '),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: !isCreator
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement join request functionality
                  },
                  child: const Text('Request to Join'),
                ),
              ),
            )
          : null,
    );
  }
}

class _PreferenceItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _PreferenceItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text('$label: '),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
