from PIPE.project import Project
from .pattern_breaks import get_project_breaks

def analyze_project(project: Project): 
  get_project_breaks(project)