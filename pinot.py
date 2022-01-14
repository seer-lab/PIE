import os 
import subprocess
from typing import Text
available_patterns = [
  'Abstract Factory', 
  'Factory Method', 
  'Singleton', 
  'Adapter', 
  'Bridge', 
  'Composite', 
  'Decorator', 
  'Facade', 
  'Flyweight', 
  'Proxy', 
  'Chain of Responsibility', 
  'Mediator', 
  'Observer', 
  'State', 
  'Strategy', 
  'Template Method', 
  'Visitor']
pattern_set = set(available_patterns)

pattern_headers={
  'Chain of Responsibility Pattern': 'Chain of Responsibility',
  'Decorator Pattern': 'Decorator',
  'Strategy Pattern.': 'Strategy', 
  'Flyweight Pattern.': 'Flyweight',
  'Visitor pattern found.': 'Visitor',
  'Mediator Pattern.': 'Mediator',
  'Mediator pattern.': 'Mediator',
  'Facade Pattern.': 'Facade',
  'Proxy Pattern.': 'Proxy',
  'Adapter Pattern.': 'Adapter',
  'Bridge Pattern.': 'Bridge',
  'State Pattern.': 'State',
  'Composite pattern.': 'Composite',
  'Observer pattern.': 'Observer',
  'Observer Pattern.': 'Observer',
  'Factory Method pattern.': 'Abstract Factory',
}

def scan_patterns(files, base_path):
  proc = subprocess.run(["pinot"] + files, capture_output=True, text=True)
  output = proc.stderr 
  #print(output)
  if proc.returncode not in [0, 1]: 
      return None, {}
  values = {}
  pattern_locations = {}

  data = output.split('\n')
  seperator = data.index('Pattern Instance Statistics:')

  locations = data[:seperator]
  summary = data[seperator:]

  current_pattern = ''
  current_files = []
  for line in locations: 
    if line.strip() in pattern_headers:
      
      if current_pattern in pattern_set: 
        if current_pattern not in pattern_locations: 
          pattern_locations[current_pattern] = []
        pattern_locations[current_pattern].append(current_files)
        current_files = []

      current_pattern = pattern_headers[line.strip()]

    elif base_path in line: 
      current_files.append(line.replace('File Location: ', '').replace('File location:', '').replace('FileLocation:', '').replace(',', '').strip())

  if current_pattern in pattern_set: 
    if current_pattern not in pattern_locations: 
      pattern_locations[current_pattern] = []
    pattern_locations[current_pattern].append(current_files)
    current_files = []

  for line in summary[:-10]: 
    for pattern in available_patterns: 
      if pattern in line: 
        values[pattern] = int(line.replace(pattern, ''))
  return values, pattern_locations

