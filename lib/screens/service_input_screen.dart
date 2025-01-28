import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
import '../widgets/loading_spinner.dart';
import '../services/api_service.dart';

class ServiceInputScreen extends StatefulWidget {
  const ServiceInputScreen({super.key});

  @override
  State<ServiceInputScreen> createState() => _ServiceInputScreenState();
}

class _ServiceInputScreenState extends State<ServiceInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _serviceController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadLastServiceNumber();
  }

  Future<void> _loadLastServiceNumber() async {
    final prefs = await SharedPreferences.getInstance();
    final lastNumber = prefs.getString(AppConstants.lastServiceNumberKey);
    if (lastNumber != null) {
      _serviceController.text = lastNumber;
    }
  }

  Future<void> _saveServiceNumber(String number) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.lastServiceNumberKey, number);
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apiService = ApiService();
      
      // Add health check
      final isHealthy = await apiService.checkHealth();
      if (!isHealthy) {
        throw Exception('Server is not responding. Please try again later.');
      }

      final serviceNumber = _serviceController.text;
      await apiService.getServiceDetails(serviceNumber);
      await _saveServiceNumber(serviceNumber);
      
      if (mounted) {
        Navigator.pushReplacementNamed(
          context, 
          '/tracking',
          arguments: serviceNumber,
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isLoading
              ? const LoadingSpinner(message: 'Loading service details...')
              : Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _serviceController,
                        decoration: InputDecoration(
                          labelText: 'Enter Service Number',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a service number';
                          }
                          return null;
                        },
                      ),
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(color: AppColors.error),
                          ),
                        ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                        child: const Text('Track Service'),
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
    _serviceController.dispose();
    super.dispose();
  }
} 