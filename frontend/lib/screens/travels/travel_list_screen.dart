import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/travel_provider.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<TravelProvider>(context, listen: false).fetchTravels();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Travel List'),
      ),
      body: Consumer<TravelProvider>(
        builder: (context, travelData, _) {
          if (travelData.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (travelData.travels.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('No travels found.'),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.of(context)
              .pushNamed(CreateTravelScreen.routeName);
          if (mounted && result != null) {
            // Refresh the list after creating a new travel
            Provider.of<TravelProvider>(context, listen: false).fetchTravels();
          }
        },
        label: const Text('Add Travel'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
