import 'package:flutter/material.dart';

class TransactionScreen extends StatefulWidget {
  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final List<Map<String, String>> transactions = const [
    {
      'service': 'Moov Money',
      'amount': '2 500 F CFA',
      'date': '20 Avril 2025',
      'status': 'Réussi',
    },
    {
      'service': 'Mix by Yassir',
      'amount': '5 000 F CFA',
      'date': '18 Avril 2025',
      'status': 'Échoué',
    },
    {
      'service': 'Moov Money',
      'amount': '1 000 F CFA',
      'date': '15 Avril 2025',
      'status': 'En attente',
    },
    {
      'service': 'Moov Money',
      'amount': '2 500 F CFA',
      'date': '20 Avril 2025',
      'status': 'Réussi',
    },
    {
      'service': 'Mix by Yassir',
      'amount': '5 000 F CFA',
      'date': '18 Avril 2025',
      'status': 'Échoué',
    },
    {
      'service': 'Moov Money',
      'amount': '1 000 F CFA',
      'date': '15 Avril 2025',
      'status': 'En attente',
    },
    {
      'service': 'Moov Money',
      'amount': '2 500 F CFA',
      'date': '20 Avril 2025',
      'status': 'Réussi',
    },
    {
      'service': 'Mix by Yassir',
      'amount': '5 000 F CFA',
      'date': '18 Avril 2025',
      'status': 'Échoué',
    },
    {
      'service': 'Moov Money',
      'amount': '1 000 F CFA',
      'date': '15 Avril 2025',
      'status': 'En attente',
    },
  ];

  Icon _buildStatusIcon(String status) {
    switch (status) {
      case 'Réussi':
        return const Icon(Icons.check_circle, color: Colors.green);
      case 'Échoué':
        return const Icon(Icons.cancel, color: Colors.red);
      case 'En attente':
        return const Icon(Icons.hourglass_empty, color: Colors.orange);
      default:
        return const Icon(Icons.help_outline, color: Colors.grey);
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Réussi':
        return Colors.green;
      case 'Échoué':
        return Colors.red;
      case 'En attente':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(33, 150, 243, 1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'Sans',
            ),
            children: [
              TextSpan(
                text: 'e',
                style: TextStyle(color: Color.fromRGBO(33, 150, 243, 1)),
              ),
              TextSpan(text: 'tontine', style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Historique des transactions',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  final status = transaction['status'] ?? '';

                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: _buildStatusIcon(status),
                      title: Text(
                        transaction['service'] ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(transaction['date'] ?? ''),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            transaction['amount'] ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            status,
                            style: TextStyle(
                              color: _getStatusColor(status),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
