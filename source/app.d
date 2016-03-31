import std.stdio;
import std.conv;
import std.algorithm;
import std.datetime;
import std.path;
import std.file;

import ddbc.all;
import parseconfig;
import dbconnect;

ParseConfig config;

void main()
{
    config = new ParseConfig();

    PGSQLDriver driver = new PGSQLDriver();
    string url = PGSQLDriver.generateUrl(config.dbhost, to!short(config.dbport), config.dbname);

    string[string] params;
    
    params["user"] = config.dbuser;
    params["password"] = config.dbpass;
    params["ssl"] = "true";
	
	DataSource ds = new ConnectionPoolDataSourceImpl(driver, url, params);

	auto conn = ds.getConnection();
	
	
}