using System;
using System.Data;
using System.Data.SqlClient;

namespace CatResort
{
    public partial class StaffDashboard : System.Web.UI.Page
    {
        string connStr = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\catdb.mdf;Integrated Security=True;";
        int StaffID => Session["StaffID"] != null ? Convert.ToInt32(Session["StaffID"]) : 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() != "Staff" || StaffID == 0)
                Response.Redirect("Login.aspx");

            if (!IsPostBack)
                LoadAppointments();
        }

        protected void btnGoTasks_Click(object sender, EventArgs e) => Response.Redirect("Tasks.aspx");
        protected void btnGoRooms_Click(object sender, EventArgs e) => Response.Redirect("Rooms.aspx");
        protected void btnGoCatCare_Click(object sender, EventArgs e) => Response.Redirect("CatCare.aspx");
        protected void btnGoReports_Click(object sender, EventArgs e) => Response.Redirect("StaffReport.aspx");

        protected void btnFilterApp_Click(object sender, EventArgs e)
        {
            LoadAppointments(txtFilterDate.Text.Trim());
        }

        void LoadAppointments(string dateFilter = "")
        {
            string sql = @"SELECT a.Appointment_id, c.Name AS CatName, a.Purpose, a.Date, a.Time
                           FROM Appointment a
                           LEFT JOIN Cat c ON a.Customer_id = c.Customer_id
                           WHERE a.RoomAssigned = 0"; // Show only pending appointments

            DateTime d;
            bool filterApplied = DateTime.TryParse(dateFilter, out d);

            if (filterApplied)
                sql += " AND a.Date = @date";

            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                if (filterApplied)
                    cmd.Parameters.AddWithValue("@date", d);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptAppointments.DataSource = dt;
                rptAppointments.DataBind();
            }
        }
    }
}
