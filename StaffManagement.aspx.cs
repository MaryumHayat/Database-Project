using System;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI.WebControls;

namespace CatResort
{
    public partial class StaffManagement : System.Web.UI.Page
    {
        string connStr = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\catdb.mdf;Integrated Security=True;";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() != "Admin")
                Response.Redirect("Login.aspx");

            if (!IsPostBack)
            {
                LoadStaff();
                gvStaff.Visible = true;
                gvQueryResults.Visible = false;
            }
        }

        #region CRUD + Query Methods

        protected void btnExecuteQuery_Click(object sender, EventArgs e)
        {
            try
            {
                string query = txtQuery.Text.Trim();

                if (string.IsNullOrEmpty(query))
                {
                    LoadStaff();
                    gvStaff.Visible = true;
                    gvQueryResults.Visible = false;
                    ShowMessage("Showing all staff records.", true);
                    return;
                }

                if (!query.Trim().ToUpper().StartsWith("SELECT"))
                {
                    ShowMessage("Only SELECT queries are allowed for security reasons.", false);
                    return;
                }

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlDataAdapter da = new SqlDataAdapter(query, con);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        gvQueryResults.DataSource = dt;
                        gvQueryResults.DataBind();
                        gvQueryResults.Visible = true;
                        gvStaff.Visible = false;
                        ShowMessage($"Query executed successfully. {dt.Rows.Count} records found.", true);
                    }
                    else
                    {
                        gvQueryResults.Visible = false;
                        gvStaff.Visible = true;
                        ShowMessage("No records found for the given query.", false);
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error executing query: " + ex.Message, false);
                gvStaff.Visible = true;
                gvQueryResults.Visible = false;
            }
        }

        protected void btnAddStaff_Click(object sender, EventArgs e)
        {
            try
            {
                if (!ValidateForm())
                    return;

                int staffId;
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();

                    SqlCommand cmd = new SqlCommand(@"
                        INSERT INTO Staff (Fname,Lname,Address,Role,Salary)
                        OUTPUT INSERTED.Staff_id
                        VALUES (@fn,@ln,@ad,@ro,@sa)", con);
                    cmd.Parameters.AddWithValue("@fn", txtFname.Text.Trim());
                    cmd.Parameters.AddWithValue("@ln", txtLname.Text.Trim());
                    cmd.Parameters.AddWithValue("@ad", txtAddress.Text.Trim());
                    cmd.Parameters.AddWithValue("@ro", txtRole.Text.Trim());
                    cmd.Parameters.AddWithValue("@sa", decimal.Parse(txtSalary.Text.Trim()));

                    staffId = (int)cmd.ExecuteScalar();

                    InsertEmails(con, staffId, txtEmails.Text.Trim());
                    InsertPhones(con, staffId, txtPhones.Text.Trim());
                }

                ClearForm();
                LoadStaff();
                gvStaff.Visible = true;
                gvQueryResults.Visible = false;
                ShowMessage("Staff member added successfully!", true);
            }
            catch (Exception ex)
            {
                ShowMessage("Error adding staff: " + ex.Message, false);
            }
        }

