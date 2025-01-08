import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/PROVIDERS/switch_user.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/VIEWS/auths/_user_DETERMINATION_screens.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/main.dart';

class FaqsScreen extends StatefulWidget {
  static const String faqsScreen = "faqsScreen";
  const FaqsScreen({super.key});

  @override
  State<FaqsScreen> createState() => _FaqsScreenState();
}

class _FaqsScreenState extends State<FaqsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context,
          title: "FAQs", hasIcon: true, hasElevation: true),
      body: SafeArea(
        child: Consumer(builder: (context, ref, _) {
          return SingleChildScrollView(
            padding: appPadding(),
            child: Column(
                children: ref.watch(switchUserProvider) == UserTypes.researcher
                    ? researcherFaqs()
                    : clientFaqs()),
          );
        }),
      ),
    );
  }

  List<Widget> clientFaqs() {
    return [
      eachQuestions(context,
          question: "Can we submit our projects for rework and corrections?",
          answer:
              "Yes. In the app, you can define a timeline for project submission. Review the researcher’s submission and make requests for corrections when needed. Only approve a particular chapter or batch submission after it has been approved by the supervising body or when it meets your objectives."),
      eachQuestions(context,
          question:
              "How do I know the level of plagiarism in the submitted research project?",
          answer:
              "For research projects submitted by a contracted researcher, test the level of plagiarism via the “Originality Test” on the Home menu.\nFor listed publications on the marketplace, the plagiarism test result will be displayed on the corresponding card. Note that the marketplace only lists publications with less than 20% plagiarism."),
      eachQuestions(context,
          question: "Can I delete my account?",
          answer:
              "Yes, you can delete your account\nShould you decide to discontinue operating with us, you can initiate the request from “Privacy & Policy” in “Account” on the Home menu.\nYou can rest assured that all your related personal information will be deleted when you initiate this request.\nHowever, the request may be declined if you have any ongoing project or if you are unable to verify your identity during the verification after clicking the “Delete my account” button."),
      eachQuestions(context,
          question: "How is the Escrow wallet different from the Wallet?",
          answer:
              "Escrow wallet holds the balance for your ongoing projects. It does not support withdrawal to protect the user’s interest.\nWallet holds any other fund you load into the app. You can withdraw from it. The balance can be used to fund your Escrow wallet, buy publications on the app, or any other transaction on the app."),
      eachQuestions(context,
          question: "Can I change my username?",
          answer:
              "Edit your username from the “Profile Details” in “Account” on the Home menu."),
      eachQuestions(context,
          question: "Can I explore/read the publication before paying?",
          answer:
              "You can only view the abstract of a publication before paying. To get more detail, you can message the researcher that posted it, via our in-app messenger."),
      eachQuestions(context,
          question: "Are there free publications on the platform?",
          answer:
              "Yeah. These could be posted from ProjectBist admin or from other researchers who decided to sell it for free.s"),
      eachQuestions(context,
          question: "Can I get a refund if I decline a project? ",
          answer:
              "Yeah, you can get a refund when you decline a project.\nHowever, note that the app algorithm calculates payment based on the proportion of the defined “Submission Batches” that have been completed. Hence, if you have approved some earlier submissions, you will only get refunded for the unapproved batches.\nFor example, a project with defined 5 submission batches with 3 approved batches will only get a refund for the remaining 2 unapproved batches. Hence, kindly verify that each submission meets your objective or gets approved by the supervising body before you approve it on the app.\nNevertheless, the researcher also reserves the right to oppose the decline on debated grounds"),
      eachQuestions(context,
          question:
              "What can I do if the researcher does not deliver within the stipulated time?",
          answer:
              "Message your researcher to verify the cause of the delay. If necessary you can extend the submission deadline.\nAs a last resort, you can decline the project, and then contract another researcher."),
      eachQuestions(context,
          question:
              "Is there no way to withdraw from the escrow wallet at all?",
          answer:
              "The escrow wallet is designed as such to protect the interests of users.\nYou need not worry if you mistakenly over-fund your Escrow Wallet, the balance will be credited automatically to your Wallet.\nAlso, the refund from the project decline will be credited automatically to your Wallet."),
      eachQuestions(context,
          question: "Is there a fine for declining an ongoing job?",
          answer:
              "Your satisfaction is our priority. There is no fine for declining an ongoing project.\nYou can decline any ongoing project if the researcher is not performing to expectations. However, you will only be refunded for unapproved submission batches")
    ];
  }

  List<Widget> researcherFaqs() {
    return [
      eachQuestions(context,
          question:
              "What's the difference between an escrow wallet and the wallet?",
          answer:
              "Escrow wallet holds the balance for your ongoing projects. It does not support withdrawal to protect users’ interests.\nWallet holds any other fund you load into the app. You can withdraw from it. The balance can be used to fund your Escrow wallet, buy publications on the app, or any other transaction on the app."),
      eachQuestions(context,
          question:
              "What is the advantages of asking the client to define submission batches?",
          answer:
              "Without submission batches defined, the system will not be able to keep track of your submission if you only submit chapters/batches via the in-app messenger.",
          answer2:
              "In case of a Decline from the client, you will be entitled only to payment on the approved submission batches. If no such batches are defined, you will lose all possible payments on the project."),
      eachQuestions(context,
          question: "When can I get the money after completing the job?",
          answer:
              "The fund becomes available 3 days after project completion. You can withdraw them to your local bank account or use them for other activities on the app"),
      eachQuestions(context,
          question: "Can I change my username?",
          answer:
              "Edit your username from the “Profile Details” in “Account” on the Home menu."),
      eachQuestions(context,
          question: "Is there a limit to the price and number of publications?",
          answer:
              "There is no such limit currently. Note that too high a price may lead to poor sales so kindly price moderately.\nYou can set N0 if you decide to sell for free"),
      eachQuestions(context,
          question:
              "Will there be a limit to the number of reworks or correction to be submitted?",
          answer:
              "You can discuss with the client on the number of reworks that will be accepted and if payment will be involved for additional reworks before the start of the project."),
      eachQuestions(context,
          question: "Can I remove or delete a published paper?",
          answer:
              "Yeah, should you decide to remove a listed publication, you can delete or manage your publications via “My Publication” on the Home menu. ")
    ];
  }
}

Widget eachQuestions(BuildContext context,
    {required String question, required String answer, String? answer2}) {
  return Column(
    children: [
      ExpansionTile(
          tilePadding: EdgeInsets.zero,
          collapsedIconColor: AppThemeNotifier.colorScheme(context).primary,
          iconColor: AppThemeNotifier.colorScheme(context).primary,
          childrenPadding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(side: BorderSide.none),
          collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
          expandedAlignment: Alignment.centerLeft,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                  child: TextOf(
                question,
                16.sp,
                6,
                align: TextAlign.left,
              )),
            ],
          ),
          children: <Widget>[
            TextOf(
              answer,
              16.sp,
              4,
              align: TextAlign.left,
            ),
            answer2 == null
                ? const SizedBox.shrink()
                : TextOf(
                    answer2,
                    16.sp,
                    5,
                    align: TextAlign.left,
                  ),
          ]),
      YMargin(10.sp)
    ],
  );
}
