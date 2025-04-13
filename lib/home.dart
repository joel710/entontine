import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color primaryColor = Color(0xFF5E2ECC);
  final Color secondaryColor = Color(0xFF956DFF);
  final Color backgroundColor = Color(0xFFF5F5F5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTopSection(),
              SizedBox(height: 16),
              _buildActionButtons(),
              SizedBox(height: 16),
              _buildServiceGrid(),
              SizedBox(height: 16),
              _buildPromoCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar et notification
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage('assets/images/avatar.png'),
              ),
              Icon(
                Icons.notifications_none,
                color: Colors.white,
                size: 28,
              ),
            ],
          ),
          SizedBox(height: 24),
          Text(
            "Available Balance",
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "\$450.54",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final buttons = [
      {'icon': Icons.arrow_downward_rounded, 'label': 'Top Up'},
      {'icon': Icons.send_rounded, 'label': 'Send'},
      {'icon': Icons.request_page_rounded, 'label': 'Request'},
      {'icon': Icons.history, 'label': 'History'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: buttons.map((btn) {
          return Column(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white,
                child: Icon(
                  btn['icon'] as IconData,
                  color: primaryColor,
                  size: 28,
                ),
              ),
              SizedBox(height: 8),
              Text(
                btn['label'] as String,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildServiceGrid() {
    final services = [
      {'icon': Icons.wifi, 'label': 'Internet'},
      {'icon': Icons.lightbulb_outline, 'label': 'Electricity'},
      {'icon': Icons.card_giftcard, 'label': 'Voucher'},
      {'icon': Icons.shield_outlined, 'label': 'Insurance'},
      {'icon': Icons.phone_android, 'label': 'Mobile'},
      {'icon': Icons.receipt_long, 'label': 'Bills'},
      {'icon': Icons.store_mall_directory, 'label': 'Merchant'},
      {'icon': Icons.more_horiz, 'label': 'More'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        itemCount: services.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (_, index) {
          final item = services[index];
          return Column(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white,
                child: Icon(
                  item['icon'] as IconData,
                  color: primaryColor,
                ),
              ),
              SizedBox(height: 8),
              Text(
                item['label'] as String,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 12),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPromoCard() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade50,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 6),
            )
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.local_offer_outlined,
              color: Colors.deepPurple,
              size: 40,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Special Offer for Today’s Top Up",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.deepPurple.shade800,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Get discount for every top up you make today!",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.deepPurple.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
