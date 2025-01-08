
// Widget topicsListSection(BuildContext context, TopicsList topicList) {
//   topicList.shuffle();
//   return Padding(
//     padding: appPadding().copyWith(top: 8.sp, bottom: 8.sp),
//     child: Column(
//       children: [
//         Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//           TextOf("Topics", 14.sp, 4),
//           Expanded(
//               child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
//             Row(
//               children: [
//                 InkWell(
//                   onTap: () {
//                     Navigator.pushNamed(context,
//                         TopicsListPreviewScreen.topicsListPreviewScreen);
//                   },
//                   child: TextOf(
//                     "View all",
//                     12,
//                     4,
//                     decoration: TextDecoration.underline,
//                     color: AppColors.brown,
//                   ),
//                 ),
//                 XMargin(5.sp),
//                 IconOf(Icons.arrow_forward_ios_rounded,
//                     color: AppColors.brown, size: 15.sp)
//               ],
//             )
//           ]))
//         ]),
//         YMargin(16.sp),
//         ...List.generate(
//             topicList.length > 2 ? 2 : topicList.length,
//             (index) => TopicDisplayItem(
//                   hasDivider: true,
//                   topicModel: topicList[index],
//                 ))
//       ],
//     ),
//   );
// }
