# PIE - Pattern Instance Explorer

Pattern Instance Explorer (PIE), is an exploratory visualization tool that enable developers and researchers to examine a repository’s design patterns and their life cycles.

Check it out at https://seerlab.ca:5000

## Server Build
This branch is dedicated for the server build and contains changes for building to a server.


## Changes

In `lifecycle_provider.dart`: 

```
  String uri = "seerlab.ca";
  // String uri = "localhost";
```

## Offline processing

To push your analysis to a server you can perform the following opperations: 

```
mongodump -d thesis_data -c YOUR_COLLECTION_HERE --port 27018
```
*Note: You can commit --port 27018 if you are not using the docker version of mongo.*
Do this for all the relevant data, including the project_status collection. You will want to manually update the existing project_status collection on the server to include your information.

You then want to setup a SSH tunnel to the server:

```
ssh -L 4321:localhost:27018 -l USERNAME URL -f -N
```

Finally you can restore the data into the mongo server. I recommend writing bash script to help with this: 

```
for FILE in *; do
  if [[ $FILE != *"metadata"* ]]; then
    mongorestore -d thesis_data -c "${FILE%.*}" $FILE --port 4321 
  fi
done
```

Close the tunnel and you are all set!