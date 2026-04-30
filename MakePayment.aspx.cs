using System;
using System.Data;
using System.Data.SqlClient;

namespace CatResort
{
    public partial class MakePayment : System.Web.UI.Page
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
                LoadPaymentHistory();
            }
        }

        protected void btnProcessPayment_Click(object sender, EventArgs e)
        {
            try
            {
                if (!ValidatePayment())
                    return;

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();

                    // Insert Payment
                    SqlCommand cmd = new SqlCommand(@"
                        INSERT INTO Payment (Customer_id, Amount, Method)
                        VALUES (@cid, @amount, @method)", con);
                    cmd.Parameters.AddWithValue("@cid", Session["CustomerId"]);
                    cmd.Parameters.AddWithValue("@amount", decimal.Parse(txtAmount.Text.Trim()));
                    cmd.Parameters.AddWithValue("@method", hdnPaymentMethod.Value);

                    int rowsAffected = cmd.ExecuteNonQuery();

                    if (rowsAffected > 0)
                    {
                        // Add notification
                        SqlCommand cmdNotif = new SqlCommand(@"
                            INSERT INTO Notification (Customer_id, Message)
                            VALUES (@cid, @msg)", con);
                        cmdNotif.Parameters.AddWithValue("@cid", Session["CustomerId"]);
                        cmdNotif.Parameters.AddWithValue("@msg", $"Payment of {decimal.Parse(txtAmount.Text.Trim()):C} processed successfully via {hdnPaymentMethod.Value}");
                        cmdNotif.ExecuteNonQuery();

                        ShowMessage("Payment processed successfully!", true);
                        txtAmount.Text = "";
                        LoadPaymentHistory();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error processing payment: " + ex.Message, false);
            }
        }

        private bool ValidatePayment()
        {
            if (string.IsNullOrEmpty(txtAmount.Text.Trim()) || !decimal.TryParse(txtAmount.Text.Trim(), out decimal amount))
            {
                ShowMessage("Please enter a valid amount.", false);
                return false;
            }

            if (amount <= 0)
            {
                ShowMessage("Amount must be greater than 0.", false);
                return false;
            }

            if (string.IsNullOrEmpty(hdnPaymentMethod.Value))
            {
                ShowMessage("Please select a payment method.", false);
                return false;
            }

            return true;
        }

        private void LoadPaymentHistory()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string sql = @"
                    SELECT Payment_id, Date, Amount, Method 
                    FROM Payment 
                    WHERE Customer_id = @cid 
                    ORDER BY Date DESC";

                SqlDataAdapter da = new SqlDataAdapter(sql, con);
                da.SelectCommand.Parameters.AddWithValue("@cid", Session["CustomerId"]);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvPaymentHistory.DataSource = dt;
                gvPaymentHistory.DataBind();
            }
        }

        protected void btnDashboard_Click(object sender, EventArgs e)
        {
            Response.Redirect("CustomerDashboard.aspx");
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