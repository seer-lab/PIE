import pandas as pd
import altair as alt

class LifecycleParser: 
  def __init__(self, documents):
    self.documents = documents
    self.chart_color = {}
    self.file_list_to_set()

  def get_file_names(self, file_list): 
    return set(str(x).split('/')[-1].replace('.java', '') for x in file_list)

  def file_locations_to_name(self, file_locations, pattern): 
    return '-'.join([path.split('/')[-1] for path in sorted(file_locations)]).replace('.java','') + '-' + pattern[:2]
    
  def get_documents(self): 
    return self.documents

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
                  instance_name = self.file_locations_to_name(instance['path'], title)
                  pattern_instances.add(instance_name)
    return pattern_instances

  def is_shared_keys_equal(self, a, b):
    shared_keys = set(a).intersection(b)
    for key in shared_keys: 
      if a[key] != b[key]: 
        return False
    return True 

  def get_intervals(self, fs): 
    intervals = [] 
    start = {}
    for x in fs: 
      start[x] = None 
    
    for document, commit_number in zip(self.documents, range(len(self.documents))): 
      for f in fs:
        exists, output = f(document)
        if exists: 
          if start[f] == None:
            #start interval
            start[f] = output 
            start[f].update({'start': commit_number})
          elif not self.is_shared_keys_equal(start[f], output): 
            # save interval
            start[f].update({'end': commit_number-1})
            intervals.append(start[f])

            #start new interval
            start[f] = output
            start[f].update({'start': commit_number})
        elif start[f] != None: 
          # save interval
          start[f].update({'end': commit_number-1})
          intervals.append(start[f])
        if commit_number == len(self.documents) -1 and start[f] != None:
          # save interval
          start[f].update({'end': commit_number})
          intervals.append(start[f])
    return intervals


  def document_contains_pattern(self, pattern_name, pattern):
    def f(document):
      if pattern in document['pattern_locations']: 
        for instance in document['pattern_locations'][pattern]: 
          if pattern_name == self.file_locations_to_name(instance['path'], pattern):
            return True, {'instance': pattern_name + ' Pattern', 'modification': 'Pattern', 'pattern': pattern }
      return False, {'instance': pattern_name + ' Pattern', 'modification': 'Pattern', 'pattern': pattern}
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
      if file in self.get_file_names(document['modified_files']):
        self.chart_color[file] = document['_id']
      return False, {'instance': file + ' modified'} 
    return f
  
  def git_pattern_instance_data(self, pattern_instance, pattern):
    file_names = pattern_instance.split('-')
    file_intervals = self.get_intervals([
      self.document_contains_pattern(pattern_instance, pattern),
    ] + [self.file_modified(file) for file in file_names] 
    + [self.file_exists(file) for file in file_names])
    return file_intervals

  def git_pattern_instance_chart(self, pattern_instance, pattern):
    file_intervals = self.git_pattern_instance_data(pattern_instance, pattern)
    source = pd.DataFrame(file_intervals)
    return alt.Chart(source).mark_bar().encode(
        x='start',
        x2='end',
        y='instance',  
        color='modification'
    ).properties(title=pattern_instance)

  def chart(self, intervals):
    source = pd.DataFrame(intervals)
    return alt.Chart(source).mark_bar().encode(
        x='start',
        x2='end',
        y='instance',  
        color='modification'
    ).properties(title='Intervals')
