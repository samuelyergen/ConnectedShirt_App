import 'package:connected_shirt/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

/// Stateful OnBoardingPage to create our OnBoardingPage.
///
/// The OnBoardingPage shows when the user first create an account.
class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).pop();
  }

  Widget _buildImage(String assetName, [double width = 250]) {
    return Image.asset('assets/images/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      globalFooter: SizedBox(
        height: 60,
        child: TextButton(
          child: const Text(
            LocaleKeys.skip,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
          ).tr(),
          onPressed: () => _onIntroEnd(context),
        ),
      ),
      pages: [
        PageViewModel(
          title: LocaleKeys.connect.tr(),
          body: LocaleKeys.connectText.tr(),
          image: _buildImage('shirt.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: LocaleKeys.monitor.tr(),
          body: LocaleKeys.monitorText.tr(),
          image: _buildImage('chart.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: LocaleKeys.beFree.tr(),
          body: LocaleKeys.beFreeText.tr(),
          image: _buildImage('offline.png'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      showSkipButton: false,
      skipFlex: 0,
      nextFlex: 0,
      next: const Icon(Icons.arrow_forward),
      done: const Text(LocaleKeys.done,
              style: TextStyle(fontWeight: FontWeight.normal))
          .tr(),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Colors.blue,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
