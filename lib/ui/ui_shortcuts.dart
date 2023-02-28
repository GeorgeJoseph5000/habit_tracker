import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StyledButton extends StatelessWidget {
  StyledButton(this.text, this.action);
  final String text;
  final dynamic action;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
      onPressed: action,
      child: Text(
        text,
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}

showSnackBar(context, text) {
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text, style: const TextStyle(fontSize: 18))));
}

class UploadImage extends StatefulWidget {
  UploadImage({super.key});
  int segmentedControlGroupValue = 0;
  bool isURL = true;
  var urlController = TextEditingController();
  bool isValidUrl = false;

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  var myTabs = <int, Widget>{0: Text("URL"), 1: Text("File")};

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      /*CupertinoSlidingSegmentedControl(
                groupValue: widget.segmentedControlGroupValue,
                children: myTabs,
                onValueChanged: (i) {
                  widget.segmentedControlGroupValue = i! as int;
                  setState(() {
                    widget.segmentedControlGroupValue == 0
                        ? widget.isURL = true
                        : widget.isURL = false;
                  });
                }),*/
      widget.isURL
          ? TextFormField(
              controller: widget.urlController,
              onChanged: (value) async {
                try {
                  final response = await http.head(
                      Uri.parse(widget.urlController.text.toString().trim()));
                  print("starts");
                  if (response.statusCode == 200) {
                    print("Cool");
                    widget.isValidUrl = true;
                  } else {
                    widget.isValidUrl = false;
                  }
                } catch (e) {
                  widget.isValidUrl = false; 
                }
              },
              decoration: const InputDecoration(
                labelText: 'Enter Image URL',
              ),
            )
          : Text("")
    ]);
  }
}
