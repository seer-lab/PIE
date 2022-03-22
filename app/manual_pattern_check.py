from pydriller import Repository, Git
import os 
from shutil import copyfile
from pinot import scan_patterns
from pymongo import MongoClient
from random import randint
import json

client = MongoClient('localhost', 27017)

db = client.thesis_data
collection = db.ignite

files ={}
for document in collection.find(): 
  files[document['_id']] = document 

pattern_intervals = {}
pattern_validation = {}
with open('./pattern_intervals.json', 'r') as f: 
  pattern_intervals = json.load(f)

with open('./pattern_validation.json', 'r') as f: 
  pattern_validation = json.load(f)

gr = Git('../../ignite')

def pick_commit(instances): 
  instance = instances[randint(0, len(instances)-1)]
  if randint(0, len(instances)-1) % 2 == 0: 
    return instance['start']
  return instance['end']

def get_file_paths(commit, pattern, dp_instance): 
  pattern_locations = files[commit]['pattern_locations']
  if pattern not in pattern_locations: 
    return None
  instances = pattern_locations[pattern]
  for x in instances: 
    if  '-'.join([path.split('/')[-1] for path in x]).replace('.java','') == dp_instance:
      return x
  return None

def clear_test_bench():
  for x in os.listdir('./test_bench'):
    os.remove('./test_bench/' + x)


for pattern, dp_instances in pattern_intervals.items(): 
  for dp_instance, intervals in dp_instances.items(): 
    if dp_instance in pattern_validation: 
      continue 

    clear_test_bench()
    print('Testing for', dp_instance)

    commit = pick_commit(intervals)
    gr.checkout(commit)
    paths = get_file_paths(commit, pattern, dp_instance)
    if paths == None: 
      print('There was an error in finding the related file paths')
    else: 
      for x in paths: 
        print('Copying', x)
        copyfile(x, './test_bench/' + x.split('/')[-1])
      value = input('is this a '+ pattern + ' pattern? (y/n)')

      pattern_validation[dp_instance] = 'y' in value
      with open('pattern_validation.json', 'w') as fp: 
        json.dump(pattern_validation, fp)

  
