import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:ui';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'istanbul.dart';
import 'izmir.dart';

String myImage;
String city;

void camera(String s){
  city=s;
  get_image();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // Function to open a camera
  Future openCamera() async {
    var cameraImage = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      myImage = cameraImage.path;
      set_image(myImage);
    });
  }

  // Function to open a local gallery
  Future openGalley() async {
    var galleryImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      myImage = galleryImage.path;
      set_image(myImage);
    });
  }

  // Function to show dialog box
  Future<void> openDialogBox() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(),
          backgroundColor: Colors.blue,
          title: Text(
            'Choose options',
            style: TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                MaterialButton(
                  color: Colors.blue[900],
                  child: Text(
                    "Open Camera",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    openCamera();
                  },
                ),
                MaterialButton(
                  color: Colors.blue[900],
                  child: Text(
                    "Open Gallery",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    openGalley();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.keyboard_return),
          onPressed: () {if(city=="Izmir"){Izmir();} else{Istanbul();}},
        ),
        centerTitle: true,
        title: Text('Where to Park'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: myImage == null
            ? Center(
            child: Text(
              "No image selected",
              style: TextStyle(
                fontSize: 20,
              ),
            ))
            : Image.file(File(myImage),fit: BoxFit.fill,),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openDialogBox();
        },
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}

get_image() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if(prefs.containsKey("image")) {
    myImage = prefs.getString("image");
  }
}

set_image(image) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("image", image);
}