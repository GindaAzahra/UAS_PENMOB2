import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/buttons.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController cityController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: 'Nama Pengguna');
    emailController = TextEditingController(text: 'user@email.com');
    phoneController = TextEditingController(text: '+62 812 3456 7890');
    addressController = TextEditingController(text: 'Jl. Merdeka No. 123');
    cityController = TextEditingController(text: 'Jakarta Selatan');
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cityController.dispose();
    super.dispose();
  }

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
          'Edit Profil',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Picture
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: lightGrayColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Text('👤', style: TextStyle(fontSize: 50)),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Form Fields
            _buildTextField('Nama Lengkap', nameController),
            const SizedBox(height: 16),
            _buildTextField('Email', emailController),
            const SizedBox(height: 16),
            _buildTextField('Nomor Telepon', phoneController),
            const SizedBox(height: 16),
            _buildTextField('Alamat', addressController),
            const SizedBox(height: 16),
            _buildTextField('Kota', cityController),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Simpan Perubahan',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profil berhasil diperbarui!'),
                    backgroundColor: successColor,
                  ),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: lightGrayColor),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              hintStyle: const TextStyle(color: darkGrayColor),
            ),
          ),
        ),
      ],
    );
  }
}
