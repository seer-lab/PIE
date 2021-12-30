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
    pattern = request.args.get('pattern')
    if pattern == None: 
      pattern = 'Flyweight'
    for pattern in parser.get_detected_patterns(pattern): 
      lifecycles[pattern] = parser.git_pattern_instance_data(pattern, 'Flyweight')
    return lifecycles
    

if __name__ == '__main__':
    app.run(debug=True)