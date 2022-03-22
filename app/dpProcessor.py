from curses import meta
from inspect import getfile
from lifecycle_parser import LifecycleParser
from analysis_tools import *
from pymongo import MongoClient
import json 

# Initialization

design_patterns = [
  'Flyweight', 
  'Strategy', 
  'Bridge', 
  'Decorator', 
  'Composite', 
  'Facade', 
  'Proxy', 
  'Mediator'
  ]

mongo_uri ='mongodb://localhost:27018'
if 'IS_DOCKER' in os.environ: 
  mongo_uri ='mongodb://dp_mongodb:27017'

client = MongoClient(mongo_uri)

db = client.thesis_data
commitCollection = db.awt_commits
lifecycleCollection = db.awt_lifecycle
modificationCollection = db.awt_modifications

if len(lifecycleCollection.find().distinct('_id')) > 0: 
  lifecycleCollection.delete_many({})

if len(commitCollection.find().distinct('_id')) > 0: 
  commitCollection.delete_many({})

if len(modificationCollection.find().distinct('_id')) > 0: 
  modificationCollection.delete_many({})

def hash_to_list(items, metadata = {}): 
  return [{'_id': key, 'items': value, **metadata} for key, value in items.items()]

documents = get_sorted_documents('topo-order')
parser = LifecycleParser(documents)

#Get all lifecycles
print('Getting all design pattern Lifecycles.')
pattern_lifecycles = {}
for pattern in design_patterns: 
  temp = {}
  for pattern_instance in parser.get_detected_patterns(pattern): 
    temp[pattern_instance] = parser.git_pattern_instance_data(pattern_instance, pattern)
  pattern_lifecycles.update(temp)
  print(str(pattern) + ' has ' + str(len(temp)) + ' instances.')
  if (len(temp) > 0):
    lifecycleCollection.insert_many(hash_to_list(temp, {'pattern': pattern}))

print('Getting File Modifications')
files_processed = set()

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
        temp[commit][filename] = get_file(commit, filename)
  
  for filename in filenames: 
    ans = {'_id': filename}
    for key, value in temp.items(): 
      if filename in value: 
        ans[key] = value[filename]
    files_processed.add(filename)
    modificationCollection.insert_one(ans)

