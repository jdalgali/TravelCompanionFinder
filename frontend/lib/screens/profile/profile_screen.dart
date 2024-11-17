import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _profileImageController = TextEditingController();
  String _activityLevel = 'Medium';
  String _budget = 'Moderate';
  final List<String> _travelStyle = ['Adventure'];

  final logger = Logger();

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    if (user != null) {
      _nameController.text = user['name'] ?? '';
      _emailController.text = user['email'] ?? '';
      _profileImageController.text = user['profileImage'] ?? '';
      _activityLevel = user['preferences']?['activityLevel'] ?? 'Medium';
      _budget = user['preferences']?['budget'] ?? 'Moderate';
      _travelStyle.addAll(List<String>.from(
          user['preferences']?['travelStyle'] ?? ['Adventure']));
    }
    logger.d('ProfileScreen initialized with user: $user');
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final result = await context.read<AuthProvider>().updateProfile(
      name: _nameController.text,
      email: _emailController.text,
      password:
          _passwordController.text.isEmpty ? null : _passwordController.text,
      profileImage: _profileImageController.text.isEmpty
          ? null
          : _profileImageController.text,
      preferences: {
        'activityLevel': _activityLevel,
        'budget': _budget,
        'travelStyle': _travelStyle,
      },
    );

    if (!mounted) return;

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('Building ProfileScreen');
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value != null && value.isNotEmpty && value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _profileImageController,
                decoration:
                    const InputDecoration(labelText: 'Profile Image URL'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _activityLevel,
                decoration: const InputDecoration(
                  labelText: 'Activity Level',
                  border: OutlineInputBorder(),
                ),
                items: ['Low', 'Medium', 'High']
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
                items: ['Budget', 'Moderate', 'Luxury']
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
              Wrap(
                spacing: 8.0,
                children: ['Adventure', 'Relaxation', 'Cultural', 'Nature']
                    .map((style) => FilterChip(
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
                        ))
                    .toList(),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _updateProfile,
                child: const Text('Update Profile'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  await context.read<AuthProvider>().logout();
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _profileImageController.dispose();
    super.dispose();
  }
}
