import 'package:flutter/material.dart';

import 'package:formvalidation/src/bloc/login_bloc.dart';
export 'package:formvalidation/src/bloc/login_bloc.dart'; // export

import 'package:formvalidation/src/bloc/productos_bloc.dart'; // import
export 'package:formvalidation/src/bloc/productos_bloc.dart'; // import

class Provider extends InheritedWidget {
  final loginBloc = LoginBloc();
  final _productosBloc = ProductosBloc();

  static late Provider _instancia;

  factory Provider({Key? key, Widget? child}) {
    _instancia = Provider._internal(key: key, child: child!);
    return _instancia;
  }

  Provider._internal({Key? key, Widget? child})
      : super(key: key, child: child!);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>()!.loginBloc;
  }

  static ProductosBloc productosBloc(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<Provider>()!
        ._productosBloc;
  }
}
