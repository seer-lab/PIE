from PIPE.process.injestion import process_project
from PIPE.analyze.analyzer import analyze_project

project = process_project('https://github.com/wrandelshofer/jhotdraw.git', force_intervaling=True, force_diffing=True)
analyze_project(project)