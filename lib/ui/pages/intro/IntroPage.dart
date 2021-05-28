import 'package:flutter/material.dart';
import 'package:free_drive/main.dart';
import 'package:free_drive/models/IntroContentModel.dart';
import 'package:free_drive/state/AppViewModel.dart';
import 'package:free_drive/ui/shared/Logo.dart';
import 'package:lottie/lottie.dart';
import 'package:free_drive/ui/shared/CustomAppBar.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:stacked/stacked.dart';

class IntroPage extends StatelessWidget {

  double deviceWidth = MediaQuery.of(navigatorKey.currentContext).size.width;
  double deviceHeight = MediaQuery.of(navigatorKey.currentContext).size.height;

  List<IntroContentModel> introList = [
    new IntroContentModel(
        title: "Faites vous aider",
        description: "Marre de conduire H24 ? Enfin nous avons pensé à vous pour cette corvée",
        imageAsset: "assets/lottie/help.json"
    ),
    new IntroContentModel(
        title: "Voyage d'affaires ou de visite ?",
        description: "Nous vous conduirons où vous voulez ",
        imageAsset: "assets/lottie/travel.json"
    ),
    new IntroContentModel(
        title: "Profitez du trajet ✨",
        description: "Choisissez le lieu, concentez-vous sur l'objectif de votre voyage et laissez-nous la charge de vous conduire à destination",
        imageAsset: "assets/lottie/city-driver.json"
    ),

  ];

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppViewModel>.reactive(
        builder: (context, model, child) => Scaffold(
            body: Container(
              color: Theme.of(context).accentColor,
              child: Column(
                children: [
                  SizedBox(height: model.deviceHeight*0.1),
                  Logo(),
                  SizedBox(height: 10.0),
                  Expanded(
                    child: IntroductionScreen(
                      isTopSafeArea: false,
                      globalBackgroundColor: Theme.of(context).accentColor,
                      doneColor: Colors.black,
                      skipColor: Colors.black,
                      nextColor: Colors.black,
                      pages: introList.map((e) => PageViewModel(
                          title: e.title,
                          body: e.description,
                          image: Lottie.asset(e.imageAsset, width: this.deviceWidth*0.5),
                          decoration: PageDecoration(
                              titleTextStyle: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 30.0
                              )
                          )
                      )).toList(),
                      onDone: () => navigatorKey.currentState.pushNamed('/signup'),
                      onSkip: () => navigatorKey.currentState.pushNamed('/signup'),
                      showSkipButton: true,
                      skip: const Icon(Icons.skip_next),
                      next: const Icon(Icons.navigate_next),
                      done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
                      dotsDecorator: DotsDecorator(
                        size: const Size.square(10.0),
                        activeSize: const Size(20.0, 10.0),
                        activeColor: Theme.of(context).primaryColor,
                        color: Colors.black26,
                        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
                        activeShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0)
                        )
                      ),
                    ),
                  ),
                ],
              ),
            )
        ),
        viewModelBuilder: () => AppViewModel()
    );
  }
}
