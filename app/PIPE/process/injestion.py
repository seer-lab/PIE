from pydriller import Repository, Git
import os 
import shutil
from git import Repo
from PIPE import CONFIG
from PIPE.project import Project
from .project_miner import mine_project
from .project_intervaler import interval_project
from .project_diffs import store_modifications
from PIPE import database as db 

def process_project(url, force_mining=False, force_intervaling=False, force_diffing=False):
  
  path = CONFIG.PROJECT_PATH

  try: 
    gr = Git(path)
    if not gr.repo.remotes.origin.url == url: 
      clear_temp_folder(path)
      Repo.clone_from(url, path)
      gr = Git(path)
  except: 
    clear_temp_folder(path)
    Repo.clone_from(url, path)
    gr = Git(path)
    
  project_name = url.split('.git')[0].split('/')[-1]

  projects = db.get_projects() 

  project = None
  if project_name in projects:
    print('Getting Project:', project_name)
    project = Project(project_name, projects[project_name])
    project.status = CONFIG.PROJECT_STATUS_QUEUED
    db.update_entry('project_status', project.to_json())
  else:
    print('Creating Project:', project_name)
    project = Project.new_project(project_name)
    db.add_entry('project_status', project.to_json())



  if force_mining: 
    project.force_phase(CONFIG.MINING)
    db.drop_collection(project._name)
    print('Forcing Mining')
  
  if force_intervaling: 
    project.force_phase(CONFIG.INTERVALING)
    db.drop_collection(project._name + CONFIG.PATTERN_INTERVAL_SUFFIX)
    print('Forcing Intervaling')

  if force_diffing: 
    project.force_phase(CONFIG.FILE_DIFFS)
    db.drop_collection(project._name + CONFIG.FILE_CHANGES_SUFFIX)
    print('Forcing File Diffing')

  while not project.is_complete() and project.status != CONFIG.PROJECT_STATUS_ERROR: 
    project = delegate_process(project, gr)
    db.update_entry('project_status', project.to_json())
  
  project.status = CONFIG.PROJECT_STATUS_READY
  db.update_entry('project_status', project.to_json())
  return project
    

def delegate_process(project: Project, git: Git): 
  process = project.get_current_phase()
  success = False

  if process == CONFIG.MINING:
    print('Mining Project')
    success = mine_project(git)
  elif process == CONFIG.INTERVALING:
    print('Intervaling Project')
    success = interval_project(project)
  elif process == CONFIG.FILE_DIFFS:
    print('Finding Differences in Files')
    success = store_modifications(project, git)


  if success: 
    project.completed_phase(process)
  else: 
    project.status = CONFIG.PROJECT_STATUS_ERROR
  return project

def clear_temp_folder(path):
  shutil.rmtree(path)
  os.makedirs(path)