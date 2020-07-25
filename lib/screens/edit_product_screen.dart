import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_model.dart';
import '../providers/products_model.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _isInit = true;

  var _editedProduct = ProductModel(id: null, title: '', price: 0, description: '', imageUrl: '');
  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<ProductsModel>(context, listen: false).findById(productId);
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }

    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) return;
    _form.currentState.save();
    if (_editedProduct.id == null) {
      Provider.of<ProductsModel>(context, listen: false).addProduct(_editedProduct);
    } else {
      Provider.of<ProductsModel>(context, listen: false).updateProduct(_editedProduct.id, _editedProduct);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  initialValue: _editedProduct.title,
                  decoration: InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_priceFocusNode),
                  onSaved: (value) => _editedProduct = _editedProduct.copyWith(title: value),
                  validator: (value) {
                    if (value.isEmpty) return 'Please provide a value.';
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: _editedProduct.price.toString(),
                  decoration: InputDecoration(labelText: 'Price'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_descriptionFocusNode),
                  onSaved: (value) =>
                      _editedProduct = _editedProduct.copyWith(price: double.parse(value)),
                  validator: (value) {
                    if (value.isEmpty) return 'Please enter a price.';
                    if (double.tryParse(value) == null) return 'Please enter a valid number.';
                    if (double.parse(value) <= 0) return 'Please enter a number greater than zero.';
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: _editedProduct.description,
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,
                  onSaved: (value) => _editedProduct = _editedProduct.copyWith(description: value),
                  validator: (value) {
                    if (value.isEmpty) return 'Please enter a description.';
                    if (value.length < 10) return 'Should be at least 10 characters long.';
                    return null;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(top: 8, right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                      ),
                      child: _imageUrlController.text.isEmpty
                          ? Text('Enter a URL')
                          : FittedBox(
                              child: Image.network(_imageUrlController.text),
                              fit: BoxFit.cover,
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        focusNode: _imageUrlFocusNode,
                        onFieldSubmitted: (_) => _saveForm(),
                        onSaved: (value) =>
                            _editedProduct = _editedProduct.copyWith(imageUrl: value),
                        validator: (value) {
                          if (value.isEmpty) return 'Please enter an image URL.';
                          if (!value.startsWith('http') && !value.startsWith('https'))
                            return 'Please enter a valid URL.';
                          return null;
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
