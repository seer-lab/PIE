from pydriller import Repository, Git
import os 
from shutil import copyfile
from pinot import scan_patterns


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
      elif '.java' in x and not 'test' in x.lower() and not 'info' in x.lower(): 
          values.append(path + x)
  return values

def analyze_commit(commit): 
  clear_directory();
  gr.get_commit(commit.hash)
  files = get_files(base_path)

  patterns, locations = scan_patterns(files, base_path)
  print(locations)
  if patterns != None: 
    found = False
    for key, value in patterns.items(): 
      if value > 0: 
        print('Found', value, key, 'in commit ', commit.hash)
        found = True
    if found: 
      print('Message:', commit.msg)
    else: 
      print('No patterns found for commit', commit.hash)
  else: 
    print('Failed to run Pinot on hash:', commit.hash)

repo = Repository('../ignite')

commits = []
for commit in repo.traverse_commits(): 
  analyze_commit(commit)


