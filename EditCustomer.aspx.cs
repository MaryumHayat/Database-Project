using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace CatResort
{
    public partial class EditCustomer : System.Web.UI.Page
    {
        string connStr = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\catdb.mdf;Integrated Security=True;";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["CustomerId"] == null)
                {
                    Response.Redirect("CustomerManagement.aspx");
                    return;
                }

                int id = Convert.ToInt32(Request.QueryString["CustomerId"]);
                hdnCustomerId.Value = id.ToString();

                LoadCustomer(id);
                LoadEmails(id);
                LoadPhones(id);
                LoadCats(id);
            }
        }

        private void LoadCustomer(int id)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("SELECT * FROM Customer WHERE Customer_id=@id", con);
                cmd.Parameters.AddWithValue("@id", id);

                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    txtFname.Text = dr["Fname"].ToString();
                    txtLname.Text = dr["Lname"].ToString();
                    txtAddress.Text = dr["Address"].ToString();
                }
            }
        }

        private void LoadEmails(int id)
        {
            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                SqlDataAdapter da = new SqlDataAdapter(
                    "SELECT Email_id, Email FROM Customer_Email WHERE Customer_id=@id", con);
                da.SelectCommand.Parameters.AddWithValue("@id", id);
                da.Fill(dt);
            }

            rptEmails.DataSource = dt;
            rptEmails.DataBind();
        }

        private void LoadPhones(int id)
        {
            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                SqlDataAdapter da = new SqlDataAdapter(
                    "SELECT Phone_id, Phone_Number FROM Customer_Phone WHERE Customer_id=@id", con);
                da.SelectCommand.Parameters.AddWithValue("@id", id);
                da.Fill(dt);
            }

            rptPhones.DataSource = dt;
            rptPhones.DataBind();
        }

        private void LoadCats(int customerId)
        {
            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                SqlDataAdapter da = new SqlDataAdapter(
                    @"SELECT Cat_id, Name, Breed, Age, Behavior, Vaccinated 
                      FROM Cat WHERE Customer_id=@cid", con);
                da.SelectCommand.Parameters.AddWithValue("@cid", customerId);
                da.Fill(dt);
            }

            rptCats.DataSource = dt;
            rptCats.DataBind();
        }


        protected void rptCats_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int catId = Convert.ToInt32(e.CommandArgument);
            int customerId = Convert.ToInt32(hdnCustomerId.Value);

            if (e.CommandName == "UpdateCat")
            {
                UpdateCat(e, catId);
            }
            else if (e.CommandName == "DeleteCat")
            {
                DeleteCat(catId);
            }

            LoadCats(customerId);
        }

        private void UpdateCat(RepeaterCommandEventArgs e, int catId)
        {
            string name = ((TextBox)e.Item.FindControl("txtCatName")).Text;
            string breed = ((TextBox)e.Item.FindControl("txtCatBreed")).Text;
            string age = ((TextBox)e.Item.FindControl("txtCatAge")).Text;
            string behavior = ((TextBox)e.Item.FindControl("txtCatBehavior")).Text;
            string vaccinated = ((TextBox)e.Item.FindControl("txtCatVaccinated")).Text;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(
                    @"UPDATE Cat SET Name=@n, Breed=@b, Age=@a, Behavior=@beh, Vaccinated=@v 
                      WHERE Cat_id=@cid", con);

                cmd.Parameters.AddWithValue("@n", name);
                cmd.Parameters.AddWithValue("@b", breed);
                cmd.Parameters.AddWithValue("@a", age);
                cmd.Parameters.AddWithValue("@beh", behavior);
                cmd.Parameters.AddWithValue("@v", vaccinated);
                cmd.Parameters.AddWithValue("@cid", catId);

                cmd.ExecuteNonQuery();
            }
        }

        private void DeleteCat(int catId)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("DELETE FROM Cat WHERE Cat_id=@cid", con);
                cmd.Parameters.AddWithValue("@cid", catId);
                cmd.ExecuteNonQuery();
            }
        }

        protected void btnAddCat_Click(object sender, EventArgs e)
        {
            int customerId = Convert.ToInt32(hdnCustomerId.Value);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(
                    @"INSERT INTO Cat (Customer_id, Name, Breed, Age, Behavior, Vaccinated)
                      VALUES (@cid, '', '', NULL, '', '')", con);

                cmd.Parameters.AddWithValue("@cid", customerId);
                cmd.ExecuteNonQuery();
            }

            LoadCats(customerId);
        }


        protected void btnSaveCustomer_Click(object sender, EventArgs e)
        {
            int id = Convert.ToInt32(hdnCustomerId.Value);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                SqlCommand cmd = new SqlCommand(
                    @"UPDATE Customer 
                      SET Fname=@fn, Lname=@ln, Address=@addr 
                      WHERE Customer_id=@id", con);

                cmd.Parameters.AddWithValue("@fn", txtFname.Text);
                cmd.Parameters.AddWithValue("@ln", txtLname.Text);
                cmd.Parameters.AddWithValue("@addr", txtAddress.Text);
                cmd.Parameters.AddWithValue("@id", id);
                cmd.ExecuteNonQuery();


                foreach (RepeaterItem item in rptEmails.Items)
                {
                    string email = ((TextBox)item.Controls[0]).Text;
                    string emailId = ((HiddenField)item.Controls[1]).Value;

                    SqlCommand cmdEmail = new SqlCommand(
                        "UPDATE Customer_Email SET Email=@e WHERE Email_id=@eid", con);

                    cmdEmail.Parameters.AddWithValue("@e", email);
                    cmdEmail.Parameters.AddWithValue("@eid", emailId);
                    cmdEmail.ExecuteNonQuery();
                }


                foreach (RepeaterItem item in rptPhones.Items)
                {
                    string phone = ((TextBox)item.Controls[0]).Text;
                    string phoneId = ((HiddenField)item.Controls[1]).Value;

                    SqlCommand cmdPhone = new SqlCommand(
                        "UPDATE Customer_Phone SET Phone_Number=@p WHERE Phone_id=@pid", con);

                    cmdPhone.Parameters.AddWithValue("@p", phone);
                    cmdPhone.Parameters.AddWithValue("@pid", phoneId);
                    cmdPhone.ExecuteNonQuery();
                }
            }

            lblMessage.Text = "Customer updated successfully!";
            lblMessage.CssClass = "msg success";
        }


        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("CustomerManagement.aspx");
        }
    }
}
