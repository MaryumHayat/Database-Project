using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace CatResort
{
    public partial class Notifications : System.Web.UI.Page
    {
        string connStr = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\catdb.mdf;Integrated Security=True;";

        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in - check both possible session keys
            if (Session["CustomerId"] == null && Session["CustomerID"] == null)
            {
                Response.Redirect("CustomerLogin.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadNotifications();
            }
        }

        private void LoadNotifications()
        {
            try
            {
                // Get CustomerId from Session
                int customerId = GetCustomerIdFromSession();
                if (customerId == 0)
                {
                    Response.Redirect("CustomerLogin.aspx");
                    return;
                }

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    // Proper SQL with Customer_id filter
                    string sql = @"
                        SELECT Notification_id, Message, Date, Time 
                        FROM Notification 
                        WHERE Customer_id = @customerId 
                        ORDER BY Date DESC, Time DESC";

                    SqlDataAdapter da = new SqlDataAdapter(sql, con);
                    da.SelectCommand.Parameters.AddWithValue("@customerId", customerId);

                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    // Add formatted time column
                    dt.Columns.Add("FormattedTime", typeof(string));

                    // Format the time
                    foreach (DataRow row in dt.Rows)
                    {
                        if (row["Time"] != DBNull.Value && row["Time"] != null)
                        {
                            try
                            {
                                TimeSpan time = (TimeSpan)row["Time"];
                                DateTime timeDate = DateTime.Today.Add(time);
                                row["FormattedTime"] = timeDate.ToString("hh:mm tt");
                            }
                            catch
                            {
                                row["FormattedTime"] = "N/A";
                            }
                        }
                        else
                        {
                            row["FormattedTime"] = "N/A";
                        }
                    }

                    if (dt.Rows.Count > 0)
                    {
                        rptNotifications.DataSource = dt;
                        rptNotifications.DataBind();
                        pnlNoNotifications.Visible = false;
                    }
                    else
                    {
                        rptNotifications.DataSource = null;
                        rptNotifications.DataBind();
                        pnlNoNotifications.Visible = true;
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage($"Error loading notifications: {ex.Message}", false);
            }
        }

        protected void rptNotifications_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            try
            {
                int notificationId = Convert.ToInt32(e.CommandArgument);
                int customerId = GetCustomerIdFromSession();

                if (customerId == 0)
                {
                    ShowMessage("Session expired. Please login again.", false);
                    return;
                }

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();

                    if (e.CommandName == "Delete")
                    {
                        // Added Customer_id check to ensure users only delete their own notifications
                        SqlCommand cmd = new SqlCommand(
                            "DELETE FROM Notification WHERE Notification_id = @id AND Customer_id = @customerId", con);

                        cmd.Parameters.AddWithValue("@id", notificationId);
                        cmd.Parameters.AddWithValue("@customerId", customerId);

                        int rowsDeleted = cmd.ExecuteNonQuery();

                        if (rowsDeleted > 0)
                        {
                            ShowMessage("Notification deleted successfully!", true);
                        }
                        else
                        {
                            ShowMessage("Notification not found or you don't have permission to delete it.", false);
                        }
                    }
                }

                LoadNotifications();
            }
            catch (Exception ex)
            {
                ShowMessage("Error: " + ex.Message, false);
            }
        }

        protected void btnClearAll_Click(object sender, EventArgs e)
        {
            try
            {
                int customerId = GetCustomerIdFromSession();

                if (customerId == 0)
                {
                    ShowMessage("Session expired. Please login again.", false);
                    return;
                }

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    // Only delete notifications for the current customer
                    SqlCommand cmd = new SqlCommand(
                        "DELETE FROM Notification WHERE Customer_id = @customerId", con);

                    cmd.Parameters.AddWithValue("@customerId", customerId);
                    con.Open();

                    int count = cmd.ExecuteNonQuery();
                    ShowMessage($"Cleared {count} notifications.", true);
                }

                LoadNotifications();
            }
            catch (Exception ex)
            {
                ShowMessage("Error: " + ex.Message, false);
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

        // Helper method to get CustomerId from Session
        private int GetCustomerIdFromSession()
        {
            if (Session["CustomerId"] != null)
            {
                return Convert.ToInt32(Session["CustomerId"]);
            }
            else if (Session["CustomerID"] != null)
            {
                return Convert.ToInt32(Session["CustomerID"]);
            }
            return 0;
        }

        // Formatters
        public string FormatDate(object date)
        {
            if (date == DBNull.Value || date == null)
                return "No date";

            try
            {
                return Convert.ToDateTime(date).ToString("MMM dd, yyyy");
            }
            catch
            {
                return "Invalid date";
            }
        }

        public bool IsNotificationUnread(object item)
        {
            return true; // all unread (can be upgraded later)
        }

        private void ShowMessage(string msg, bool success)
        {
            lblMessage.Text = msg;
            lblMessage.CssClass = success ? "message success" : "message error";
            lblMessage.Visible = true;

            // Auto-hide success messages
            if (success)
            {
                string script = "setTimeout(function() { document.getElementById('" + lblMessage.ClientID + "').style.display = 'none'; }, 5000);";
                ClientScript.RegisterStartupScript(this.GetType(), "HideMessage", script, true);
            }
        }
    }
}