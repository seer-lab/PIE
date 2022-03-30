from pydriller import Repository, Git
import os 
from shutil import copyfile
from pinot import scan_patterns
from pymongo import MongoClient
import analysis_tools


mongo_uri ='mongodb://localhost:27018'
if 'IS_DOCKER' in os.environ: 
  mongo_uri ='mongodb://dp_mongodb:27017'

client = MongoClient(mongo_uri)

db = client.thesis_data
collection = db.jhotdraw

processed_commits = set([str(id) for id in collection.find().distinct('_id')])

base_path = '../jhotdraw/JHotDraw'
subdir= 'JHotDraw'
gr = Git('../jhotdraw/')

# base_path = '../jhotdraw'
# gr = Git('../jhotdraw/')

def get_files(path): 
  values = []
  for p, d, f in os.walk(path):
    for file in f:
      if file.endswith('.java') and not 'test' in file.lower():
          values.append(os.path.join(p, file))
  return values

def is_subdirectory_modified(modified_files): 
  for x in modified_files: 
    if x.new_path != None and subdir in x.new_path: 
      return True
  return False

def analyze_commit(commit): 
  if commit.hash in processed_commits: 
    return 

  if not is_subdirectory_modified(commit.modified_files):
    return 
  gr.checkout(commit.hash)

  files = get_files(base_path)
  patterns, locations = scan_patterns(files, base_path)
  json = {
    '_id': commit.hash, 
    'msg': commit.msg,
    'merge': commit.merge,
    'author': commit.author.name,
    'date': commit.committer_date.strftime("%Y-%m-%d"),
    'lines': commit.lines,
    'files': commit.files,
    'file_list': [str(x).split('/')[-1].replace('.java', '') for x in files],
    'modified_files': [x.new_path for x in commit.modified_files],
    'summary': patterns, 
    'pattern_locations': locations
  }
  collection.insert_one(json)
  if patterns != None: 
    # print(json)
    print('Processed', commit.hash)
  else: 
    print('Failed to run Pinot on hash:', commit.hash)

# repo = Repository('../jdk8u_jdk/', order='topo-order')
repo = Repository('../jhotdraw/', order='topo-order')
commits = []
for commit in repo.traverse_commits(): 
  analyze_commit(commit)
# commit = gr.get_commit('6e45e10b03bafdc125c46a4864ba802c24d6bc78')
# analyze_commit(commit)