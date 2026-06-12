import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

import '../controllers/signin_controller.dart';

class SigninView extends GetView<SigninController> {
  const SigninView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.Lychee,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Stack(
          children: [
            // Background left
            Positioned(
              bottom: 0,
              left: 0,
              child: SvgPicture.asset(
                'assets/images/Star 1.svg',
                width: 255,
              ),
            ),

            // Background right
            Positioned(
              top: 0,
              right: 0,
              child: SvgPicture.asset(
                'assets/images/Star 2.svg',
                width: 185,
              ),
            ),

            // Main content
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 180,),

                    // Title
                    Text(
                      'Selamat Datang!',
                      style: AppText.Heading1,
                    ),

                    const SizedBox(height: 8,),

                    // Subtitle
                    Text(
                      'Masukkan role, e-mail atau nomor handphone, dan password untuk melanjutkan.',
                      style: AppText.Body,
                    ),

                    const SizedBox(height: 32,),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.black),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8,),

                          _label('Username'),
                          _input(controller.usernameC, ''),

                          const SizedBox(height: 16,),
                          _label('Password'),
                          Obx( () => _password(
                            controller.passwordC, 
                            controller.obscurePassword.value, 
                            controller.togglePassword)),

                          const SizedBox(height: 32,),
                          SizedBox(
                            width: double.infinity,
                            height: 46,
                            child: Obx(() => ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.Tangerine,
                                foregroundColor: AppColors.black,
                                disabledBackgroundColor: AppColors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  side: BorderSide(color: AppColors.black, width: 1)
                                ),
                              ),
                              onPressed: controller.isLoading.value ? null : controller.login,
                              child: controller.isLoading.value
                                ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                    child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : Text('Masuk',
                                  style: AppText.Body1_SemiBold.copyWith(color: AppColors.white),
                                ),
                            )),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ), 
            ),
          ],
        ),
      )
    );
  }
}

Widget _label(String text) => Padding(
  padding: const EdgeInsets.only(bottom: 14),
  child: Text(
    text,
    style: AppText.Body_Bold,
  ),
);

Widget _input(TextEditingController controller, String hint) {
  return TextField(
    controller: controller,
    style: const TextStyle(color: Colors.black),
    decoration: _decoration(hint: hint),
    keyboardType: TextInputType.text,
  );
}

InputDecoration _decoration({String? hint}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: AppText.Body,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 18,
      vertical: 12,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: Colors.black),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: Colors.black),
    ),
  );
}

Widget _password(TextEditingController controller, bool obscure, VoidCallback toggle) {
  return TextField(
    controller: controller,
    obscureText: obscure,
    style: const TextStyle(color: Colors.black),
    decoration: _decoration(hint: 'Enter your password').copyWith(
      suffixIcon: IconButton(
        icon: Icon(
          obscure ? Icons.visibility_off : Icons.visibility,
          color: Colors.black54,
        ),
        onPressed: toggle,
      ),
    ),
  );
}