from flask import Flask, request, session
from flask_cors import CORS, cross_origin
from lifecycle_parser import LifecycleParser
import secrets
from analysis_tools import * 
import json

app = Flask(__name__)
app.secret_key = secrets.token_bytes(32)
CORS(app, support_credentials=True)
PROJECT = 'project'

projects = {
  'awt': {'name': 'awt', 'location': '../jdk8u_jdk', 'status': 'ready'},
  'ignite': {'name': 'ignite', 'location': '../ignite', 'status': 'ready'}
}
parsers = {}

def get_parser(): 
  if not PROJECT in session: 
    session[PROJECT] = projects['awt']
  
  project = session[PROJECT]
  if not project['name'] in parsers: 
    documents = get_sorted_documents(project, 'topo-order')
    parsers[project['name']] = LifecycleParser(documents)
  
  return parsers[project['name']]

@app.route('/documents')
@cross_origin(supports_credentials=True)
def serve_documents(): 
  project = request.args.get('project')
  if project == None and not PROJECT in session: 
    session[PROJECT] = projects['awt']
  elif project != None: 
    session[PROJECT] = projects[project]
  
  def remove_set(document):
    d = document.copy() 
    d.pop('file_list')
    return d 
  print(len(get_parser().get_documents()))
  return json.dumps([remove_set(document) for document in get_parser().get_documents()])

@app.route('/projects')
@cross_origin(supports_credentials=True)
def serve_projects():
  return projects

@app.route("/lifecycle")
@cross_origin(supports_credentials=True)
def lifecycle():
  if not PROJECT in session: 
    session[PROJECT] = projects['awt']
  patterns = request.args.get('pattern')
  if patterns == None: 
    patterns = ['Flyweight']
  else: 
    patterns = patterns.split(',')
  return get_lifecycles(session[PROJECT], patterns)

@app.route('/related_files')
@cross_origin(supports_credentials=True)
def related_files():
  if not PROJECT in session: 
    session[PROJECT] = projects['awt']
  pattern = request.args.get('pattern')
  pattern_instance = request.args.get('pattern_instance')
  if pattern_instance == None or pattern == None: 
    return {'success': False}
  return get_related_files(session[PROJECT], pattern_instance)
  
if __name__ == '__main__':
    app.run(debug=True)