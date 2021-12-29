from flask import Flask
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


@app.route("/lifecycle")
def lifecycle():
    get_documents()
    lifecycles = {}
    for pattern in parser.get_detected_patterns('Flyweight'): 
      lifecycles[pattern] = parser.git_pattern_instance_data(pattern, 'Flyweight')
    return lifecycles
    

if __name__ == '__main__':
    app.run(debug=True)