import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../utils/constant/color_constants.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _onboardingItems = [
    OnboardingItem(
      title: 'Track Your Attendance',
      description:
          'Check in and check out with attendance tracking to monitor your daily activities.',
      imagePath: 'assets/images/onboarding1.svg',
    ),
    OnboardingItem(
      title: 'Place Orders Easily',
      description:
          'Browse products, place orders for outlets and manage your sales with our digital catalogue.',
      imagePath: 'assets/images/onboarding2.svg',
    ),
    OnboardingItem(
      title: 'Works Offline',
      description:
          'App works without internet. All operations automatically sync when you\'re back online.',
      imagePath: 'assets/images/onboarding3.svg',
    ),
    OnboardingItem(
      title: 'Enable Location & Notification Permission',
      description:
          'Allow access to your location with notification permission to get nearest outlets and timely updates.',
      imagePath: 'assets/images/onboarding4.svg',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _onboardingItems.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      context.go('/SignIn');
    }
  }

  void _skipOnboarding() {
    context.go('/SignIn');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingItems.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return OnboardingPage(item: _onboardingItems[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ✅ Skip button (hidden on last page)
                  _currentPage < _onboardingItems.length - 1
                      ? TextButton(
                          onPressed: _skipOnboarding,
                          child: const Text(
                            'Skip',
                            style: TextStyle(
                              color: AppColors.lightTextColor,
                              fontSize: 16,
                            ),
                          ),
                        )
                      : const SizedBox(width: 60),

                  //  Dot indicators
                  Row(
                    children: List.generate(
                      _onboardingItems.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? AppColors.primaryColor
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),

                  // ✅ Next button
                  SizedBox(
                    width: 60,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(12),
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
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

class OnboardingItem {
  final String title;
  final String description;
  final String imagePath;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

class OnboardingPage extends StatelessWidget {
  final OnboardingItem item;

  const OnboardingPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(item.imagePath, height: 280),
          const SizedBox(height: 40),
          Container(
            width: 60,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            item.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            item.description,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.lightTextColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
