from pydriller import Repository, Git
import os 
from shutil import copyfile
from pinot import scan_patterns
from pymongo import MongoClient
import analysis_tools


client = MongoClient('localhost', 27017)

db = client.thesis_data
collection = db.ignite

repo = Repository('../ignite')

for commit in repo.traverse_commits():
  collection.update_one({'_id': commit.hash}, { "$set": { 'file_list': analysis_tools.get_files_at_commit(commit.hash) } })
