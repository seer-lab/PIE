from pydriller import Repository, Git
import os 
from shutil import copyfile
from pinot import scan_patterns
from pymongo import MongoClient
client = MongoClient('localhost', 27017)

db = client.thesis_data
collection = db.ignite

processed_commits = set([str(id) for id in collection.find().distinct('_id')])

base_path = '../ignite/modules/'
flatten_path = '../flatten_ignite/'
gr = Git('../ignite')

def clear_directory(): 
  for x in os.listdir(flatten_path): 
    os.remove(flatten_path + x)


def flatten_project(path): 
    files = os.listdir(path)
    for x in files: 
        if os.path.isdir(path + x): 
            flatten_project(path + x + '/')
        elif '.java' in x and not 'test' in x.lower(): 
            copyfile(path + x, flatten_path + x)

def get_files(path): 
  values = []
  files = os.listdir(path)
  for x in files: 
      if os.path.isdir(path + x): 
          values += get_files(path + x + '/')
      elif '.java' in x and not 'test' in x.lower(): 
          values.append(path + x)
  return values

def analyze_commit(commit): 
  if commit.hash in processed_commits: 
    return 

  gr.get_commit(commit.hash)
  files = get_files(base_path)

  patterns, locations = scan_patterns(files, base_path)
  json = {
    '_id': commit.hash, 
    'msg': commit.msg,
    'author': commit.author.name,
    'date': commit.committer_date.strftime("%Y-%m-%d"),
    'lines': commit.lines,
    'files': commit.files,
    'modified_files': [x.new_path for x in commit.modified_files],
    'summary': patterns, 
    'pattern_locations': locations
  }

  if patterns != None: 
    collection.insert_one(json)
    print('Processed', commit.hash)
  else: 
    print('Failed to run Pinot on hash:', commit.hash)

repo = Repository('../ignite')

commits = []
for commit in repo.traverse_commits(): 
  analyze_commit(commit)


