import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:final_app/components/my_button.dart';
import 'package:final_app/components/my_textfield.dart';
import 'package:final_app/controllers/edit_profile_controller.dart';

class EditProfilePage extends StatelessWidget {
  final EditProfileController editProfileController =
      Get.put(EditProfileController());

  EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: const Text('Edit Profile'),
        backgroundColor: Colors.orange.shade400,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Center(
          child: GetBuilder<EditProfileController>(
            builder: (controller) => Column(
              children: [
                const SizedBox(height: 20),
                // profil pic
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(25),
                  child: const Icon(
                    Icons.person,
                    size: 64,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    children: [
                      MyTextfield(
                        hintText: 'Full Name',
                        obscureText: false,
                        controller: controller.usernameController,
                      ),
                      const SizedBox(height: 10),
                      MyTextfield(
                        hintText: 'Email',
                        obscureText: false,
                        controller: controller.emailController,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.width * 0.12,
                        child: MyButton(
                          text: 'Edit Profile',
                          onTap: () async {
                            await controller.editProfile();
                          },
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Bergabung',
                                  style: TextStyle(fontSize: 12),
                                ),
                                WidgetSpan(
                                  child: SizedBox(width: 3),
                                ),
                                TextSpan(
                                  text: '14 Juni 2024',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: controller.deleteAccount,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.redAccent.withOpacity(0.1),
                              elevation: 0,
                              foregroundColor: Colors.red,
                              shape: const StadiumBorder(),
                              side: BorderSide.none,
                            ),
                            child: const Text('Hapus'),
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
      ),
    );
  }
}
