import 'package:autoflex/application/services/asset_strings.dart';
import 'package:autoflex/domain/value_objects/app_strings.dart';
import 'package:autoflex/presentation/core/theme/text_theme.dart';
import 'package:autoflex/presentation/core/widgets/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int currentIndex = 0;
  final PageController controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: PageView(
                controller: controller,
                onPageChanged: (int index) => setState(() {
                  currentIndex = index;
                }),
                children: const <Widget>[
                  OnboardingSliderWidgetItem(
                    title: onboardingTourSliderTitleOne,
                    description: onboardingTourSliderBodyTextOne,
                    iconSvgPath: mechanicOnboardingIllustarationOne,
                  ),
                  OnboardingSliderWidgetItem(
                    title: onboardingTourSliderTitleTwo,
                    description: onboardingTourSliderBodyTextTwo,
                    iconSvgPath: mechanicIllustrationTwo,
                  ),
                  OnboardingSliderWidgetItem(
                    title: onboardingTourSliderTitleThree,
                    description: onboardingTourSliderBodyTextThree,
                    iconSvgPath: mechanicOnboardingIllustarationOne,
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

class OnboardingSliderWidgetItem extends StatelessWidget {
  const OnboardingSliderWidgetItem({
    super.key,
    required this.iconSvgPath,
    required this.title,
    required this.description,
  });
  final String iconSvgPath;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        veryLargeHorizontalSizedBox,
        SvgPicture.asset(iconSvgPath),
        SizedBox(
          height: MediaQuery.of(context).size.height / 16,
        ),
        Text(
          title,
          style: heavySize24Text(),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
