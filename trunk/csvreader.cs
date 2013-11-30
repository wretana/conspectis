//Namespace reference
using System.IO;
using System.Data;

#region BuildDataSet
/// <summary>
/// method to read a text file into a DataSet
/// </summary>
/// <param name="file">file to read from</param>
/// <param name="tableName">name of the DataTable we want to add</param>
/// <param name="delimeter">delimiter to split on</param>
/// <returns>a populated DataSet</returns>
public DataSet readFile(string file,string tableName,string delimeter)
{
    //create our DataSet
    DataSet domains = new DataSet();
    //add our table
    domains.Tables.Add(tableName);
    try
    {
        //first make sure the file exists
        if (File.Exists(file))
        {
            //create a StreamReader and open our text file
            StreamReader reader = new StreamReader(file);
            //read the first line in and split it into columns
            string[] columns = reader.ReadLine().Split(delimeter.ToCharArray());
            //now add our columns (we will check to make sure the column doesnt exist before adding it)
            foreach (string col in columns)
            {
                //variable to determine if a column has been added
                bool added = false;
                string next = "";
                //our counter
                int i = 0;
                while (!(added))
                {
                    string columnName = col;
                    //now check to see if the column already exists in our DataTable
                    if (!(domains.Tables[tableName].Columns.Contains(columnName)))
                    {
                        //since its not in our DataSet we will add it
                        domains.Tables[tableName].Columns.Add(columnName, typeof(string));
                        added = true;
                    }
                    else
                    {
                        //we didnt add the column so increment out counter
                        i++;
                    }
                }
            }
            //now we need to read the rest of the text file
            string data = reader.ReadToEnd();
            //now we will split the file on the carriage return/line feed
            //and toss it into a string array
            string[] rows = data.Split("\r".ToCharArray());
            //now we will add the rows to our DataTable
            foreach (string r in rows)
            {
                string[] items = r.Split(delimeter.ToCharArray());
                //split the row at the delimiter
                domains.Tables[tableName].Rows.Add(items);
            }
        }
        else
        {
            throw new FileNotFoundException("The file " + file + " could not be found");
        }
        
    }
    catch (FileNotFoundException ex)
    {
        _message = ex.Message;
        return null;
    }
    catch (Exception ex)
    {
        _message = ex.Message;
        return null;
    }
    
    //now return the DataSet
    return domains;
}
#endregion


//Sample usage

//for a Windows application
DataSet data = BuildDataSet("C:\MyFile.txt","MyTable",",");

//For an ASP.Net application
DataSet data = BuildDataSet(Server.MapPath("MyFile.txt"),"MyTable",",");