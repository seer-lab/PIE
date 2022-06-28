from operator import indexOf
from PIPE.project import Project
from PIPE import CONFIG, database as db
from pydriller import Git
import json 

def get_file(git: Git, commit, filename): 
  data = git.get_commit(commit)
  if data == None or filename == None: 
    return {
      'content': 'Failed to fetch modification for commit ' + commit, 
      'diff': {'added': [], 'deleted': []}
      }
  for file in data.modified_files: 
    if file.new_path == None:
      continue
    if filename + '.java' in file.new_path:
      if file.diff == None or file.source_code == None: 
        return {
        'content': '', 
        'diff': {'added': [], 'deleted': []}
      }
      # source = file.source_code.split('\n')
      # for key, value in file.diff_parsed['added']: 
      #   source[key-1] = '+ ' + source[key-1]
      # for key, value in file.diff_parsed['deleted']: 
      #   source.insert(key-1, '- ' + value)
      # for line in source: 
      #   if line[0] != '+' and line[0] != '-': 
      #     source[source.index(line)] = '  ' + line 
      return {'content': file.source_code, 'diff': file.diff_parsed}
  return {
        'content': '', 
        'diff': {'added': [], 'deleted': []}
      }

def store_modifications(project: Project, git: Git):
  #files_processed = set(db.get_ids_in_collection(project._name + CONFIG.FILE_CHANGES_SUFFIX))
  files_processed = set()
  pattern_lifecycles = db.get_lifecycles(project, CONFIG.DESIGN_PATTERNS)
  collection_name = project._name + CONFIG.FILE_CHANGES_SUFFIX

  for lifecycle, instances in pattern_lifecycles.items():
    print('Working on ' + lifecycle)
    temp = {}
    filenames = set()
    for instance in instances: 
      filename = instance['instance'].split(' ')[0]
      if instance['modification'] != 'Pattern' and not filename in files_processed:
        filenames.add(filename)
        commit = instance['modification']
        if not commit in temp: 
          temp[commit] = {}
        if not filename in temp[commit]: 
          temp[commit][filename] = get_file(git, commit, filename)
      
    for filename in filenames: 
      ans = {'_id': filename}
      last_modification = None
      for key, value in temp.items(): 
        if filename in value: 
          ans[key] = value[filename]
          previous_commit = last_modification if last_modification != None else ''
          ans[key].update({'previous_commit': previous_commit})
          last_modification = key
      files_processed.add(filename)
      db.add_entry(collection_name, json.loads(json.dumps(ans)))
  return True 