import pandas as pd
import altair as alt
import analysis_tools

class LifecycleParser: 
  def __init__(self, documents):
    self.documents = documents
    self.chart_color = {}
    self.file_list_to_set()
  
  def file_list_to_set(self):
    for document in self.documents: 
      document['file_list'] = set(document['file_list'])

  def get_detected_patterns(self, patterns): 
    if type(patterns) == str:
      patterns = [patterns]

    pattern_instances = set()
    for title in patterns: 
      for x in self.documents: 
          if title in x['pattern_locations']: 
              for instance in x['pattern_locations'][title]: 
                  instance_name = analysis_tools.file_locations_to_name(instance)
                  pattern_instances.add(instance_name)
    return pattern_instances

  def get_intervals(self, fs):
    intervals = []
    start = {}
    for x in fs: 
      start[x] = -1
    for document, commit_number in zip(self.documents, range(len(self.documents))): 
      for f in fs:
        exists, output = f(document)
        if exists:
          if start[f] == -1: 
            start[f] = commit_number
        elif start[f] != -1: 
          output.update({'start': start[f], 'end': commit_number -1})
          intervals.append(output)
          start[f] = -1
    return intervals

  def document_contains_pattern(self, pattern_name, pattern):
    def f(document):
      if pattern in document['pattern_locations']: 
        for instance in document['pattern_locations'][pattern]: 
          if pattern_name == analysis_tools.file_locations_to_name(instance):
            return True, {'instance': pattern_name + ' Pattern'}
      return False, {'instance': pattern_name + ' Pattern'}
    return f

  def pattern_timeline(self, pattern): 
    pattern_instances = self.get_detected_patterns(pattern)
    all_intervals =self.get_intervals([self.document_contains_pattern(instance, pattern) for instance in pattern_instances])
    # for instance in pattern_instances:
    #   all_intervals += self.get_intervals(self.document_contains_pattern(instance, pattern), instance)
    source = pd.DataFrame(all_intervals)
    return alt.Chart(source).mark_bar().encode(
        x='start',
        x2='end',
        y='instance',  
    ).properties(title=pattern)

  def file_exists(self, file):
    if file not in self.chart_color: 
      self.chart_color[file] = 'a'
    def f(document):
      if file in document['file_list']:
        return True, {'instance': file + ' exists', 'modification': self.chart_color[file]} 
      return False , {'instance': file + ' exists', 'modification': self.chart_color[file]} 
    return f
  
  def file_modified(self, file): 
    if file not in self.chart_color: 
      self.chart_color[file] = 'a'

    def f(document):
      if file in analysis_tools.get_file_names(document['modified_files']):
        self.chart_color[file] = document['_id']
      return False, {'instance': file + ' modified'} 
    return f

  def git_pattern_instance_timeline(self, pattern_instance, pattern):
    file_names = pattern_instance.split('-')
    
    file_intervals = self.get_intervals([
      self.document_contains_pattern(pattern_instance, pattern),
    ] + [self.file_exists(file) for file in file_names] 
    + [self.file_modified(file) for file in file_names])

    # for file in file_names: 
    #   file_exists = self.get_intervals(self.file_exists(file), file+ ' Exists')
    #   file_modified = self.get_intervals(self.file_modified(file), file+ ' Modified')
    #   file_intervals += file_exists
    #   file_intervals += file_modified
    for x in file_intervals: 
      if 'modification' not in x: 
        x['modification'] = 'a'
    source = pd.DataFrame(file_intervals)
    return alt.Chart(source).mark_bar().encode(
        x='start',
        x2='end',
        y='instance',  
        color='modification'
    ).properties(title=pattern_instance)
