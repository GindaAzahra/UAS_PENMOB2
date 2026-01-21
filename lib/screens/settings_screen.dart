import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;

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
          'Pengaturan',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Notification Settings
            Container(
              color: Colors.white,
              margin: const EdgeInsets.only(top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Notifikasi',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.notifications, color: primaryColor),
                    title: const Text(
                      'Aktifkan Notifikasi',
                      style: TextStyle(fontSize: 14, color: textColor),
                    ),
                    trailing: Switch(
                      value: notificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          notificationsEnabled = value;
                        });
                      },
                      activeColor: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Display Settings
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Tampilan',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.dark_mode, color: primaryColor),
                    title: const Text(
                      'Mode Gelap',
                      style: TextStyle(fontSize: 14, color: textColor),
                    ),
                    trailing: Switch(
                      value: darkModeEnabled,
                      onChanged: (value) {
                        setState(() {
                          darkModeEnabled = value;
                        });
                      },
                      activeColor: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Account Settings
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.security, color: primaryColor),
                    title: const Text(
                      'Ganti Password',
                      style: TextStyle(fontSize: 14, color: textColor),
                    ),
                    trailing: const Icon(Icons.chevron_right, color: darkGrayColor),
                    onTap: () {},
                  ),
                  Divider(color: lightGrayColor, height: 0),
                  ListTile(
                    leading: const Icon(Icons.delete_outline, color: errorColor),
                    title: const Text(
                      'Hapus Akun',
                      style: TextStyle(fontSize: 14, color: errorColor),
                    ),
                    trailing: const Icon(Icons.chevron_right, color: darkGrayColor),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Hapus Akun?'),
                          content: const Text(
                            'Tindakan ini tidak dapat dibatalkan. Semua data Anda akan dihapus.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Akun berhasil dihapus'),
                                    backgroundColor: errorColor,
                                  ),
                                );
                              },
                              child: const Text('Hapus', style: TextStyle(color: errorColor)),
                            ),
                          ],
                        ),
                      );
                    },
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
