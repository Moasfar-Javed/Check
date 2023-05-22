import "package:carousel_slider/carousel_slider.dart";
import "package:flutter/material.dart";
import "package:smooth_page_indicator/smooth_page_indicator.dart";

import '../utilities/pallete.dart';
import "../utilities/routes.dart";

class DemoPageView extends StatefulWidget {
  const DemoPageView({super.key});

  @override
  State<DemoPageView> createState() => _DemoPageViewState();
}

class _DemoPageViewState extends State<DemoPageView> {
  int carouselActiveIndex = 0;
  final textList = [
    'Check is an all-in-one notebook app that helps you manage your tasks more efficiently and lead a more productive lifestyle',
    'Quickly jot important things down and make sticky notes',
    'Make a todo checklist and track your progress as you go',
    'Mark down events and set reminders in your calendar and receive notifications',
    'Set timers and stopwatch to keep track of time while you do your tasks',
    'Work and view your tasks anywhere with cloud sync enabled'
  ];

  final imageList = [
    'assets/images/cover.png',
    'assets/images/notes.png',
    'assets/images/todo.png',
    'assets/images/events.png',
    'assets/images/time.png',
    'assets/images/multiple_devices.png'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 100),
            const Text(
              'Check',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w800,
                color: Palette.textColor,
              ),
            ),
            const SizedBox(height: 50),
            CarouselSlider.builder(
              options: CarouselOptions(
                  height: 400,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 4),
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      carouselActiveIndex = index;
                    });
                  }),
              itemCount: imageList.length,
              itemBuilder: (context, index, realIndex) {
                final image = imageList[index];
                return buildImage(image, index);
              },
            ),
            buildIndicator(),
            const SizedBox(height: 50),
            SizedBox(
              width: 180,
              height: 40,
              child: ElevatedButton(
                  onPressed: () {
                    if (context.mounted){
                      Navigator.of(context).pushNamedAndRemoveUntil(signUpRoute, (route) => false);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text('Get Started')),
            )
          ],
        ),
      ),
    );
  }

  Widget buildImage(String image, index) => Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 0),
        child: Column(
          children: [
            SizedBox(
              height: 300,
              width: 230,
              child: Image.asset(
                image,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              textList[index],
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            )
          ],
        ),
      );

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: carouselActiveIndex,
        count: imageList.length,
        effect: ExpandingDotsEffect(
          activeDotColor: Palette.appColorPalette[200]!,
          dotWidth: 7,
          dotHeight: 7,
          spacing: 2,
        ),
      );
}
