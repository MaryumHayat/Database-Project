using System;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI;

namespace CatResort
{
    public partial class MakeAppointment : System.Web.UI.Page
    {
        string connStr = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\catdb.mdf;Integrated Security=True;";

        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in - IMPORTANT: Check the exact Session key name
            if (Session["CustomerId"] == null && Session["CustomerID"] == null)
            {
                Response.Redirect("CustomerLogin.aspx");
            }

            // Set default date to tomorrow
            if (!IsPostBack)
            {
                txtDate.Text = DateTime.Now.AddDays(1).ToString("MM/dd/yyyy");
                txtTime.Text = "09:00 AM";
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("CustomerDashboard.aspx");
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            // Basic required-field check
            if (string.IsNullOrWhiteSpace(txtDate.Text) ||
                string.IsNullOrWhiteSpace(txtTime.Text) ||
                string.IsNullOrWhiteSpace(txtPurpose.Text))
            {
                ShowLabel("Please fill out all fields.", false);
                return;
            }

            try
            {
                string dateInput = txtDate.Text.Trim();
                string timeInput = txtTime.Text.Trim();
                string purpose = txtPurpose.Text.Trim();

                // Get CustomerId from Session - check both possible key names
                int customerId = 0;
                if (Session["CustomerId"] != null)
                {
                    customerId = Convert.ToInt32(Session["CustomerId"]);
                }
                else if (Session["CustomerID"] != null)
                {
                    customerId = Convert.ToInt32(Session["CustomerID"]);
                }
                else
                {
                    ShowLabel("Session expired. Please login again.", false);
                    Response.Redirect("CustomerLogin.aspx");
                    return;
                }

                // Validate date format
                DateTime apptDate;
                bool dateOk = DateTime.TryParseExact(dateInput,
                    new string[] { "MM/dd/yyyy", "M/d/yyyy", "MM/dd/yy", "M/d/yy" },
                    CultureInfo.InvariantCulture, DateTimeStyles.None, out apptDate);

                if (!dateOk)
                {
                    ShowLabel("Invalid date format. Please use MM/DD/YYYY format (e.g., 12/08/2025).", false);
                    return;
                }

                // Check if date is in the past
                if (apptDate.Date < DateTime.Now.Date)
                {
                    ShowLabel("Cannot book appointment for a past date.", false);
                    return;
                }

                // Validate time format
                DateTime parsedTime;
                bool timeOk = DateTime.TryParseExact(timeInput,
                    new string[] { "hh:mm tt", "h:mm tt", "HH:mm", "H:mm", "hh:mm", "h:mm" },
                    CultureInfo.InvariantCulture, DateTimeStyles.NoCurrentDateDefault, out parsedTime);

                // If not parsed, try general parse
                if (!timeOk)
                {
                    timeOk = DateTime.TryParse(timeInput, out parsedTime);
                }

                if (!timeOk)
                {
                    ShowLabel("Invalid time format. Please use format like 11:00 AM or 14:30.", false);
                    return;
                }

                // Extract TimeSpan for DB
                TimeSpan apptTime = parsedTime.TimeOfDay;

                // Check business hours
                if (apptTime < TimeSpan.FromHours(9) || apptTime > TimeSpan.FromHours(18))
                {
                    ShowLabel("Appointments can only be booked between 9:00 AM and 6:00 PM.", false);
                    return;
                }

                // Check if time is at least 1 hour from now if booking for today
                if (apptDate.Date == DateTime.Now.Date)
                {
                    TimeSpan timeUntilAppointment = apptTime - DateTime.Now.TimeOfDay;
                    if (timeUntilAppointment.TotalHours < 1)
                    {
                        ShowLabel("Appointments must be booked at least 1 hour in advance.", false);
                        return;
                    }
                }

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();

                    // Debug: Check if customer exists
                    string checkCustomerSql = "SELECT COUNT(*) FROM Customer WHERE Customer_id = @cid";
                    using (SqlCommand checkCustomerCmd = new SqlCommand(checkCustomerSql, con))
                    {
                        checkCustomerCmd.Parameters.AddWithValue("@cid", customerId);
                        int customerCount = (int)checkCustomerCmd.ExecuteScalar();
                        if (customerCount == 0)
                        {
                            ShowLabel("Customer not found. Please login again.", false);
                            return;
                        }
                    }

                    // Check for existing appointment
                    string checkSql = @"SELECT COUNT(*) FROM Appointment 
                                       WHERE Customer_id = @cid AND Date = @date AND Time = @time";

                    using (SqlCommand checkCmd = new SqlCommand(checkSql, con))
                    {
                        checkCmd.Parameters.AddWithValue("@cid", customerId);
                        checkCmd.Parameters.AddWithValue("@date", apptDate);
                        checkCmd.Parameters.AddWithValue("@time", apptTime);

                        int existingCount = (int)checkCmd.ExecuteScalar();
                        if (existingCount > 0)
                        {
                            ShowLabel("You already have an appointment at this date and time.", false);
                            return;
                        }
                    }

                    // INSERT APPOINTMENT - Matching your table column order
                    string sql = @"INSERT INTO Appointment (Customer_id, Time, Date, Purpose)
                                   VALUES (@cid, @time, @date, @purpose)";

                    using (SqlCommand cmd = new SqlCommand(sql, con))
                    {
                        cmd.Parameters.AddWithValue("@cid", customerId);
                        cmd.Parameters.AddWithValue("@time", apptTime);
                        cmd.Parameters.AddWithValue("@date", apptDate);
                        cmd.Parameters.AddWithValue("@purpose", purpose);

                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            // INSERT NOTIFICATION
                            DateTime now = DateTime.Now;
                            string noteText = $"📅 Appointment Booked!\n• Date: {apptDate:MMM dd, yyyy}\n• Time: {parsedTime:hh:mm tt}\n• Purpose: {purpose}";

                            string noteSQL = @"INSERT INTO Notification (Customer_id, Message, Date, Time)
                                               VALUES (@cid, @msg, @date, @time)";

                            using (SqlCommand cmd2 = new SqlCommand(noteSQL, con))
                            {
                                cmd2.Parameters.AddWithValue("@cid", customerId);
                                cmd2.Parameters.AddWithValue("@msg", noteText);
                                cmd2.Parameters.AddWithValue("@date", now.Date);
                                cmd2.Parameters.AddWithValue("@time", now.TimeOfDay);

                                cmd2.ExecuteNonQuery();
                            }

                            ShowLabel("✅ Appointment booked successfully! A notification has been sent.", true);

                            // Clear form
                            txtDate.Text = DateTime.Now.AddDays(1).ToString("MM/dd/yyyy");
                            txtTime.Text = "09:00 AM";
                            txtPurpose.Text = "";
                        }
                        else
                        {
                            ShowLabel("Failed to save appointment. Please try again.", false);
                        }
                    }
                }
            }
            catch (SqlException sqlEx)
            {
                // Show specific error
                string errorMsg = "Database error. ";

                if (sqlEx.Message.Contains("foreign key"))
                {
                    errorMsg += "Customer not found. Please login again.";
                }
                else if (sqlEx.Message.Contains("conversion"))
                {
                    errorMsg += "Invalid data format.";
                }
                else
                {
                    errorMsg += "Please try again.";
                }

                ShowLabel(errorMsg, false);
            }
            catch (Exception ex)
            {
                ShowLabel($"An error occurred: {ex.Message}", false);
            }
        }

        private void ShowLabel(string text, bool success)
        {
            lblMsg.Text = text;
            lblMsg.CssClass = success ? "message success" : "message error";
            lblMsg.Visible = true;

            if (success)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "HideMessage",
                    "setTimeout(function() { document.getElementById('" + lblMsg.ClientID + "').style.display = 'none'; }, 5000);", true);
            }
        }
    }
}