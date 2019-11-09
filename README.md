# Lexis-Nexis Toolbox

Query Lexis/Nexis via their WebServices API, and manage the search results. Sample usage:

   1. edit pre-configurations in ./bin/search.sh
   2. run ./bin/search.sh &amp; wait patiently
   3. run ./bin/files2tsv.sh &amp; wait patiently
   
The results will be two-fold:

   1. a directory of JSON files where each file is a Lexis/Nexis "record"
   2. a stream of tab-separated values which you can redirect to a file and open in your favorite spreadsheet or database program

Please remember, "Software is never done, and if it were, then it would be called 'hardware'."

--- 
Eric Lease Morgan &lt;emorgan@nd.edu&gt;  
November 7, 2019
