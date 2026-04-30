using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CatResort
{
    public partial class CatCare : System.Web.UI.Page
    {
        string connStr = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\catdb.mdf;Integrated Security=True;Connect Timeout=30";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"]?.ToString() != "Staff")
                Response.Redirect("Login.aspx");

            if (!IsPostBack)
            {
                LoadCurrentCats();
                LoadFilterOptions();
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("StaffDashboard.aspx");
        }

        // Load all cats currently staying
        private void LoadCurrentCats()
        {
            try
            {
                string sql = @"
                    SELECT 
                        c.Cat_id,
                        c.Name AS CatName,
                        c.Breed,
                        c.Age,
                        c.Behavior AS SpecialNeeds,
                        c.Vaccinated,
                        r.Room_id,
                        r.Room_no,
                        r.Check_in_date,
                        r.Check_out_date,
                        cust.Fname + ' ' + cust.Lname AS OwnerName,
                        ISNULL((SELECT TOP 1 Phone_Number FROM Customer_Phone WHERE Customer_id = cust.Customer_id), 'N/A') AS OwnerPhone,
                        ISNULL((SELECT TOP 1 Email FROM Customer_Email WHERE Customer_id = cust.Customer_id), 'N/A') AS OwnerEmail,
                        DATEDIFF(day, GETDATE(), r.Check_out_date) AS DaysRemaining,
                        CASE 
                            WHEN r.Check_out_date IS NULL THEN 'No Check-out Date'
                            WHEN r.Check_out_date < GETDATE() THEN 'Overdue'
                            WHEN DATEDIFF(day, GETDATE(), r.Check_out_date) <= 1 THEN 'Leaving Soon'
                            ELSE 'Active'
                        END AS Status
                    FROM Cat c
                    INNER JOIN Room r ON c.Room_id = r.Room_id
                    INNER JOIN Customer cust ON c.Customer_id = cust.Customer_id
                    WHERE r.Status = 'Occupied' 
                    AND r.Check_out_date >= GETDATE()
                    ORDER BY r.Check_out_date ASC, c.Name ASC";

                using (SqlConnection con = new SqlConnection(connStr))
                using (SqlDataAdapter da = new SqlDataAdapter(sql, con))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        lblTotalCats.Text = $"Currently Boarding: {dt.Rows.Count} cats";
                        gvCurrentCats.DataSource = dt;
                        gvCurrentCats.DataBind();
                    }
                    else
                    {
                        lblTotalCats.Text = "No cats currently staying";
                        gvCurrentCats.DataSource = null;
                        gvCurrentCats.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error loading cats: " + ex.Message;
                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
        }

        // Load filter options
        private void LoadFilterOptions()
        {
            try
            {
                // Room filter - using Room_no from Room table
                string roomSql = "SELECT DISTINCT Room_no FROM Room WHERE Status='Occupied' ORDER BY Room_no";
                using (SqlConnection con = new SqlConnection(connStr))
                using (SqlDataAdapter da = new SqlDataAdapter(roomSql, con))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    ddlFilterRoom.DataSource = dt;
                    ddlFilterRoom.DataTextField = "Room_no";
                    ddlFilterRoom.DataValueField = "Room_no";
                    ddlFilterRoom.DataBind();
                    ddlFilterRoom.Items.Insert(0, new ListItem("All Rooms", ""));
                }

                // Breed filter
                string breedSql = "SELECT DISTINCT Breed FROM Cat WHERE Breed IS NOT NULL AND Breed != '' ORDER BY Breed";
                using (SqlConnection con = new SqlConnection(connStr))
                using (SqlDataAdapter da = new SqlDataAdapter(breedSql, con))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    ddlFilterBreed.DataSource = dt;
                    ddlFilterBreed.DataTextField = "Breed";
                    ddlFilterBreed.DataValueField = "Breed";
                    ddlFilterBreed.DataBind();
                    ddlFilterBreed.Items.Insert(0, new ListItem("All Breeds", ""));
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error loading filters: " + ex.Message;
                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
        }

        // Filter cats
        protected void btnFilter_Click(object sender, EventArgs e)
        {
            try
            {
                string roomFilter = ddlFilterRoom.SelectedValue;
                string breedFilter = ddlFilterBreed.SelectedValue;
                string searchName = txtSearchName.Text.Trim();

                string sql = @"
                    SELECT 
                        c.Cat_id,
                        c.Name AS CatName,
                        c.Breed,
                        c.Age,
                        c.Behavior AS SpecialNeeds,
                        c.Vaccinated,
                        r.Room_id,
                        r.Room_no,
                        r.Check_in_date,
                        r.Check_out_date,
                        cust.Fname + ' ' + cust.Lname AS OwnerName,
                        ISNULL((SELECT TOP 1 Phone_Number FROM Customer_Phone WHERE Customer_id = cust.Customer_id), 'N/A') AS OwnerPhone,
                        ISNULL((SELECT TOP 1 Email FROM Customer_Email WHERE Customer_id = cust.Customer_id), 'N/A') AS OwnerEmail,
                        DATEDIFF(day, GETDATE(), r.Check_out_date) AS DaysRemaining,
                        CASE 
                            WHEN r.Check_out_date IS NULL THEN 'No Check-out Date'
                            WHEN r.Check_out_date < GETDATE() THEN 'Overdue'
                            WHEN DATEDIFF(day, GETDATE(), r.Check_out_date) <= 1 THEN 'Leaving Soon'
                            ELSE 'Active'
                        END AS Status
                    FROM Cat c
                    INNER JOIN Room r ON c.Room_id = r.Room_id
                    INNER JOIN Customer cust ON c.Customer_id = cust.Customer_id
                    WHERE r.Status = 'Occupied' 
                    AND r.Check_out_date >= GETDATE()";

                // Apply filters
                if (!string.IsNullOrEmpty(roomFilter))
                    sql += " AND r.Room_no = @roomNo";

                if (!string.IsNullOrEmpty(breedFilter))
                    sql += " AND c.Breed = @breed";

                if (!string.IsNullOrEmpty(searchName))
                    sql += " AND c.Name LIKE @searchName";

                sql += " ORDER BY r.Check_out_date ASC, c.Name ASC";

                using (SqlConnection con = new SqlConnection(connStr))
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    if (!string.IsNullOrEmpty(roomFilter))
                        cmd.Parameters.AddWithValue("@roomNo", roomFilter);

                    if (!string.IsNullOrEmpty(breedFilter))
                        cmd.Parameters.AddWithValue("@breed", breedFilter);

                    if (!string.IsNullOrEmpty(searchName))
                        cmd.Parameters.AddWithValue("@searchName", "%" + searchName + "%");

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        lblTotalCats.Text = $"Found: {dt.Rows.Count} cats";
                        gvCurrentCats.DataSource = dt;
                        gvCurrentCats.DataBind();
                    }
                    else
                    {
                        lblTotalCats.Text = "No cats found with current filters";
                        gvCurrentCats.DataSource = null;
                        gvCurrentCats.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error filtering cats: " + ex.Message;
                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
        }

        // Clear filters
        protected void btnClearFilter_Click(object sender, EventArgs e)
        {
            ddlFilterRoom.SelectedIndex = 0;
            ddlFilterBreed.SelectedIndex = 0;
            txtSearchName.Text = "";
            LoadCurrentCats();
        }

        // Export to CSV
        protected void btnExport_Click(object sender, EventArgs e)
        {
            try
            {
                string sql = @"
                    SELECT 
                        c.Name AS 'Cat Name',
                        c.Breed,
                        c.Age,
                        c.Behavior AS 'Special Needs/Behavior',
                        c.Vaccinated AS 'Vaccination Status',
                        r.Room_no AS 'Room Number',
                        FORMAT(r.Check_in_date, 'MM/dd/yyyy HH:mm') AS 'Check-in Date',
                        FORMAT(r.Check_out_date, 'MM/dd/yyyy HH:mm') AS 'Check-out Date',
                        cust.Fname + ' ' + cust.Lname AS 'Owner Name',
                        ISNULL((SELECT TOP 1 Phone_Number FROM Customer_Phone WHERE Customer_id = cust.Customer_id), 'N/A') AS 'Owner Phone',
                        ISNULL((SELECT TOP 1 Email FROM Customer_Email WHERE Customer_id = cust.Customer_id), 'N/A') AS 'Owner Email'
                    FROM Cat c
                    INNER JOIN Room r ON c.Room_id = r.Room_id
                    INNER JOIN Customer cust ON c.Customer_id = cust.Customer_id
                    WHERE r.Status = 'Occupied' 
                    AND r.Check_out_date >= GETDATE()
                    ORDER BY r.Check_out_date ASC, c.Name ASC";

                using (SqlConnection con = new SqlConnection(connStr))
                using (SqlDataAdapter da = new SqlDataAdapter(sql, con))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    // Export to CSV
                    Response.Clear();
                    Response.Buffer = true;
                    Response.AddHeader("content-disposition", "attachment;filename=CurrentCats_" + DateTime.Now.ToString("yyyyMMdd") + ".csv");
                    Response.Charset = "";
                    Response.ContentType = "application/text";

                    string columnNames = "";
                    foreach (DataColumn column in dt.Columns)
                    {
                        columnNames += column.ColumnName + ",";
                    }
                    Response.Output.Write(columnNames.TrimEnd(',') + "\r\n");

                    foreach (DataRow row in dt.Rows)
                    {
                        foreach (DataColumn column in dt.Columns)
                        {
                            Response.Output.Write(row[column].ToString().Replace(",", ";") + ",");
                        }
                        Response.Output.Write("\r\n");
                    }

                    Response.Flush();
                    Response.End();
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error exporting: " + ex.Message;
                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
        }

        // Grid formatting
        protected void gvCurrentCats_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // Make row clickable
                e.Row.Attributes["onclick"] = "this.style.cursor='pointer';";
                e.Row.Attributes["onmouseover"] = "this.style.backgroundColor='#fff6fc';";
                e.Row.Attributes["onmouseout"] = "this.style.backgroundColor='';";

                // Style based on status
                string status = DataBinder.Eval(e.Row.DataItem, "Status")?.ToString() ?? "";
                switch (status)
                {
                    case "Leaving Soon":
                        e.Row.CssClass = "status-leaving-soon";
                        break;
                    case "Overdue":
                        e.Row.CssClass = "status-overdue";
                        break;
                    case "Active":
                        e.Row.CssClass = "status-active";
                        break;
                }

                // Add tooltip for special needs if it exists
                string specialNeeds = DataBinder.Eval(e.Row.DataItem, "SpecialNeeds")?.ToString() ?? "";
                if (!string.IsNullOrEmpty(specialNeeds))
                {
                    e.Row.ToolTip = "Special Needs: " + specialNeeds;
                }
            }
        }

        // View cat details
        protected void gvCurrentCats_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (gvCurrentCats.SelectedIndex >= 0)
            {
                int catId = Convert.ToInt32(gvCurrentCats.SelectedDataKey.Value);
                Response.Redirect($"CatDetails.aspx?catId={catId}");
            }
        }

        // Handle row click
        protected void gvCurrentCats_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Select")
            {
                int rowIndex = Convert.ToInt32(e.CommandArgument);
                int catId = Convert.ToInt32(gvCurrentCats.DataKeys[rowIndex].Value);
                Response.Redirect($"CatDetails.aspx?catId={catId}");
            }
        }
    }
}