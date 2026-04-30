using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CatResort
{
    public partial class StaffReport : System.Web.UI.Page
    {
        string connStr = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\catdb.mdf;Integrated Security=True;Connect Timeout=30";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"]?.ToString() != "Staff")
                Response.Redirect("Login.aspx");

            if (!IsPostBack)
            {
                LoadDailyReports();
                LoadCatStatistics();
                LoadReportHistory();
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("StaffDashboard.aspx");
        }

        // Load Daily Reports
        private void LoadDailyReports()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();

                    // 1. Occupancy Summary
                    string occupancySql = @"
                        SELECT 
                            COUNT(*) AS TotalRooms,
                            SUM(CASE WHEN Status = 'Occupied' THEN 1 ELSE 0 END) AS Occupied,
                            SUM(CASE WHEN Status = 'Available' THEN 1 ELSE 0 END) AS Available,
                            SUM(CASE WHEN Status = 'Maintenance' THEN 1 ELSE 0 END) AS Maintenance
                        FROM Room";

                    SqlCommand cmd = new SqlCommand(occupancySql, con);
                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        int totalRooms = Convert.ToInt32(reader["TotalRooms"]);
                        int occupied = Convert.ToInt32(reader["Occupied"]);
                        int available = Convert.ToInt32(reader["Available"]);
                        int maintenance = Convert.ToInt32(reader["Maintenance"]);
                        decimal occupancyRate = totalRooms > 0 ? (occupied * 100m / totalRooms) : 0;

                        lblTotalRooms.Text = totalRooms.ToString();
                        lblOccupied.Text = occupied.ToString();
                        lblAvailable.Text = available.ToString();
                        lblMaintenance.Text = maintenance.ToString();
                        lblOccupancyRate.Text = occupancyRate.ToString("0.0") + "%";
                    }
                    reader.Close();

                    // 2. Today's Activity
                    string todayActivitySql = @"
                        SELECT 
                            SUM(CASE WHEN CONVERT(DATE, Check_in_date) = CONVERT(DATE, GETDATE()) THEN 1 ELSE 0 END) AS CheckInsToday,
                            SUM(CASE WHEN CONVERT(DATE, Check_out_date) = CONVERT(DATE, GETDATE()) THEN 1 ELSE 0 END) AS CheckOutsToday
                        FROM Room
                        WHERE Check_in_date IS NOT NULL OR Check_out_date IS NOT NULL";

                    cmd = new SqlCommand(todayActivitySql, con);
                    reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        int checkInsToday = Convert.ToInt32(reader["CheckInsToday"]);
                        int checkOutsToday = Convert.ToInt32(reader["CheckOutsToday"]);

                        lblCheckInsToday.Text = checkInsToday.ToString();
                        lblCheckOutsToday.Text = checkOutsToday.ToString();
                    }
                    reader.Close();

                    // 3. New Appointments Today
                    string newAppointmentsSql = @"
                        SELECT COUNT(*) AS NewAppointments
                        FROM Appointment
                        WHERE CONVERT(DATE, Date) = CONVERT(DATE, GETDATE())";

                    cmd = new SqlCommand(newAppointmentsSql, con);
                    object result = cmd.ExecuteScalar();
                    lblNewAppointments.Text = result != DBNull.Value ? result.ToString() : "0";

                    // 4. Current Cats Staying
                    string currentCatsSql = @"
                        SELECT COUNT(DISTINCT c.Cat_id) AS CurrentCats
                        FROM Cat c
                        INNER JOIN Room r ON c.Room_id = r.Room_id
                        WHERE r.Status = 'Occupied' 
                        AND r.Check_out_date >= GETDATE()";

                    cmd = new SqlCommand(currentCatsSql, con);
                    result = cmd.ExecuteScalar();
                    lblCurrentCats.Text = result != DBNull.Value ? result.ToString() : "0";

                    // 5. Pending Tasks
                    string pendingTasksSql = @"
                        SELECT COUNT(*) AS PendingTasks
                        FROM Task
                        WHERE Status = 'Pending'";

                    cmd = new SqlCommand(pendingTasksSql, con);
                    result = cmd.ExecuteScalar();
                    lblPendingTasks.Text = result != DBNull.Value ? result.ToString() : "0";

                    con.Close();
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error loading daily reports: " + ex.Message;
                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
        }

        // Load Cat Statistics
        private void LoadCatStatistics()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();

                    // 1. Breed Distribution
                    string breedSql = @"
                        SELECT Breed, COUNT(*) AS BreedCount
                        FROM Cat c
                        INNER JOIN Room r ON c.Room_id = r.Room_id
                        WHERE r.Status = 'Occupied' 
                        AND r.Check_out_date >= GETDATE()
                        AND Breed IS NOT NULL AND Breed != ''
                        GROUP BY Breed
                        ORDER BY BreedCount DESC";

                    SqlDataAdapter da = new SqlDataAdapter(breedSql, con);
                    DataTable dtBreeds = new DataTable();
                    da.Fill(dtBreeds);

                    gvBreedDistribution.DataSource = dtBreeds;
                    gvBreedDistribution.DataBind();

                    // 2. Age Groups
                    string ageSql = @"
                        SELECT 
                            CASE 
                                WHEN Age <= 1 THEN 'Kitten (0-1)'
                                WHEN Age <= 3 THEN 'Young (2-3)'
                                WHEN Age <= 7 THEN 'Adult (4-7)'
                                ELSE 'Senior (8+)'
                            END AS AgeGroup,
                            COUNT(*) AS CatCount
                        FROM Cat c
                        INNER JOIN Room r ON c.Room_id = r.Room_id
                        WHERE r.Status = 'Occupied' 
                        AND r.Check_out_date >= GETDATE()
                        AND Age IS NOT NULL
                        GROUP BY 
                            CASE 
                                WHEN Age <= 1 THEN 'Kitten (0-1)'
                                WHEN Age <= 3 THEN 'Young (2-3)'
                                WHEN Age <= 7 THEN 'Adult (4-7)'
                                ELSE 'Senior (8+)'
                            END
                        ORDER BY 
                            MIN(Age)";

                    da = new SqlDataAdapter(ageSql, con);
                    DataTable dtAgeGroups = new DataTable();
                    da.Fill(dtAgeGroups);

                    gvAgeGroups.DataSource = dtAgeGroups;
                    gvAgeGroups.DataBind();

                    // 3. Average Stay Duration
                    string avgStaySql = @"
                        SELECT 
                            AVG(DATEDIFF(day, Check_in_date, Check_out_date)) AS AvgStayDays
                        FROM Room
                        WHERE Status = 'Occupied' 
                        AND Check_in_date IS NOT NULL 
                        AND Check_out_date IS NOT NULL
                        AND Check_out_date >= GETDATE()";

                    SqlCommand cmd = new SqlCommand(avgStaySql, con);
                    object result = cmd.ExecuteScalar();
                    if (result != DBNull.Value && result != null)
                    {
                        decimal avgDays = Convert.ToDecimal(result);
                        lblAvgStay.Text = avgDays.ToString("0.0") + " days";
                    }
                    else
                    {
                        lblAvgStay.Text = "N/A";
                    }

                    // 4. Vaccination Status
                    string vaccineSql = @"
                        SELECT 
                            Vaccinated,
                            COUNT(*) AS Count
                        FROM Cat c
                        INNER JOIN Room r ON c.Room_id = r.Room_id
                        WHERE r.Status = 'Occupied' 
                        AND r.Check_out_date >= GETDATE()
                        AND Vaccinated IS NOT NULL
                        GROUP BY Vaccinated
                        ORDER BY Count DESC";

                    da = new SqlDataAdapter(vaccineSql, con);
                    DataTable dtVaccine = new DataTable();
                    da.Fill(dtVaccine);

                    gvVaccination.DataSource = dtVaccine;
                    gvVaccination.DataBind();

                    con.Close();
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error loading cat statistics: " + ex.Message;
                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
        }

        // Load Report History
        private void LoadReportHistory()
        {
            try
            {
                string sql = @"
                    SELECT r.Report_id, r.Type, r.Date_generated, s.Fname + ' ' + s.Lname AS StaffName
                    FROM Report r
                    LEFT JOIN Staff s ON r.Staff_id = s.Staff_id
                    ORDER BY r.Date_generated DESC";

                using (SqlConnection con = new SqlConnection(connStr))
                using (SqlDataAdapter da = new SqlDataAdapter(sql, con))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gvReportHistory.DataSource = dt;
                    gvReportHistory.DataBind();
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error loading report history: " + ex.Message;
                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
        }

        // Generate New Report
        protected void btnGenerateReport_Click(object sender, EventArgs e)
        {
            try
            {
                string reportType = "Daily Summary";
                int staffId = Session["StaffID"] != null ? Convert.ToInt32(Session["StaffID"]) : 0;

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();

                    string sql = "INSERT INTO Report (Staff_id, Type, Date_generated) VALUES (@staffId, @type, GETDATE())";
                    SqlCommand cmd = new SqlCommand(sql, con);
                    cmd.Parameters.AddWithValue("@staffId", staffId);
                    cmd.Parameters.AddWithValue("@type", reportType);
                    cmd.ExecuteNonQuery();

                    con.Close();
                }

                // Save report data to file (optional)
                SaveReportToFile(reportType);

                lblMessage.Text = "Report generated successfully!";
                lblMessage.ForeColor = System.Drawing.Color.Green;

                LoadReportHistory();
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error generating report: " + ex.Message;
                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
        }

        // Export Report
        protected void btnExportReport_Click(object sender, EventArgs e)
        {
            try
            {
                Response.Clear();
                Response.Buffer = true;
                Response.AddHeader("content-disposition", "attachment;filename=CatResort_Report_" + DateTime.Now.ToString("yyyyMMdd_HHmm") + ".txt");
                Response.Charset = "";
                Response.ContentType = "application/text";

                string reportContent = GenerateReportText();
                Response.Output.Write(reportContent);
                Response.Flush();
                Response.End();
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error exporting report: " + ex.Message;
                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
        }

        // Generate Report Text
        private string GenerateReportText()
        {
            string report = "CAT RESORT - DAILY REPORT\n";
            report += "Generated: " + DateTime.Now.ToString("yyyy-MM-dd HH:mm") + "\n";
            report += "========================================\n\n";

            report += "A. CURRENT STATUS REPORT\n";
            report += "   Occupancy Summary:\n";
            report += "   - Total Rooms: " + lblTotalRooms.Text + "\n";
            report += "   - Occupied: " + lblOccupied.Text + "\n";
            report += "   - Available: " + lblAvailable.Text + "\n";
            report += "   - Maintenance: " + lblMaintenance.Text + "\n";
            report += "   - Occupancy Rate: " + lblOccupancyRate.Text + "\n\n";

            report += "   Today's Activity:\n";
            report += "   - Check-ins today: " + lblCheckInsToday.Text + "\n";
            report += "   - Check-outs today: " + lblCheckOutsToday.Text + "\n";
            report += "   - New appointments: " + lblNewAppointments.Text + "\n";
            report += "   - Pending tasks: " + lblPendingTasks.Text + "\n\n";

            report += "B. CAT STATISTICS REPORT\n";
            report += "   Current Boarding Cats: " + lblCurrentCats.Text + "\n";
            report += "   Average Stay Duration: " + lblAvgStay.Text + "\n\n";

            report += "   Breed Distribution:\n";
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                string breedSql = @"
                    SELECT Breed, COUNT(*) AS BreedCount
                    FROM Cat c
                    INNER JOIN Room r ON c.Room_id = r.Room_id
                    WHERE r.Status = 'Occupied' 
                    AND r.Check_out_date >= GETDATE()
                    AND Breed IS NOT NULL AND Breed != ''
                    GROUP BY Breed
                    ORDER BY BreedCount DESC";

                SqlCommand cmd = new SqlCommand(breedSql, con);
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    report += "   - " + reader["Breed"].ToString() + ": " + reader["BreedCount"].ToString() + "\n";
                }
                reader.Close();
                con.Close();
            }

            return report;
        }

        // Save Report to File
        private void SaveReportToFile(string reportType)
        {
            string reportContent = GenerateReportText();
            string fileName = Server.MapPath("~/Reports/Report_" + DateTime.Now.ToString("yyyyMMdd_HHmmss") + ".txt");

            // Create Reports directory if it doesn't exist
            string directory = Server.MapPath("~/Reports/");
            if (!System.IO.Directory.Exists(directory))
            {
                System.IO.Directory.CreateDirectory(directory);
            }

            System.IO.File.WriteAllText(fileName, reportContent);
        }

        // Grid Row Formatting
        protected void gvReportHistory_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // Add click event to view report details
                e.Row.Attributes["onclick"] = "this.style.cursor='pointer';";
                e.Row.Attributes["onmouseover"] = "this.style.backgroundColor='#fff6fc';";
                e.Row.Attributes["onmouseout"] = "this.style.backgroundColor='';";
            }
        }
    }
}