using System;
using System.Data;
using System.Data.SqlClient;

namespace CatResort
{
    public partial class VetCheckups : System.Web.UI.Page
    {
        // Connection string
        string connStr = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\catdb.mdf;Integrated Security=True;";

        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if vet is logged in
            if (Session["VetID"] == null)
                Response.Redirect("Login.aspx");

            if (!IsPostBack)
                LoadCheckups();
        }

        private void LoadCheckups()
        {
            int vetId = Convert.ToInt32(Session["VetID"]); // 1 = AM vet, 2 = PM vet
            DataTable dt = new DataTable();

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                // Time filter for AM/PM
                string timeFilter = "";
                if (vetId == 1)
                {
                    timeFilter = "AND a.Time >= '09:00:00' AND a.Time < '12:00:00'";
                }
                else if (vetId == 2)
                {
                    timeFilter = "AND a.Time >= '12:00:00' AND a.Time <= '17:59:59'";
                }

                string sql = $@"
                    SELECT 
                        a.Appointment_id,
                        a.Cat_id,
                        ISNULL(c.Name, 'Unknown') AS CatName,   -- Always show cat name
                        cust.Fname + ' ' + cust.Lname AS OwnerName,
                        a.Date,
                        a.Time,
                        a.Purpose,
                        CASE WHEN a.RoomAssigned = 1 THEN 'Assigned' ELSE 'Not Assigned' END AS RoomStatus
                    FROM Appointment a
                    LEFT JOIN Cat c ON a.Customer_id = c.Customer_id
                    LEFT JOIN Customer cust ON a.Customer_id = cust.Customer_id
                    WHERE a.Purpose IN ('Vaccination', 'Surgery', 'Medical Checkup')
                      {timeFilter}
                    ORDER BY a.Date, a.Time";

                SqlDataAdapter da = new SqlDataAdapter(sql, con);
                da.Fill(dt);
            }

            gvCheckups.DataSource = dt;
            gvCheckups.DataBind();
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("VetDashboard.aspx");
        }
    }
}
