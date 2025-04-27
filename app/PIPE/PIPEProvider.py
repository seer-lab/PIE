from flask import Flask
import PIPE.database as db
from PIPE.project import Project
import json

class PIPEProvider: 
  def __init__(self, app: Flask) -> None:
    self.logger = app.logger
    self.project_status = db.get_projects()

  def remove_set(self, document, field):
    if field in document: 
      document.pop(field)
    return document
  
  def get_project(self, project_name): 
    if not project_name in self.project_status: 
      return None
    
    return Project(project_name, self.project_status[project_name])

  def get_commit_documents(self, project_name): 
    
    project = self.get_project(project_name)
    if project == None: 
      return {}

    documents = db.get_documents(project)
    return json.dumps([self.remove_set(document, 'file_list') for document in documents])

  def get_projects(self): 
    projects = self.project_status
    for key, value in projects.items(): 
      value['name'] = key
    return projects
  
  def get_lifecycles(self, project_name, design_pattern): 

    project = self.get_project(project_name)
    self.logger.info(project)
    self.logger.info(design_pattern)
    if project == None: 
      return {}

    return db.get_lifecycles(project, design_pattern)
  
  def get_related_files(self, project_name, pattern_instance): 
    project = self.get_project(project_name)
    if project == None: 
      return {}
    
    return db.get_file_modifications(project, pattern_instance)

  def get_annotations(self, project_name, pattern_instance): 
    project = self.get_project(project_name)
    if project == None: 
      return {}
    
    return json.dumps([self.remove_set(doc, '_id') for doc in db.get_analysis(project, pattern_instance)])

    