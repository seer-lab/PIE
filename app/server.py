from flask import Flask, request, session
from flask_cors import CORS, cross_origin
from lifecycle_parser import LifecycleParser
import secrets
from analysis_tools import * 
import json

app = Flask(__name__)
app.secret_key = secrets.token_bytes(32)
app.config.update(SESSION_COOKIE_SAMESITE="None", SESSION_COOKIE_SECURE=True)
CORS(app, support_credentials=True)
PROJECT = 'project'

projects = {
  'awt': {'name': 'awt', 'location': '../jdk8u_jdk', 'status': 'ready'},
  'ignite': {'name': 'ignite', 'location': '../ignite', 'status': 'ready'},
  'jhotdraw': {'name': 'jhotdraw', 'location': '../jhotdraw', 'status': 'ready'}
}
parsers = {}

def get_parser(project): 
  if not project['name'] in parsers: 
    documents = get_sorted_documents(project, 'topo-order')
    parsers[project['name']] = LifecycleParser(documents)
  
  return parsers[project['name']]

@app.route('/documents')
@cross_origin(supports_credentials=True)
def serve_documents(): 
  project_name = request.args.get('project')
  
  def remove_set(document):
    if 'file_list' in document: 
      document.pop('file_list')
    return document
  return json.dumps([remove_set(document) for document in get_parser(projects[project_name]).get_documents()])

@app.route('/projects')
@cross_origin(supports_credentials=True)
def serve_projects():
  return projects

@app.route("/lifecycle")
@cross_origin(supports_credentials=True)
def lifecycle():
  project_name = request.args.get('project')
  patterns = request.args.get('pattern')
  if patterns == None: 
    patterns = ['Flyweight']
  else: 
    patterns = patterns.split(',')
  return get_lifecycles(projects[project_name], patterns)

@app.route('/related_files')
@cross_origin(supports_credentials=True)
def related_files():
  project_name = request.args.get('project')
  pattern = request.args.get('pattern')
  pattern_instance = request.args.get('pattern_instance')
  if pattern_instance == None or pattern == None: 
    return {'success': False}
  return get_related_files(projects[project_name], pattern_instance)
  
if __name__ == '__main__':
    app.run(debug=True)