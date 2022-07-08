# PIPE

Where the backend lives.

## Project Structure 

**Server.py :** Entry point for the Flask backend service. 
**Driver.py :** Script for analyzing projects using PIPE

**PIPE/CONFIG.py :** Configurations for PIPE. The place to be when setting up on a new system or getting ready to analyze a new project. 
**PIPE/PIPEProvider.py :** Manages state and cleans data for the server.
**PIPE/process :** Project mining and organizing.
**PIPE/analyze :** Project analysis and annotation.

## Development

When working on new features, treat PIPE as a python package and use it in a python script, similar to `example.py`.