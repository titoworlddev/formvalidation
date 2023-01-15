import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';

import 'package:formvalidation/src/models/producto_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final productosBloc = Provider.productosBloc(context);
    productosBloc.cargarProductos();

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text('Home'),
      ),
      body: _crearListado(productosBloc),
      floatingActionButton: _crearBoton(context),
    );
  }

  Widget _crearListado(ProductosBloc productosBloc) {
    return StreamBuilder(
      stream: productosBloc.productosStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        if (snapshot.hasData) {
          final productos = snapshot.data;

          return ListView.builder(
            itemCount: productos!.length,
            itemBuilder: (context, i) =>
                _crearItem(context, productos[i], productosBloc),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _crearItem(BuildContext context, ProductoModel producto,
      ProductosBloc productosBloc) {
    return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
        ),
        onDismissed: (direccion) {
          productosBloc.borrarProducto(producto.id!);
        },
        child: GestureDetector(
          onTap: () =>
              Navigator.pushNamed(context, 'producto', arguments: producto)
                  .then((value) => setState(() {})),
          child: Card(
            child: Column(
              children: [
                (producto.fotoUrl == null)
                    ? const Image(image: AssetImage('assets/no-image.png'))
                    : FadeInImage(
                        image: NetworkImage(producto.fotoUrl!),
                        placeholder: const AssetImage('assets/jar-loading.gif'),
                        height: 300.0,
                        width: double.infinity,
                        fit: BoxFit.cover),
                ListTile(
                  title: Text('${producto.titulo} - ${producto.valor}'),
                  subtitle: Text(producto.id!),
                ),
              ],
            ),
          ),
        ));
  }

  _crearBoton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Navigator.pushNamed(context, 'producto')
          .then((value) => setState(() {})),
      backgroundColor: Colors.deepPurple,
      child: const Icon(Icons.add),
    );
  }
}
