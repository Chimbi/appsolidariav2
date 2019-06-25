import 'package:appsolidariav2/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class _PageSelector extends StatefulWidget {

  @override
  __PageSelectorState createState() => __PageSelectorState();
}

class __PageSelectorState extends State<_PageSelector> {
  final GlobalKey<FormState> formKey = GlobalKey();


  TextEditingController controller = new TextEditingController();


  void _handleArrowButtonPress(BuildContext context, int delta) {
    final TabController controller = DefaultTabController.of(context);
    final int controllerLength = 2;
    if (!controller.indexIsChanging)
      controller.animateTo((controller.index + delta).clamp(
          0, controllerLength - 1)); //2 se cambia por widget.icons.length
  }

  //TODO Inicializar el objeto con los campos que se traen del sistema por ahora que son:
  //poliza,sede,fechaEmision = now, numero,temporario,periodo, estado, intermediario, comision, cupoOperativo.
  //cuando se incluya inicializar tambien la variable cumulo.


  @override
  Widget build(BuildContext context) {
    final TabController controller = DefaultTabController.of(context);
    final Color color = Theme.of(context).accentColor;
    return SafeArea(
      top: false,
      bottom: false,
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 16.0),
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  color: color,
                  onPressed: () {
                    _handleArrowButtonPress(context, -1);
                  },
                  tooltip: 'Atras',
                ),
                TabPageSelector(controller: controller),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  color: color,
                  onPressed: () {
                    _handleArrowButtonPress(context, 1);
                  },
                  tooltip: 'Adelante',
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
          ),
          Expanded(
            child: IconTheme(
              data: IconThemeData(
                size: 128.0,
                color: color,
              ),
              //TODO puse TabBarView dentro de form vamos a ver si funciona!!!
              child: Form(
                key: formKey,
                child: TabBarView(
                  //Aca se definen las ventanas _____________________________________
                    children: <Widget>[
                Card(
                margin: EdgeInsets.all(10.0),
                  child: Center(child: Text("Pagina 1"))),

                Card(
                          margin: EdgeInsets.all(10.0),
                          child: Center(child: Text("Pagina 2")))
                    ]
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class PageSelectorDemo extends StatelessWidget {
  static const String routeName = '/material/page-selector';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Póliza'),
        actions: <Widget>[],
      ),
      body: DefaultTabController(
        length: 2,
        child: _PageSelector(),
      ),
    );
  }
}
