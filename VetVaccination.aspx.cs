using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CatResort
{
    public partial class VetVaccination : Page
    {
        string connStr = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\catdb.mdf;Integrated Security=True;";
        int VetID => Session["VetID"] != null ? Convert.ToInt32(Session["VetID"]) : 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (VetID == 0 || Session["Role"] == null || Session["Role"].ToString() != "Vet")
                Response.Redirect("Login.aspx");

            if (!IsPostBack)
            {
                LoadCats();
                LoadVaccines();
                btnUpdate.Enabled = false;
                btnDelete.Enabled = false;
            }
        }

        private void LoadCats()
        {
            ddlCat.Items.Clear();
            ddlCat.Items.Add(new ListItem("--Select Cat--", ""));

            using (SqlConnection con = new SqlConnection(connStr))
            {
                // SIMPLE: Get ALL cats from the Cat table
                string sql = @"
                    SELECT Cat_id, Name 
                    FROM Cat 
                    ORDER BY Name";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    con.Open();
                    SqlDataReader dr = cmd.ExecuteReader();
                    while (dr.Read())
                    {
                        string catId = dr["Cat_id"].ToString();
                        string catName = dr["Name"].ToString();

                        if (!string.IsNullOrEmpty(catId) && catId != "0")
                        {
                            ddlCat.Items.Add(new ListItem(catName, catId));
                        }
                    }
                }
            }
        }

        private void LoadVaccines()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string sql = @"
                    SELECT v.Vaccine_id, c.Name AS CatName, v.Name, v.Due_date, v.Vaccination_date, v.Vaccine_Status
                    FROM Vaccine v
                    INNER JOIN Cat c ON v.Cat_id = c.Cat_id
                    WHERE v.Vet_id = @VetID
                    ORDER BY v.Due_date";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.AddWithValue("@VetID", VetID);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gvVaccines.DataSource = dt;
                    gvVaccines.DataBind();
                }
            }
        }

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(ddlCat.SelectedValue) || string.IsNullOrWhiteSpace(txtVaccineName.Text))
            {
                // Show error message
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Please select a cat and enter vaccine name.');", true);
                return;
            }

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string sql = @"INSERT INTO Vaccine (Cat_id, Vet_id, Name, Due_date, Vaccination_date, Vaccine_Status)
                               VALUES (@CatID, @VetID, @Name, @Due, @VaccDate, @Status)";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.AddWithValue("@CatID", ddlCat.SelectedValue);
                    cmd.Parameters.AddWithValue("@VetID", VetID);
                    cmd.Parameters.AddWithValue("@Name", txtVaccineName.Text.Trim());
                    cmd.Parameters.AddWithValue("@Due", string.IsNullOrEmpty(txtDueDate.Text) ? DBNull.Value : (object)txtDueDate.Text);
                    cmd.Parameters.AddWithValue("@VaccDate", string.IsNullOrEmpty(txtVaccinationDate.Text) ? DBNull.Value : (object)txtVaccinationDate.Text);
                    cmd.Parameters.AddWithValue("@Status", ddlStatus.SelectedValue);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            ClearForm();
            LoadVaccines();
            ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Vaccination record added successfully.');", true);
        }

        protected void gvVaccines_SelectedIndexChanged(object sender, EventArgs e)
        {
            int id = Convert.ToInt32(gvVaccines.SelectedDataKey.Value);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string sql = "SELECT * FROM Vaccine WHERE Vaccine_id=@ID";
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.AddWithValue("@ID", id);
                    con.Open();
                    SqlDataReader dr = cmd.ExecuteReader();
                    if (dr.Read())
                    {
                        ddlCat.SelectedValue = dr["Cat_id"].ToString();
                        txtVaccineName.Text = dr["Name"].ToString();
                        txtDueDate.Text = dr["Due_date"] == DBNull.Value ? "" : Convert.ToDateTime(dr["Due_date"]).ToString("yyyy-MM-dd");
                        txtVaccinationDate.Text = dr["Vaccination_date"] == DBNull.Value ? "" : Convert.ToDateTime(dr["Vaccination_date"]).ToString("yyyy-MM-dd");
                        ddlStatus.SelectedValue = dr["Vaccine_Status"].ToString();

                        ViewState["VaccineID"] = id;
                        btnAdd.Enabled = false;
                        btnUpdate.Enabled = true;
                        btnDelete.Enabled = true;
                    }
                }
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            if (ViewState["VaccineID"] == null)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Please select a vaccination record to update.');", true);
                return;
            }

            int id = (int)ViewState["VaccineID"];
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string sql = @"UPDATE Vaccine SET Cat_id=@CatID, Name=@Name, Due_date=@Due, Vaccination_date=@VaccDate, Vaccine_Status=@Status 
                               WHERE Vaccine_id=@ID";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.AddWithValue("@CatID", ddlCat.SelectedValue);
                    cmd.Parameters.AddWithValue("@Name", txtVaccineName.Text.Trim());
                    cmd.Parameters.AddWithValue("@Due", string.IsNullOrEmpty(txtDueDate.Text) ? DBNull.Value : (object)txtDueDate.Text);
                    cmd.Parameters.AddWithValue("@VaccDate", string.IsNullOrEmpty(txtVaccinationDate.Text) ? DBNull.Value : (object)txtVaccinationDate.Text);
                    cmd.Parameters.AddWithValue("@Status", ddlStatus.SelectedValue);
                    cmd.Parameters.AddWithValue("@ID", id);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            ClearForm();
            LoadVaccines();
            ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Vaccination record updated successfully.');", true);
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            if (ViewState["VaccineID"] == null)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Please select a vaccination record to delete.');", true);
                return;
            }

            int id = (int)ViewState["VaccineID"];
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string sql = "DELETE FROM Vaccine WHERE Vaccine_id=@ID";
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.AddWithValue("@ID", id);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            ClearForm();
            LoadVaccines();
            ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Vaccination record deleted successfully.');", true);
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        private void ClearForm()
        {
            ddlCat.SelectedIndex = 0;
            txtVaccineName.Text = "";
            txtDueDate.Text = "";
            txtVaccinationDate.Text = "";
            ddlStatus.SelectedIndex = 0;

            btnAdd.Enabled = true;
            btnUpdate.Enabled = false;
            btnDelete.Enabled = false;
            ViewState["VaccineID"] = null;
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("VetDashboard.aspx");
        }
    }
}