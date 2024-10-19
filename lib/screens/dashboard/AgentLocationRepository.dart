import 'package:hive_flutter/adapters.dart';

import 'AgentLocations.dart';

class AgentLocationRepository {
  Future<Box<AgentLocation>> openBox() async {
    if (Hive.isBoxOpen("agentLocations")) {
      return Hive.box<AgentLocation>("agentLocations");
    } else {
      return await Hive.openBox<AgentLocation>("agentLocations");
    }
  }

  insertAgentLocations(List<AgentLocation> agentLocations) async {
    var box = await openBox();
    await box.clear();
    box.addAll(agentLocations);
  }

  Future<List<AgentLocation>> getAllAgentLocations() async {
    var box = await openBox();
    return box.values.toList();
  }
}