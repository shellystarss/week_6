part of 'pages.dart';

class EditPage extends StatefulWidget {
  EditPage({Key key, this.product}) : super(key: key);
  final Products product;

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  Products product;
  TextEditingController ctrlName;
  TextEditingController ctrlPrice;
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

  @override
  void initState() {
    product = widget.product;
    ctrlName = TextEditingController(text: product.name);
    ctrlPrice = TextEditingController(text: product.price);
    super.initState();
  }

  @override
  void dispose() {
    ctrlName.dispose();
    ctrlPrice.dispose();
    super.dispose();
  }

  void clearForm() {
    ctrlName.clear();
    ctrlPrice.clear();
    setState(() {
      imageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Data"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(children: [
        Container(
          margin: EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: ctrlName,
                    // initialValue: product.name,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.add_box),
                        labelText: 'Product Name',
                        hintText: "Write your product name",
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: ctrlPrice,
                    // initialValue: product.price,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.attach_money),
                        labelText: 'Price',
                        hintText: "Write product's price",
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 50, right: 50),
                    child: Image.network(product.image),
                  ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      RaisedButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        padding: EdgeInsets.all(15),
                        child: Text("Update Product"),
                        onPressed: () async {
                          // ctrlName.text = product.name;
                          // ctrlPrice.text = product.price;
                          if (ctrlName.text == "" || ctrlPrice.text == "") {
                            Fluttertoast.showToast(
                                msg: "Please fill all fields!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else {
                            setState(() {
                              isLoading = true;
                            });
                            Products product = Products(
                                widget.product.id,
                                ctrlName.text,
                                ctrlPrice.text,
                                widget.product.image);
                            bool result =
                                await ProductServices.updateProduct(product);

                            if (result == true) {
                              Fluttertoast.showToast(
                                  msg: "Update product successful.",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              clearForm();
                              setState(() {
                                isLoading = false;
                              });
                              Navigator.of(context).pop();
                            } else {
                              Fluttertoast.showToast(
                                  msg:
                                      "Update product failed. Please try again.",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                      ),
                      RaisedButton(
                          color: Colors.red,
                          textColor: Colors.white,
                          padding: EdgeInsets.all(15),
                          child: Text("Delete Product"),
                          onPressed: () async {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Delete Confirmation"),
                                    content: Text("Are you sure to delete " +
                                        product.name +
                                        "?"),
                                    actions: [
                                      FlatButton(
                                        onPressed: () async {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          await ProductServices.deleteProduct(
                                              product);
                                          Fluttertoast.showToast(
                                              msg: "Delete product successful.",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor: Colors.green,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                          clearForm();
                                          setState(() {
                                            isLoading = false;
                                          });
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
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
                          }),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              )
            ],
          ),
        ),
        isLoading == true
            ? Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.transparent,
                child: SpinKitFadingCircle(
                  size: 50,
                  color: Colors.blue,
                ),
              )
            : Container()
      ]),
    );
  }
}
