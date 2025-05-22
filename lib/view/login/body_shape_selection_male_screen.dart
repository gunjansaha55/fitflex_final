import 'package:fitness/services/auth/auth_exceptions.dart';
import 'package:fitness/services/bloc/auth_bloc.dart';
import 'package:fitness/services/bloc/auth_event.dart';
import 'package:fitness/services/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BodyShapeSelectionMaleScreen extends StatefulWidget {
  const BodyShapeSelectionMaleScreen({super.key});

  @override
  State<BodyShapeSelectionMaleScreen> createState() =>
      _BodyShapeSelectionMaleScreenState();
}

class _BodyShapeSelectionMaleScreenState
    extends State<BodyShapeSelectionMaleScreen> {
  final PageController _pageController = PageController();
  int _selectedPage = 0;

  final List<Map<String, String>> bodyShapes = [
    {
      'image': 'assets/img/goal1.png',
      'label': 'Improve Shape',
    },
    {
      'image': 'assets/img/goal2.png',
      'label': 'Lean & Tone',
    },
    {
      'image': 'assets/img/goal3.png',
      'label': 'Lose a Fat',
    },
    {
      'image': 'assets/img/goal4.png',
      'label': 'Better Shape',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('User not found'),
              ),
            );
          } else if (state.exception is GenericAuthException) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('An error occurred'),
              ),
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Title
              const Text(
                "What is your Body Shape ?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                "It will help us to choose a best\nprogram for you",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 20),

              // PageView for images
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: bodyShapes.length,
                  onPageChanged: (index) {
                    setState(() {
                      _selectedPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 30),
                          padding: const EdgeInsets.all(20),
                          height: 360,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFFCC),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Image.asset(
                            bodyShapes[index]['image']!,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          bodyShapes[index]['label']!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Confirm Button
              Container(
                width: 160,
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00F260), Color(0xFFFFDD00)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextButton(
                  onPressed: () {
                    // Handle selection confirmation
                    final selectedShape = bodyShapes[_selectedPage]['label'];
                    context.read<AuthBloc>().add(
                          AuthEventSelectBodyShape(bodyShape: selectedShape),
                        );
                  },
                  child: const Text(
                    "Confirm",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
