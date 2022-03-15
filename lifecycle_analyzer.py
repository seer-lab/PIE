class LifecycleAnalyzer: 
  def __init__(self, intervals): 
    self.intervals = intervals['items']
    self.instance_name = intervals['_id']
  
  def is_modified(self, file, commit): 
    found = False
    prevModification = ''
    for interval in file: 
      if interval['end'] == commit:
        found = True 
        prevModification = interval['modification']
      elif found:
        if interval['start'] == commit and interval['modification'] != prevModification:
          return True 
        else: 
          return False
    return False 
        
      
          
  def find_pattern_breaks(self, pattern, files):
    break_intervals = []
    for pattern_interval in pattern: 
      break_commit = pattern_interval['end']
      modified_files = []
      for name, interval in files.items(): 
        if self.is_modified(interval, break_commit): 
          modified_files.append(name)
      if len(modified_files) > 0:
        break_intervals.append({
          'instance': '-'.join(modified_files),
          'modification': 'break',
          'start': break_commit - 1,
          'end': break_commit + 1,
        })
    return break_intervals
  
  def analyze(self):
    pattern_intervals = list(filter(lambda x: x['modification'] == 'Pattern', self.intervals))
    
    file_intervals = {}
    file_names = self.instance_name.split('-')[:-1]
    for file in file_names: 
      file_intervals[file] = list(filter(lambda x: file == x['instance'].split(' ')[0], self.intervals))
    return self.find_pattern_breaks(pattern_intervals, file_intervals)