// import 'package:flutter/material.dart';

// class Messaging extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Search Text Highlighting'),
//         ),
//         body: MySearchWidget(),
//       ),
//     );
//   }
// }

// class MySearchWidget extends StatefulWidget {
//   @override
//   _MySearchWidgetState createState() => _MySearchWidgetState();
// }

// class _MySearchWidgetState extends State<MySearchWidget> {
//   TextEditingController _searchController = TextEditingController();
//   List<String> items = [
//     'John Doe',
//     'Jane Smith',
//     'Alice Johnson',
//     'Bob Johnson',
//     'Charlie Brown',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: TextField(
//             controller: _searchController,
//             onChanged: (value) {
//               setState(() {});
//             },
//             decoration: const InputDecoration(
//               labelText: 'Search',
//               hintText: 'Enter a name',
//             ),
//           ),
//         ),
//         Expanded(
//           child: ListView.builder(
//             itemCount: items.length,
//             itemBuilder: (context, index) {
//               return buildItem(items[index]);
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget buildItem(String item) {
//     // Get the search query from the TextField
//     String query = _searchController.text;

//     // Highlight the matching part of the text
//     List<TextSpan> textSpans = [];

//     // Case-insensitive search for the query in the item
//     RegExp exp = RegExp(query, caseSensitive: false);
//     Iterable<Match> matches = exp.allMatches(item);

//     int lastMatchEnd = 0;

//     for (Match match in matches) {
//       // Add the non-matching part before the match
//       if (match.start > lastMatchEnd) {
//         textSpans.add(TextSpan(
//           text: item.substring(lastMatchEnd, match.start),
//           style: const TextStyle(color: Colors.black),
//         ));
//       }

//       // Add the matching part with a different color
//       textSpans.add(TextSpan(
//         text: item.substring(match.start, match.end),
//         style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
//       ));

//       lastMatchEnd = match.end;
//     }

//     // Add the non-matching part after the last match
//     if (lastMatchEnd < item.length) {
//       textSpans.add(TextSpan(
//         text: item.substring(lastMatchEnd),
//         style: const TextStyle(color: Colors.black),
//       ));
//     }

//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: RichText(
//         text: TextSpan(
//           children: textSpans,
//         ),
//       ),
//     );
//   }
// }
