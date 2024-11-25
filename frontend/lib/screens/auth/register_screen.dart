import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../app_theme.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _activityLevel = 'Medium';
  String _budget = 'Moderate';
  final List<String> _travelStyle = ['Adventure'];

  final List<String> _activityLevels = ['Low', 'Medium', 'High'];
  final List<String> _budgetOptions = ['Budget', 'Moderate', 'Luxury'];
  final List<String> _travelStyleOptions = [
    'Adventure',
    'Cultural',
    'Relaxation',
    'Food',
    'Nature'
  ];

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final result = await context.read<AuthProvider>().register(
      email: _emailController.text,
      password: _passwordController.text,
      name: _nameController.text,
      preferences: {
        'activityLevel': _activityLevel,
        'budget': _budget,
        'travelStyle': _travelStyle,
      },
    );

    if (!mounted) return;

    if (result['success']) {
      // Navigate to home screen
      // This will be handled by the auth state listener
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                Text(
                  'Create Account',
                  style: AppTheme.headline,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
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
                const SizedBox(height: 24),
                Consumer<AuthProvider>(
                  builder: (context, auth, child) {
                    return ElevatedButton(
                      onPressed: auth.isLoading ? null : _register,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                      child: auth.isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Register'),
                    );
                  },
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text('Already have an account? Login'),
                ),
              ],
            ),
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
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
