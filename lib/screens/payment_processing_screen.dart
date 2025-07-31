import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/donation.dart';
import '../viewmodels/donation_viewmodel.dart';
import '../core/app_localizations_patch.dart';
import 'donation_success_screen.dart';

/// Screen for processing donation payment
class PaymentProcessingScreen extends StatefulWidget {
  final DonationAmount selectedAmount;
  final PaymentMethod paymentMethod;

  const PaymentProcessingScreen({
    super.key,
    required this.selectedAmount,
    required this.paymentMethod,
  });

  @override
  State<PaymentProcessingScreen> createState() => _PaymentProcessingScreenState();
}

class _PaymentProcessingScreenState extends State<PaymentProcessingScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _progressController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _progressAnimation;
  
  bool _isProcessing = false;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _progressController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));
    
    _pulseController.repeat(reverse: true);
    
    // Start payment processing automatically
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _processPayment();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DonationViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Processing Payment'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false, // Prevent back navigation during processing
        ),
        body: Consumer<DonationViewModel>(
          builder: (context, viewModel, _) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildProcessingAnimation(),
                  const SizedBox(height: 40),
                  _buildStatusContent(),
                  const SizedBox(height: 40),
                  _buildProgressIndicator(),
                  const SizedBox(height: 60),
                  if (_hasError) _buildRetryButton(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Build processing animation
  Widget _buildProcessingAnimation() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _hasError ? 1.0 : _pulseAnimation.value,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _hasError 
                    ? [Colors.red.shade300, Colors.red.shade500]
                    : _isProcessing
                        ? [Colors.blue.shade300, Colors.blue.shade500]
                        : [Colors.green.shade300, Colors.green.shade500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (_hasError ? Colors.red : Colors.blue).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              _hasError 
                  ? Icons.error_outline
                  : _isProcessing 
                      ? Icons.credit_card
                      : Icons.check,
              color: Colors.white,
              size: 60,
            ),
          ),
        );
      },
    );
  }

  /// Build status content
  Widget _buildStatusContent() {
    return Column(
      children: [
        Text(
          _hasError 
              ? 'Payment Failed'
              : _isProcessing 
                  ? 'Processing Payment...'
                  : 'Payment Successful!',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: _hasError 
                ? Colors.red.shade600
                : _isProcessing 
                    ? Colors.grey[800]
                    : Colors.green.shade600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        if (_hasError && _errorMessage != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Text(
              _errorMessage!,
              style: TextStyle(
                color: Colors.red.shade700,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  'Donating: ${widget.selectedAmount.formattedAmount}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.local_hospital, 
                         color: Colors.red.shade400, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.selectedAmount.formattedHospiceAmount} → Hospice',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.phone_android, 
                         color: Colors.blue.shade400, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.selectedAmount.formattedAppAmount} → App',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }

  /// Build progress indicator
  Widget _buildProgressIndicator() {
    if (_hasError || !_isProcessing) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        AnimatedBuilder(
          animation: _progressAnimation,
          builder: (context, child) {
            return LinearProgressIndicator(
              value: _progressAnimation.value,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade500),
              minHeight: 6,
            );
          },
        ),
        const SizedBox(height: 16),
        Text(
          'Please wait while we securely process your payment...',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Build retry button
  Widget _buildRetryButton() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _processPayment,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade500,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh, size: 20),
                SizedBox(width: 8),
                Text(
                  'Try Again',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  /// Process the payment
  Future<void> _processPayment() async {
    setState(() {
      _isProcessing = true;
      _hasError = false;
      _errorMessage = null;
    });

    _progressController.reset();
    _progressController.forward();

    try {
      final viewModel = Provider.of<DonationViewModel>(context, listen: false);

      // Step 1: Create donation
      final donationCreated = await viewModel.createDonation(
        amount: widget.selectedAmount,
        paymentMethod: widget.paymentMethod,
        userEmail: null, // Will be filled by the service
      );

      if (!donationCreated) {
        throw Exception(viewModel.errorMessage ?? 'Failed to create donation');
      }

      final donation = viewModel.currentDonation!;

      // Step 2: Process payment
      final paymentSuccess = await viewModel.processPayment(
        donationId: donation.id,
        paymentDetails: {
          'amount': widget.selectedAmount.amount,
          'currency': 'EUR',
          'paymentMethod': widget.paymentMethod.name,
        },
      );

      if (!paymentSuccess) {
        throw Exception(viewModel.errorMessage ?? 'Payment processing failed');
      }

      // Step 3: Wait for completion and navigate to success
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => DonationSuccessScreen(
              donation: donation.copyWith(status: DonationStatus.completed),
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ PaymentProcessingScreen: Payment failed: $e');
      
      setState(() {
        _isProcessing = false;
        _hasError = true;
        _errorMessage = e.toString();
      });

      _pulseController.stop();
      _progressController.stop();
    }
  }
}
