import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Card brand network detected from card number.
enum CardBrand { visa, mastercard, amex, discover, mada, generic }

/// An interactive 3D flippable credit/debit card widget.
///
/// ```dart
/// CreditCardWidget(
///   cardNumber: '4111 2222 3333 4444',
///   expiryDate: '12/28',
///   cardHolderName: 'NASHWAN TAHA',
///   cvv: '123',
///   showBack: _isCvvFocused,
/// )
/// ```
class CreditCardWidget extends StatelessWidget {
  const CreditCardWidget({
    super.key,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
    required this.cvv,
    this.showBack = false,
    this.bankName = 'BANK',
    this.gradient,
    this.backgroundColor,
    this.textColor = Colors.white,
    this.width = 320.0,
    this.height = 190.0,
    this.borderRadius,
    this.onTap,
  });

  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvv;
  final bool showBack;
  final String bankName;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Color textColor;
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  CardBrand get brand {
    final clean = cardNumber.replaceAll(RegExp(r'\s+'), '');
    if (clean.startsWith('4')) return CardBrand.visa;
    if (clean.startsWith(RegExp(r'^(5[1-5]|2[2-7])'))) {
      return CardBrand.mastercard;
    }
    if (clean.startsWith(RegExp(r'^(34|37)'))) return CardBrand.amex;
    if (clean.startsWith('6011')) return CardBrand.discover;
    if (clean.startsWith(RegExp(r'^(588845|440647|440795|446404)'))) {
      return CardBrand.mada;
    }
    return CardBrand.generic;
  }

  String get _formattedNumber {
    final clean = cardNumber.replaceAll(RegExp(r'\s+'), '');
    final buffer = StringBuffer();
    for (int i = 0; i < clean.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(clean[i]);
    }
    return buffer.isEmpty ? '•••• •••• •••• ••••' : buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final br = borderRadius ?? BorderRadius.circular(16);
    final bgGradient = gradient ??
        const LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

    return GestureDetector(
      onTap: onTap,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: showBack ? 1.0 : 0.0),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutBack,
        builder: (context, val, child) {
          final isBack = val >= 0.5;
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0015)
              ..rotateY(val * math.pi),
            alignment: Alignment.center,
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                gradient: backgroundColor == null ? bgGradient : null,
                color: backgroundColor,
                borderRadius: br,
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4)),
                ],
              ),
              child: isBack
                  ? Transform(
                      transform: Matrix4.identity()..rotateY(math.pi),
                      alignment: Alignment.center,
                      child: _buildBack(br),
                    )
                  : _buildFront(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFront() => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  bankName.toUpperCase(),
                  style: TextStyle(
                    color: textColor.withAlpha(200),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                _buildBrandBadge(),
              ],
            ),
            const Spacer(),
            // Chip simulation
            Container(
              width: 36,
              height: 26,
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _formattedNumber,
              style: TextStyle(
                color: textColor,
                fontSize: 17,
                fontWeight: FontWeight.w600,
                fontFamily: 'monospace',
                letterSpacing: 2,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CARD HOLDER',
                      style: TextStyle(
                          color: textColor.withAlpha(140),
                          fontSize: 9,
                          letterSpacing: 1),
                    ),
                    Text(
                      cardHolderName.isEmpty
                          ? 'YOUR NAME'
                          : cardHolderName.toUpperCase(),
                      style: TextStyle(
                          color: textColor,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'EXPIRES',
                      style: TextStyle(
                          color: textColor.withAlpha(140),
                          fontSize: 9,
                          letterSpacing: 1),
                    ),
                    Text(
                      expiryDate.isEmpty ? 'MM/YY' : expiryDate,
                      style: TextStyle(
                          color: textColor,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );

  Widget _buildBack(BorderRadius br) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          // Magnetic stripe
          Container(
            width: double.infinity,
            height: 38,
            color: Colors.black87,
          ),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 32,
                    color: Colors.white70,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      cvv.isEmpty ? '•••' : cvv,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Text(
              'This card is property of the issuing bank and must be returned upon request.',
              style: TextStyle(color: textColor.withAlpha(120), fontSize: 8),
            ),
          ),
        ],
      );

  Widget _buildBrandBadge() {
    String label = 'CARD';
    Color bg = Colors.white24;
    switch (brand) {
      case CardBrand.visa:
        label = 'VISA';
        bg = const Color(0xFF1A1F71);
        break;
      case CardBrand.mastercard:
        label = 'MC';
        bg = const Color(0xFFEB001B);
        break;
      case CardBrand.amex:
        label = 'AMEX';
        bg = const Color(0xFF006FCF);
        break;
      case CardBrand.mada:
        label = 'mada';
        bg = const Color(0xFF007A3D);
        break;
      default:
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(4)),
      child: Text(
        label,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
      ),
    );
  }
}
