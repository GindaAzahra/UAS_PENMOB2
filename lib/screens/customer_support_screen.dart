import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CustomerSupportScreen extends StatefulWidget {
  const CustomerSupportScreen({super.key});

  @override
  State<CustomerSupportScreen> createState() => _CustomerSupportScreenState();
}

class _CustomerSupportScreenState extends State<CustomerSupportScreen> {
  final TextEditingController _messageController = TextEditingController();
  late List<Map<String, dynamic>> messages = [
    {
      'id': 1,
      'message': 'Halo, ada yang bisa kami bantu?',
      'isUser': false,
      'time': '10:00',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
    },
    {
      'id': 2,
      'message': 'Halo, makanannya kok belum sampai ya?',
      'isUser': true,
      'time': '10:02',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 3)),
    },
    {
      'id': 3,
      'message': 'Mohon maaf atas keterlambatan. Driver sedang dalam perjalanan. Estimasi sampai 5 menit lagi',
      'isUser': false,
      'time': '10:03',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 2)),
    },
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      messages.add({
        'id': messages.length + 1,
        'message': _messageController.text,
        'isUser': true,
        'time': DateTime.now().hour.toString().padLeft(2, '0') +
            ':' +
            DateTime.now().minute.toString().padLeft(2, '0'),
        'timestamp': DateTime.now(),
      });
      _messageController.clear();

      // Simulate response
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            messages.add({
              'id': messages.length + 1,
              'message': 'Terima kasih atas pertanyaannya. Tim kami sedang memproses...',
              'isUser': false,
              'time': DateTime.now().hour.toString().padLeft(2, '0') +
                  ':' +
                  DateTime.now().minute.toString().padLeft(2, '0'),
              'timestamp': DateTime.now(),
            });
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Layanan Pelanggan',
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
      ),
      body: Column(
        children: [
          // Header Info
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Center(
                    child: Text('🤖', style: TextStyle(fontSize: 32)),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Aliya Support Assistant',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: successColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '● Online',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: successColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0),

          // Chat Messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUser = message['isUser'] as bool;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment:
                        isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (!isUser)
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: Text('🤖', style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isUser ? primaryColor : lightGrayColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: isUser
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                message['message'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isUser ? Colors.white : textColor,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                message['time'],
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isUser
                                      ? Colors.white.withOpacity(0.7)
                                      : darkGrayColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (isUser) const SizedBox(width: 8),
                    ],
                  ),
                );
              },
            ),
          ),

          // Quick Replies (Optional)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _QuickReplyButton('Lagi dimana pesanan saya?', _messageController),
                _QuickReplyButton('Bagaimana cara refund?', _messageController),
                _QuickReplyButton('Hubungi seller', _messageController),
              ],
            ),
          ),

          // Message Input
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Ketik pesan...',
                      hintStyle: const TextStyle(color: darkGrayColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: lightGrayColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: lightGrayColor),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickReplyButton extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const _QuickReplyButton(this.label, this.controller);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.text = label;
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.1),
          border: Border.all(color: primaryColor.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
