from pydriller import Repository, Git
import os 
from pymongo import MongoClient

def get_files(path): 
  values = []
  for p, d, f in os.walk(path):
    for file in f:
      if file.endswith('.java') and not 'test' in file.lower():
          values.append(os.path.join(p, file))
  return values

def get_sorted_documents(sort): 
  client = MongoClient('localhost', 27017)

  db = client.thesis_data
  collection = db.ignite

  files ={}
  for document in collection.find(): 
    files[document['_id']] = document 

  repo = Repository('../ignite', order=sort)

  documents = []
  for commit in repo.traverse_commits(): 
    documents.append(files[commit.hash])
  return documents

def get_files_at_commit(commit): 
  gr = Git('../ignite')

  gr.checkout(commit)
  return get_files('../ignite')

def get_commit_data(commit): 
  gr = Git('../ignite')
  return gr.get_commit(commit)