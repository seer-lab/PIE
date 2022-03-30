# PIE - Pattern Instance Explorer

## Pre-requisites 

- Python 3.9.6 & pip
- Flutter & Dart
- Mongodb
- Java 8

## Installation

Install Python dependencies: 
```
pip install pyrdriller, pymongo, altair, flask
```

Visit https://www.cs.ucdavis.edu/~shini/research/pinot/
and install Pinot. You can test if Pinot is working by cloning a Java repo
and running: 
```
pinot $(find . -regex ".*\.\(java\)")
```

Clone this repository: 
```
git clone https://github.com/sqrlab/design-patterns-lifecycle.git
```

## Setup 
Open dpTracker.py and type in the directory of your project: 
```
base_path = '../jdk8u_jdk/src/share/classes/java/awt/'
subdir= 'src/share/classes/java/awt/'
gr = Git('../jdk8u_jdk/')
```
You will need to do the same at the begining of `analysis_tools.py`

Run dpTracker: 
```
python3 dpTracker.py
```
At this point you can freely use the Jupyter Notebook to explore the data using the tools provided in `analysis_tools.py` to express the patterns into timelines. 

After analysis run the flask server: 

```
export FLASK_APP=server  
export FLASK_ENV=development
flask run
```

Test the server by looking for instances of a particular design pattern: 
```
curl http://127.0.0.1:5000/lifecycle\?pattern\=Strategy | jq .
```

In the dp_lifecycle folder install dependencies and run the program: 
```
flutter pub get 
flutter run -d [device name]
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






