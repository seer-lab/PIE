# PIE - Pattern Instance Explorer

Pattern Instance Explorer (PIE), is an exploratory visualization tool that enable developers and researchers to examine a repository’s design patterns and their life cycles.

Check it out at https://seerlab.ca:5000

## Project Layout 

*dp_lifecycle :* Flutter web application for the user interface.
*app :* Contains `server.py` the entry point for the server.
*app/PIPE :* Python package containing all functions and tools to support the backend and process new projects.

## Pre-requisites 

### Required for Analysis
- Python 3.9.6 & pip
- Java 8

### Not Required if using Docker:
- Flutter & Dart
- Mongodb

## Installation

Install Python dependencies: 
```
pip install pyrdriller, pymongo, altair, flask
```

Visit https://www.cs.ucdavis.edu/~shini/research/pinot/
and install Pinot. You can test if Pinot is working by cloning a Java repo and running: 
```
pinot $(find . -regex ".*\.\(java\)")
```

Clone this repository: 
```
git clone https://github.com/sqrlab/PIE.git
```

## Mine & Analyze Projects Locally

### Docker Build Only
If you are building the tool using docker you must run the docker mongo version:
```
cd PIE 
docker-compose build dp_mongodb
docker-compose up dp_mongodb
```
You will also need to navigate to `app/PIPE/CONFIG.py`
and update the `MONGO_PORT` to `"27018"`.

### Mining Configurations
In `app/PIPE/CONFIG.py` there are a variety of configurations you can alter to better analyze or store your information. **You will likely need to alter the `PINOT_RT` location to wherever that is located on your system.**

*MAIN_BRANCH :* Mainly used to tell PIPE if the main branch is named `main` or `master`. Can also be used to choose a different branch for analysis.

*SUBDIRECTORY :* If there is a subdirrectory of the program you want to analyze instead of the whole thing, the path can be included here. To ignore use `''`.

*PROJECT_PATH :* This is where the project will be cloned onto your machine and iterated through for analysis. 

### Mine the project
In `app/driver.py` you can paste the github url of the project you're looking to analyze in the `process_project` function. You can then: 

```
cd app
sudo python3 driver.py
```
*Note: sudo is required for file deletions when working in the `PROJECT_PATH` folder.*

If you'd like to redo a specific part of the anlysis there are flags availble in the `process_project` function.

## Build and Run the Tool with Docker 

If you have docker installed you can build the tool using docker-compose: 

```
cd PIE 
docker-compose build
docker-compose up
```

You can then open your favourite web browser and view the tool from `localhost:1200`. 

## Build and Run the tool without docker.

### Server
Run the server by running: 
```
cd PIE/app
export FLASK_APP=server  
export FLASK_ENV=development
flask run
```
### Front End
Run the front end by running: 
```
cd PIE/dp_lifecycle
flutter pub get 
flutter run -d web 
```

### Pinot Troubleshooting 

Note: Pinot may not work correctly out of the box. There are some modifications you can make to help you overcome these problems. 

Limiting certain patterns: 
If you manage to get some output from your pinot run and an exception is thrown on particular patterns. You can disable the pattern by commenting them out in `control.cpp` past line `6435`: 

```
  Coutput << "--------- Original GoF Patterns ----------" << endl << endl;

    //FindSingleton(cs_table, ms_table);
    FindSingleton1(cs_table, ast_pool);

    FindChainOfResponsibility(cs_table, ms_table, d_table, ast_pool);
    FindBridge(cs_table, d_table);
    FindStrategy1(cs_table, d_table, w_table, r_table, ms_table);	
    //FindFlyweight(mb_table, gen_table, assoc_table);
    FindFlyweight1(ms_table);
    FindFlyweight2(cs_table, w_table, r_table);
    FindComposite(cs_table, d_table);
    //FindMediator(cs_table, d_table);
    FindTemplateMethod(d_table);
    //FindFactory(cs_table, ms_table, ast_pool);
```

Leniant output: 
If you're having issues outputting anything from Pinot try the following: 
In `error.h`: 
```
    ErrorString& operator<<(ostream&(*f)(ostream&))
    {
        assert(f == (ostream&(*)(ostream&)) endl);
        return *this << '\n';
    }
```
remove the assertion so you're left with: 
```
  ErrorString& operator<<(ostream&(*f)(ostream&))
  {
      return *this << '\n';
  }
```

## Deeper Pinot Search

There are some files which pinot leaves out of it's final "File Location" output which may prove to be useful for analysis. As such the following edits have been made to `control.cpp` to account for these files. 

Around line `2104`
```
Coutput << endl;
sym = hidden_types.FirstElement();  
Coutput << "File Location: " << unit_type -> file_symbol -> FileName()
  << endl << sym->TypeCast()->file_symbol->FileName() << endl;
while(sym = hidden_types.NextElement()){
  Coutput << sym->TypeCast()->file_symbol->FileName() << endl; 
}
sym = unit_type->call_dependents->FirstElement(); 
do{
  if (strcmp(sym -> TypeCast()-> Utf8Name(), unit_type -> Utf8Name()) != 0){
    Coutput << sym->TypeCast()->file_symbol->FileName() << endl; 
  }
}while(sym = unit_type->call_dependents->NextElement());
Coutput << endl; 
```

Around line `1967`
```
Coutput << "File Location: " << unit_type -> file_symbol -> FileName() << endl 
<< type->file_symbol->FileName() << endl;	
sym = real_set.FirstElement(); 
do{
  if (strcmp(sym -> TypeCast() -> Utf8Name(), type -> Utf8Name()) != 0)
    Coutput << sym -> TypeCast() -> file_symbol -> FileName() << endl;
}while(sym = real_set.NextElement());
Coutput << endl; 
```

Around line `1319`
```
Coutput << endl;

sym = colleagues.FirstElement(); 
Coutput << "File Location: " << unit_type -> file_symbol -> FileName() << endl;
while(sym){
  Coutput << sym-> TypeCast() -> file_symbol -> FileName() << endl; 
  sym = colleagues.NextElement(); 
}
Coutput << endl; 
```

Around line `1343`
```
Coutput << endl;

sym = observers.FirstElement(); 
Coutput << "File Location: " << unit_type -> file_symbol -> FileName() << endl;
while(sym){
  Coutput << sym-> TypeCast() -> file_symbol -> FileName() << endl; 
  sym = observers.NextElement(); 
}
Coutput << endl; 
observers.SetEmpty();
```






