using System;
using System.Data;
using System.Data.SqlClient;

namespace CatResort
{
    public partial class CustomerDashboard : System.Web.UI.Page
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
                // Debug: Show current customer ID
                System.Diagnostics.Debug.WriteLine($"Dashboard Load - Customer ID: {Session["CustomerId"]}");
                System.Diagnostics.Debug.WriteLine($"Dashboard Load - Customer Name: {Session["CustomerName"]}");

                lblCustomerName.Text = Session["CustomerName"].ToString();
                lblWelcomeName.Text = Session["CustomerName"].ToString();
                LoadRecentPayments();
                LoadRecentNotifications();
                LoadNotificationCount();
            }
        }

        private void LoadRecentPayments()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    string sql = @"
                        SELECT TOP 5 Payment_id, Date, Amount, Method 
                        FROM Payment 
                        WHERE Customer_id = @cid 
                        ORDER BY Date DESC";

                    SqlDataAdapter da = new SqlDataAdapter(sql, con);
                    da.SelectCommand.Parameters.AddWithValue("@cid", Session["CustomerId"]);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gvPayments.DataSource = dt;
                    gvPayments.DataBind();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading payments: {ex.Message}");
            }
        }

        private void LoadRecentNotifications()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    string sql = @"
                        SELECT TOP 5 Notification_id, Message, Date, Time 
                        FROM Notification 
                        WHERE Customer_id = @cid 
                        ORDER BY Date DESC, Time DESC";

                    SqlDataAdapter da = new SqlDataAdapter(sql, con);
                    da.SelectCommand.Parameters.AddWithValue("@cid", Session["CustomerId"]);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    // Ensure FormattedTime column exists
                    if (dt.Columns.Contains("FormattedTime"))
                        dt.Columns.Remove("FormattedTime");

                    dt.Columns.Add("FormattedTime", typeof(string));

                    // Format the Time column
                    if (dt.Rows.Count > 0)
                    {
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
                    }

                    gvNotifications.DataSource = dt;
                    gvNotifications.DataBind();

                    // Debug: Show how many notifications were found
                    System.Diagnostics.Debug.WriteLine($"Found {dt.Rows.Count} notifications for customer {Session["CustomerId"]}");
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading notifications: {ex.Message}");
            }
        }

        private void LoadNotificationCount()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    string sql = "SELECT COUNT(*) FROM Notification WHERE Customer_id = @cid";
                    SqlCommand cmd = new SqlCommand(sql, con);
                    cmd.Parameters.AddWithValue("@cid", Session["CustomerId"]);

                    con.Open();
                    int count = (int)cmd.ExecuteScalar();

                    if (count > 0)
                    {
                        lblNotificationCount.Text = count.ToString();
                        lblNotificationCount.Visible = true;

                        // Debug: Show notification count
                        System.Diagnostics.Debug.WriteLine($"Notification count for customer {Session["CustomerId"]}: {count}");
                    }
                    else
                    {
                        lblNotificationCount.Visible = false;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading notification count: {ex.Message}");
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            
            Response.Redirect("Dashboard.aspx");
        }

        protected void btnViewProfile_Click(object sender, EventArgs e)
        {
            Response.Redirect("CustomerProfile.aspx");
        }

        protected void btnMakeAppointment_Click(object sender, EventArgs e)
        {
            Response.Redirect("MakeAppointment.aspx");
        }

        protected void btnMakePayment_Click(object sender, EventArgs e)
        {
            Response.Redirect("MakePayment.aspx");
        }

        protected void btnViewNotifications_Click(object sender, EventArgs e)
        {
            Response.Redirect("Notifications.aspx");
        }
    }
}