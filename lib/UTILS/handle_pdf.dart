import 'dart:io';

import 'package:pdf/widgets.dart';
// ignore: depend_on_referenced_packages
import "package:path_provider/path_provider.dart";

class PdfApi {
  static Future<File> generateCenteredText(String text) async {
    // making a pdf document to store a text and it is provided by pdf pakage
    final pdf = Document();

    // Text is added here in center
    pdf.addPage(Page(
      build: (context) => Center(
        child: Text(text, style: const TextStyle(fontSize: 48)),
      ),
    ));

    // passing the pdf and name of the docoment to make a direcotory in  the internal storage
    return saveDocument(name: 'my_example.pdf', pdf: pdf);
  }

  // it will make a named dircotory in the internal storage and then return to its call
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    // pdf save to the variable called bytes
    final bytes = await pdf.save();

    // here a beautiful pakage  path provider helps us and take dircotory and name of the file  and made a proper file in internal storage
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    // reterning the file to the top most method which is generate centered text.
    return file;
  }
}
