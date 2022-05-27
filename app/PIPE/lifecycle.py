class Lifecycle(object):

  def __init__(self):
    self._name = str() 
    self._files = list(str())
    self._intervals = list()
  
  def __init__(self, name, files, intervals): 
    self._name = name
    self._files = files 
    self._intervals = intervals
  
  def get_name(self): 
    return self._name 

  def get_files(self): 
    return self._files
  
  def get_intervals(self): 
    return self._intervals 
  
  def set_name(self, name): 
    if len(self._name) == 0: 
      self._name = name 
  
  def set_files(self, files): 
    self._files = files 
  
  def set_intervals(self, intervals): 
    self._intervals = intervals
  
  def to_json(self): 
    return {
      'name': self._name, 
      'files': self._files, 
      'intervals': self._intervals
    }
