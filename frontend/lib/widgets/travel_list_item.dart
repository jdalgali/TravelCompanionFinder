import 'package:flutter/material.dart';
import '../models/travel.dart';

class TravelListItem extends StatelessWidget {
  final Travel travel;
  final VoidCallback onTap;

  const TravelListItem({
    required this.travel,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                travel.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(travel.description),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Destination: ${travel.destination}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${travel.currentCompanions.length}/${travel.maxCompanions} companions',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Start: ${travel.startDate.toString().substring(0, 10)}',
                  ),
                  Text(
                    'End: ${travel.endDate.toString().substring(0, 10)}',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
