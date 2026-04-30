using System;
using System.Data.SqlClient;

namespace CatResort
{
    public partial class Login : System.Web.UI.Page
    {
        string connStr = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\catdb.mdf;Integrated Security=True;";

        protected void Page_Load(object sender, EventArgs e)
        {
            lblMessage.Text = "";
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
            {
                lblMessage.Text = "Please enter username and password.";
                return;
            }

            string sql = "SELECT User_id, Role, Reference_id FROM Users WHERE Username=@u AND Password=@p";

            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                cmd.Parameters.AddWithValue("@u", username);
                cmd.Parameters.AddWithValue("@p", password);

                try
                {
                    con.Open();
                    SqlDataReader dr = cmd.ExecuteReader();

                    if (dr.Read())
                    {
                        string role = dr["Role"].ToString().Trim();
                        int referenceId = Convert.ToInt32(dr["Reference_id"]); // Staff_id for staff users

                        // ✅ Set session variables
                        Session["Username"] = username;
                        Session["Role"] = role;

                        if (role == "Staff")
                            Session["StaffID"] = referenceId;
                        if (role == "Vet")
                            Session["VetID"] = referenceId;

                        // Redirect based on role
                        if (role == "Admin")
                            Response.Redirect("AdminDashboard.aspx");
                        else if (role == "Staff")
                            Response.Redirect("StaffDashboard.aspx"); // redirect staff to dashboard
                        else if (role == "Vet")
                            Response.Redirect("VetDashboard.aspx");
                        else
                            lblMessage.Text = "Invalid role assigned.";
                    }
                    else
                    {
                        lblMessage.Text = "Invalid username or password.";
                    }
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "An error occurred: " + ex.Message;
                }
            }
        }
    }
}
