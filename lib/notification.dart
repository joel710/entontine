import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class NotificationsScreen extends StatelessWidget {
  final Color primaryColor = Color(0xFF5E2ECC);
  final Color secondaryColor = Color(0xFF956DFF);
  final Color backgroundColor = Color(0xFFF5F5F5);

  final List<NotificationItem> notifications = [
    NotificationItem(
      title: "Maintenance terminée",
      message:
          "Cher utilisateur, nous vous informons que la maintenance du système est terminée et que vous pouvez maintenant reprendre l'utilisation de l'application. Merci pour votre collaboration.",
      date: DateTime(2025, 4, 16, 16, 43, 22),
      isRead: false,
      hasCheckbox: true,
    ),
    NotificationItem(
      title: "Test 2",
      subtitle: "etontine",
      date: DateTime(2025, 4, 14, 15, 38, 6),
      isRead: true,
    ),
    NotificationItem(
      title: "etontine Test",
      subtitle: "Test",
      date: DateTime(2025, 4, 14, 15, 9, 49),
      isRead: true,
    ),
    NotificationItem(
      title: "Maintenance planifiée",
      message:
          "Cher utilisateur, nous effectuerons une maintenance ce 15 avril 2025 à 23h GMT pour améliorer votre expérience. La maintenance ne devrait pas durer plus d'une heure. Nous vous notifierons dès la fin des opérations. Merci pour votre compréhension.",
      date: DateTime(2025, 4, 14, 14, 9, 20),
      isRead: true,
      hasCheckbox: true,
      isChecked: true,
    ),
    NotificationItem(
      title: "Bonne fête des Rameaux !",
      message:
          "En ce jour de paix et d'espérance, etontine vous souhaite une belle célébration remplie de sérénité et de bénédictions.",
      date: DateTime(2025, 4, 14),
      isRead: true,
      hasCheckbox: true,
      isChecked: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 103, 95, 221),
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: EdgeInsets.only(top: 8),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return _buildNotificationCard(notification, index);
        },
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification, int index) {
    // Index ajouté en paramètre
    final dateFormat = DateFormat('EEEE, d MMMM y à HH:mm:ss', 'fr_FR');
    final formattedDate = dateFormat.format(notification.date);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // Correction de la syntaxe ici
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (notification.hasCheckbox)
            Padding(
              padding: EdgeInsets.only(left: 16, top: 16),
              child: Row(
                children: [
                  Checkbox(
                    value: notification.isChecked ?? false,
                    onChanged: (value) {},
                    activeColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    notification.title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color:
                          notification.isRead ? Colors.grey[600] : primaryColor,
                    ),
                  ),
                ],
              ),
            )
          else
            Padding(
              padding: EdgeInsets.only(left: 16, top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color:
                          notification.isRead ? Colors.grey[600] : primaryColor,
                    ),
                  ),
                  if (notification.subtitle != null)
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        notification.subtitle!,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                ],
              ),
            ),

          if (notification.message != null)
            Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Text(
                notification.message!,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[800],
                ),
              ),
            ),

          Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Text(
              formattedDate,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[500],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),

          if (index < notifications.length - 1)
            Divider(height: 1, color: Colors.grey[200]),
        ],
      ),
    );
  }
}

class NotificationItem {
  final String title;
  final String? subtitle;
  final String? message;
  final DateTime date;
  final bool isRead;
  final bool hasCheckbox;
  final bool? isChecked;

  NotificationItem({
    required this.title,
    this.subtitle,
    this.message,
    required this.date,
    this.isRead = false,
    this.hasCheckbox = false,
    this.isChecked,
  });
}
