




SET search_path = jx_io, pg_catalog;



CREATE FUNCTION export_json_query(filename text, query text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
    declare
       command text;
       msg text;
       msg_detail text;
       msg_err text;
    BEGIN
        command := 'COPY ( SELECT row_to_json(q.*) FROM ('||query||') as q) TO '''|| filename||'''';
        raise notice '%',command;
        BEGIN
        EXECUTE command;
        EXCEPTION 
         WHEN OTHERS THEN
          GET STACKED DIAGNOSTICS msg = message_text, msg_detail =pg_exception_detail, msg_err = returned_sqlstate;
          RAISE EXCEPTION 'Error: %, %, %', msg, msg_detail,msg_err;
        END;
    RETURN true;    
    END;
$$;




CREATE FUNCTION export_json_table(filename text, tbl text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
    declare
       command text;
       msg text;
       msg_detail text;
       msg_err text;
    BEGIN
        command := 'COPY ( SELECT row_to_json('||tbl||'.*) FROM '||tbl||')  TO '''|| filename||'''';
        raise notice '%',command;
        BEGIN
        EXECUTE command;
        EXCEPTION 
         WHEN OTHERS THEN
          GET STACKED DIAGNOSTICS msg = message_text, msg_detail =pg_exception_detail, msg_err = returned_sqlstate;
          RAISE EXCEPTION 'Error: %, %, %', msg, msg_detail,msg_err;
        END;
    RETURN true;    
    END;
$$;




CREATE FUNCTION export_xml_query(filename text, query text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
    declare
       command text;
       msg text;
       msg_detail text;
       msg_err text;
    BEGIN
        command := 'COPY ( SELECT replace(query_to_xml('''|| query ||''',true,false,'''')::text,E''\n'',''''))  TO '''|| filename||'''';
        raise notice '%',command;
        BEGIN
        EXECUTE command;
        EXCEPTION 
         WHEN OTHERS THEN
          GET STACKED DIAGNOSTICS msg = message_text, msg_detail =pg_exception_detail, msg_err = returned_sqlstate;
          RAISE EXCEPTION 'Error: %, %, %', msg, msg_detail,msg_err;
        END;
    RETURN true;    
    END;
$$;




CREATE FUNCTION export_xml_table(filename text, tbl text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
    declare
       command text;
       msg text;
       msg_detail text;
       msg_err text;
    BEGIN
        command := 'COPY ( SELECT replace(table_to_xml('''|| tbl ||'''::regclass,true,false,'''')::text,E''\n'',''''))  TO '''|| filename||'''';
        raise notice '%',command;
        BEGIN
        EXECUTE command;
        EXCEPTION 
         WHEN OTHERS THEN
          GET STACKED DIAGNOSTICS msg = message_text, msg_detail =pg_exception_detail, msg_err = returned_sqlstate;
          RAISE EXCEPTION 'Error: %, %, %', msg, msg_detail,msg_err;
        END;
    RETURN true;    
    END;
$$;




CREATE FUNCTION import_json_doc(filename text) RETURNS json
    LANGUAGE plpgsql
    AS $$
    declare
        content bytea;
        foid oid;
        ffd integer;
        fsize integer;
        msg text;
        msg_detail text;
        msg_err text;
    begin
        foid := lo_import(filename);
        ffd := lo_open(foid,262144);
        fsize := lo_lseek(ffd,0,2);
        perform lo_lseek(ffd,0,0);
        content := loread(ffd,fsize);
        perform lo_close(ffd);
        perform lo_unlink(foid);
        return json(convert_from(content,'UTF8'));
        EXCEPTION 
         WHEN OTHERS THEN
          GET STACKED DIAGNOSTICS msg = message_text, msg_detail =pg_exception_detail, msg_err = returned_sqlstate;
          RAISE EXCEPTION 'Error: %, %, %', msg, msg_detail,msg_err;

        
    end;
$$;




CREATE FUNCTION import_json_docs_into_table(filename text, tbl text, col text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
    declare
       command text;
       msg text;
       msg_detail text;
       msg_err text;
    begin
        command := 'COPY '||tbl||'('||col||') FROM '''|| filename||'''';
        begin
        EXECUTE command;
        EXCEPTION 
         WHEN OTHERS THEN
          GET STACKED DIAGNOSTICS msg = message_text, msg_detail =pg_exception_detail, msg_err = returned_sqlstate;
          RAISE EXCEPTION 'Error: %, %, %', msg, msg_detail,msg_err;
        end;
    RETURN true;    
    end;
$$;




CREATE FUNCTION import_xml(filename text) RETURNS xml
    LANGUAGE plpgsql
    AS $$
    declare
        content bytea;
        foid oid;
        ffd integer;
        fsize integer;
        msg text;
        msg_detail text;
        msg_err text;
    begin
        foid := lo_import(filename);
        ffd := lo_open(foid,262144);
        fsize := lo_lseek(ffd,0,2);
        perform lo_lseek(ffd,0,0);
        content := loread(ffd,fsize);
        perform lo_close(ffd);
        perform lo_unlink(foid);
        return xmlparse(document convert_from(content,'UTF8'));
        EXCEPTION 
         WHEN OTHERS THEN
          GET STACKED DIAGNOSTICS msg = message_text, msg_detail =pg_exception_detail, msg_err = returned_sqlstate;
          RAISE EXCEPTION 'Error: %, %, %', msg, msg_detail,msg_err;

        
    end;
$$;



