from PIPE.process.injestion import process_project
from PIPE.analyze.analyzer import analyze_project

project = process_project('https://github.com/wrandelshofer/jhotdraw.git')
analyze_project(project)