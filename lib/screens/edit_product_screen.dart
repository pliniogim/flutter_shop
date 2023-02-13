import 'package:flutter/material.dart';
import '../providers/product.dart';

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

  @override
  void initState() {
    _imageURLFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  void _updateImageUrl() {
    if (!_imageURLFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    _form.currentState?.save();
    debugPrint(_editedProduct.title);
    debugPrint(_editedProduct.description);
    debugPrint(_editedProduct.imageUrl);
    debugPrint(_editedProduct.price.toString());
    debugPrint(_editedProduct.id);
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
      body: Form(
        key: _form,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: value!,
                    description: _editedProduct.description,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
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
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: _editedProduct.title,
                    description: _editedProduct.description,
                    price: double.parse(value!),
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
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
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: _editedProduct.title,
                    description: value!,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
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
                            child: Image.network(_imageURLController.text),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: value!,
                        );
                      },
                      controller: _imageURLController,
                      decoration: const InputDecoration(labelText: 'Image URL'),
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
