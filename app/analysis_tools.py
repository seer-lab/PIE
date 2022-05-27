from fileinput import filename
from pydriller import Repository, Git
import os 
from pymongo import MongoClient
from lifecycle_analyzer import LifecycleAnalyzer
import subprocess


mongo_uri ='mongodb://localhost:27017'
if 'IS_DOCKER' in os.environ:
  mongo_uri ='mongodb://dp_mongodb:27017'

def get_files(path): 
  values = []
  for p, d, f in os.walk(path):
    for file in f:
      if file.endswith('.java') and not 'test' in file.lower():
          values.append(os.path.joizn(p, file))
  return values

def find_file(path, file_name): 
  for p, d, f in os.walk(path):
    for file in f:
      if file.endswith('.java') and file_name in file:
        return os.path.join(p, file)
  return None

def get_file_names(file_list): 
  return set(str(x).split('/')[-1].replace('.java', '') for x in file_list)

def file_locations_to_name(file_locations, pattern): 
  return '-'.join([path.split('/')[-1] for path in sorted(file_locations)]).replace('.java','') + '-' + pattern[:2]

def get_sorted_documents(project, sort): 
  print(project['name'])
  client = MongoClient(mongo_uri)
  db = client.thesis_data
  #collection = db.awt
  collection = db[project['name']]
  if sort == 'topo-order': 
    return [doc for doc in collection.find()]

  files ={}
  for document in collection.find(): 
    files[document['_id']] = document 

  repo = Repository(project['location'], order=sort)

  documents = []
  for commit in repo.traverse_commits():
    if commit.hash in files:  
      documents.append(files[commit.hash])
  return documents

def get_lifecycles(project, patterns): 
  client = MongoClient(mongo_uri)
  
  db = client.thesis_data
  collection = db[project['name'] + '_lifecycle']
  ans = {}
  for pattern in patterns: 
    data = collection.find({'pattern': pattern})
    for item in data:
      analyzer = LifecycleAnalyzer(item)
      ans[item['_id']] = item['items'] + analyzer.analyze()
  return ans 

def get_related_files(project, pattern_instance): 
  client = MongoClient(mongo_uri)

  db = client.thesis_data
  collection = db[project['name'] + '_modifications']
  
  filenames = pattern_instance.split('-')[:-1]
  ans = {}
  for file in filenames: 
    data = collection.find({'_id': file})
    for item in data: 
      ans[file] = item
      ans[file].pop('_id')
  return ans

def get_files_at_commit(project, commit): 
  proc = subprocess.run(["git -C '{}' ls-tree --name-only -r {}".format(project['location'], commit)], shell=True, capture_output=True, text=True)
  output = proc.stdout.split('\n')
  return [str(x).split('/')[-1].replace('.java', '') for x in filter(lambda x: '.java' in x, output)]

def get_commit_data(project, commit): 
  gr = Git(project['location'])
  return gr.get_commit(commit)


def get_file(project, commit, filename): 
  data = get_commit_data(project, commit)
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
  # file_path = find_file(TARGET_PROJECT, filename)
  # content = ""
  # if file_path != None: 
  #   with open(file_path, 'r') as f: 
  #     content = f.read()
  # return content
