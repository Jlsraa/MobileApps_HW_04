import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_track/user_page/bloc/apibloc_bloc.dart';
import 'package:money_track/user_page/bloc/picture_bloc.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:feature_discovery/feature_discovery.dart';

import 'circular_button.dart';
import 'cuenta_item.dart';

const String feature1 = 'view_tutorial_feature_id';
const String feature2 = 'change_picture_feature_id';
const String feature3 = 'view_card_feature_id';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ScreenshotController _screenshotController = ScreenshotController();

  Column clientData(ApiListState state) {
    List<CuentaItem> accounts = [];
    for (var account in state.url["sheet1"]) {
      accounts.add(
        CuentaItem(
          saldoDisponible: "${account["dinero"]}",
          terminacion: "${account["tarjeta"]}".substring(4),
          tipoCuenta: "${account["cuenta"]}",
        ),
      );
    }
    return Column(
      children: accounts,
    );
  }

  Future _captureAndShare() async {
    await _screenshotController
        .capture(delay: const Duration(milliseconds: 10))
        .then((image) async {
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = await File('${directory.path}/image.png').create();
        await imagePath.writeAsBytes(image);

        /// Share Plugin
        await Share.shareFiles([imagePath.path]);
      }
    });
  }

  @override
  void initState() {
    BlocProvider.of<ApiblocBloc>(context).add(ApiEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: _screenshotController,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              tooltip: "Compartir pantalla",
              onPressed: () async {
                await _captureAndShare();
              },
              icon: Icon(Icons.share),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                BlocConsumer<PictureBloc, PictureState>(
                  // Listener looks at the state that was recieved and it stays there (Last state), if the next state is the same that the actual state, it doesn't do anything
                  // It's designed to make changes but not to return widgets
                  listener: (context, state) {
                    if (state is PictureErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${state.errorMsg}"),
                        ),
                      );
                    }
                  },
                  // Builder recieves state generated by Bloc, resets everytime a new state comes in
                  builder: (context, state) {
                    if (state is PictureSelectedState) {
                      return CircleAvatar(
                        backgroundImage: FileImage(state.picture),
                        minRadius: 40,
                        maxRadius: 80,
                      );
                    } else {
                      return CircleAvatar(
                        backgroundColor: Colors.grey,
                        minRadius: 40,
                        maxRadius: 80,
                      );
                    }
                  },
                ),
                SizedBox(height: 16),
                Text(
                  "Bienvenido",
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(color: Colors.black),
                ),
                SizedBox(height: 8),
                Text("Usuario${UniqueKey()}"),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    DescribedFeatureOverlay(
                      featureId: 'view_card_feature_id',
                      tapTarget: Icon(Icons.credit_card),
                      title: Text('Ver tarjeta'),
                      description: Text('Ve tarjetas guardadas'),
                      overflowMode: OverflowMode.extendBackground,
                      child: CircularButton(
                        textAction: "Ver tarjeta",
                        iconData: Icons.credit_card,
                        bgColor: Color(0xff123b5e),
                        action: null,
                      ),
                    ),
                    DescribedFeatureOverlay(
                      featureId: 'change_picture_feature_id',
                      tapTarget: Icon(Icons.camera_alt),
                      title: Text('Cambiar foto'),
                      description: Text(
                          'Cambia tu foto de perfil al tomar una foto con tu cámara.'),
                      overflowMode: OverflowMode.extendBackground,
                      child: CircularButton(
                        textAction: "Cambiar foto",
                        iconData: Icons.camera_alt,
                        bgColor: Colors.orange,
                        action: () {
                          BlocProvider.of<PictureBloc>(context).add(
                            ChangeImageEvent(),
                          );
                        },
                      ),
                    ),
                    DescribedFeatureOverlay(
                      featureId: 'view_tutorial_feature_id',
                      tapTarget: Icon(Icons.play_arrow),
                      title: Text('Ver Tutorial'),
                      description: Text('Muestra el funcionamiento de la app.'),
                      overflowMode: OverflowMode.extendBackground,
                      child: CircularButton(
                        textAction: "Ver tutorial",
                        iconData: Icons.play_arrow,
                        bgColor: Colors.green,
                        action: () {
                          FeatureDiscovery.clearPreferences(
                              context, <String>{feature1, feature2, feature3});
                          FeatureDiscovery.discoverFeatures(
                              context, <String>{feature1, feature2, feature3});
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 48),
                Column(
                  children: [
                    BlocConsumer<ApiblocBloc, ApiblocState>(
                      builder: (context, state) {
                        if (state is ApiLoadingState) {
                          return CircularProgressIndicator();
                        } else if (state is ApiListState) {
                          return clientData(state);
                        } else {
                          return Text("Lo sentimos, ha ocurrido un error");
                        }
                      },
                      listener: (context, state) {
                        if (state is ApiLoadingState) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Cargando...")),
                          );
                        } else if (state is ApiErrorState) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Hubo un error")),
                          );
                        } else {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Listo")),
                          );
                        }
                      },
                    ),
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
