using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CatResort
{
    public partial class Rooms : System.Web.UI.Page
    {
        string connStr = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\catdb.mdf;Integrated Security=True;Connect Timeout=30";
        int StaffID => Session["StaffID"] != null ? Convert.ToInt32(Session["StaffID"]) : 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"]?.ToString() != "Staff")
                Response.Redirect("Login.aspx");

            if (!IsPostBack)
            {
                LoadAppointments();
                LoadRoomsDropDown();
                LoadServices();
                LoadRoomsGrid();

                ddlCats.Items.Clear();
                ddlCats.Items.Insert(0, new ListItem("--Select Cat--", "0"));
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("StaffDashboard.aspx");
        }

        // ------------------ Load Appointments ---------------------
        void LoadAppointments()
        {
            try
            {
                string sql = @"
                    SELECT Appointment_id,
                           CONCAT('Appt #', Appointment_id, ' - ', 
                                  FORMAT(Date, 'MM/dd/yyyy'), ' ', Time) AS DisplayInfo
                    FROM Appointment
                    WHERE RoomAssigned = 0 AND (Staff_id = @sid OR Staff_id IS NULL)
                    ORDER BY Appointment_id DESC";

                using (SqlConnection con = new SqlConnection(connStr))
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.CommandTimeout = 30;
                    cmd.Parameters.AddWithValue("@sid", StaffID);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    ddlAppointments.DataSource = dt;
                    ddlAppointments.DataTextField = "DisplayInfo";
                    ddlAppointments.DataValueField = "Appointment_id";
                    ddlAppointments.DataBind();
                    ddlAppointments.Items.Insert(0, new ListItem("--Select Appointment--", "0"));
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error loading appointments: " + ex.Message;
                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
        }

        // ------------------ Load Cats based on selected appointment ---------------------
        void LoadCats()
        {
            ddlCats.Items.Clear();
            ddlCats.Items.Insert(0, new ListItem("--Select Cat--", "0"));

            if (ddlAppointments.SelectedValue == "0" || string.IsNullOrEmpty(ddlAppointments.SelectedValue))
                return;

            int appointmentId;
            if (!int.TryParse(ddlAppointments.SelectedValue, out appointmentId))
                return;

            try
            {
                // Simplified query - get cat directly from appointment
                string sql = @"
                    SELECT ISNULL(a.Cat_id, 0) AS Cat_id, 
                           ISNULL(c.Name, 'No Cat Associated') AS Name
                    FROM Appointment a
                    LEFT JOIN Cat c ON a.Cat_id = c.Cat_id
                    WHERE a.Appointment_id = @aid";

                using (SqlConnection con = new SqlConnection(connStr))
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.CommandTimeout = 30;
                    cmd.Parameters.AddWithValue("@aid", appointmentId);
                    con.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        int catId = Convert.ToInt32(reader["Cat_id"]);
                        string catName = reader["Name"].ToString();

                        if (catId > 0 && catName != "No Cat Associated")
                        {
                            ddlCats.Items.Add(new ListItem(catName, catId.ToString()));
                        }
                        else
                        {
                            // If no cat in appointment, get all cats from customer
                            LoadCatsFromCustomer(appointmentId);
                        }
                    }
                    reader.Close();
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error loading cats: " + ex.Message;
                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
        }

        // Helper method to load cats from customer
        private void LoadCatsFromCustomer(int appointmentId)
        {
            try
            {
                string sql = @"
                    SELECT c.Cat_id, c.Name
                    FROM Appointment a
                    INNER JOIN Cat c ON a.Customer_id = c.Customer_id
                    WHERE a.Appointment_id = @aid
                    ORDER BY c.Name";

                using (SqlConnection con = new SqlConnection(connStr))
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.CommandTimeout = 30;
                    cmd.Parameters.AddWithValue("@aid", appointmentId);
                    con.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    bool hasCats = false;
                    while (reader.Read())
                    {
                        int catId = Convert.ToInt32(reader["Cat_id"]);
                        string catName = reader["Name"].ToString();

                        if (catId > 0)
                        {
                            ddlCats.Items.Add(new ListItem(catName, catId.ToString()));
                            hasCats = true;
                        }
                    }
                    reader.Close();

                    if (!hasCats)
                    {
                        ddlCats.Items.Insert(1, new ListItem("-- No cats found for this customer --", "0"));
                    }
                }
            }
            catch (Exception)
            {
                // Silent fail - just don't load cats
            }
        }

        // ------------------ Load Rooms Dropdown ---------------------
        void LoadRoomsDropDown()
        {
            try
            {
                string sql = "SELECT Room_id, CONCAT('Room ', Room_no, ' - ', ISNULL(Type, 'Standard')) AS DisplayInfo FROM Room WHERE Status='Available'";

                using (SqlConnection con = new SqlConnection(connStr))
                using (SqlDataAdapter da = new SqlDataAdapter(sql, con))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    ddlRooms.DataSource = dt;
                    ddlRooms.DataTextField = "DisplayInfo";
                    ddlRooms.DataValueField = "Room_id";
                    ddlRooms.DataBind();
                    ddlRooms.Items.Insert(0, new ListItem("--Select Room--", "0"));
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error loading rooms: " + ex.Message;
                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
        }

        // ------------------ Load Services ---------------------
        void LoadServices()
        {
            try
            {
                chkServices.Items.Clear();

                string sql = "SELECT Service_id, Name FROM Services WHERE Room_id IS NULL";

                using (SqlConnection con = new SqlConnection(connStr))
                using (SqlDataAdapter da = new SqlDataAdapter(sql, con))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    foreach (DataRow row in dt.Rows)
                        chkServices.Items.Add(new ListItem(row["Name"].ToString(), row["Service_id"].ToString()));
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error loading services: " + ex.Message;
                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
        }

        // ------------------ Load Rooms Grid ---------------------
        void LoadRoomsGrid()
        {
            try
            {
                string sql = @"
                    SELECT 
                        r.Room_id,
                        ISNULL(r.Type, 'Standard') AS Type,
                        ISNULL(r.Price, 0.00) AS Price,
                        ISNULL(r.Status, 'Available') AS Status,
                        ISNULL(c.Name, 'No Cat') AS CatName,
                        r.Check_in_date,
                        r.Check_out_date
                    FROM Room r
                    LEFT JOIN Cat c ON r.Room_id = c.Room_id
                    ORDER BY r.Room_id";

                using (SqlConnection con = new SqlConnection(connStr))
                using (SqlDataAdapter da = new SqlDataAdapter(sql, con))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gvRooms.DataSource = dt;
                    gvRooms.DataBind();
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error loading rooms grid: " + ex.Message;
                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
        }

        // ------------------ Assign Room & Services ---------------------
        protected void btnAssignRoom_Click(object sender, EventArgs e)
        {
            if (ddlAppointments.SelectedValue == "0" || ddlCats.SelectedValue == "0" || ddlRooms.SelectedValue == "0")
            {
                lblMessage.Text = "Please select Appointment, Cat, and Room.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            int appointmentId, roomId, catId;

            if (!int.TryParse(ddlAppointments.SelectedValue, out appointmentId) ||
                !int.TryParse(ddlRooms.SelectedValue, out roomId) ||
                !int.TryParse(ddlCats.SelectedValue, out catId))
            {
                lblMessage.Text = "Invalid selection. Please try again.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            int durationDays = int.TryParse(txtDurationDays.Text, out int d) ? d : 1;
            int durationHours = int.TryParse(txtDurationHours.Text, out int h) ? h : 0;

            DateTime checkIn = DateTime.Now;
            DateTime checkOut = checkIn.AddDays(durationDays).AddHours(durationHours);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                try
                {
                    con.Open();
                    SqlTransaction tran = con.BeginTransaction();

                    try
                    {
                        // Update Room
                        string sqlRoom = @"UPDATE Room SET Status='Occupied', Check_in_date=@checkIn, 
                                         Check_out_date=@checkOut, Staff_id=@staffId 
                                         WHERE Room_id=@roomId";
                        SqlCommand cmdRoom = new SqlCommand(sqlRoom, con, tran);
                        cmdRoom.CommandTimeout = 60;
                        cmdRoom.Parameters.AddWithValue("@roomId", roomId);
                        cmdRoom.Parameters.AddWithValue("@checkIn", checkIn);
                        cmdRoom.Parameters.AddWithValue("@checkOut", checkOut);
                        cmdRoom.Parameters.AddWithValue("@staffId", StaffID);
                        cmdRoom.ExecuteNonQuery();

                        // Update Cat
                        string sqlCat = "UPDATE Cat SET Room_id=@roomId WHERE Cat_id=@catId";
                        SqlCommand cmdCat = new SqlCommand(sqlCat, con, tran);
                        cmdCat.CommandTimeout = 60;
                        cmdCat.Parameters.AddWithValue("@roomId", roomId);
                        cmdCat.Parameters.AddWithValue("@catId", catId);
                        cmdCat.ExecuteNonQuery();

                        // Update Appointment
                        string sqlApp = "UPDATE Appointment SET RoomAssigned=1 WHERE Appointment_id=@aid";
                        SqlCommand cmdApp = new SqlCommand(sqlApp, con, tran);
                        cmdApp.CommandTimeout = 60;
                        cmdApp.Parameters.AddWithValue("@aid", appointmentId);
                        cmdApp.ExecuteNonQuery();

                        // Assign Services
                        if (chkServices.Items.Count > 0)
                        {
                            string sqlService = "UPDATE Services SET Room_id=@roomId WHERE Service_id=@serviceId";
                            foreach (ListItem item in chkServices.Items)
                            {
                                if (item.Selected)
                                {
                                    SqlCommand cmdService = new SqlCommand(sqlService, con, tran);
                                    cmdService.CommandTimeout = 60;
                                    cmdService.Parameters.AddWithValue("@roomId", roomId);
                                    cmdService.Parameters.AddWithValue("@serviceId", item.Value);
                                    cmdService.ExecuteNonQuery();
                                }
                            }
                        }

                        // Insert Task
                        string taskName = $"Room {GetRoomNumber(roomId)} assignment for {GetCatName(catId)}";
                        string sqlTask = @"INSERT INTO Task(Staff_id, Appointment_id, Room_id, Cat_id, Name, Status, Check_in_date, Check_out_date)
                                           VALUES(@sid, @aid, @rid, @cid, @name, 'Pending', @checkIn, @checkOut)";
                        SqlCommand cmdTask = new SqlCommand(sqlTask, con, tran);
                        cmdTask.CommandTimeout = 60;
                        cmdTask.Parameters.AddWithValue("@sid", StaffID);
                        cmdTask.Parameters.AddWithValue("@aid", appointmentId);
                        cmdTask.Parameters.AddWithValue("@rid", roomId);
                        cmdTask.Parameters.AddWithValue("@cid", catId);
                        cmdTask.Parameters.AddWithValue("@name", taskName);
                        cmdTask.Parameters.AddWithValue("@checkIn", checkIn);
                        cmdTask.Parameters.AddWithValue("@checkOut", checkOut);
                        cmdTask.ExecuteNonQuery();

                        tran.Commit();

                        lblMessage.Text = $"Room assigned successfully! Task created. Check-out: {checkOut:MM/dd/yyyy HH:mm}";
                        lblMessage.ForeColor = System.Drawing.Color.Green;

                        // Reset form
                        ddlAppointments.SelectedIndex = 0;
                        ddlCats.Items.Clear();
                        ddlCats.Items.Insert(0, new ListItem("--Select Cat--", "0"));
                        ddlRooms.SelectedIndex = 0;
                        chkServices.ClearSelection();
                        txtDurationDays.Text = "1";
                        txtDurationHours.Text = "0";
                    }
                    catch (Exception ex)
                    {
                        tran.Rollback();
                        lblMessage.Text = "Transaction Error: " + ex.Message;
                        lblMessage.ForeColor = System.Drawing.Color.Red;
                    }
                }
                catch (SqlException sqlEx)
                {
                    if (sqlEx.Number == -2) // Timeout error
                    {
                        lblMessage.Text = "Database operation timed out. Please try again.";
                    }
                    else
                    {
                        lblMessage.Text = "Database Error: " + sqlEx.Message;
                    }
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "Error: " + ex.Message;
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                }
            }

            // Reload data
            LoadAppointments();
            LoadRoomsDropDown();
            LoadServices();
            LoadRoomsGrid();
        }

        // ------------------ Helpers ---------------------
        private string GetRoomNumber(int roomId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    string sql = "SELECT Room_no FROM Room WHERE Room_id=@id";
                    SqlCommand cmd = new SqlCommand(sql, con);
                    cmd.CommandTimeout = 30;
                    cmd.Parameters.AddWithValue("@id", roomId);
                    con.Open();
                    object result = cmd.ExecuteScalar();
                    return result?.ToString() ?? "Unknown";
                }
            }
            catch
            {
                return "Unknown";
            }
        }

        private string GetCatName(int catId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    string sql = "SELECT Name FROM Cat WHERE Cat_id=@id";
                    SqlCommand cmd = new SqlCommand(sql, con);
                    cmd.CommandTimeout = 30;
                    cmd.Parameters.AddWithValue("@id", catId);
                    con.Open();
                    object result = cmd.ExecuteScalar();
                    return result?.ToString() ?? "Unknown Cat";
                }
            }
            catch
            {
                return "Unknown Cat";
            }
        }

        // ------------------ Grid Row Styling ---------------------
        protected void gvRooms_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                string status = DataBinder.Eval(e.Row.DataItem, "Status")?.ToString().ToLower() ?? "";
                if (status == "occupied") e.Row.CssClass = "status-occupied";
                else if (status == "available") e.Row.CssClass = "status-available";
                else if (status == "maintenance") e.Row.CssClass = "status-maintenance";
            }
        }

        protected void ddlAppointments_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadCats();
        }
    }
}