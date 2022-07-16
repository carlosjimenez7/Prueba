using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
using System.Data;

namespace Prueba2.controllers
{
    public class BD
    {
        private SqlConnection conn;
        public BD()
        {
           
            String clave = "True";
            String server = "STI005";
            String bd = "Materials";
            String conStr = "Data Source=" + server + ";Initial Catalog=" + bd + ";Password=" + clave;
            conn = new SqlConnection(conStr);
            conn.Open();
        }

        public SqlDataReader Query(String sql)
        {
            SqlCommand cmd = new SqlCommand(sql, conn);
            SqlDataReader reader = cmd.ExecuteReader();
            return reader;
        }

        public int Command(String sql)
        {
            SqlCommand cmd = new SqlCommand(sql, conn);
            return cmd.ExecuteNonQuery();
        }
    }
}