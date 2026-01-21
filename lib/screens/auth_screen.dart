import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../utils/constants.dart';
import '../widgets/buttons.dart';
import '../widgets/form_widgets.dart';
import '../services/validation_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  final formKey = GlobalKey<FormState>();
  bool showPassword = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void handleLogin() {
    if (formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      
      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        setState(() => isLoading = false);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login berhasil!'),
            backgroundColor: successColor,
          ),
        );
        
        Navigator.pushReplacementNamed(context, '/home');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                height: 200,
                decoration: const BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                          child: Text('🍲', style: TextStyle(fontSize: 40)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'ALIYA DIVANI',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Masuk ke Akun Anda',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Selamat datang kembali! Silakan masuk untuk melanjutkan',
                      style: TextStyle(
                        fontSize: 14,
                        color: darkGrayColor,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Email Field
                    CustomTextFormField(
                      controller: emailController,
                      label: 'Email',
                      hintText: 'Masukkan email Anda',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,
                      validator: ValidationService.validateEmail,
                    ),
                    const SizedBox(height: 16),
                    // Password Field
                    StatefulBuilder(
                      builder: (context, setState) => CustomTextFormField(
                        controller: passwordController,
                        label: 'Password',
                        hintText: 'Masukkan password Anda',
                        obscureText: !showPassword,
                        prefixIcon: Icons.lock_outlined,
                        suffixIcon: showPassword ? Icons.visibility : Icons.visibility_off,
                        onSuffixTap: () => setState(() => showPassword = !showPassword),
                        validator: ValidationService.validatePassword,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Fitur reset password akan datang'),
                            ),
                          );
                        },
                        child: const Text(
                          'Lupa Password?',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Login Button
                    PrimaryButton(
                      label: isLoading ? 'Sedang Masuk...' : 'Masuk',
                      onPressed: isLoading ? () {} : handleLogin,
                    ),
                    const SizedBox(height: 16),
                    // Sign Up Link
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: 'Belum punya akun? ',
                          style: const TextStyle(
                            fontSize: 12,
                            color: darkGrayColor,
                          ),
                          children: [
                            TextSpan(
                              text: 'Daftar di sini',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: primaryColor,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterScreen(),
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
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
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  
  final formKey = GlobalKey<FormState>();
  bool showPassword = false;
  bool showConfirmPassword = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void handleRegister() {
    if (formKey.currentState!.validate()) {
      if (passwordController.text != confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password tidak cocok!'),
            backgroundColor: errorColor,
          ),
        );
        return;
      }

      setState(() => isLoading = true);
      
      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        setState(() => isLoading = false);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Akun berhasil dibuat!'),
            backgroundColor: successColor,
          ),
        );
        
        Navigator.pushReplacementNamed(context, '/home');
      });
    }
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
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Buat Akun Baru',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Daftar sekarang dan mulai memesan makanan favorit Anda',
                  style: TextStyle(
                    fontSize: 14,
                    color: darkGrayColor,
                  ),
                ),
                const SizedBox(height: 24),
                // Name Field
                CustomTextFormField(
                  controller: nameController,
                  label: 'Nama Lengkap',
                  hintText: 'Masukkan nama lengkap Anda',
                  prefixIcon: Icons.person_outlined,
                  validator: ValidationService.validateName,
                ),
                const SizedBox(height: 16),
                // Email Field
                CustomTextFormField(
                  controller: emailController,
                  label: 'Email',
                  hintText: 'Masukkan email Anda',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: ValidationService.validateEmail,
                ),
                const SizedBox(height: 16),
                // Phone Field
                CustomTextFormField(
                  controller: phoneController,
                  label: 'Nomor Telepon',
                  hintText: 'Masukkan nomor telepon Anda',
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_outlined,
                  validator: ValidationService.validatePhone,
                ),
                const SizedBox(height: 16),
                // Password Field
                StatefulBuilder(
                  builder: (context, setState) => CustomTextFormField(
                    controller: passwordController,
                    label: 'Password',
                    hintText: 'Masukkan password minimal 6 karakter',
                    obscureText: !showPassword,
                    prefixIcon: Icons.lock_outlined,
                    suffixIcon: showPassword ? Icons.visibility : Icons.visibility_off,
                    onSuffixTap: () => setState(() => showPassword = !showPassword),
                    validator: ValidationService.validatePassword,
                  ),
                ),
                const SizedBox(height: 16),
                // Confirm Password Field
                StatefulBuilder(
                  builder: (context, setState) => CustomTextFormField(
                    controller: confirmPasswordController,
                    label: 'Konfirmasi Password',
                    hintText: 'Ulangi password Anda',
                    obscureText: !showConfirmPassword,
                    prefixIcon: Icons.lock_outlined,
                    suffixIcon: showConfirmPassword ? Icons.visibility : Icons.visibility_off,
                    onSuffixTap: () => setState(() => showConfirmPassword = !showConfirmPassword),
                    validator: ValidationService.validatePassword,
                  ),
                ),
                const SizedBox(height: 24),
                // Register Button
                PrimaryButton(
                  label: isLoading ? 'Sedang Mendaftar...' : 'Daftar',
                  onPressed: isLoading ? () {} : handleRegister,
                ),
                const SizedBox(height: 16),
                // Login Link
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Sudah punya akun? ',
                      style: const TextStyle(
                        fontSize: 12,
                        color: darkGrayColor,
                      ),
                      children: [
                        TextSpan(
                          text: 'Masuk di sini',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
