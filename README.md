jx_io extension
======================================

This PostgreSQL extension implements  functions to export/import JSON and XML from/to PostgreSQL
#Tested  9.2+

IMPORTANT: There're bugs in the existing version, please contact to me.


Building and install
--------
Run: `make install` 
In PostgreSQL database execute: `CREATE EXTENSION jx_io;`

It create schema jx_io
              




Example of use:
```sql
###export
select jx_io.export_json_table('/tmp/export_roles.json','pg_roles')--export table to json file
select jx_io.export_json_query('/tmp/export_databases.json','select * from pg_database')--export result of query to json file
select jx_io.export_xml_table('/tmp/export.xml','pg_database')--export table to xml file
select jx_io.export_xml_query('/tmp/export.xml','select * from pg_roles')--export result of query to xml file

###import 
select jx_io.import_json_docs_into_table('/tmp/export.json','table_x','col1') --import json file (with one or many json docs) to column into table
select jx_io.import_json_doc('/tmp/doc.json')--return  json doc from json file (on doc)
select jx_io.import_xml('/tmp/export.xml')--return  xml doc from xml file 

```


Anthony R. Sotolongo leon
asotolongo@gmail.com

