using System;
using System.Data.SqlClient;

namespace CatResort
{
    public partial class CustomerProfile : System.Web.UI.Page
    {
        string connStr = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\catdb.mdf;Integrated Security=True;";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["CustomerId"] == null)
            {
                Response.Redirect("CustomerLogin.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadCustomerData();
            }
        }

        private void LoadCustomerData()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string sql = @"
                    SELECT c.Fname, c.Lname, c.Address, c.No_of_Cats, ce.Email, cp.Phone_Number
                    FROM Customer c
                    LEFT JOIN Customer_Email ce ON c.Customer_id = ce.Customer_id
                    LEFT JOIN Customer_Phone cp ON c.Customer_id = cp.Customer_id
                    WHERE c.Customer_id = @cid";

                SqlCommand cmd = new SqlCommand(sql, con);
                cmd.Parameters.AddWithValue("@cid", Session["CustomerId"]);

                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    txtFirstName.Text = reader["Fname"].ToString();
                    txtLastName.Text = reader["Lname"].ToString();
                    txtAddress.Text = reader["Address"].ToString();
                    txtCats.Text = reader["No_of_Cats"].ToString();
                    txtEmail.Text = reader["Email"].ToString();
                    txtPhone.Text = reader["Phone_Number"].ToString();
                }
                reader.Close();
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();

                    // Update Customer
                    SqlCommand cmd = new SqlCommand(@"
                        UPDATE Customer 
                        SET Address = @ad, No_of_Cats = @cats 
                        WHERE Customer_id = @cid", con);
                    cmd.Parameters.AddWithValue("@ad", txtAddress.Text.Trim());
                    cmd.Parameters.AddWithValue("@cats", string.IsNullOrEmpty(txtCats.Text) ? 0 : int.Parse(txtCats.Text));
                    cmd.Parameters.AddWithValue("@cid", Session["CustomerId"]);
                    cmd.ExecuteNonQuery();

                    // Update Email
                    SqlCommand cmdEmail = new SqlCommand(@"
                        UPDATE Customer_Email 
                        SET Email = @em 
                        WHERE Customer_id = @cid", con);
                    cmdEmail.Parameters.AddWithValue("@em", txtEmail.Text.Trim());
                    cmdEmail.Parameters.AddWithValue("@cid", Session["CustomerId"]);
                    cmdEmail.ExecuteNonQuery();

                    // Update Phone
                    SqlCommand cmdPhone = new SqlCommand(@"
                        UPDATE Customer_Phone 
                        SET Phone_Number = @ph 
                        WHERE Customer_id = @cid", con);
                    cmdPhone.Parameters.AddWithValue("@ph", txtPhone.Text.Trim());
                    cmdPhone.Parameters.AddWithValue("@cid", Session["CustomerId"]);
                    cmdPhone.ExecuteNonQuery();

                    ShowMessage("Profile updated successfully!", true);
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error updating profile: " + ex.Message, false);
            }
        }

        protected void btnDashboard_Click(object sender, EventArgs e)
        {
            Response.Redirect("CustomerDashboard.aspx");
        }
        protected void btnMyCats_Click(object sender, EventArgs e)
        {
            Response.Redirect("MyCats.aspx");
        }
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("CustomerLogin.aspx");
        }

        private void ShowMessage(string message, bool isSuccess)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = isSuccess ? "message success" : "message error";
            lblMessage.Visible = true;
        }
    }
}