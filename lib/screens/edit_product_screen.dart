// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_app_my_shop/models/product.dart';
import 'package:flutter_app_my_shop/providers/products_provider.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "'/edit-product";

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imgUrlController = TextEditingController();
  final _imgUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _edittedProduct = Product(
    id: null,
    title: "",
    description: "",
    price: 0,
    imgUrl: "",
  );
  var _initValues = {
    "title": "",
    "description": "",
    "price": "",
    "imgUrl": "",
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    _imgUrlFocusNode.addListener(_updateImgUrl);
    super.initState();
  }

  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _edittedProduct = Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId);
        _initValues = {
          "title": _edittedProduct.title,
          "description": _edittedProduct.description,
          "price": _edittedProduct.price.toString(),
          // "imgUrl": _edittedProduct.imgUrl,
          "imgUrl": "",
        };
        _imgUrlController.text = _edittedProduct.imgUrl;
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _imgUrlFocusNode.removeListener(_updateImgUrl);
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imgUrlController.dispose();
    _imgUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImgUrl() {
    if (!_imgUrlFocusNode.hasFocus) {
      if ((!_imgUrlController.text.startsWith("http") &&
              !_imgUrlController.text.startsWith("https")) ||
          (!_imgUrlController.text.endsWith(".png") &&
              !_imgUrlController.text.endsWith(".jpg") &&
              !_imgUrlController.text.endsWith(".jpeg"))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();

    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_edittedProduct.id != null) {
      await Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(_edittedProduct.id, _edittedProduct);
    } else {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(_edittedProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("An error occurred"),
            content: Text(
              "Sonething went wrong ",
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text("OK"),
              )
            ],
          ),
        );
      }
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValues["title"],
                      decoration: InputDecoration(
                        labelText: "Title",
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please provide a value ";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        _edittedProduct = Product(
                          title: value,
                          description: _edittedProduct.description,
                          price: _edittedProduct.price,
                          imgUrl: _edittedProduct.imgUrl,
                          id: _edittedProduct.id,
                          isFavorite: _edittedProduct.isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues["price"],
                      decoration: InputDecoration(labelText: "Price"),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter a price";
                        }
                        if (double.tryParse(value) == null) {
                          return "Please enter a valid number";
                        }
                        if (double.parse(value) <= 0) {
                          return "Please enter a number greater than 0";
                        }
                        if (double.parse(value) > 500.0) {
                          return "Please enter a number smaller than 500";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _edittedProduct = Product(
                          title: _edittedProduct.title,
                          description: _edittedProduct.description,
                          price: double.parse(value),
                          imgUrl: _edittedProduct.imgUrl,
                          id: _edittedProduct.id,
                          isFavorite: _edittedProduct.isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues["description"],
                      decoration: InputDecoration(labelText: "Description"),
                      maxLines: 3,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter a description";
                        }
                        if (value.length < 10) {
                          return "Should be at least 10 chars long";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _edittedProduct = Product(
                          title: _edittedProduct.title,
                          description: value,
                          price: _edittedProduct.price,
                          imgUrl: _edittedProduct.imgUrl,
                          id: _edittedProduct.id,
                          isFavorite: _edittedProduct.isFavorite,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(
                            top: 8,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imgUrlController.text.isEmpty
                              ? Text("Enter a URL")
                              : FittedBox(
                                  child: Image.network(
                                    _imgUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            //initialValue and controller can't exist in the same widget
                            decoration: InputDecoration(labelText: "Image URL"),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imgUrlController,
                            focusNode: _imgUrlFocusNode,
                            onFieldSubmitted: (_) => _saveForm(),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please enter an imgage URL";
                              }
                              if (!value.startsWith("http") &&
                                  !value.startsWith("https")) {
                                return "Please enter a valid URL";
                              }
                              if (!value.endsWith(".png") &&
                                  !value.endsWith(".jpg") &&
                                  !value.endsWith(".jpeg")) {
                                return "Please enter a valid image URL";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _edittedProduct = Product(
                                title: _edittedProduct.title,
                                description: _edittedProduct.description,
                                price: _edittedProduct.price,
                                imgUrl: value,
                                id: _edittedProduct.id,
                                isFavorite: _edittedProduct.isFavorite,
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
