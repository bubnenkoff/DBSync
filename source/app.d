// before start ODBC connection should be set up
// %windir%\SysWOW64\odbcad32.exe
// http://web.synametrics.com/firebird.htm

import std.stdio;
import std.conv;
import std.algorithm;
import std.datetime;
import std.path;
import std.file;

import ddbc.all; // setAutoCommit false string 165 pgsqlddbc.d
import std.database.sqlite; // for sqlite support
import std.database; // for sqlite support
import std.base64;


import parseconfig;
//import dbconnect;

import arsd.mssql;

string sqlLiteDBFullName;
string sqlLiteDBName = "result.sqlite";

ParseConfig config;

void main()
{
    config = new ParseConfig();
    sqlLiteDBFullName = buildPath(getcwd, sqlLiteDBName);

    PGSQLDriver driver = new PGSQLDriver();
    string url = PGSQLDriver.generateUrl(config.dbhost, to!short(config.dbport), config.dbname);

    string[string] params;
    
    params["user"] = config.dbuser;
    params["password"] = config.dbpass;
    //params["ssl"] = "true";
	
	DataSource ds = new ConnectionPoolDataSourceImpl(driver, url, params);

	auto conn = ds.getConnection();

	auto pgstmt = conn.createStatement();
	scope(exit) pgstmt.close();

	struct MyData
	{
		string  guid;
		string  id;
		string  name;
		byte [] userblob;
		string  fl;
	}	

	MyData [] mydata;

	MyData md;


		auto rs = pgstmt.executeQuery(`SELECT guid::text, id, name, userblob, "FL" FROM "USERS" where "FL" = 10;`);
		while (rs.next())
		{
		    //writeln(to!string(rs.getString(1)) ~ "\t" ~ rs.getString(2) ~ "\t" ~ "\t" ~ rs.getString(3));
		    md.guid = to!string(rs.getString(1));
		    md.id = to!string(rs.getString(2));
		    md.name = to!string(rs.getString(3));
		    md.userblob = to!string(rs.getString(4)); //need covert from base64 to normal file
		    md.fl = to!string(rs.getString(5));

		    //std.file.write("output.png", Base64.decode(md.userblob));
		    std.file.write("output.txt", md.userblob);

			//auto file = File("test.png", "w");
			//file.rawWrite(data);

		    readln;
		    //writeln(md.guid);
		    //writeln(md.id);
		    //writeln(md.name);
		    //readln;

		    mydata ~= md;
		}

		foreach(m;mydata)
		{
			//writeln(m);
			//writeln();
			//readln;
		}


		if(!exists(sqlLiteDBFullName))
		{
			//writeln("SQLLite DataBase do not Exists");
			//try
			//{
			//	createDatabase("file:///" ~ sqlLiteDBName).query("CREATE TABLE IF NOT EXISTS MySyncData (guid text, id integer, name text, fl integer)");
			//}

			//catch(Exception e)
			//{
			//	writeln(e.msg);
			//	writeln("Can't create DB: ", sqlLiteDBFullName);
			//	writeln("------------------------------------------------");
			//}
			//writeln("DataBase created: ", sqlLiteDBFullName);

			auto db = createDatabase("file:///" ~ sqlLiteDBName).query("CREATE TABLE IF NOT EXISTS MySyncData (guid text, id integer, name text, userblob text, fl integer)"); // not ddbc
			
			//db.query(`insert into MySyncData values("sometext",14)`);
			//auto stmt = con.statement(`insert into MySyncData values(?,?)`);
			//stmt.query("a",1);
   // 		stmt.query("b",2);
   // 		writeln(stmt);

		}

		//try{
		//	createDatabase("file:///C://code1//sqlLiteDBFullName.db").query("CREATE TABLE IF NOT EXISTS ddbct1 (ts text)");
		//}

		//catch(Exception e)
		//{
		//	writeln(e.msg);
		//}


  	  	SQLITEDriver driverLite = new SQLITEDriver();
		DataSource dsLite = new ConnectionPoolDataSourceImpl(driverLite, sqlLiteDBFullName, null);

		//// creating Connection
		auto connLite = dsLite.getConnection();

		auto stmtLite = connLite.createStatement();
		scope(exit) stmtLite.close();

		//stmtLite.executeUpdate(`insert into MySyncData(guid,id,name,fl) values("sometext",14)`);


		text myblob;

		//stmt1.executeUpdate("CREATE TABLE IF NOT EXISTS ddbct1 (ts text)");

		//scope(exit) conn1.close();

	//fbconnet();
	
	
}

void fbconnet()
{

	auto db = new MsSql("DRIVER=Firebird/InterBase(r) driver;UID=SYSDBA;PWD=masterkey; DBNAME=D:\\Project\\2016\\DBSync\\TEST.FDB;");
//	db.query("INSERT INTO users (id, name) values (30, 'hello mang')");
	foreach(line; db.query("SELECT * FROM USERS")) {
		writeln(line[1]);
		//std.file.write("file.txt", line[1]);
		//readln;
	}

}



    byte[] byteaToBytes(string s) {
        if (s is null)
            return null;
        byte[] res;
        bool lastBackSlash = 0;
        foreach(ch; s) {
            if (ch == '\\') {
                if (lastBackSlash) {
                    res ~= '\\';
                    lastBackSlash = false;
                } else {
                    lastBackSlash = true;
                }
            } else {
                if (lastBackSlash) {
                    if (ch == '0') {
                        res ~= 0;
                    } else if (ch == 'r') {
                        res ~= '\r';
                    } else if (ch == 'n') {
                        res ~= '\n';
                    } else if (ch == 't') {
                        res ~= '\t';
                    } else {
                    }
                } else {
                    res ~= cast(byte)ch;
                }
                lastBackSlash = false;
            }
        }
        return res;
    }

