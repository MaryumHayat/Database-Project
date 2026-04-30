using System;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI.WebControls;

namespace CatResort
{
    public partial class VetManagement : System.Web.UI.Page
    {
        string connStr = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\catdb.mdf;Integrated Security=True;";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() != "Admin")
                Response.Redirect("Login.aspx");

            if (!IsPostBack)
            {
                LoadVets();
                gvVet.Visible = true;
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
                    LoadVets();
                    gvVet.Visible = true;
                    gvQueryResults.Visible = false;
                    ShowMessage("Showing all vet records.", true);
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
                        gvVet.Visible = false;
                        ShowMessage($"Query executed successfully. {dt.Rows.Count} records found.", true);
                    }
                    else
                    {
                        gvQueryResults.Visible = false;
                        gvVet.Visible = true;
                        ShowMessage("No records found for the given query.", false);
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error executing query: " + ex.Message, false);
                gvVet.Visible = true;
                gvQueryResults.Visible = false;
            }
        }

        protected void btnAddVet_Click(object sender, EventArgs e)
        {
            try
            {
                if (!ValidateForm()) return;

                int vetId;
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();

                    SqlCommand cmd = new SqlCommand(@"
                        INSERT INTO Vet (Fname,Lname,Address,Shift,Salary)
                        OUTPUT INSERTED.Vet_id
                        VALUES (@fn,@ln,@ad,@sh,@sa)", con);
                    cmd.Parameters.AddWithValue("@fn", txtFname.Text.Trim());
                    cmd.Parameters.AddWithValue("@ln", txtLname.Text.Trim());
                    cmd.Parameters.AddWithValue("@ad", txtAddress.Text.Trim());
                    cmd.Parameters.AddWithValue("@sh", txtShift.Text.Trim());
                    cmd.Parameters.AddWithValue("@sa", decimal.Parse(txtSalary.Text.Trim()));

                    vetId = (int)cmd.ExecuteScalar();

                    InsertEmails(con, vetId, txtEmails.Text.Trim());
                    InsertPhones(con, vetId, txtPhones.Text.Trim());
                }

                ClearForm();
                LoadVets();
                gvVet.Visible = true;
                gvQueryResults.Visible = false;
                ShowMessage("Vet added successfully!", true);
            }
            catch (Exception ex)
            {
                ShowMessage("Error adding vet: " + ex.Message, false);
            }
        }

