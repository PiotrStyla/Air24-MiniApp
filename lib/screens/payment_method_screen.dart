import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/donation.dart';
import '../viewmodels/donation_viewmodel.dart';
import '../core/app_localizations_patch.dart';
import 'payment_processing_screen.dart';

/// Screen for selecting payment method for donation
class PaymentMethodScreen extends StatefulWidget {
  final DonationAmount selectedAmount;

  const PaymentMethodScreen({
    super.key,
    required this.selectedAmount,
  });

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen>
    with SingleTickerProviderStateMixin {
  PaymentMethod? _selectedPaymentMethod;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DonationViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.paymentMethod),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Consumer<DonationViewModel>(
          builder: (context, viewModel, _) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDonationSummary(),
                    const SizedBox(height: 32),
                    _buildPaymentMethodSelection(),
                    const SizedBox(height: 40),
                    _buildActionButtons(),
                    const SizedBox(height: 24),
                    _buildSecurityInfo(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Build donation summary card
  Widget _buildDonationSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.purple.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.favorite, color: Colors.blue.shade600),
              const SizedBox(width: 8),
              Text(
                context.l10n.donationSummary,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSummaryRow(
            context.l10n.totalDonation,
            widget.selectedAmount.formattedAmount,
            isTotal: true,
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            '→ ${context.l10n.hospiceFoundation}',
            widget.selectedAmount.formattedHospiceAmount,
            icon: Icons.local_hospital,
            color: Colors.red.shade400,
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            '→ ${context.l10n.appDevelopment}',
            widget.selectedAmount.formattedAppAmount,
            icon: Icons.phone_android,
            color: Colors.blue.shade400,
          ),
        ],
      ),
    );
  }

  /// Build summary row
  Widget _buildSummaryRow(
    String label,
    String amount, {
    IconData? icon,
    Color? color,
    bool isTotal = false,
  }) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
              color: isTotal ? Colors.grey[800] : Colors.grey[700],
            ),
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: FontWeight.bold,
            color: isTotal ? Colors.blue.shade700 : (color ?? Colors.grey[700]),
          ),
        ),
      ],
    );
  }

  /// Build payment method selection
  Widget _buildPaymentMethodSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.choosePaymentMethod,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
        _buildPaymentMethodCard(
          method: PaymentMethod.card,
          icon: Icons.credit_card,
          title: context.l10n.creditDebitCard,
          subtitle: context.l10n.visaMastercardAmex,
          color: Colors.blue.shade500,
        ),
        const SizedBox(height: 12),
        _buildPaymentMethodCard(
          method: PaymentMethod.paypal,
          icon: Icons.account_balance_wallet,
          title: 'PayPal',
          subtitle: context.l10n.payWithPayPalAccount,
          color: Colors.orange.shade500,
        ),
        const SizedBox(height: 12),
        _buildPaymentMethodCard(
          method: PaymentMethod.applePay,
          icon: Icons.phone_iphone,
          title: 'Apple Pay',
          subtitle: context.l10n.touchIdOrFaceId,
          color: Colors.grey.shade800,
          isAvailable: Theme.of(context).platform == TargetPlatform.iOS,
        ),
        const SizedBox(height: 12),
        _buildPaymentMethodCard(
          method: PaymentMethod.googlePay,
          icon: Icons.android,
          title: 'Google Pay',
          subtitle: context.l10n.quickAndSecure,
          color: Colors.green.shade500,
          isAvailable: Theme.of(context).platform == TargetPlatform.android,
        ),
      ],
    );
  }

  /// Build payment method card
  Widget _buildPaymentMethodCard({
    required PaymentMethod method,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    bool isAvailable = true,
  }) {
    final isSelected = _selectedPaymentMethod == method;
    
    return Opacity(
      opacity: isAvailable ? 1.0 : 0.5,
      child: GestureDetector(
        onTap: isAvailable ? () {
          setState(() {
            _selectedPaymentMethod = method;
          });
        } : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected 
                    ? color.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.1),
                blurRadius: isSelected ? 8 : 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isAvailable ? subtitle : 'Not available on this device',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: color,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build action buttons
  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _selectedPaymentMethod != null ? _onContinue : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade500,
              foregroundColor: Colors.white,
              elevation: _selectedPaymentMethod != null ? 8 : 0,
              shadowColor: Colors.blue.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock, size: 20),
                const SizedBox(width: 8),
                Text(
                  _selectedPaymentMethod != null 
                      ? context.l10n.continueToPayment
                      : context.l10n.selectAPaymentMethod,
                  style: const TextStyle(
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
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Back',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  /// Build security information
  Widget _buildSecurityInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.security, color: Colors.green.shade600, size: 20),
              const SizedBox(width: 8),
              Text(
                context.l10n.securePayment,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.paymentSecurityInfo,
            style: TextStyle(
              fontSize: 14,
              color: Colors.green.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.receipt, color: Colors.green.shade600, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  context.l10n.taxReceiptEmail,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green.shade600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Handle continue button press
  void _onContinue() {
    if (_selectedPaymentMethod == null) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PaymentProcessingScreen(
          selectedAmount: widget.selectedAmount,
          paymentMethod: _selectedPaymentMethod!,
        ),
      ),
    );
  }
}
