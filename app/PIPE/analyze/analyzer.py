from PIPE.project import Project
from .pattern_breaks import get_project_breaks
import PIPE.database as db
from PIPE import CONFIG

def analyze_project(project: Project):
  db.drop_collection(project._name + CONFIG.ANALYSIS_SUFFIX)
  get_project_breaks(project)