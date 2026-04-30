using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CatResort
{
    public partial class Tasks : System.Web.UI.Page
    {
        string connStr = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\catdb.mdf;Integrated Security=True;";
        int StaffID => Session["StaffID"] != null ? Convert.ToInt32(Session["StaffID"]) : 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"]?.ToString() != "Staff")
                Response.Redirect("Login.aspx");

            if (!IsPostBack)
            {
                LoadTasks();
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("StaffDashboard.aspx");
        }

        protected void ddlStatusFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadTasks();
        }

        void LoadTasks()
        {
            string sql = @"
                SELECT 
                    t.Task_id,
                    t.Name,
                    t.Status,
                    t.Check_in_date,
                    t.Check_out_date,
                    t.Room_id,
                    t.Cat_id,
                    r.Room_no,
                    c.Name AS CatName,
                    r.Status AS RoomStatus,
                    (SELECT COUNT(*) FROM Services s WHERE s.Room_id = t.Room_id) AS ServiceCount
                FROM Task t
                LEFT JOIN Room r ON t.Room_id = r.Room_id
                LEFT JOIN Cat c ON t.Cat_id = c.Cat_id
                WHERE t.Staff_id = @sid";

            if (ddlStatusFilter.SelectedValue != "All")
            {
                sql += " AND t.Status = @status";
            }

            sql += @" ORDER BY 
                    CASE 
                        WHEN t.Status = 'Pending' THEN 1
                        WHEN t.Status = 'In Progress' THEN 2
                        WHEN t.Status = 'Completed' THEN 3
                        ELSE 4
                    END,
                    t.Check_in_date DESC";

            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                cmd.Parameters.AddWithValue("@sid", StaffID);
                if (ddlStatusFilter.SelectedValue != "All")
                    cmd.Parameters.AddWithValue("@status", ddlStatusFilter.SelectedValue);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvTasks.DataSource = dt;
                gvTasks.DataBind();
            }
        }

        protected void chkComplete_CheckedChanged(object sender, EventArgs e)
        {
            CheckBox chk = (CheckBox)sender;
            GridViewRow row = (GridViewRow)chk.NamingContainer;

            int taskId = Convert.ToInt32(((HiddenField)row.FindControl("hfTaskId")).Value);
            int roomId = 0;
            int catId = 0;

            HiddenField hfRoomId = (HiddenField)row.FindControl("hfRoomId");
            HiddenField hfCatId = (HiddenField)row.FindControl("hfCatId");

            if (hfRoomId != null && !string.IsNullOrEmpty(hfRoomId.Value))
                roomId = Convert.ToInt32(hfRoomId.Value);

            if (hfCatId != null && !string.IsNullOrEmpty(hfCatId.Value))
                catId = Convert.ToInt32(hfCatId.Value);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                SqlTransaction tran = con.BeginTransaction();

                try
                {
                    // 1. Mark task as completed
                    string sqlTask = "UPDATE Task SET Status='Completed', Check_out_date=GETDATE() WHERE Task_id=@tid";
                    SqlCommand cmdTask = new SqlCommand(sqlTask, con, tran);
                    cmdTask.Parameters.AddWithValue("@tid", taskId);
                    cmdTask.ExecuteNonQuery();

                    // 2. Set room to Available
                    if (roomId > 0)
                    {
                        string sqlRoom = @"UPDATE Room 
                                           SET Status='Available', 
                                               Check_out_date=GETDATE(),
                                               Staff_id=NULL 
                                           WHERE Room_id=@rid";
                        SqlCommand cmdRoom = new SqlCommand(sqlRoom, con, tran);
                        cmdRoom.Parameters.AddWithValue("@rid", roomId);
                        cmdRoom.ExecuteNonQuery();
                    }

                    // 3. Remove cat from room
                    if (catId > 0)
                    {
                        string sqlCat = "UPDATE Cat SET Room_id=NULL WHERE Cat_id=@cid";
                        SqlCommand cmdCat = new SqlCommand(sqlCat, con, tran);
                        cmdCat.Parameters.AddWithValue("@cid", catId);
                        cmdCat.ExecuteNonQuery();
                    }

                    // 4. Clear services from room
                    if (roomId > 0)
                    {
                        string sqlServices = "UPDATE Services SET Room_id=NULL WHERE Room_id=@rid";
                        SqlCommand cmdServices = new SqlCommand(sqlServices, con, tran);
                        cmdServices.Parameters.AddWithValue("@rid", roomId);
                        cmdServices.ExecuteNonQuery();
                    }

                    tran.Commit();

                    // Redirect to refresh grid and Rooms page
                    Response.Redirect(Request.RawUrl);
                }
                catch (Exception ex)
                {
                    tran.Rollback();
                    ScriptManager.RegisterStartupScript(this, GetType(), "showError",
                        $"alert('Error completing task: {ex.Message.Replace("'", "\\'")}');", true);
                    chk.Checked = false;
                }
            }
        }

        protected void gvTasks_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                CheckBox chkComplete = (CheckBox)e.Row.FindControl("chkComplete");
                DataRowView rowView = (DataRowView)e.Row.DataItem;

                string status = rowView["Status"].ToString();
                string roomStatus = rowView["RoomStatus"] != DBNull.Value ? rowView["RoomStatus"].ToString() : "";

                if (status == "Completed")
                {
                    chkComplete.Enabled = false;
                    chkComplete.Checked = true;
                    chkComplete.ToolTip = "Task already completed";
                    e.Row.CssClass = "task-completed";
                }
                else
                {
                    chkComplete.Enabled = true;
                    chkComplete.Checked = false;
                    chkComplete.ToolTip = "Click to mark as completed";
                }

                // Show room status and service count
                if (!string.IsNullOrEmpty(roomStatus))
                    e.Row.Cells[6].Text += $" (Room: {roomStatus})";

                if (rowView["ServiceCount"] != DBNull.Value && Convert.ToInt32(rowView["ServiceCount"]) > 0)
                    e.Row.Cells[3].Text += $" ({rowView["ServiceCount"]} services)";
            }
        }
    }
}
