using System;
using System.Data.SqlClient;

namespace CatResort
{
    public partial class CustomerLogin : System.Web.UI.Page
    {
        string connStr = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\catdb.mdf;Integrated Security=True;";

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    string sql = @"
                        SELECT c.Customer_id, c.Fname, c.Lname, ce.Email, cp.Phone_Number
                        FROM Customer c
                        INNER JOIN Customer_Email ce ON c.Customer_id = ce.Customer_id
                        INNER JOIN Customer_Phone cp ON c.Customer_id = cp.Customer_id
                        WHERE ce.Email = @email AND cp.Phone_Number = @phone";

                    SqlCommand cmd = new SqlCommand(sql, con);
                    cmd.Parameters.AddWithValue("@email", txtEmail.Text.Trim());
                    cmd.Parameters.AddWithValue("@phone", txtPhone.Text.Trim());

                    con.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        // Login successful
                        Session["CustomerId"] = reader["Customer_id"];
                        Session["CustomerName"] = reader["Fname"] + " " + reader["Lname"];
                        Session["CustomerEmail"] = reader["Email"];
                        Response.Redirect("CustomerDashboard.aspx");
                    }
                    else
                    {
                        ShowMessage("Invalid email or phone number. Please try again.");
                    }
                    reader.Close();
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error during login: " + ex.Message);
            }
        }

        private void ShowMessage(string message)
        {
            lblMessage.Text = message;
            lblMessage.Visible = true;
        }
    }
}