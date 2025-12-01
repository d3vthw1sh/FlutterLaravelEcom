import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../logic/blocs/cart/cart_bloc.dart';
import '../../../logic/blocs/cart/cart_state.dart';
import '../../../logic/blocs/cart/cart_event.dart';
import '../../../logic/blocs/auth/auth_bloc.dart';
import '../../../logic/blocs/auth/auth_state.dart';
import '../../../data/services/stripe_service.dart';
import '../../../core/utils.dart';
import '../../widgets/app_appbar.dart';
import '../../widgets/checkout/checkout_form_field.dart';
import '../../widgets/checkout/order_summary_card.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _stripeService = StripeService();
  
  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  final _countryController = TextEditingController(text: 'Cambodia');
  
  bool _isLoading = false;
  final double _shippingCost = 5.00;

  @override
  void initState() {
    super.initState();
    _prefillUserData();
  }

  void _prefillUserData() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      _nameController.text = authState.user.username;
      _emailController.text = authState.user.email;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  Future<void> _processCheckout() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final cartState = context.read<CartBloc>().state;
    if (cartState is! CartLoaded || cartState.items.isEmpty) {
      AppUtils.showToast('Cart is empty');
      setState(() => _isLoading = false);
      return;
    }

    try {
      final authState = context.read<AuthBloc>().state;
      String? userId;
      if (authState is AuthAuthenticated) {
        userId = authState.user.id;
      }

      // Build order payload matching backend expectations
      final payload = {
        'cartItems': cartState.items.map((item) => {
          'id': item.id,
          'name': item.name,
          'price': item.price,
          'qty': item.qty,
          'image': item.image,
        }).toList(),
        'subtotal': cartState.total.toDouble(),
        'shippingCost': _shippingCost,
        'total': (cartState.total + _shippingCost).toDouble(),
        'customerInfo': {
          'userId': userId,
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
        },
        'shippingAddress': {
          'address': _addressController.text,
          'city': _cityController.text,
          'state': _stateController.text,
          'zipCode': _zipController.text,
          'country': _countryController.text,
        },
      };

      // Create checkout session (saves order to database)
      final response = await _stripeService.createCheckoutSession(payload);
      
      if (response['success'] == true && mounted) {
        // Clear the cart
        context.read<CartBloc>().add(ClearCart());
        
        // Navigate to success screen
        context.go('/success');
        
        AppUtils.showToast('Order placed successfully!');
      } else {
        throw Exception('Failed to place order');
      }
    } catch (e) {
      if (mounted) {
        AppUtils.showToast('Error: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartState = context.watch<CartBloc>().state;
    
    if (cartState is! CartLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final total = cartState.total + _shippingCost;

    return Scaffold(
      appBar: const AppAppBar(
        title: 'Checkout',
        showBack: true,
        showCart: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Contact Information'),
                    const SizedBox(height: 16),
                    CheckoutFormField(
                      label: 'Full Name',
                      controller: _nameController,
                      validator: (v) => v?.isEmpty == true ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    CheckoutFormField(
                      label: 'Email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => v?.isEmpty == true ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    CheckoutFormField(
                      label: 'Phone Number',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      validator: (v) => v?.isEmpty == true ? 'Required' : null,
                    ),
                    const SizedBox(height: 24),
                    
                    _buildSectionTitle('Shipping Address'),
                    const SizedBox(height: 16),
                    CheckoutFormField(
                      label: 'Address',
                      controller: _addressController,
                      validator: (v) => v?.isEmpty == true ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: CheckoutFormField(
                            label: 'City',
                            controller: _cityController,
                            validator: (v) => v?.isEmpty == true ? 'Required' : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CheckoutFormField(
                            label: 'State/Province',
                            controller: _stateController,
                            validator: (v) => v?.isEmpty == true ? 'Required' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: CheckoutFormField(
                            label: 'Zip Code',
                            controller: _zipController,
                            keyboardType: TextInputType.number,
                            validator: (v) => v?.isEmpty == true ? 'Required' : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CheckoutFormField(
                            label: 'Country',
                            controller: _countryController,
                            readOnly: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    OrderSummaryCard(
                      items: cartState.items,
                      subtotal: cartState.total.toDouble(),
                      shippingCost: _shippingCost,
                      total: total.toDouble(),
                    ),
                    const SizedBox(height: 32),
                    
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _processCheckout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Proceed to Payment',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
