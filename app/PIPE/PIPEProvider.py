import PIPE.database as db
from PIPE.project import Project
import json

class PIPEProvider: 
  def __init__(self) -> None:
    self.project_status = db.get_projects()
  
  def get_project(self, project_name): 
    if not project_name in self.project_status: 
      return None
    
    return Project(project_name, self.project_status[project_name])

  def get_commit_documents(self, project_name): 
    
    project = self.get_project(project_name)
    if project == None: 
      return {}

    def remove_set(document):
      if 'file_list' in document: 
        document.pop('file_list')
      return document

    documents = db.get_documents(project)
    return json.dumps([remove_set(document) for document in documents])

  def get_projects(self): 
    projects = self.project_status
    for key, value in projects.items(): 
      value['name'] = key
    return projects
  
  def get_lifecycles(self, project_name, design_pattern): 

    project = self.get_project(project_name)
    if project == None: 
      return {}

    return db.get_lifecycles(project, design_pattern)
  
  def get_related_files(self, project_name, pattern_instance): 
    project = self.get_project(project_name)
    if project == None: 
      return {}
    
    return db.get_file_modifications(project, pattern_instance)

    