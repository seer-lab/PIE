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
    patterns = request.args.get('pattern')
    if patterns == None: 
      patterns = ['Flyweight']
    else: 
      patterns = patterns.split(',')
    return get_lifecycles(patterns)

@app.route('/related_files')
def related_files():
  get_documents()
  pattern = request.args.get('pattern')
  pattern_instance = request.args.get('pattern_instance')
  if pattern_instance == None or pattern == None: 
    return {'success': False}
  return get_related_files(pattern_instance)
  
if __name__ == '__main__':
    print('Loading Documents')
    get_documents()
    app.run(debug=True)