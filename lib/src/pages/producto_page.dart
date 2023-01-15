import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:formvalidation/src/models/producto_model.dart';
import 'package:formvalidation/src/utils/utils.dart' as utils;

class ProductoPage extends StatefulWidget {
  const ProductoPage({super.key});

  @override
  State<ProductoPage> createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // final productoBloc = ProductosBloc();

  late ProductosBloc productosBloc;
  ProductoModel producto = ProductoModel();
  bool _guardando = false;
  late File? foto;
  // PickedFile foto;

  @override
  Widget build(BuildContext context) {
    productosBloc = Provider.productosBloc(context);

    producto = ProductoModel();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        title: const Text('Producto'),
        actions: [
          // Galeria
          IconButton(
            icon: const Icon(Icons.photo_size_select_actual),
            onPressed: _seleccionarFoto,
          ),
          // Camara
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: _tomarFoto,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: Form(
              key: formKey,
              child: Column(
                children: [
                  _mostrarFoto(),
                  _crearNombre(),
                  _crearPrecio(),
                  _crearDisponible(),
                  _crearBoton(),
                ],
              )),
        ),
      ),
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        labelText: 'Producto',
      ),
      onSaved: (value) => producto.titulo = value!,
      validator: (value) {
        if (value!.length < 3) {
          return 'Ingrese el nombre del producto';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearPrecio() {
    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: const InputDecoration(
        labelText: 'Precio',
      ),
      onSaved: (value) => producto.valor = double.parse(value!),
      validator: (value) {
        if (utils.isNumeric(value!)) {
          return null;
        } else {
          return 'Sólo números';
        }
      },
    );
  }

  Widget _crearDisponible() {
    return SwitchListTile(
        value: producto.disponible,
        title: const Text('Disponible'),
        activeColor: Colors.deepPurple,
        onChanged: (value) => setState(() {
              producto.disponible = value;
            }));
  }

  Widget _crearBoton() {
    return TextButton.icon(
      style: TextButton.styleFrom(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        backgroundColor: Colors.deepPurple,
        textStyle: const TextStyle(
          color: Colors.white,
        ),
      ),
      label: const Text('Guardar'),
      icon: const Icon(Icons.save),
      onPressed: (_guardando) ? null : _submit,
    );
  }

  void _submit() async {
    if (!formKey.currentState!.validate()) return;

    formKey.currentState!.save();

    _guardando = true;
    setState(() {});

    producto.fotoUrl = await productosBloc.subirFoto(foto!);

    if (producto.id == null) {
      productosBloc.agregrarProducto(producto);
    } else {
      productosBloc.editarProducto(producto);
    }

    mostrarSnackbar('Registro guardado');

    Timer(const Duration(milliseconds: 1500), () {
      Navigator.pop(context);
    });
  }

  void mostrarSnackbar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: const Duration(milliseconds: 1500),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  Widget _mostrarFoto() {
    if (producto.fotoUrl != null) {
      return FadeInImage(
        image: NetworkImage(producto.fotoUrl!),
        placeholder: const AssetImage('assets/jar-loading.gif'),
        height: 300.0,
        fit: BoxFit.contain,
      );
    } else {
      return const Image(
        image: AssetImage('assets/no-image.png'),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }
  }

  _seleccionarFoto() async {
    _procesarImagen(ImageSource.gallery);
  }

  _tomarFoto() {
    _procesarImagen(ImageSource.camera);
  }

  _procesarImagen(ImageSource origen) async {
    final pickedFile = await ImagePicker().pickImage(source: origen);

    try {
      foto = File(pickedFile!.path);
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
    }

    if (foto != null) {
      producto.fotoUrl = null;
    }

    setState(() {});
  }
}
