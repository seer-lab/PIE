from pydriller import Repository, Git
import os 
from pymongo import MongoClient
import subprocess

TARGET_PROJECT = '../ignite'

def get_files(path): 
  values = []
  for p, d, f in os.walk(path):
    for file in f:
      if file.endswith('.java') and not 'test' in file.lower():
          values.append(os.path.join(p, file))
  return values

def get_file_names(file_list): 
  return [str(x).split('/')[-1].replace('.java', '') for x in file_list]

def file_locations_to_name(file_locations): 
  return '-'.join([path.split('/')[-1] for path in file_locations]).replace('.java','')

def get_sorted_documents(sort): 
  client = MongoClient('localhost', 27017)

  db = client.thesis_data
  collection = db.ignite

  files ={}
  for document in collection.find(): 
    files[document['_id']] = document 

  repo = Repository(TARGET_PROJECT, order=sort, only_in_branch='master')

  documents = []
  for commit in repo.traverse_commits(): 
    #files[commit.hash]['branches'] = commit.branches
    documents.append(files[commit.hash])
  return documents

def get_files_at_commit(commit): 
  proc = subprocess.run(["git -C '{}' ls-tree --name-only -r {}".format(TARGET_PROJECT, commit)], shell=True, capture_output=True, text=True)
  output = proc.stdout.split('\n')
  return list(filter(lambda x: 'java' in x, output))

def get_commit_data(commit): 
  gr = Git(TARGET_PROJECT)
  return gr.get_commit(commit)

get_files_at_commit()