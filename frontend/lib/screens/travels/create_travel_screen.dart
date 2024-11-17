import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/travel.dart';
import '../../models/travel_preferences.dart';
import '../../providers/travel_provider.dart';

class CreateTravelScreen extends StatefulWidget {
  static const routeName = '/create-travel';
  final Travel? initialTravel; // For editing mode

  const CreateTravelScreen({
    this.initialTravel,
    super.key,
  });

  @override
  State<CreateTravelScreen> createState() => _CreateTravelScreenState();
}

class _CreateTravelScreenState extends State<CreateTravelScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _destinationController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  String _activityLevel = 'Medium';
  String _budget = 'Moderate';
  final List<String> _travelStyle = ['Adventure'];
  int _maxCompanions = 2;
  bool _isSubmitting = false;

  final List<String> _activityLevels = ['Low', 'Medium', 'High'];
  final List<String> _budgetOptions = ['Budget', 'Moderate', 'Luxury'];
  final List<String> _travelStyleOptions = [
    'Adventure',
    'Cultural',
    'Relaxation',
    'Food',
    'Nature'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialTravel != null) {
      // Populate form for editing
      final travel = widget.initialTravel!;
      _titleController.text = travel.title;
      _descriptionController.text = travel.description;
      _destinationController.text = travel.destination;
      _startDate = travel.startDate;
      _endDate = travel.endDate;
      _activityLevel = travel.preferences.activityLevel;
      _budget = travel.preferences.budget;
      _travelStyle.addAll(travel.preferences.travelStyle);
      _maxCompanions = travel.maxCompanions;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? _startDate ?? DateTime.now()
          : _endDate ?? _startDate ?? DateTime.now(),
      firstDate: isStartDate ? DateTime.now() : _startDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          // Reset end date if it's before new start date
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final travel = Travel(
      id: widget.initialTravel?.id ?? '',
      title: _titleController.text,
      description: _descriptionController.text,
      destination: _destinationController.text,
      startDate: _startDate!,
      endDate: _endDate!,
      maxCompanions: _maxCompanions,
      currentCompanions: widget.initialTravel?.currentCompanions ?? [],
      preferences: TravelPreferences(
        activityLevel: _activityLevel,
        budget: _budget,
        travelStyle: _travelStyle,
      ),
      status: widget.initialTravel?.status ?? 'active',
      creatorId: widget.initialTravel?.creatorId ?? 'currentUserId',
      createdAt: widget.initialTravel?.createdAt ?? DateTime.now(),
    );

    try {
      if (widget.initialTravel != null) {
        await Provider.of<TravelProvider>(context, listen: false)
            .updateTravel(travel);
      } else {
        await Provider.of<TravelProvider>(context, listen: false)
            .createTravel(travel);
      }
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (error) {
      // Handle error
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.initialTravel != null ? 'Edit Travel' : 'Create New Travel'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  if (value.length < 5) {
                    return 'Title should be at least 5 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  if (value.length < 20) {
                    return 'Description should be at least 20 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _destinationController,
                decoration: const InputDecoration(
                  labelText: 'Destination',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a destination';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text('Start Date'),
                      subtitle: Text(
                        _startDate == null
                            ? 'Not set'
                            : _startDate!.toString().substring(0, 10),
                      ),
                      onTap: () => _selectDate(context, true),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('End Date'),
                      subtitle: Text(
                        _endDate == null
                            ? 'Not set'
                            : _endDate!.toString().substring(0, 10),
                      ),
                      onTap: () => _selectDate(context, false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _activityLevel,
                decoration: const InputDecoration(
                  labelText: 'Activity Level',
                  border: OutlineInputBorder(),
                ),
                items: _activityLevels
                    .map((level) => DropdownMenuItem(
                          value: level,
                          child: Text(level),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _activityLevel = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _budget,
                decoration: const InputDecoration(
                  labelText: 'Budget',
                  border: OutlineInputBorder(),
                ),
                items: _budgetOptions
                    .map((budget) => DropdownMenuItem(
                          value: budget,
                          child: Text(budget),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _budget = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              const Text('Travel Style', style: TextStyle(fontSize: 16)),
              Wrap(
                spacing: 8,
                children: _travelStyleOptions.map((style) {
                  return FilterChip(
                    label: Text(style),
                    selected: _travelStyle.contains(style),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _travelStyle.add(style);
                        } else {
                          _travelStyle.remove(style);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Maximum Companions: '),
                  Expanded(
                    child: Slider(
                      value: _maxCompanions.toDouble(),
                      min: 1,
                      max: 10,
                      divisions: 9,
                      label: _maxCompanions.toString(),
                      onChanged: (value) {
                        setState(() {
                          _maxCompanions = value.toInt();
                        });
                      },
                    ),
                  ),
                  Text(_maxCompanions.toString()),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitForm,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _isSubmitting
                      ? const CircularProgressIndicator()
                      : Text(
                          widget.initialTravel != null
                              ? 'Update Travel'
                              : 'Create Travel',
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
