import "dart:io" show Platform;

import "package:carousel_slider/carousel_slider.dart";
import "package:flutter/material.dart";
import "package:gif/gif.dart";
import "package:smooth_page_indicator/smooth_page_indicator.dart";

import '../utilities/pallete.dart';
import "../utilities/routes.dart";
import "../widgets/gradient_button.dart";

class DemoPageView extends StatefulWidget {
  const DemoPageView({super.key});

  @override
  State<DemoPageView> createState() => _DemoPageViewState();
}

class _DemoPageViewState extends State<DemoPageView>
    with TickerProviderStateMixin {
  late final GifController ctrlr1, ctrlr2, ctrlr3, ctrlr4, ctrlr5, ctrlr6;
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
    'assets/images/cover.gif',
    'assets/images/notes.gif',
    'assets/images/todo.gif',
    'assets/images/events.gif',
    'assets/images/time.gif',
    'assets/images/multiple_devices.gif'
  ];

  @override
  void initState() {
    ctrlr1 = GifController(vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    ctrlr1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: (Platform.isIOS || Platform.isAndroid) ? 80 : 30),
            const Text(
              'Check',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
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
            GradientButton(
                onPressed: () {
                  if (context.mounted) {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(signUpRoute, (route) => false);
                  }
                },
                child: const Text('Get Started')),
            const SizedBox(height: 25),
            const Text('Already have an account?'),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                if (context.mounted) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(signInRoute, (route) => false);
                }
              },
              child: const Text(
                'Sign In instead',
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImage(String image, index) => Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SizedBox(
          height: 200,
          child: Column(
            children: [
              SizedBox(
                  height: 300,
                  child: Gif(
                    controller: ctrlr1,
                    //duration: const Duration(seconds: 4),
                    autostart: Autostart.once,
                    placeholder: (context) =>
                        const Center(child: CircularProgressIndicator()),
                    image: AssetImage(image),
                  )
                  // Image.asset(
                  //   image,
                  //   fit: BoxFit.contain,
                  // ),
                  ),
              Text(
                textList[index],
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      );

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: carouselActiveIndex,
        count: imageList.length,
        effect: const ExpandingDotsEffect(
          activeDotColor: Palette.accentColorVariant,
          dotWidth: 7,
          dotHeight: 7,
          spacing: 2,
        ),
      );
}
