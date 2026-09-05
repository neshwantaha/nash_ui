import 'package:nash_ui/nash_ui.dart';
import 'showcase_page.dart';

class CreativeCardsPage extends StatelessWidget {
  const CreativeCardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'Creative Cards',
      icon: Icons.style_rounded,
      sections: [
        // ── 3D Flippable Credit Card ───────────────────────────────────
        ShowcaseSection(
          title: 'CreditCardWidget (3D Interactive Flip)',
          children: const [
            Text(
              'Tap to flip between front (chip, brand detector) and back (magnetic strip, CVV).',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 16),
            CreditCardWidget(
              cardNumber: '4532 8921 4321 9081',
              cardHolderName: 'NESHWAN DEV',
              expiryDate: '08/29',
              cvv: '782',
            ),
          ],
        ),

        // ── Boarding Pass & Event Ticket ───────────────────────────────
        ShowcaseSection(
          title: 'BoardingPassCard (Ticket & Cutout Notches)',
          children: const [
            Text(
              'Perforated flight boarding pass with ticket stub divider and barcode.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 16),
            BoardingPassCard(
              originCode: 'RUH',
              originCity: 'Riyadh, SA',
              destinationCode: 'DXB',
              destinationCity: 'Dubai, UAE',
              passengerName: 'NESHWAN / MR',
              flightNumber: 'SV 552',
              gate: 'B12',
              seat: '04A (First)',
              departureTime: '08:45 AM',
              boardingTime: '08:15 AM',
            ),
          ],
        ),

        // ── Glassmorphism ──────────────────────────────────────────────
        ShowcaseSection(
          title: 'GlassmorphicContainer (Frosted Glass)',
          children: [
            const Text(
              'Real-time backdrop blur filter with gradient border highlight.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Stack(
              alignment: Alignment.center,
              children: [
                // Colorful background blobs
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                            color: Colors.deepPurple, shape: BoxShape.circle)),
                    Container(
                        width: 90,
                        height: 90,
                        decoration: const BoxDecoration(
                            color: Colors.amber, shape: BoxShape.circle)),
                    Container(
                        width: 70,
                        height: 70,
                        decoration: const BoxDecoration(
                            color: Colors.cyan, shape: BoxShape.circle)),
                  ],
                ),
                GlassmorphicContainer(
                  width: double.infinity,
                  borderRadius: 16,
                  blur: 20,
                  child: const Column(
                    children: [
                      Icon(Icons.auto_awesome, color: Colors.amber, size: 28),
                      SizedBox(height: 6),
                      Text('Glassmorphism Container',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Subtle reflection and high-fidelity blur filter',
                          style: TextStyle(fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),

        // ── 3D Parallax Card ───────────────────────────────────────────
        ShowcaseSection(
          title: 'ParallaxCard (Pointer Tilt Effect)',
          children: const [
            Text(
              'Hover with mouse or drag touch to experience realistic 3D perspective depth.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 16),
            Center(
              child: SizedBox(
                width: 280,
                height: 140,
                child: ParallaxCard(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.view_in_ar, size: 36, color: Colors.white),
                        SizedBox(height: 8),
                        Text('Interactive 3D Tilt',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        // ── Corner Ribbon Card ─────────────────────────────────────────
        ShowcaseSection(
          title: 'CornerRibbon',
          children: const [
            Text(
              'Diagonal corner banner for sales, status or featured badges.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 16),
            CornerRibbon(
              text: 'SALE 50%',
              color: Colors.redAccent,
              child: SizedBox(
                width: double.infinity,
                height: 100,
                child: Center(
                  child: Text('Product Item with Corner Ribbon',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        ),

        // ── Scratch To Reveal Card ─────────────────────────────────────
        ShowcaseSection(
          title: 'ScratchCard',
          children: const [
            Text(
              'Interactive scratch surface using custom drawing.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 16),
            Center(
              child: SizedBox(
                width: 260,
                height: 120,
                child: ScratchCard(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.card_giftcard,
                            color: Colors.green, size: 32),
                        SizedBox(height: 4),
                        Text('🎁 Promo Code: NASH2026',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
