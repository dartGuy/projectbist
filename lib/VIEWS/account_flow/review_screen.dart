import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/PROVIDERS/reviews_provider/reviews_provider.dart';
import 'package:project_bist/WIDGETS/buttons.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/input_field.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/main.dart';

class ReviewsScreen extends StatefulWidget {
  static const String reeviewScreen = "reeviewScreen";
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  late TextEditingController reviewsInputFielfController;

  @override
  void initState() {
    setState(() {
      reviewsInputFielfController = TextEditingController();
    });
    super.initState();
  }

  @override
  void dispose() {
    reviewsInputFielfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) {
      if (mounted) {
        setState(() {});
      }
    });
    return Scaffold(
      appBar: customAppBar(context,
          title: "Review", hasIcon: true, hasElevation: true),
      body: Padding(
        padding: appPadding().copyWith(bottom: 20.sp),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SizedBox.expand(
                child: SingleChildScrollView(
                    child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextOf(
                        "Tell us about how our app make you feel so that we can help you have a better experience than you have now.",
                        16.sp,
                        4,
                        align: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                YMargin(24.sp),
                InputField(
                    hintText: "Write your review...",
                    maxLines: 5,
                    fieldController: reviewsInputFielfController),
              ],
            ))),
            Button(
              text: "Send Review",
              buttonType: reviewsInputFielfController.text.isEmpty
                  ? ButtonType.disabled
                  : ButtonType.blueBg,
              onPressed: () {
                ReviewsProvider.sendReportOrReviewToAdmin(context,
                        emailContent: reviewsInputFielfController.text,
                        messageType: "review")
                    .then((value) => reviewsInputFielfController.clear());
              },
            )
          ],
        ),
      ),
    );
  }
}
