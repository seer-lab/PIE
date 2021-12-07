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

pattern_interruptions = {}
with open('./pattern_interruptions.json', 'r') as f: 
  pattern_interruptions = json.load(f)

gr = Git('../ignite')

def get_file_paths(commit, pattern, dp_instance): 
  pattern_locations = files[commit]['pattern_locations']
  if pattern not in pattern_locations: 
    return []
  instances = pattern_locations[pattern]
  for x in instances: 
    if  '-'.join([path.split('/')[-1] for path in x]).replace('.java','') == dp_instance:
      return x
  return []

def clear_test_bench():
  for x in os.listdir('./test_bench'):
    os.remove('./test_bench/' + x)

for pattern, interruptions in pattern_interruptions.items(): 
  for interruption in interruptions: 
    clear_test_bench()
    commit = gr.get_commit(interruption['end'])
    gr.checkout(interruption['start'])
    paths = get_file_paths(interruption['start'], pattern, interruption['instance'])
    gr.checkout(interruption['end'])
    paths += get_file_paths(interruption['end'], pattern, interruption['instance'])
    paths = [x.replace('../ignite/', '') for x in list(set(paths))]
    print(paths)
    for x in commit.modified_files: 
      print(x.new_path)
      if x.new_path in paths or x.old_path in paths: 
        with open('./test_bench/' + x.new_path.split('/')[-1], 'w') as f: 
          f.write(x.diff)
    print(interruption['instance'], 'has been written to the test bench.')
    value = input('Continue?')

    