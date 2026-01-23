import 'package:flutter/material.dart';
import '../utils/constants.dart';

class NotificationCenterScreen extends StatefulWidget {
  const NotificationCenterScreen({super.key});

  @override
  State<NotificationCenterScreen> createState() => _NotificationCenterScreenState();
}

class _NotificationCenterScreenState extends State<NotificationCenterScreen> {
  late List<Map<String, dynamic>> notifications;
  String selectedTab = 'all';

  @override
  void initState() {
    super.initState();
    notifications = List.from(dummyNotifications);
  }

  void markAsRead(int index) {
    setState(() {
      notifications[index]['isRead'] = true;
    });
  }

  void deleteNotification(int index) {
    setState(() {
      notifications.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notifikasi dihapus'),
        backgroundColor: primaryColor,
      ),
    );
  }

  List<Map<String, dynamic>> get filteredNotifications {
    if (selectedTab == 'all') return notifications;
    return notifications.where((n) => (n['type'] as String).toLowerCase() == selectedTab.toLowerCase()).toList();
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = notifications.where((n) => !n['isRead']).length;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Notifikasi',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (unreadCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: errorColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$unreadCount baru',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Tab Filter
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterTab(
                    label: 'Semua',
                    isActive: selectedTab == 'all',
                    onTap: () => setState(() => selectedTab = 'all'),
                  ),
                  _FilterTab(
                    label: 'Pesanan',
                    isActive: selectedTab == 'pesanan',
                    onTap: () => setState(() => selectedTab = 'pesanan'),
                  ),
                  _FilterTab(
                    label: 'Promo',
                    isActive: selectedTab == 'promo',
                    onTap: () => setState(() => selectedTab = 'promo'),
                  ),
                  _FilterTab(
                    label: 'Reward',
                    isActive: selectedTab == 'reward',
                    onTap: () => setState(() => selectedTab = 'reward'),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 0),

          // Notifications List
          Expanded(
            child: filteredNotifications.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_none,
                          size: 80,
                          color: lightGrayColor,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Tidak ada notifikasi',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: darkGrayColor,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(8),
                    itemCount: filteredNotifications.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final notif = filteredNotifications[index];
                      final globalIndex = notifications.indexOf(notif);
                      return _NotificationItem(
                        notification: notif,
                        isUnread: !notif['isRead'],
                        onTap: () => markAsRead(globalIndex),
                        onDismiss: () => deleteNotification(globalIndex),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterTab extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterTab({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? primaryColor : lightGrayColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.white : darkGrayColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final Map<String, dynamic> notification;
  final bool isUnread;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _NotificationItem({
    required this.notification,
    required this.isUnread,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(notification['id']),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        onDismiss();
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.red,
        ),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isUnread ? primaryColor.withValues(alpha: 0.05) : Colors.white,
            border: Border.all(
              color: isUnread ? primaryColor.withValues(alpha: 0.2) : lightGrayColor,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notification Image
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: lightGrayColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        notification['image'] as String,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.image_not_supported);
                        },
                      ),
                    ),
                    if (isUnread)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Notification Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            notification['title'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight:
                                  isUnread ? FontWeight.bold : FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                        ),
                        Text(
                          notification['icon'] as String,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification['message'] as String,
                      style: const TextStyle(
                        fontSize: 11,
                        color: darkGrayColor,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          notification['time'] as String,
                          style: TextStyle(
                            fontSize: 10,
                            color: darkGrayColor.withValues(alpha: 0.7),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: _getTypeColor(notification['type'] as String),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            notification['type'] as String,
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'pesanan':
        return primaryColor;
      case 'promo':
        return accentColor;
      case 'ulasan':
        return Colors.orange;
      case 'reward':
        return Colors.green;
      case 'restoran':
        return secondaryColor;
      default:
        return primaryColor;
    }
  }
}

