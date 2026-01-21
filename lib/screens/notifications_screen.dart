import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/advanced_widgets.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<NotificationModel> notifications = [
    NotificationModel(
      id: 1,
      title: 'Pesanan Tiba',
      message: 'Pesanan Anda #ORD001 telah tiba',
      time: '10 menit yang lalu',
      type: 'order',
      icon: '📦',
      isRead: false,
    ),
    NotificationModel(
      id: 2,
      title: 'Promo Spesial',
      message: 'Dapatkan diskon 30% untuk pesanan berikutnya',
      time: '1 jam yang lalu',
      type: 'promo',
      icon: '🎉',
      isRead: false,
    ),
    NotificationModel(
      id: 3,
      title: 'Pesanan Dikonfirmasi',
      message: 'Pesanan Anda #ORD002 telah dikonfirmasi oleh restoran',
      time: '2 jam yang lalu',
      type: 'order',
      icon: '✅',
      isRead: true,
    ),
    NotificationModel(
      id: 4,
      title: 'Review Diterima',
      message: 'Terima kasih untuk review Anda tentang Nasi Goreng Spesial',
      time: '1 hari yang lalu',
      type: 'review',
      icon: '⭐',
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: primaryColor),
        ),
        title: const Text(
          'Notifikasi',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          if (notifications.any((n) => !n.isRead))
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      for (var notif in notifications) {
                        notif.isRead = true;
                      }
                    });
                  },
                  child: const Text('Tandai Semua'),
                ),
              ),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? EmptyStateWidget(
              emoji: '🔔',
              title: 'Tidak Ada Notifikasi',
              subtitle: 'Anda akan menerima notifikasi untuk pesanan dan promo',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notif = notifications[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      notif.isRead = true;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: notif.isRead ? Colors.white : primaryColor.withAlpha(26),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: notif.isRead ? lightGrayColor : Colors.transparent,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(13),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: lightGrayColor,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Text(notif.icon, style: const TextStyle(fontSize: 24)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      notif.title,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: textColor,
                                        fontStyle: !notif.isRead ? FontStyle.italic : FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                  if (!notif.isRead)
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                notif.message,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: darkGrayColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                notif.time,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: darkGrayColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class NotificationModel {
  final int id;
  final String title;
  final String message;
  final String time;
  final String type;
  final String icon;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    required this.icon,
    this.isRead = false,
  });
}
