import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';

import '../../../theme/theme.dart';

class Modules extends StatefulWidget {
  const Modules({super.key});

  @override
  State<Modules> createState() => _ModulesState();
}

class _ModulesState extends State<Modules> {
  final _moduleRepo = ModuleRepository();

  @override
  Widget build(BuildContext context) {
    return  Container(
        height: 400,
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder<List<ModuleItem>?>(
          future: _moduleRepo.getModulesById('MAIN'),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            Widget child = const SizedBox();

            if (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.connectionState == ConnectionState.active) {
              child = const CircularProgressIndicator(color: primaryColor);
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                List<ModuleItem> modules = snapshot.data;
                debugPrint('SnapshotData>>>${snapshot.data}');
                child = GridView.builder(
                  shrinkWrap: true,
                    itemCount: modules.length,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 1,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                          onTap: () {
                            ModuleUtil.onItemClick(modules[index], context);
                          },
                          child: Container(
                            decoration: const BoxDecoration(),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                    child: Image.network(
                                  modules[index].moduleUrl!,
                                )),
                                Text(
                                  modules[index].moduleName,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          ));
                    });
              } else {
                child = Text('${snapshot.error}');
              }
            }
            return child;
          },
        ),
    );
  }
}
