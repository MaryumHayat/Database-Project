using System;
using System.Data;
using System.Data.SqlClient;

namespace CatResort
{
    public partial class FinancialManagement : System.Web.UI.Page
    {
        string connStr = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\catdb.mdf;Integrated Security=True;";
        decimal monthlyGoal = 5000; // Example fixed goal

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadPayments();
            }
        }

        private void LoadPayments()
        {
            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Payment ORDER BY Date DESC", con);
                da.Fill(dt);
            }

            gvPayments.DataSource = dt;
            gvPayments.DataBind();
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("AdminDashboard.aspx");
        }

        protected void btnGenerateReport_Click(object sender, EventArgs e)
        {
            Response.Redirect("Report.aspx");
        }
    }
}
