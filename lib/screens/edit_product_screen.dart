import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = 'edit-product';

  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageURLFocusNode = FocusNode();
  final _imageURLController = TextEditingController();

  var _editedProduct = Product(
    id: '',
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  final _form = GlobalKey<FormState>();
  var _isInit = true;
  var _isLoading = false;

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  @override
  void initState() {
    _imageURLFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments as String;
      if (productId != 'newProduct') {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          //'imageUrl': _editedProduct.imageUrl,
          'imageUrl': '',
        };
        _imageURLController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageURLFocusNode.hasFocus) {
      if (_imageURLController.text.isEmpty ||
          (_imageURLController.text.startsWith('http://') &&
              !_imageURLController.text.startsWith('https://')) ||
          (!_imageURLController.text.endsWith('.png') &&
              !_imageURLController.text.endsWith('.jpg') &&
              !_imageURLController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (isValid) {
      _form.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      if (_editedProduct.id != '') {
        await Provider.of<Products>(context, listen: false)
            .updateProduct(_editedProduct.id, _editedProduct);

      } else {
        try {
          await Provider.of<Products>(context, listen: false)
              .addProduct(_editedProduct);
        } catch (error) {
          await showDialog<void>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Ops, an error occurred!'),
              content: Text(
                error.toString(),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
        // finally {
        //   setState(() {
        //     _isLoading = false;
        //   });
        //   Navigator.pop(context);
        // }
      }
      // debugPrint(_editedProduct.title);
      // debugPrint(_editedProduct.description);
      // debugPrint(_editedProduct.imageUrl);
      // debugPrint(_editedProduct.price.toString());
      // debugPrint(_editedProduct.id);
      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _imageURLFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageURLFocusNode.dispose();
    _imageURLController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(
              Icons.save,
            ),
          )
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _form,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      initialValue: _initValues['title'],
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          return null;
                        } else {
                          return 'Please, provide a value!';
                        }
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: value!,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      initialValue: _initValues['price'],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please, enter a price.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please, enter a valid number.';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please, enter a number greater than zero.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: double.parse(value!),
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      focusNode: _priceFocusNode,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Price',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      initialValue: _initValues['description'],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please, provide a description.';
                        } else {
                          if (value.length < 10) {
                            return 'Should be at leas 10 characters long.';
                          } else {
                            return null;
                          }
                        }
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: value!,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                      maxLines: 3,
                      focusNode: _descriptionFocusNode,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(
                            top: 8,
                            right: 10,
                          ),
                          child: _imageURLController.text.isEmpty
                              ? const Text('Enter a URL')
                              : FittedBox(
                                  fit: BoxFit.cover,
                                  child:
                                      Image.network(_imageURLController.text),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            //initialValue: _initValues['imageUrl'], cannot be used because of a controller
                            //change in controller
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please, enter a valid URL.';
                              }
                              if (!value.startsWith('http://') &&
                                  (!value.startsWith('https://'))) {
                                return 'Please, enter a URL that starts with http.';
                              }
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Please, enter a valid format (png, jpg or jpeg)';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                imageUrl: value!,
                                isFavorite: _editedProduct.isFavorite,
                              );
                            },
                            controller: _imageURLController,
                            decoration:
                                const InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            focusNode: _imageURLFocusNode,
                            onEditingComplete: () {
                              setState(() {});
                            },
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