        protected void btnUpdateVet_Click(object sender, EventArgs e)
        {
            try
            {
                if (string.IsNullOrEmpty(hdnVetId.Value))
                {
                    ShowMessage("Please select a vet to update.", false);
                    return;
                }

                if (!ValidateForm()) return;

                int vetId = int.Parse(hdnVetId.Value);

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();

                    SqlCommand cmd = new SqlCommand(@"
                        UPDATE Vet
                        SET Fname=@fn, Lname=@ln, Address=@ad, Shift=@sh, Salary=@sa
                        WHERE Vet_id=@id", con);
                    cmd.Parameters.AddWithValue("@fn", txtFname.Text.Trim());
                    cmd.Parameters.AddWithValue("@ln", txtLname.Text.Trim());
                    cmd.Parameters.AddWithValue("@ad", txtAddress.Text.Trim());
                    cmd.Parameters.AddWithValue("@sh", txtShift.Text.Trim());
                    cmd.Parameters.AddWithValue("@sa", decimal.Parse(txtSalary.Text.Trim()));
                    cmd.Parameters.AddWithValue("@id", vetId);

                    int rowsAffected = cmd.ExecuteNonQuery();

                    if (rowsAffected > 0)
                    {
                        DeleteVetContacts(con, vetId);
                        InsertEmails(con, vetId, txtEmails.Text.Trim());
                        InsertPhones(con, vetId, txtPhones.Text.Trim());

                        ClearForm();
                        LoadVets();
                        gvVet.Visible = true;
                        gvQueryResults.Visible = false;
                        ShowMessage("Vet updated successfully!", true);
                    }
                    else
                    {
                        ShowMessage("Vet not found.", false);
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error updating vet: " + ex.Message, false);
            }
        }

        protected void gvVet_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                if (e.CommandName == "EditVet")
                {
                    int vetId = int.Parse(e.CommandArgument.ToString());
                    LoadVetForEdit(vetId);
                }
                else if (e.CommandName == "DeleteVet")
                {
                    int vetId = int.Parse(e.CommandArgument.ToString());
                    DeleteVet(vetId);
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

        private void InsertEmails(SqlConnection con, int vetId, string emails)
        {
            if (!string.IsNullOrEmpty(emails))
            {
                var emailsArr = emails.Split(',').Select(em => em.Trim()).Where(em => !string.IsNullOrEmpty(em));
                foreach (var em in emailsArr)
                {
                    SqlCommand cmdEmail = new SqlCommand(
                        "INSERT INTO Vet_Email (Vet_id, Email) VALUES (@vid,@em)", con);
                    cmdEmail.Parameters.AddWithValue("@vid", vetId);
                    cmdEmail.Parameters.AddWithValue("@em", em);
                    cmdEmail.ExecuteNonQuery();
                }
            }
        }

        private void InsertPhones(SqlConnection con, int vetId, string phones)
        {
            if (!string.IsNullOrEmpty(phones))
            {
                var phonesArr = phones.Split(',').Select(ph => ph.Trim()).Where(ph => !string.IsNullOrEmpty(ph));
                foreach (var ph in phonesArr)
                {
                    SqlCommand cmdPhone = new SqlCommand(
                        "INSERT INTO Vet_Phone (Vet_id, Phone_Number) VALUES (@vid,@ph)", con);
                    cmdPhone.Parameters.AddWithValue("@vid", vetId);
                    cmdPhone.Parameters.AddWithValue("@ph", ph);
                    cmdPhone.ExecuteNonQuery();
                }
            }
        }

        private void DeleteVetContacts(SqlConnection con, int vetId)
        {
            SqlCommand deleteEmails = new SqlCommand("DELETE FROM Vet_Email WHERE Vet_id=@id", con);
            deleteEmails.Parameters.AddWithValue("@id", vetId);
            deleteEmails.ExecuteNonQuery();

            SqlCommand deletePhones = new SqlCommand("DELETE FROM Vet_Phone WHERE Vet_id=@id", con);
            deletePhones.Parameters.AddWithValue("@id", vetId);
            deletePhones.ExecuteNonQuery();
        }

        private void LoadVetForEdit(int vetId)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string sql = @"
                    SELECT v.Vet_id, v.Fname, v.Lname, v.Address, v.Shift, v.Salary,
                        ISNULL(STUFF((SELECT ',' + Email FROM Vet_Email e WHERE e.Vet_id=v.Vet_id FOR XML PATH('')),1,1,''),'') AS Emails,
                        ISNULL(STUFF((SELECT ',' + Phone_Number FROM Vet_Phone p WHERE p.Vet_id=v.Vet_id FOR XML PATH('')),1,1,''),'') AS Phones
                    FROM Vet v
                    WHERE v.Vet_id = @id";

                SqlCommand cmd = new SqlCommand(sql, con);
                cmd.Parameters.AddWithValue("@id", vetId);

                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    hdnVetId.Value = reader["Vet_id"].ToString();
                    txtFname.Text = reader["Fname"].ToString();
                    txtLname.Text = reader["Lname"].ToString();
                    txtAddress.Text = reader["Address"].ToString();
                    txtShift.Text = reader["Shift"].ToString();
                    txtSalary.Text = Convert.ToDecimal(reader["Salary"]).ToString("0.00");
                    txtEmails.Text = reader["Emails"].ToString();
                    txtPhones.Text = reader["Phones"].ToString();

                    ShowMessage("Vet loaded for editing.", true);
                }
                reader.Close();
            }
        }

        private void DeleteVet(int vetId)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                DeleteVetContacts(con, vetId);

                SqlCommand deleteVet = new SqlCommand("DELETE FROM Vet WHERE Vet_id=@id", con);
                deleteVet.Parameters.AddWithValue("@id", vetId);
                int rowsAffected = deleteVet.ExecuteNonQuery();

                if (rowsAffected > 0)
                {
                    LoadVets();
                    ShowMessage("Vet deleted successfully!", true);
                }
                else
                {
                    ShowMessage("Vet not found.", false);
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

            if (string.IsNullOrEmpty(txtShift.Text.Trim()))
            {
                ShowMessage("Shift is required.", false);
                return false;
            }

            if (string.IsNullOrEmpty(txtSalary.Text.Trim()) || !decimal.TryParse(txtSalary.Text.Trim(), out _))
            {
                ShowMessage("Valid Salary is required.", false);
                return false;
            }

            return true;
        }

        private void LoadVets()
        {
            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string sql = @"
                    SELECT v.Vet_id, v.Fname, v.Lname, v.Address, v.Shift, v.Salary,
                        ISNULL(STUFF((SELECT ',' + Email FROM Vet_Email e WHERE e.Vet_id=v.Vet_id FOR XML PATH('')),1,1,''),'') AS Emails,
                        ISNULL(STUFF((SELECT ',' + Phone_Number FROM Vet_Phone p WHERE p.Vet_id=v.Vet_id FOR XML PATH('')),1,1,''),'') AS Phones
                    FROM Vet v
                    ORDER BY v.Vet_id";
                SqlDataAdapter da = new SqlDataAdapter(sql, con);
                da.Fill(dt);
            }

            gvVet.DataSource = dt;
            gvVet.DataBind();
        }

        private void ClearForm()
        {
            hdnVetId.Value = "";
            txtFname.Text = "";
            txtLname.Text = "";
            txtAddress.Text = "";
            txtShift.Text = "";
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
