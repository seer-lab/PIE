import os
from pymongo import MongoClient

from PIPE.project import Project

mongo_uri ='mongodb://localhost:27017'
client = MongoClient(mongo_uri)
db = client.thesis_data

def get_documents(project: Project): 
  collection = db[project._name]
  return [doc for doc in collection.find()]

def get_lifecycles(project: Project, patterns): 
  collection = db[project._name + '_lifecycle']

  ans = {}
  for pattern in patterns: 
    data = collection.find({'pattern': pattern})
    for item in data: 
      ans[item['_id']] = item['items']
  return ans 

def get_file_modifications(project: Project, pattern_instance): 
  collection = db[project._name + '_modifications']
  
  filenames = pattern_instance.split('-')[:-1]
  ans = {}
  for file in filenames: 
    data = collection.find({'_id': file})
    for item in data: 
      ans[file] = item
      ans[file].pop('_id')
  return ans

def get_processed_commits(project_name):
  if not project_name in db.list_collection_names(): 
    return set()
  collection = db[project_name]
  return set([str(id) for id in collection.find().distinct('_id')])

def add_entry(collection_name, data): 
  collection = db[collection_name]
  collection.insert_one(data)

def add_entrys(collection_name, data): 
  collection = db[collection_name]
  collection.insert_many(data)

def update_entry(collection_name, data): 
  collection = db[collection_name]
  collection.update_one({'_id': data.pop('_id')}, {'$set': data})

def get_collection_names(): 
  return db.collection_names()

def get_projects(): 
  collection = db.project_status
  projects = {}
  for project in collection.find({}):
    id = project.pop('_id'); 
    projects[id] = project
  return projects
