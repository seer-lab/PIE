from PIPE import * 
from pydriller import Git

project = process.injestion.get_project('https://github.com/wrandelshofer/jhotdraw', CONFIG.PROJECT_PATH)
gr = Git(CONFIG.PROJECT_PATH)

commit = gr.get_commit('d1276043a5aca96649f5840d2204edd429454a05')

file = commit.modified_files[0]
print(file.diff)
