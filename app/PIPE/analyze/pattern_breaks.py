from PIPE.project import Project
import PIPE.CONFIG as CONFIG
import PIPE.database as db

def is_modified(file, commit): 
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

def find_stale_intervals(pattern_intervals, file_intervals, break_intervals): 
  stale_intervals = []
  for break_data in break_intervals: 
    found = False
    for interval in pattern_intervals:
      if break_data['commit'] < interval['start']:
        stale_intervals.append({
            'instance': break_data['instance'],
            'files': break_data['files'],
            'modification': 'stale',
            'start': break_data['commit'],
            'end': interval['start']
          })
        found = True
    if not found:
      file_names = break_data['files'].split(',')
      earliest_break = 0x3f3f3f3f
      for file_name in file_names: 
        end = file_intervals[file_name][-1]['end']
        if end < earliest_break: 
          earliest_break = end 
      stale_intervals.append({
            'instance': break_data['instance'],
            'files': break_data['files'],
            'modification': 'stale',
            'start': break_data['commit'],
            'end': earliest_break
          })
  return stale_intervals


def find_pattern_breaks(pattern, files, instance_name):
  break_intervals = []
  for pattern_interval in pattern: 
    break_commit = pattern_interval['end']
    modified_files = []
    for name, interval in files.items(): 
      if is_modified(interval, break_commit): 
        modified_files.append(name)
    if len(modified_files) > 0:
      break_intervals.append({
        'instance': instance_name,
        'files': ','.join(modified_files),
        'modification': 'break',
        'commit': break_commit
      })
      
  return break_intervals

def get_pattern_breaks(instance_name, intervals):
  pattern_intervals = list(filter(lambda x: x['modification'] == 'Pattern', intervals))

  file_intervals = {}
  file_names = instance_name.split('-')[:-1]
  for file in file_names: 
    file_intervals[file] = list(filter(lambda x: file == x['instance'].split(' ')[0], intervals))
  break_intervals = find_pattern_breaks(pattern_intervals, file_intervals, instance_name)
  stale_intervals = find_stale_intervals(pattern_intervals, file_intervals, break_intervals)
  return break_intervals + stale_intervals


def get_project_breaks(project: Project, patterns = CONFIG.DESIGN_PATTERNS):
  if not project.is_complete(): 
    return {}
  
  dpi = db.get_lifecycles(project, patterns)
  breaks = []

  for instance_name, intervals in dpi.items(): 
    breaks += get_pattern_breaks(instance_name, intervals)
    print('Analyzed', instance_name, 'for pattern breaks.')
  
  if len(breaks) == 0: 
    print('Found 0 pattern breaks.')
  else: 
    db.add_entrys(project._name + CONFIG.ANALYSIS_SUFFIX, breaks)
    print('Found', str(len(breaks)), 'pattern breaks.')
  return breaks 
