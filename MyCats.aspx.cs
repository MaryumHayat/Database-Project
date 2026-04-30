using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace CatResort
{
    public partial class MyCats : System.Web.UI.Page
    {
        string connStr = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\catdb.mdf;Integrated Security=True;";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["CustomerId"] == null)
                Response.Redirect("CustomerLogin.aspx");

            if (!IsPostBack)
            {
                BindCats();
            }
        }

        private void BindCats()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("SELECT * FROM Cat WHERE Customer_id=@cid", con);
                cmd.Parameters.AddWithValue("@cid", Session["CustomerId"]);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvCats.DataSource = dt;
                gvCats.DataBind();
            }
        }

        protected void btnClearCat_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        private void ClearForm()
        {
            txtCatName.Text = "";
            txtCatBreed.Text = "";
            txtCatAge.Text = "";
            txtCatBehavior.Text = "";
            txtCatVaccine.Text = "";
            hfCatId.Value = "";
            lblFormTitle.Text = "Add Cat";
        }

        protected void btnSaveCat_Click(object sender, EventArgs e)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                SqlCommand cmd;

                if (string.IsNullOrEmpty(hfCatId.Value)) // Add
                {
                    cmd = new SqlCommand("INSERT INTO Cat(Customer_id, Name, Breed, Age, Behavior, Vaccinated) VALUES(@cid, @name, @breed, @age, @behavior, @vaccinated)", con);
                }
                else // Update
                {
                    cmd = new SqlCommand("UPDATE Cat SET Name=@name, Breed=@breed, Age=@age, Behavior=@behavior, Vaccinated=@vaccinated WHERE Cat_id=@id", con);
                    cmd.Parameters.AddWithValue("@id", hfCatId.Value);
                }

                cmd.Parameters.AddWithValue("@cid", Session["CustomerId"]);
                cmd.Parameters.AddWithValue("@name", txtCatName.Text.Trim());
                cmd.Parameters.AddWithValue("@breed", txtCatBreed.Text.Trim());
                cmd.Parameters.AddWithValue("@age", string.IsNullOrEmpty(txtCatAge.Text) ? 0 : int.Parse(txtCatAge.Text));
                cmd.Parameters.AddWithValue("@behavior", txtCatBehavior.Text.Trim());
                cmd.Parameters.AddWithValue("@vaccinated", txtCatVaccine.Text.Trim());
                cmd.ExecuteNonQuery();
            }

            ClearForm();
            BindCats();
        }

        protected void gvCats_RowEditing(object sender, GridViewEditEventArgs e)
        {
            int catId = Convert.ToInt32(gvCats.DataKeys[e.NewEditIndex].Value);
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("SELECT * FROM Cat WHERE Cat_id=@id", con);
                cmd.Parameters.AddWithValue("@id", catId);
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    hfCatId.Value = dr["Cat_id"].ToString();
                    txtCatName.Text = dr["Name"].ToString();
                    txtCatBreed.Text = dr["Breed"].ToString();
                    txtCatAge.Text = dr["Age"].ToString();
                    txtCatBehavior.Text = dr["Behavior"].ToString();
                    txtCatVaccine.Text = dr["Vaccinated"].ToString();
                    lblFormTitle.Text = "Edit Cat";
                }
            }
        }

        protected void gvCats_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int catId = Convert.ToInt32(gvCats.DataKeys[e.RowIndex].Value);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("DELETE FROM Cat WHERE Cat_id=@id", con);
                cmd.Parameters.AddWithValue("@id", catId);
                cmd.ExecuteNonQuery();
            }

            BindCats();
            ClearForm();
        }
    }
}
