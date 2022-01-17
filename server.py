from flask import Flask, request
from lifecycle_parser import LifecycleParser
from analysis_tools import * 
import json

app = Flask(__name__)
documents = []
parser = None

def get_documents():
  global documents
  global parser

  if len(documents) == 0: 
    documents = get_sorted_documents('topo-order')
    parser = LifecycleParser(documents)

@app.route('/documents')
def serve_documents(): 
  global documents 
  get_documents()
  def remove_set(document):
    d = document.copy() 
    d.pop('file_list')
    return d 
  return json.dumps([remove_set(document) for document in documents])

@app.route("/lifecycle")
def lifecycle():
    get_documents()
    lifecycles = {}
    patterns = request.args.get('pattern')
    if patterns == None: 
      patterns = ['Flyweight']
    else: 
      patterns = patterns.split(',')
    for pattern in patterns: 
      for pattern_instance in parser.get_detected_patterns(pattern): 
        lifecycles[pattern_instance] = parser.git_pattern_instance_data(pattern_instance, pattern)
    return lifecycles

@app.route('/related_files')
def related_files():
  pattern = request.args.get('pattern')
  pattern_instance = request.args.get('pattern_instance')
  if pattern_instance == None or pattern == None: 
    return {'success': False}
  lifecycle = parser.git_pattern_instance_data(pattern_instance, pattern)
  data = {}
  for instance in lifecycle: 
    if instance['modification'] != 'Pattern': 
      commit = instance['modification']
      if commit not in data: 
        data[commit] = {}
      filename = instance['instance'].split(' ')[0]
      data[commit][filename] = get_file(commit, filename)
  return data 
  
if __name__ == '__main__':
    print('Loading Documents')
    get_documents()
    app.run(debug=True)