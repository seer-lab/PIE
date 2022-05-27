from pydriller import Repository, Git 
from PIPE import CONFIG, database as db
from .pinot import scan_patterns
import os

def is_subdirectory_modified(modified_files):
  if CONFIG.SUBDIRECTORY == None: 
    return True

  for x in modified_files: 
    if x.new_path != None and CONFIG.SUBDIRECTORY in x.new_path: 
      return True
  return False

def get_files(path): 
  values = []
  for p, d, f in os.walk(path):
    for file in f:
      if file.endswith('.java'):
          values.append(os.path.join(p, file))
  return values

def get_project_name(git: Git): 
  return git.repo.remotes.origin.url.split('.git')[0].split('/')[-1]

def analyze_commit(git: Git, repo: Repository, commit):
  if not is_subdirectory_modified(commit.modified_files): 
    return 

  git.checkout(commit.hash)
  directory = CONFIG.PROJECT_PATH
  if CONFIG.SUBDIRECTORY != None: 
    directory += CONFIG.SUBDIRECTORY

  files = get_files(directory)
  # Have multiple versions of PINOT so that if the first scan fails we can use
  # a different version. We can cache which version works best.
  patterns, locations = scan_patterns(files, CONFIG.PROJECT_PATH)
  if patterns != None: 
    print('Processed', commit.hash)
  else: 
    print('Failed to run Pinot on hash:', commit.hash)

  json = {
    '_id': commit.hash, 
    'msg': commit.msg,
    'merge': commit.merge,
    'author': commit.author.name,
    'date': commit.committer_date.strftime("%Y-%m-%d"),
    'lines': commit.lines,
    'files': commit.files,
    'file_list': [str(x).split('/')[-1].replace('.java', '') for x in files],
    'modified_files': [x.new_path for x in commit.modified_files],
    'summary': patterns, 
    'pattern_locations': locations
  }
  db.add_entry(get_project_name(git), json)

def mine_project(git):

  repo = Repository(CONFIG.PROJECT_PATH, order='topo-order')
  git.checkout(CONFIG.MAIN_BRANCH)

  processed_commits = db.get_processed_commits(get_project_name(git))

  for commit in repo.traverse_commits():
    if not commit.hash in processed_commits: 
      analyze_commit(git, repo, commit)
  return True