        protected void btnUpdateStaff_Click(object sender, EventArgs e)
        {
            try
            {
                if (string.IsNullOrEmpty(hdnStaffId.Value))
                {
                    ShowMessage("Please select a staff member to update.", false);
                    return;
                }

                if (!ValidateForm())
                    return;

                int staffId = int.Parse(hdnStaffId.Value);

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();

                    SqlCommand cmd = new SqlCommand(@"
                        UPDATE Staff 
                        SET Fname=@fn, Lname=@ln, Address=@ad, Role=@ro, Salary=@sa
                        WHERE Staff_id=@id", con);
                    cmd.Parameters.AddWithValue("@fn", txtFname.Text.Trim());
                    cmd.Parameters.AddWithValue("@ln", txtLname.Text.Trim());
                    cmd.Parameters.AddWithValue("@ad", txtAddress.Text.Trim());
                    cmd.Parameters.AddWithValue("@ro", txtRole.Text.Trim());
                    cmd.Parameters.AddWithValue("@sa", decimal.Parse(txtSalary.Text.Trim()));
                    cmd.Parameters.AddWithValue("@id", staffId);

                    int rowsAffected = cmd.ExecuteNonQuery();

                    if (rowsAffected > 0)
                    {
                        DeleteStaffContacts(con, staffId);
                        InsertEmails(con, staffId, txtEmails.Text.Trim());
                        InsertPhones(con, staffId, txtPhones.Text.Trim());

                        ClearForm();
                        LoadStaff();
                        gvStaff.Visible = true;
                        gvQueryResults.Visible = false;
                        ShowMessage("Staff member updated successfully!", true);
                    }
                    else
                    {
                        ShowMessage("Staff member not found.", false);
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error updating staff: " + ex.Message, false);
            }
        }

        protected void gvStaff_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                if (e.CommandName == "EditStaff")
                {
                    int staffId = int.Parse(e.CommandArgument.ToString());
                    LoadStaffForEdit(staffId);
                }
                else if (e.CommandName == "DeleteStaff")
                {
                    int staffId = int.Parse(e.CommandArgument.ToString());
                    DeleteStaff(staffId);
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error: " + ex.Message, false);
            }
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearForm();
            ShowMessage("Form cleared.", true);
        }

        #endregion

        #region Helper Methods

        private void InsertEmails(SqlConnection con, int staffId, string emails)
        {
            if (!string.IsNullOrEmpty(emails))
            {
                var emailsArr = emails.Split(',').Select(em => em.Trim()).Where(em => !string.IsNullOrEmpty(em));
                foreach (var em in emailsArr)
                {
                    SqlCommand cmdEmail = new SqlCommand(
                        "INSERT INTO Staff_Email (Staff_id, Email) VALUES (@sid,@em)", con);
                    cmdEmail.Parameters.AddWithValue("@sid", staffId);
                    cmdEmail.Parameters.AddWithValue("@em", em);
                    cmdEmail.ExecuteNonQuery();
                }
            }
        }

        private void InsertPhones(SqlConnection con, int staffId, string phones)
        {
            if (!string.IsNullOrEmpty(phones))
            {
                var phonesArr = phones.Split(',').Select(ph => ph.Trim()).Where(ph => !string.IsNullOrEmpty(ph));
                foreach (var ph in phonesArr)
                {
                    SqlCommand cmdPhone = new SqlCommand(
                        "INSERT INTO Staff_Phone (Staff_id, Phone_Number) VALUES (@sid,@ph)", con);
                    cmdPhone.Parameters.AddWithValue("@sid", staffId);
                    cmdPhone.Parameters.AddWithValue("@ph", ph);
                    cmdPhone.ExecuteNonQuery();
                }
            }
        }

        private void DeleteStaffContacts(SqlConnection con, int staffId)
        {
            SqlCommand deleteEmails = new SqlCommand("DELETE FROM Staff_Email WHERE Staff_id=@id", con);
            deleteEmails.Parameters.AddWithValue("@id", staffId);
            deleteEmails.ExecuteNonQuery();

            SqlCommand deletePhones = new SqlCommand("DELETE FROM Staff_Phone WHERE Staff_id=@id", con);
            deletePhones.Parameters.AddWithValue("@id", staffId);
            deletePhones.ExecuteNonQuery();
        }

        private void LoadStaffForEdit(int staffId)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string sql = @"
                    SELECT s.Staff_id, s.Fname, s.Lname, s.Address, s.Role, s.Salary,
                        ISNULL(STUFF((SELECT ',' + Email FROM Staff_Email e WHERE e.Staff_id=s.Staff_id FOR XML PATH('')),1,1,''),'') AS Emails,
                        ISNULL(STUFF((SELECT ',' + Phone_Number FROM Staff_Phone p WHERE p.Staff_id=s.Staff_id FOR XML PATH('')),1,1,''),'') AS Phones
                    FROM Staff s
                    WHERE s.Staff_id = @id";

                SqlCommand cmd = new SqlCommand(sql, con);
                cmd.Parameters.AddWithValue("@id", staffId);

                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    hdnStaffId.Value = reader["Staff_id"].ToString();
                    txtFname.Text = reader["Fname"].ToString();
                    txtLname.Text = reader["Lname"].ToString();
                    txtAddress.Text = reader["Address"].ToString();
                    txtRole.Text = reader["Role"].ToString();
                    txtSalary.Text = Convert.ToDecimal(reader["Salary"]).ToString("0.00");
                    txtEmails.Text = reader["Emails"].ToString();
                    txtPhones.Text = reader["Phones"].ToString();

                    ShowMessage("Staff member loaded for editing.", true);
                }
                reader.Close();
            }
        }

        private void DeleteStaff(int staffId)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                DeleteStaffContacts(con, staffId);

                SqlCommand deleteStaff = new SqlCommand("DELETE FROM Staff WHERE Staff_id=@id", con);
                deleteStaff.Parameters.AddWithValue("@id", staffId);
                int rowsAffected = deleteStaff.ExecuteNonQuery();

                if (rowsAffected > 0)
                {
                    LoadStaff();
                    ShowMessage("Staff member deleted successfully!", true);
                }
                else
                {
                    ShowMessage("Staff member not found.", false);
                }
            }
        }

        private bool ValidateForm()
        {
            if (string.IsNullOrEmpty(txtFname.Text.Trim()))
            {
                ShowMessage("First Name is required.", false);
                return false;
            }

            if (string.IsNullOrEmpty(txtLname.Text.Trim()))
            {
                ShowMessage("Last Name is required.", false);
                return false;
            }

            if (string.IsNullOrEmpty(txtRole.Text.Trim()))
            {
                ShowMessage("Role is required.", false);
                return false;
            }

            if (string.IsNullOrEmpty(txtSalary.Text.Trim()) || !decimal.TryParse(txtSalary.Text.Trim(), out _))
            {
                ShowMessage("Valid Salary is required.", false);
                return false;
            }

            return true;
        }

        private void LoadStaff()
        {
            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string sql = @"
                    SELECT s.Staff_id, s.Fname, s.Lname, s.Address, s.Role, s.Salary,
                        ISNULL(STUFF((SELECT ',' + Email FROM Staff_Email e WHERE e.Staff_id=s.Staff_id FOR XML PATH('')),1,1,''),'') AS Emails,
                        ISNULL(STUFF((SELECT ',' + Phone_Number FROM Staff_Phone p WHERE p.Staff_id=s.Staff_id FOR XML PATH('')),1,1,''),'') AS Phones
                    FROM Staff s
                    ORDER BY s.Staff_id";
                SqlDataAdapter da = new SqlDataAdapter(sql, con);
                da.Fill(dt);
            }

            gvStaff.DataSource = dt;
            gvStaff.DataBind();
        }

        private void ClearForm()
        {
            hdnStaffId.Value = "";
            txtFname.Text = "";
            txtLname.Text = "";
            txtAddress.Text = "";
            txtRole.Text = "";
            txtSalary.Text = "";
            txtEmails.Text = "";
            txtPhones.Text = "";
        }

        private void ShowMessage(string message, bool isSuccess)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = isSuccess ? "success-message" : "";
        }

        #endregion

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("Login.aspx");
        }
        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("AdminDashboard.aspx");
        }

    }
}
