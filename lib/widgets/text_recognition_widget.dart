import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:text_recognizer_app/api/FirebaseMLApi.dart';
import 'package:text_recognizer_app/widgets/controls_widget.dart';
import 'package:text_recognizer_app/widgets/text_area_widget.dart';

class TextRecognitionWidget extends StatefulWidget {
  const TextRecognitionWidget({Key? key}) : super(key: key);

  @override
  _TextRecognitionWidgetState createState() => _TextRecognitionWidgetState();
}

class _TextRecognitionWidgetState extends State<TextRecognitionWidget> {
  String text = "";
  late File image;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(child: buildImage()),
          SizedBox(height: 16),
          ControlsWidget(
            onClickedPickImage: pickImage,
            onClickedScanText: scanText,
            onClickedClear: clear
          ),
          SizedBox(height: 16),
          TextAreaWidget(
            text: text,
            onClickedCopy: copyToClipBoard
          )
        ]
      )
    );
  }
  Widget buildImage(){
      try{
        return Container(
          child: Image.file(image)
        );
      }
      catch(e){
        return Container(
          child: Icon(Icons.photo, size: 80, color: Colors.black)
        );
      }
  }

  Future pickImage() async{
      final file = await ImagePicker().getImage(source: ImageSource.gallery);
      setImage(File(file!.path));
  }

  Future scanText() async{
    showDialog(
      builder:(context)=> Center(
        child: CircularProgressIndicator()
      ), context: context
    );

    final text = await FirebaseMLApi.recogniseText(image);
    setText(text);

    Navigator.of(context).pop();

  }

  void clear(){
     // setImage(Icon(Icons.photo));
    setText('');
  }

  void copyToClipBoard(){
      if(text.trim() != ''){
        FlutterClipboard.copy(text);
      }
  }

  void setImage(File newImage){
      setState(() {
        image = newImage;
      });
  }

  void setText(String newText){
      setState(() {
        text = newText;
      });
  }
}
