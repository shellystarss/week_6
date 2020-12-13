part of 'pages.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String name, email, profilePic;
  bool isLoading = false;

  PickedFile imageFile;
  final ImagePicker imagePicker = ImagePicker();

  Future chooseImage() async {
    final selectedImage = await imagePicker.getImage(
        source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      imageFile = selectedImage;
    });
  }

  void fetchUserData() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .snapshots()
        .listen((event) {
      name = event.data()['name'];
      email = event.data()['email'];
      profilePic = event.data()['profilePicture'];
      if (profilePic == "") {
        profilePic = null;
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    fetchUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My Account"),
          centerTitle: true,
          leading: Container(),
        ),
        body: Stack(children: <Widget>[
          Container(
              margin:
                  EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 100),
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                )
              ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 80,
                      backgroundImage: NetworkImage(profilePic ??
                          "https://cdn.onlinewebfonts.com/svg/img_568656.png")),
                  SizedBox(
                    height: 40,
                  ),
                  RaisedButton.icon(
                    onPressed: () async {
                      await chooseImage();
                      setState(() {
                        isLoading = true;
                      });
                      await UserServices.updateProfilePic(
                              FirebaseAuth.instance.currentUser.uid, imageFile)
                          .then((value) {
                        if (value) {
                          Fluttertoast.showToast(
                              msg: "Update Profile Successfull",
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              toastLength: Toast.LENGTH_LONG);
                          setState(() {
                            isLoading = false;
                          });
                        } else {
                          Fluttertoast.showToast(
                              msg: "Update Profile Failed",
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              toastLength: Toast.LENGTH_LONG);
                          setState(() {
                            isLoading = false;
                          });
                        }
                      });
                    },
                    label: Text("Edit photo"),
                    icon: Icon(Icons.camera_alt),
                    color: Colors.blue,
                    padding: EdgeInsets.all(8),
                    textColor: Colors.white,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(email)
                ],
              )),
          Container(
            padding: EdgeInsets.only(bottom: 20),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: RaisedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Signout Confirmation"),
                            content: Text("Are you sure to signout?"),
                            actions: [
                              FlatButton(
                                onPressed: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  await AuthServices.signOut().then((value) {
                                    if (value) {
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (context) {
                                        return SignInPage();
                                      }));
                                      setState(() {
                                        isLoading = false;
                                      });
                                    } else {
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                  });
                                },
                                child: Text("Yes"),
                              ),
                              FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("No"),
                              )
                            ],
                          );
                        });
                  },
                  color: Colors.red,
                  padding: EdgeInsets.all(12),
                  child: Text(
                    "Signout",
                    style: TextStyle(color: Colors.white),
                  ),
                )),
          ),
          isLoading == true
              ? Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.transparent,
                  child: SpinKitFadingCircle(size: 50, color: Colors.blue),
                )
              : Container()
        ]));
  }
}
