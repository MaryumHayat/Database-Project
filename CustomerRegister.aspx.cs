using System;
using System.Data.SqlClient;

namespace CatResort
{
    public partial class CustomerRegister : System.Web.UI.Page
    {
        string connStr = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\catdb.mdf;Integrated Security=True;";

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            try
            {
                if (!ValidateForm())
                    return;

                int customerId;
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();

                    // Insert Customer
                    SqlCommand cmd = new SqlCommand(@"
                        INSERT INTO Customer (Fname, Lname, Address, No_of_Cats)
                        OUTPUT INSERTED.Customer_id
                        VALUES (@fn, @ln, @ad, @cats)", con);
                    cmd.Parameters.AddWithValue("@fn", txtFirstName.Text.Trim());
                    cmd.Parameters.AddWithValue("@ln", txtLastName.Text.Trim());
                    cmd.Parameters.AddWithValue("@ad", txtAddress.Text.Trim());
                    cmd.Parameters.AddWithValue("@cats", string.IsNullOrEmpty(txtCats.Text) ? 0 : int.Parse(txtCats.Text));

                    customerId = (int)cmd.ExecuteScalar();

                    // Insert Email
                    SqlCommand cmdEmail = new SqlCommand(
                        "INSERT INTO Customer_Email (Customer_id, Email) VALUES (@cid, @em)", con);
                    cmdEmail.Parameters.AddWithValue("@cid", customerId);
                    cmdEmail.Parameters.AddWithValue("@em", txtEmail.Text.Trim());
                    cmdEmail.ExecuteNonQuery();

                    // Insert Phone
                    SqlCommand cmdPhone = new SqlCommand(
                        "INSERT INTO Customer_Phone (Customer_id, Phone_Number) VALUES (@cid, @ph)", con);
                    cmdPhone.Parameters.AddWithValue("@cid", customerId);
                    cmdPhone.Parameters.AddWithValue("@ph", txtPhone.Text.Trim());
                    cmdPhone.ExecuteNonQuery();
                }

                ShowMessage("Account created successfully! You can now login.", true);
                ClearForm();
            }
            catch (Exception ex)
            {
                ShowMessage("Error creating account: " + ex.Message, false);
            }
        }

        private bool ValidateForm()
        {
            if (string.IsNullOrEmpty(txtFirstName.Text.Trim()))
            {
                ShowMessage("First name is required.", false);
                return false;
            }

            if (string.IsNullOrEmpty(txtLastName.Text.Trim()))
            {
                ShowMessage("Last name is required.", false);
                return false;
            }

            if (string.IsNullOrEmpty(txtEmail.Text.Trim()))
            {
                ShowMessage("Email is required.", false);
                return false;
            }

            if (string.IsNullOrEmpty(txtPhone.Text.Trim()))
            {
                ShowMessage("Phone number is required.", false);
                return false;
            }

            return true;
        }

        private void ShowMessage(string message, bool isSuccess)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = isSuccess ? "message success" : "message error";
            lblMessage.Visible = true;
        }

        private void ClearForm()
        {
            txtFirstName.Text = "";
            txtLastName.Text = "";
            txtAddress.Text = "";
            txtCats.Text = "";
            txtEmail.Text = "";
            txtPhone.Text = "";
        }
    }
}