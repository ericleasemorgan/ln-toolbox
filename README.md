# Lexis-Nexis Toolbox

This is a set of command-line utilities used to search Lexis/Nexis via the WebServices API, and then manage the search results. 

## Requirements

To use the Toolbox you will need a few additional tools:

  1. Bash - A "shell"; a scripting language which is (now) available for Windows, Macintosh, and Linux computers.
  
  2. Python - A popular scripting language and available on Windows, Macintosh, and Linux computers. 
  
  3. GNU Parallel - A utility used to simplify the implementation of parallel processing. "My computer has many cores. Why not use them all?"
  
  4. jq - A utility which eats JSON files for lunch.

## Manifest

Each utility is enumerated below with instructions on how it expected to be used:

  1. `./bin/get-count.py` - Given a OAuth Client ID, an OAuth Secret, and a query, search Lexis/Nexis and merely return the number of items matching the query. Use this utility to get a quick & dirty idea of how broad or narrow your query is. You might consider using the graphical Web interface to Lexis/Nexis instead of this script. Moreover, using the Lexis/Nexis Web interface makes it easier to articulate your query for later batch processing, below.
  
  2. `./bin/search.sh` - After editing the pre-configurations (Client ID, Secret, and query) in this file and given an output directory, search Lexis/Nexis and save the results as a set of "records" (JSON files). This script first runs `./bin/get-count.py` and then repeatedly runs `./bin/search.py` to download/cache batches of search results. As each batch is cached another script, /bin/batch2files.sh, parses the batch into individual files, each representing a search result.
  
  3. `./bin/search.py` - Given a OAuth Client ID, an OAuth Secret, a query, an offset, and a count, return a batch of search results in the form of a JSON stream. This script is intended to be run from `./bin/search.sh`; `./bin/search.sh` is a front-end to `./bin/search.py`.
  
  4. `./bin/batch2files.sh` - Given a Lexis/Nexis JSON batch file of search results and an output directory, this script parses the JSON file into individual records and saves them in the output directory.
  
  5. `./bin/batches2files.sh` - Given an output directory and assuming a set of *.json files is located in the ./tmp directory, save all individual search results (records) to the output directory. This script is a front-end to `./bin/batch2files.sh`. 
  
  6. `./bin/file2tsv.sh` - Given an individual Lexis/Nexis "record" (JSON file), output a tab-delimited stream of really rudimentary bibliographics for the record, specifically: 1) identifier, 2) title, and 3) date.
  
  7. `./bin/files2tsv.sh` - Given an input directory containing a set of Lexis/Nexis JSON files ("records"), output a tab-delimited stream of really rudimentary bibliographics for an entire search result. This script is a front-end to `./bin/file2tsv.sh`. Redirect the output of this script to a file, and then read the file with your favorite spreadsheet, database, or data science application. Granted, the set of bibliographics is really rudimentary. 
  
  8. `./bin/db-create.sh` - Given the name of a database to create, use ./etc/schema.sql to create (initialize) an SQLite database file. The database will contain fields for identifiers, authors, titles, dates, sources, and full text content.
  
  9. `./bin/record2sql.py` - Given a Lexis/Nexis "record" (JSON file), output an SQL INSERT statement suitable for the database described above. 
  
  10. `./bin/record2sql.sh` - Given a Lexis/Nexis "record" (JSON file) and an output directory, save an SQL INSERT statement as a file in the output directory. This script is a front-end to `./bin/record2sql.py`, and this is really intended to be run with the output of the find command. (Note to self: write a program called `./bin/records2sql.sh`.)
  
  11. `./bin/db-insert.sh` - Given an input directory containing a set of files of INSERT statements and a SQLite database file name, insert into the database all records defined by `./bin/record2sql.py`. Once this operaton is complete, you will be able to use SQL to query your database for more specifically than your original query applied to Lexis/Nexis. 
  
  12. `./bin/db2reader.sh` - Given a SQLite database file name and an output directory, generate a set of files suitable for the Distant Reader and its analysis. All this will really do is dump the full text content (an XML stream) of every records to a file in the output directory. You can then zip this file up, submit it to the Distant Reader, and do analysis against the content -- "read" it.
  
## Cookbook

While all the scripts in the system are enumerated above, they are not expected to be used individually. Instead, they are designed to be used in a sort of recipe, below:

   1. Use the Web/graphical interface to search Lexis/Nexis and thus refine your query.
   
   2. Edit the pre-configurations of `./bin/search.sh`, and then run `./bin/search.sh`. Wait patiently, since the search results may be voluminous. The result will be a set of JSON files ("records") in the given directory.
   
   3. Now that all of your results have been retrieved, you will want to read them. Start by using `./bin/files2tsv.sh` to create a sort of bibliography. Sort the resulting list to get a feel for its contents. Then use  `./bin/db-create.sh`, `./bin/record2sql.sh`, and `./bin/db-insert.sh` to fill a database of your content. Just like the bibliography, use SQL to query the resulting database for items of interest.
   
   4. Finally, articulate an SQL query denoting the items you really want to read. Insert that query into `./bin/db2reader.sh`, run it, and the result will be a set of XML files in the given directory.
   
   5. Feed a zipped version of the directory created in Step #4 to the Distant Reader, or...
   
   6. Parse/reformat the XML to read the content in a more traditional manner.

## Conclusion

I don't really expect anybody to do very many of the things above. This whole repository is still a work in progress, but at least one can now search Lexis/Nexis for voluminous amounts of content and begin to read it. 
  
--- 
Eric Lease Morgan &lt;emorgan@nd.edu&gt;  
November 11, 2019
