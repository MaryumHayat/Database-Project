using System;
using System.Data;
using System.Data.SqlClient;

namespace CatResort
{
    public partial class Dashboard : System.Web.UI.Page
    {
        string connStr = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\catdb.mdf;Integrated Security=True;";

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        
    }
}
