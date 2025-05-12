import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/api_service.dart';
import 'dart:convert';

import 'profil.dart';

class HomeScreen extends StatefulWidget {
  final String token;
  const HomeScreen({super.key, required this.token});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color primaryColor = Color.from(
    alpha: 1,
    red: 0.129,
    green: 0.588,
    blue: 0.953,
  );
  final Color secondaryColor = Color.from(
    alpha: 1,
    red: 0.129,
    green: 0.588,
    blue: 0.953,
  );
  final Color backgroundColor = Color(0xFFF5F5F5);

  late Future<Map<String, dynamic>> dashboardFuture;

  @override
  void initState() {
    super.initState();
    dashboardFuture = fetchDashboard();
  }

  Future<Map<String, dynamic>> fetchDashboard() async {
    final response = await ApiService.getDashboard(widget.token);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur lors du chargement du dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: dashboardFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erreur : \\${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('Aucune donnée trouvée.'));
            }
            final data = snapshot.data!;
            final balance = data['balance']?.toString() ?? '0 CFA';
            final transactions = data['transactions'] ?? [];
            return SingleChildScrollView(
          child: Column(
            children: [
                  _buildTopSection(balance),
              SizedBox(height: 16),
              _buildPromoCard(),
              SizedBox(height: 16),
                  _buildRecentTransactions(transactions),
              SizedBox(height: 16),
              _buildReferralSection(),
              SizedBox(height: 16),
            ],
          ),
            );
          },
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildTopSection(String balance) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar et notification
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilScreen(token: widget.token)),
                      );
                    },
                    child: CircleAvatar(
                      radius: 24,
                      backgroundImage: AssetImage('assets/images/avatar.png'),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.notifications_none,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/notification',
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 24),
              Text(
                "Balance",
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 6),
              Text(
                balance,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 24),
              SizedBox(height: 40),
            ],
          ),
        ),
        Positioned(
          bottom: -30,
          left: 20,
          right: 20,
          child: _buildActionButtons(),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    final buttons = [
      {'icon': Icons.account_balance_wallet, 'label': 'Dépôt'},
      {'icon': Icons.compare_arrows, 'label': 'Transfert'},
      {'icon': Icons.history, 'label': 'Historique'},
      {'icon': Icons.more_horiz, 'label': 'Plus'},
    ];

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children:
            buttons.map((btn) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: primaryColor.withAlpha((0.1 * 255).toInt()),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      btn['icon'] as IconData,
                      color: primaryColor,
                      size: 24,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    btn['label'] as String,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }).toList(),
      ),
    );
  }

  Widget _buildPromoCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 232, 240, 247),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "1000 Days !",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color.from(
                  alpha: 1,
                  red: 0.129,
                  green: 0.588,
                  blue: 0.953,
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Chaque mois, gagne une surprise avec etontine.",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Color.fromARGB(255, 128, 192, 245),
              ),
            ),
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  "Réclame ta surprise maintenant",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactions(List<dynamic> transactions) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Transactions récentes",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 12),
          ...transactions.take(3).map((transaction) => Container(
            margin: EdgeInsets.only(bottom: 8),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      transaction['date'] ?? '',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      transaction['amount'] ?? '',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        transaction['service'] ?? '',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
          if (transactions.isNotEmpty)
          Center(
            child: Text(
              "Voir plus",
              style: GoogleFonts.poppins(
                color: primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReferralSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.amber.shade50,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.share, color: Colors.amber.shade700, size: 40),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Partagez etontine avec vos proches",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.amber.shade800,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Partagez etontine avec vos amis et gagnez plein de lots",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.amber.shade700,
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

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/mes-tontines');
            break;
          case 1:
            Navigator.pushNamed(context, '/payement');
            break;
          case 2:
            Navigator.pushNamed(context, '/transactions');
            break;
          case 3:
            Navigator.pushNamed(context, '/retrait');
            break;
          case 4:
            Navigator.pushNamed(context, '/support');
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.credit_card),
          label: 'Mes Tontine',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.compare_arrows),
          label: 'Dépôt',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'Trasactions',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag),
          label: 'Retrait',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.headset_mic),
          label: 'Support',
        ),
      ],
    );
  }
}
