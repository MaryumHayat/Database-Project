using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace CatResort
{
    public partial class UserManagement : System.Web.UI.Page
    {
        string connStr = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\catdb.mdf;Integrated Security=True;";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() != "Admin")
                Response.Redirect("Login.aspx");

            if (!IsPostBack)
            {
                LoadUsers();
                gvUsers.Visible = true;
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("AdminDashboard.aspx");
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("Login.aspx");
        }

        protected void ddlRole_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlReference.Items.Clear();
            ddlReference.Items.Add(new ListItem("Select Reference", ""));

            string role = ddlRole.SelectedValue;
            if (string.IsNullOrEmpty(role)) return;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                string sql = "";
                switch (role)
                {
                    case "Admin":
                        sql = "SELECT Admin_id AS Id, Fname + ' ' + Lname AS Name FROM Admin";
                        break;
                    case "Staff":
                        sql = "SELECT Staff_id AS Id, Fname + ' ' + Lname AS Name FROM Staff";
                        break;
                    case "Vet":
                        sql = "SELECT Vet_id AS Id, Fname + ' ' + Lname AS Name FROM Vet";
                        break;
                    case "Customer":
                        sql = "SELECT Customer_id AS Id, Fname + ' ' + Lname AS Name FROM Customer";
                        break;
                }

                SqlDataAdapter da = new SqlDataAdapter(sql, con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                ddlReference.DataSource = dt;
                ddlReference.DataTextField = "Name";
                ddlReference.DataValueField = "Id";
                ddlReference.DataBind();
                ddlReference.Items.Insert(0, new ListItem("Select Reference", ""));
            }
        }

        #region CRUD Methods

        protected void btnAddUser_Click(object sender, EventArgs e)
        {
            if (!ValidateForm()) return;

            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand(@"
                        INSERT INTO Users (Username, Password, Role, Reference_id) 
                        VALUES (@user, @pass, @role, @ref)", con);

                    string passwordValue = ddlRole.SelectedValue == "Customer" ? "" : txtPassword.Text.Trim();
                    cmd.Parameters.AddWithValue("@user", txtUsername.Text.Trim());
                    cmd.Parameters.AddWithValue("@pass", passwordValue);
                    cmd.Parameters.AddWithValue("@role", ddlRole.SelectedValue);
                    cmd.Parameters.AddWithValue("@ref", ddlReference.SelectedValue);

                    cmd.ExecuteNonQuery();
                }

                ClearForm();
                LoadUsers();
                ShowMessage("User added successfully!", true);
            }
            catch (Exception ex)
            {
                ShowMessage("Error: " + ex.Message, false);
            }
        }

        protected void btnUpdateUser_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(hdnUserId.Value))
            {
                ShowMessage("Select a user to update.", false);
                return;
            }
            if (!ValidateForm()) return;

            int userId = int.Parse(hdnUserId.Value);
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand(@"
                        UPDATE Users 
                        SET Username=@user, Password=@pass, Role=@role, Reference_id=@ref 
                        WHERE User_id=@id", con);

                    string passwordValue = ddlRole.SelectedValue == "Customer" ? "" : txtPassword.Text.Trim();
                    cmd.Parameters.AddWithValue("@user", txtUsername.Text.Trim());
                    cmd.Parameters.AddWithValue("@pass", passwordValue);
                    cmd.Parameters.AddWithValue("@role", ddlRole.SelectedValue);
                    cmd.Parameters.AddWithValue("@ref", ddlReference.SelectedValue);
                    cmd.Parameters.AddWithValue("@id", userId);

                    cmd.ExecuteNonQuery();
                }

                ClearForm();
                LoadUsers();
                ShowMessage("User updated successfully!", true);
            }
            catch (Exception ex)
            {
                ShowMessage("Error: " + ex.Message, false);
            }
        }

        protected void gvUsers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int userId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditUser")
            {
                LoadUserForEdit(userId);
            }
            else if (e.CommandName == "DeleteUser")
            {
                try
                {
                    using (SqlConnection con = new SqlConnection(connStr))
                    {
                        con.Open();
                        SqlCommand cmd = new SqlCommand("DELETE FROM Users WHERE User_id=@id", con);
                        cmd.Parameters.AddWithValue("@id", userId);
                        cmd.ExecuteNonQuery();
                    }
                    LoadUsers();
                    ShowMessage("User deleted successfully!", true);
                }
                catch (Exception ex)
                {
                    ShowMessage("Error: " + ex.Message, false);
                }
            }
        }

        private void LoadUserForEdit(int userId)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("SELECT * FROM Users WHERE User_id=@id", con);
                cmd.Parameters.AddWithValue("@id", userId);
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    hdnUserId.Value = reader["User_id"].ToString();
                    txtUsername.Text = reader["Username"].ToString();
                    txtPassword.Text = reader["Role"].ToString() == "Customer" ? "" : reader["Password"].ToString();

                    // Set Role
                    ddlRole.SelectedValue = reader["Role"].ToString();

                    // Populate Reference dropdown based on Role
                    ddlRole_SelectedIndexChanged(null, null);

                    // Safely set Reference
                    string referenceId = reader["Reference_id"].ToString();
                    if (ddlReference.Items.FindByValue(referenceId) != null)
                    {
                        ddlReference.SelectedValue = referenceId;
                    }
                    else
                    {
                        ddlReference.SelectedIndex = 0; // fallback to "Select Reference"
                    }

                    ShowMessage("User loaded for editing.", true);
                }
                reader.Close();
            }
        }


        private void LoadUsers()
        {
            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string sql = @"
                    SELECT u.User_id, u.Username, u.Role, 
                        CASE u.Role
                            WHEN 'Admin' THEN a.Fname + ' ' + a.Lname
                            WHEN 'Staff' THEN s.Fname + ' ' + s.Lname
                            WHEN 'Vet' THEN v.Fname + ' ' + v.Lname
                            WHEN 'Customer' THEN c.Fname + ' ' + c.Lname
                            ELSE '' END AS ReferenceName
                    FROM Users u
                    LEFT JOIN Admin a ON u.Reference_id=a.Admin_id AND u.Role='Admin'
                    LEFT JOIN Staff s ON u.Reference_id=s.Staff_id AND u.Role='Staff'
                    LEFT JOIN Vet v ON u.Reference_id=v.Vet_id AND u.Role='Vet'
                    LEFT JOIN Customer c ON u.Reference_id=c.Customer_id AND u.Role='Customer'";
                SqlDataAdapter da = new SqlDataAdapter(sql, con);
                da.Fill(dt);
            }
            gvUsers.DataSource = dt;
            gvUsers.DataBind();
        }

        private bool ValidateForm()
        {
            if (string.IsNullOrEmpty(txtUsername.Text.Trim()))
            {
                ShowMessage("Username is required.", false);
                return false;
            }

            if (ddlRole.SelectedValue != "Customer" && string.IsNullOrEmpty(txtPassword.Text.Trim()))
            {
                ShowMessage("Password is required for non-Customer users.", false);
                return false;
            }

            if (string.IsNullOrEmpty(ddlRole.SelectedValue))
            {
                ShowMessage("Select a role.", false);
                return false;
            }

            if (string.IsNullOrEmpty(ddlReference.SelectedValue))
            {
                ShowMessage("Select a reference user.", false);
                return false;
            }

            return true;
        }

        private void ClearForm()
        {
            txtUsername.Text = txtPassword.Text = "";
            ddlRole.SelectedIndex = 0;
            ddlReference.Items.Clear();
            ddlReference.Items.Add(new ListItem("Select Reference", ""));
            hdnUserId.Value = "";
            lblMessage.Text = "";
        }

        private void ShowMessage(string msg, bool isSuccess)
        {
            lblMessage.Text = msg;
            lblMessage.CssClass = isSuccess ? "success-message" : "";
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        #endregion
    }
}
