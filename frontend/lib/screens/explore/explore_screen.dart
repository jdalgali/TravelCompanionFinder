import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/explore_provider.dart';
import '../../providers/auth_provider.dart';

class ExploreScreen extends StatelessWidget {
  static const routeName = '/explore';

  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthProvider>().user?['id'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
      ),
      body: userId == null
          ? const Center(child: Text('Please log in to see recommendations'))
          : FutureBuilder(
              future: context
                  .read<ExploreProvider>()
                  .fetchRecommendedTravels(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                return Consumer<ExploreProvider>(
                  builder: (context, exploreProvider, child) {
                    if (exploreProvider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (exploreProvider.error != null) {
                      return Center(
                          child: Text('Error: ${exploreProvider.error}'));
                    }

                    final travels = exploreProvider.recommendedTravels;

                    if (travels.isEmpty) {
                      return const Center(
                          child: Text('No recommendations available'));
                    }

                    return ListView.builder(
                      itemCount: travels.length,
                      itemBuilder: (context, index) {
                        final travel = travels[index];
                        return ListTile(
                          title: Text(travel.title),
                          subtitle: Text(travel.destination),
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}
