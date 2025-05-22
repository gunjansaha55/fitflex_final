// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:fitness/services/auth/auth_service.dart';
import 'package:fitness/services/bloc/auth_bloc.dart';
import 'package:fitness/services/bloc/auth_event.dart';
import 'package:fitness/common/colo_extension.dart';
import 'package:fitness/common_widget/round_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Verify Email',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(height: 60),
              Image.asset(
                'assets/img/Component 2.png',
                height: 200,
              ),
              const SizedBox(
                height: 80,
              ),
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: TColor.secondaryColor1,
                    width: 1,
                  ),
                ),
                child: RoundButton(
                  title: 'Click to resend email',
                  onPressed: () {
                    context
                        .read<AuthBloc>()
                        .add(const AuthEventSendEmailVerification());
                  },
                ),
              ),
              const SizedBox(height: 50),
              Row(
                // crossAxisAlignment: CrossAxisAlignment.,
                children: [
                  Expanded(
                      child: Container(
                    height: 1,
                    color: TColor.gray.withOpacity(0.5),
                  )),
                  Text(
                    "  Or  ",
                    style: TextStyle(color: TColor.black, fontSize: 15),
                  ),
                  Expanded(
                      child: Container(
                    height: 1,
                    color: TColor.gray.withOpacity(0.5),
                  )),
                ],
              ),
              const SizedBox(height: 50),
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Colors.grey,
                    )),
                child: TextButton(
                  onPressed: () async {
                    await AuthService.firebase().logout();
                    context.read<AuthBloc>().add(const AuthEventLogout());
                  },
                  child: const Text(
                    'Back to login',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
