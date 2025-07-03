import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'services/api_service.dart';
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationsScreen extends StatefulWidget {
  final String token;
  const NotificationsScreen({Key? key, required this.token}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late Future<List<dynamic>> notificationsFuture;

  @override
  void initState() {
    super.initState();
    notificationsFuture = fetchNotifications();
  }

  Future<List<dynamic>> fetchNotifications() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return [];
    final notifications = await Supabase.instance.client
        .from('notifications')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false)
        .limit(20);
    return notifications;
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color.from(
      alpha: 1,
      red: 0.129,
      green: 0.588,
      blue: 0.953,
    );
    final Color secondaryColor = const Color.from(
      alpha: 1,
      red: 0.129,
      green: 0.588,
      blue: 0.953,
    );
    final Color backgroundColor = Color(0xFFF5F5F5);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 254, 255, 255),
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
      body: FutureBuilder<List<dynamic>>(
        future: notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : \\${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucune notification trouvée.'));
          }
          final notifications = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.only(top: 8),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              final date =
                  DateTime.tryParse(notification['date'] ?? '') ??
                  DateTime.now();
              final dateFormat = DateFormat(
                'EEEE, d MMMM y à HH:mm:ss',
                'fr_FR',
              );
              final formattedDate = dateFormat.format(date);
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16, top: 16),
                      child: Text(
                        notification['title'] ?? '',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color:
                              notification['isRead'] == true
                                  ? Colors.grey[600]
                                  : primaryColor,
                        ),
                      ),
                    ),
                    if (notification['subtitle'] != null)
                      Padding(
                        padding: EdgeInsets.only(left: 16, top: 4),
                        child: Text(
                          notification['subtitle'],
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    if (notification['message'] != null)
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                        child: Text(
                          notification['message'],
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
            },
          );
        },
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

Future<void> fetchNotifications(String token) async {
  final response = await ApiService.getNotifications(token);
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print('Notifications : ' + data.toString());
  } else {
    print(
      'Erreur lors de la récupération des notifications : ' + response.body,
    );
  }
}
