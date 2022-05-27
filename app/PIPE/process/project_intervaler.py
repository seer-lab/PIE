from PIPE.project import Project
from PIPE import CONFIG, database as db
from lifecycle_parser import LifecycleParser


def hash_to_list(items, metadata = {}): 
  return [{'_id': key, 'items': value, **metadata} for key, value in items.items()]

def interval_project(project: Project): 
  documents = db.get_documents(project)
  parser = LifecycleParser(documents)

  collection_name = project._name + CONFIG.PATTERN_INTERVAL_SUFFIX
  pattern_lifecycles = {}

  for pattern in CONFIG.DESIGN_PATTERNS: 
    temp = {}
    for pattern_instance in parser.get_detected_patterns(pattern): 
      temp[pattern_instance] = parser.git_pattern_instance_data(pattern_instance, pattern)
    pattern_lifecycles.update(temp)
    print(str(pattern) + ' has ' + str(len(temp)) + ' instances.')
    if (len(temp) > 0):
      db.add_entrys(collection_name, hash_to_list(temp, {'pattern': pattern}))
  
  return True 