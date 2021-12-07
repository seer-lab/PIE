from pydriller import Repository, Git
import os 
from shutil import copyfile
from pinot import scan_patterns
from pymongo import MongoClient

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
    if (commit.in_main_branch): 
      documents.append(files[commit.hash])
  return documents
