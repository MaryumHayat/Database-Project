using System;
using System.Web.UI;

namespace CatResort
{
    public partial class VetDashboard : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() != "Vet" || Session["VetID"] == null)
                Response.Redirect("Login.aspx");

            if (!IsPostBack)
            {
                LoadVetName();
            }
        }

        private void LoadVetName()
        {
            try
            {
                if (Session["VetID"] != null)
                {
                    int VetID = Convert.ToInt32(Session["VetID"]);
                    string connStr = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\catdb.mdf;Integrated Security=True;";
                    string sql = "SELECT Fname + ' ' + Lname FROM Vet WHERE Vet_id = @vetId";

                    using (var con = new System.Data.SqlClient.SqlConnection(connStr))
                    using (var cmd = new System.Data.SqlClient.SqlCommand(sql, con))
                    {
                        cmd.Parameters.AddWithValue("@vetId", VetID);
                        con.Open();
                        object result = cmd.ExecuteScalar();
                        lblVetName.Text = result != null ? result.ToString() : "Veterinarian";
                    }
                }
            }
            catch
            {
                lblVetName.Text = "Veterinarian";
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("Dashboard.aspx");
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("VetDashboard.aspx");
        }
    }
}
