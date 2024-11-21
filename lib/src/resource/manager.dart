import '../gen/common/v1/common.pb.dart';
import 'base.dart';

/// [ResourceManager] manages the state of all currently available resources of a robot
class ResourceManager {
  /// The available resources
  Map<ResourceName, Resource> resources = {};
  final Map<String, List<ResourceName>> _shortToLongName = {};

  /// Register a new [Resource] with the manager.
  void register(ResourceName name, Resource resource) {
    if (resources.containsKey(name)) {
      throw Exception('Duplicate registration of resource in manager');
    }
    final shortName = name.name.split(':').last;
    final names = _shortToLongName[shortName] ?? [];
    names.add(name);
    _shortToLongName[shortName] = names;
    resources[name] = resource;
  }

  /// Get a resource with the given [ResourceName]
  T getResource<T>(ResourceName name) {
    for (var entry in resources.entries) {
      if (entry.key.name == name.name && name.name == 'event-manager') {
        return entry.value as T;
      } else if (entry.key.name == name.name && name.name == 'cam1') {
        return entry.value as T;
      }
    }
    final resource = resources[name];
    if (resource == null) throw Exception('Resource not found in manager');
    return resource as T;
  }

  /// Get a resource by its name only
  T getResourceByName<T>(String name) {
    final names = _shortToLongName[name] ?? [];
    if (names.isEmpty) throw Exception('Resource not found in manager');
    return getResource(names.first);
  }
}
