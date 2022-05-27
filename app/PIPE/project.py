from PIPE import CONFIG
class Project(object):  
  def __init__(self, name, data): 
    self._name = name 
    self._checklist = data['checklist']
    self.status = data['status']

  @classmethod
  def new_project(cons, name): 
    data = {
      '_id': name,
      'checklist':  {
        CONFIG.MINING: False, 
        CONFIG.INTERVALING: False, 
        CONFIG.FILE_DIFFS: False
      },
      'status': 'queued'
    }
    return cons(name, data)
  
  def to_json(self): 
    return {
      '_id': self._name, 
      'checklist': self._checklist,
      'status': self.status
    }
  

  def get_current_phase(self): 
    for key, value in self._checklist.items(): 
      if not value: 
        return key 
  
  def completed_phase(self, phase):
    self._checklist[phase] = True
  
  def is_complete(self):
    for key, value in self._checklist.items(): 
      if not value:
        return False 
    return True
