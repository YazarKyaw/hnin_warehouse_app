import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hnin_warehouse_app/providers/item.dart';
import 'package:hnin_warehouse_app/providers/items.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

class AddItemScreen extends StatefulWidget {
  static const routeName = '/add_item_screen';
  final String categoryId;
  final String itemId;
  AddItemScreen({this.categoryId, this.itemId = ''});
  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  var isLoading = false;
  final _itemCodeEditingController = TextEditingController();
  final _imageUrlEditingController = TextEditingController();
  final _itemNameFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _quantityFocusNode = FocusNode();
  String _myActivity;
  String _myItemList;
  File _storedImage;
  var _isInit = true;
  final _formKey = GlobalKey<FormState>();
  var _initValues = {
    'itemCode': '',
    'itemName': '',
    'description': '',
    'quantity': '',
  };
  var _editedItem = Item(
      id: null,
      itemCode: '',
      itemName: '',
      description: '',
      quantity: 0,
      position: '',
      itemList: '',
      imageUrl: '');
  Future<void> _saveForm() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    setState(() {
      isLoading = true;
    });
    print(_editedItem.position);
    try {
      if (widget.itemId.isEmpty) {
        await Provider.of<Items>(context, listen: false)
            .addItem(_editedItem, widget.categoryId);
      } else {
        await Provider.of<Items>(context, listen: false)
            .updateItem(widget.itemId, _editedItem, widget.categoryId);
      }
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occurred'),
          content: Text('Something went wrong'),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop('dialog');
              },
              child: Text('Okay'),
            ),
          ],
        ),
      );
      throw error;
    }
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
  }

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final imageFile = await picker.getImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    if (imageFile == null) {
      return;
    }
    final image = File(imageFile.path);
    setState(() {
      _storedImage = File(imageFile.path);
    });
    _uploadImageToStorage(image);
  }

  String imageString;
  Future<void> _uploadImageToStorage(File imageFile) async {
    int randomNumber = Random().nextInt(100000);
    String imageLocation = "images/images$randomNumber.jpg";
    try {
      final StorageReference storageReference =
          FirebaseStorage().ref().child(imageLocation);
      final StorageUploadTask uploadTask = storageReference.putFile(imageFile);
      await uploadTask.onComplete;
      final ref = FirebaseStorage().ref().child(imageLocation);
      imageString = await ref.getDownloadURL();
      setState(() {
        _imageUrlEditingController.text = imageString;
      });
    } catch (error) {
      throw error;
    }
    //_addToImagePathToDatabase(imageLocation);
  }

  @override
  void initState() {
    super.initState();
    _myActivity = '';
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _itemNameFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _quantityFocusNode.dispose();
    _itemCodeEditingController.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      if (widget.itemId.isNotEmpty && widget.itemId != null) {
        _editedItem = Provider.of<Items>(context, listen: false)
            .findByItemId(widget.itemId);
        _initValues = {
          'itemCode': _editedItem.itemCode,
          'itemName': _editedItem.itemName,
          'description': _editedItem.description,
          'quantity': _editedItem.quantity.toString(),
        };
        _myActivity = _editedItem.position;
        _myItemList = _editedItem.itemList;
        _imageUrlEditingController.text = _editedItem.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 77, 210, 1),
        title: Text('Add Item'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1.0, color: Colors.pinkAccent),
                          ),
                          child: _imageUrlEditingController.text.isEmpty
                              ? _storedImage != null
                                  ? Image.file(
                                      _storedImage,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    )
                                  : Text(
                                      'No Image Taken',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color.fromRGBO(255, 77, 210, 1),
                                      ),
                                    )
                              : Image.network(
                                  _imageUrlEditingController.text,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                          alignment: Alignment.center,
                        ),
                        SizedBox(width: 1.0),
                        Flexible(
                          child: FlatButton.icon(
                            onPressed: _takePicture,
                            icon: Icon(
                              Icons.camera,
                              color: Color.fromRGBO(255, 77, 210, 1),
                            ),
                            label: Text(
                              'Take Picture',
                              style: TextStyle(
                                color: Color.fromRGBO(255, 77, 210, 1),
                              ),
                            ),
                            textColor: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Image Url',
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      controller: _imageUrlEditingController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter the quantity';
                        }
                        return null;
                      },
                      //onFieldSubmitted: (_) {},
                      onSaved: (value) {
                        _editedItem = Item(
                            id: _editedItem.id,
                            itemCode: _editedItem.itemCode,
                            itemName: _editedItem.itemName,
                            description: _editedItem.description,
                            quantity: _editedItem.quantity,
                            imageUrl: value,
                            position: _editedItem.position,
                            itemList: _editedItem.itemList,
                            isFavorite: _editedItem.isFavorite);
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          //padding: EdgeInsets.all(15),
                          child: DropDownFormField(
                            autovalidate: true,
                            titleText: 'ပစ္စည်းထားသည့်နေရာ',
                            hintText: 'တစ်ခုရွေးပါ',
                            value: _myActivity,
                            onSaved: (value) {
                              _editedItem = Item(
                                  id: _editedItem.id,
                                  itemCode: _editedItem.itemCode,
                                  itemName: _editedItem.itemName,
                                  description: _editedItem.description,
                                  quantity: _editedItem.quantity,
                                  imageUrl: _editedItem.imageUrl,
                                  position: value,
                                  itemList: _editedItem.itemList,
                                  isFavorite: _editedItem.isFavorite);
                            },
                            onChanged: (value) {
                              setState(() {
                                _myActivity = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "အိမ်ပေါ် ",
                                "value": "HomeUp",
                              },
                              {
                                "display": "ဆိုင်အနောက်",
                                "value": "ShopBack",
                              },
                              {
                                "display": "ဂိုဒေါင်",
                                "value": "Warehouse",
                              },
                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          //padding: EdgeInsets.all(15),
                          child: DropDownFormField(
                            autovalidate: true,
                            titleText: 'စာရင်းတိုက်ရန်',
                            hintText: 'တစ်ခုရွေးပါ',
                            value: _myItemList,
                            onSaved: (value) {
                              _editedItem = Item(
                                  id: _editedItem.id,
                                  itemCode: _editedItem.itemCode,
                                  itemName: _editedItem.itemName,
                                  description: _editedItem.description,
                                  quantity: _editedItem.quantity,
                                  imageUrl: _editedItem.imageUrl,
                                  position: _editedItem.position,
                                  itemList: value,
                                  isFavorite: _editedItem.isFavorite);
                            },
                            onChanged: (value) {
                              setState(() {
                                _myItemList = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "ရောက်/ကိုက် ",
                                "value": "yk",
                              },
                              {
                                "display": "ရောက်/မကိုက်",
                                "value": "ymk",
                              },
                              {
                                "display": "ပစ္စည်းမတိုက်ရသေးပါ",
                                "value": "nymk",
                              },
                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Item Code',
                      ),
                      keyboardType: TextInputType.number,
                      controller:
                          TextEditingController(text: _initValues['itemCode']),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_itemNameFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide some code';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedItem = Item(
                            id: _editedItem.id,
                            itemCode: value,
                            itemName: _editedItem.itemName,
                            description: _editedItem.description,
                            quantity: _editedItem.quantity,
                            imageUrl: _editedItem.imageUrl,
                            position: _editedItem.position,
                            itemList: _editedItem.itemList,
                            isFavorite: _editedItem.isFavorite);
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Item Name',
                      ),
                      keyboardType: TextInputType.text,
                      controller:
                          TextEditingController(text: _initValues['itemName']),
                      textInputAction: TextInputAction.next,
                      focusNode: _itemNameFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter item name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedItem = Item(
                            id: _editedItem.id,
                            itemCode: _editedItem.itemCode,
                            itemName: value,
                            description: _editedItem.description,
                            quantity: _editedItem.quantity,
                            imageUrl: _editedItem.imageUrl,
                            position: _editedItem.position,
                            itemList: _editedItem.itemList,
                            isFavorite: _editedItem.isFavorite);
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.next,
                      focusNode: _descriptionFocusNode,
                      controller: TextEditingController(
                          text: _initValues['description']),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_quantityFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter the description';
                        }
                        return null;
                        return null;
                      },
                      onSaved: (value) {
                        _editedItem = Item(
                            id: _editedItem.id,
                            itemCode: _editedItem.itemCode,
                            itemName: _editedItem.itemName,
                            description: value,
                            quantity: _editedItem.quantity,
                            imageUrl: _editedItem.imageUrl,
                            position: _editedItem.position,
                            itemList: _editedItem.itemList,
                            isFavorite: _editedItem.isFavorite);
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                      ),
                      controller:
                          TextEditingController(text: _initValues['quantity']),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      focusNode: _quantityFocusNode,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter the quantity';
                        }
                        return null;
                        return null;
                      },
                      onSaved: (value) {
                        _editedItem = Item(
                            id: _editedItem.id,
                            itemCode: _editedItem.itemCode,
                            itemName: _editedItem.itemName,
                            description: _editedItem.description,
                            quantity: int.parse(value),
                            imageUrl: _editedItem.imageUrl,
                            position: _editedItem.position,
                            itemList: _editedItem.itemList,
                            isFavorite: _editedItem.isFavorite);
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
