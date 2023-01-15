import 'package:flutter/material.dart';

import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/providers/usuario_provider.dart';

import 'package:formvalidation/src/utils/utils.dart';

class RegistroPage extends StatelessWidget {
  final usuarioProvider = UsuarioProvider();

  RegistroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        _crearFondo(context),
        _loginForm(context),
      ],
    ));
  }

  Widget _loginForm(BuildContext context) {
    final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
              child: Container(
            height: 180.0,
          )),
          Container(
            width: size.width * 0.85,
            margin: const EdgeInsets.symmetric(vertical: 30.0),
            padding: const EdgeInsets.symmetric(vertical: 50.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3.0,
                      offset: Offset(0.0, 5.0),
                      spreadRadius: 3.0)
                ]),
            child: Column(
              children: [
                const Text(
                  'Crear cuenta',
                  style: TextStyle(fontSize: 20.0),
                ),
                const SizedBox(
                  height: 60.0,
                ),
                _crearEmail(bloc),
                const SizedBox(
                  height: 30.0,
                ),
                _crearPassword(bloc),
                const SizedBox(
                  height: 30.0,
                ),
                _crearBoton(bloc)
              ],
            ),
          ),
          TextButton(
            child: const Text('¿Ya tienes cuenta?  Login'),
            onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
          ),
          const SizedBox(
            height: 100.0,
          )
        ],
      ),
    );
  }

  Widget _crearEmail(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                icon: const Icon(
                  Icons.alternate_email,
                  color: Colors.deepPurple,
                ),
                hintText: 'ejemplo@correo.com',
                labelText: 'Correo electrónico',
                counterText: snapshot.data,
                errorText: snapshot.error.toString()),
            onChanged: bloc.changeEmail,
          ),
        );
      },
    );
  }

  Widget _crearPassword(LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.passwordStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                  icon: const Icon(
                    Icons.lock_outline,
                    color: Colors.deepPurple,
                  ),
                  labelText: 'Contraseña',
                  counterText: snapshot.data,
                  errorText: snapshot.error.toString()),
              onChanged: bloc.changePassword,
            ),
          );
        });
  }

/* El boton a mi manera */

  // Widget _crearBoton(LoginBloc bloc) {

  //   // formValidStream
  //   // snapshot.hasData
  //   // true ? algo si true : algo si false

  //   return StreamBuilder(
  //     stream: bloc.formValidStream,
  //     builder: (BuildContext context, AsyncSnapshot snapshot ) {

  //       final btnActivo =  RaisedButton(
  //         child: Container(
  //           padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
  //           child: Text('Ingresar'),
  //         ),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(5.0)
  //         ),
  //         elevation: 0.1,
  //         color: Colors.deepPurple,
  //         textColor: Colors.white,
  //         onPressed: () {

  //         },
  //       );

  //       final btnInactivo = RaisedButton(
  //         child: Container(
  //           padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
  //           child: Text('Ingresar'),
  //         ),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(5.0)
  //         ),
  //         elevation: 0.1,
  //         color: Colors.grey,
  //         textColor: Colors.black87,
  //         onPressed: null,
  //       );

  //       final vali = snapshot.hasData ? btnActivo : btnInactivo;

  //       return vali;
  //     }
  //   );
  // }

/* El boton como Fernando */

  Widget _crearBoton(LoginBloc bloc) {
    // formValidStream
    // snapshot.hasData
    // true ? algo si true : algo si false

    return StreamBuilder(
        stream: bloc.formValidStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              elevation: 0.1,
              backgroundColor: Colors.deepPurple,
              textStyle: const TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: snapshot.hasData == true
                ? () => _register(bloc, context)
                : null,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
              child: const Text('Registrar'),
            ),
          );
        });
  }

  _register(LoginBloc bloc, BuildContext context) async {
    final info = await usuarioProvider.nuevoUsuario(bloc.email, bloc.password);

    if (info['ok']) {
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      mostrarAlerta(context, info['mensaje']);
    }
  }

  Widget _crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size.height;

    final fondoMorado = Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(colors: <Color>[
        Color.fromRGBO(63, 63, 156, 1.0),
        Color.fromRGBO(90, 70, 178, 1.0)
      ])),
    );

    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: const Color.fromRGBO(255, 255, 255, 0.05)),
    );

    final logo = Container(
      padding: const EdgeInsets.only(top: 80.0),
      child: Column(
        children: const [
          Icon(
            Icons.person_pin_circle,
            color: Colors.white,
            size: 100.0,
          ),
          SizedBox(
            height: 10.0,
            width: double.infinity,
          ),
          Text('Nombre usuario',
              style: TextStyle(color: Colors.white, fontSize: 25.0))
        ],
      ),
    );

    return SizedBox(
      height: size * 0.4,
      width: double.infinity,
      child: Stack(
        children: [
          fondoMorado,
          Positioned(top: 90.0, left: 30.0, child: circulo),
          Positioned(top: -40.0, right: -30.0, child: circulo),
          Positioned(bottom: -60.0, right: -10.0, child: circulo),
          Positioned(bottom: 100.0, right: 20.0, child: circulo),
          Positioned(bottom: -50.0, left: -20.0, child: circulo),
          logo
        ],
      ),
    );
  }
}
