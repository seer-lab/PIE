from PIPE.project import Project
from PIPE import CONFIG, database as db
from pydriller import Repository

def get_file(repo: Repository, commit, filename): 
  data = repo.git.get_commit(commit)
  if data == None or filename == None: 
    return 'Failed to fetch modification for commit ' + commit
  for file in data.modified_files: 
    if file.new_path == None:
      continue
    if filename + '.java' in file.new_path:
      if file.diff == None or file.source_code == None: 
        return ''
      source = file.source_code.split('\n')
      for key, value in file.diff_parsed['added']: 
        source[key-1] = '+ ' + source[key-1]
      for key, value in file.diff_parsed['deleted']: 
        source.insert(key-1, '- ' + value)
      return '\n'.join(source)
  return ''

def store_modifications(project: Project, repo: Repository): 
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
          temp[commit][filename] = get_file(project, commit, filename)
    
  for filename in filenames: 
    ans = {'_id': filename}
    for key, value in temp.items(): 
      if filename in value: 
        ans[key] = value[filename]
    files_processed.add(filename)
    db.add_entry(collection_name, ans)