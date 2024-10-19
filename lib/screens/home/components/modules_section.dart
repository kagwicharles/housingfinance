import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:hfbbank/screens/home/components/skeleton_loader.dart';

import '../../../theme/theme.dart';
import 'modules_loader.dart';

class Modules extends StatefulWidget {
  final bool isSkyBlueTheme;
  const Modules({required this.isSkyBlueTheme});

  @override
  State<Modules> createState() => _ModulesState();
}

class _ModulesState extends State<Modules> {
  final _moduleRepo = ModuleRepository();

  @override
  Widget build(BuildContext context) {
    return  Container(
        color: Colors.grey[200],
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: FutureBuilder<List<ModuleItem>?>(
            future: _moduleRepo.getModulesById('MAIN'),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              Widget child = const SizedBox();

              if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.connectionState == ConnectionState.active) {
                child = Center(child: SkeletonLoader(child: const ModuleLoader(),));
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  List<ModuleItem> modules = snapshot.data;
                  debugPrint('SnapshotData>>>${snapshot.data}');
                  child = GridView.builder(
                      shrinkWrap: true,
                      itemCount: modules.length,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 20,
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
                                  Card(
                                      margin: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      elevation: 0,
                                      color: Colors.white,
                                      shadowColor: Colors.black,
                                      child: Padding(
                                        padding: EdgeInsets.all(15),
                                        child: Image.network(
                                          modules[index].moduleUrl!,
                                          width: 20,
                                        ),
                                      )),
                                  SizedBox(height: 4,),
                                  Text(
                                    formatModuleName(modules[index].moduleName),
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 11,
                                      fontFamily: "Manrope"
                                    ),
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
        ),
    );
  }

  String formatModuleName(String moduleName) {
    List<String> parts = moduleName.split(' ');

    if (parts.length > 2) {
      // Check the length of the second string
      if (parts[1].length > 4) {
        // Move the second string to the next line
        return '${parts[0]}\n${parts[1]} ${parts.sublist(2).join(' ')}';
      } else {
        // Move the third string to the next line
        return '${parts[0]} ${parts[1]}\n${parts.sublist(2).join(' ')}';
      }
    } else if (parts.length == 2) {
      // Handle case where there are only two words
      if (parts[1].length > 2) {
        return '${parts[0]}\n${parts[1]}';
      } else {
        return moduleName; // No change needed
      }
    }

    return moduleName; // Return unchanged if only one word
  }

}
