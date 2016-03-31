// before start ODBC connection should be set up
// %windir%\SysWOW64\odbcad32.exe
// http://web.synametrics.com/firebird.htm

import std.stdio;
import std.conv;
import std.algorithm;
import std.datetime;
import std.path;
import std.file;

import ddbc.all;
import parseconfig;
import dbconnect;

import arsd.mssql;

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

/*
	auto db = new MsSql("DRIVER=Firebird/InterBase(r) driver;UID=SYSDBA;PWD=masterkey; DBNAME=D:\\Project\\2016\\DBSync\\TEST.FDB;");
//	db.query("INSERT INTO users (id, name) values (30, 'hello mang')");
	foreach(line; db.query("SELECT * FROM USERS")) {
		writeln(line[1]);
	}
*/


