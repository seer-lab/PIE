from flask import Flask, request, session
from flask_cors import CORS, cross_origin
import PIPE.database as db
import secrets
from analysis_tools import * 
import json
from PIPE.PIPEProvider import PIPEProvider

app = Flask(__name__)
app.secret_key = secrets.token_bytes(32)
app.config.update(SESSION_COOKIE_SAMESITE="None", SESSION_COOKIE_SECURE=True)
CORS(app, support_credentials=True)
PROJECT = 'project'

parsers = {}
provider = PIPEProvider()

@app.route('/documents')
@cross_origin(supports_credentials=True)
def serve_documents(): 
  project_name = request.args.get('project')
  return provider.get_commit_documents(project_name)

@app.route('/projects')
@cross_origin(supports_credentials=True)
def serve_projects():
  return provider.get_projects()

@app.route("/lifecycle")
@cross_origin(supports_credentials=True)
def lifecycle():
  project_name = request.args.get('project')
  patterns = request.args.get('pattern')
  if patterns == None: 
    patterns = ['Strategy']
  else: 
    patterns = patterns.split(',')
  return provider.get_lifecycles(project_name, patterns)

@app.route('/annotations')
@cross_origin(supports_credentials=True)
def annotations():
  project_name = request.args.get('project')
  pattern_instance = request.args.get('pattern_instance')
  return provider.get_annotations(project_name, pattern_instance)

@app.route('/related_files')
@cross_origin(supports_credentials=True)
def related_files():
  project_name = request.args.get('project')
  pattern = request.args.get('pattern')
  pattern_instance = request.args.get('pattern_instance')
  if pattern_instance == None or pattern == None: 
    return {'success': False}
  return provider.get_related_files(project_name, pattern_instance)
  
if __name__ == '__main__':
    app.run(debug=True)