using System;
using System.Data;
using System.Data.SqlClient;

namespace CatResort
{
    public partial class CustomerManagement : System.Web.UI.Page
    {
        string connStr = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\catdb.mdf;Integrated Security=True;";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCustomers();
            }
        }

        private void LoadCustomers()
        {
            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                string query = @"
                    SELECT 
                        c.Customer_id,
                        c.Fname + ' ' + c.Lname AS FullName,
                        ISNULL(STRING_AGG(ce.Email, ', '), '') AS Email,
                        ISNULL(STRING_AGG(cp.Phone_Number, ', '), '') AS Phone,
                        c.No_of_Cats
                    FROM Customer c
                    LEFT JOIN Customer_Email ce ON c.Customer_id = ce.Customer_id
                    LEFT JOIN Customer_Phone cp ON c.Customer_id = cp.Customer_id
                    GROUP BY c.Customer_id, c.Fname, c.Lname, c.No_of_Cats
                    ORDER BY c.Customer_id
                ";
                SqlDataAdapter da = new SqlDataAdapter(query, con);
                da.Fill(dt);
            }

            gvCustomers.DataSource = dt;
            gvCustomers.DataBind();
        }

        protected void gvCustomers_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            int customerId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditCustomer")
            {
                // Redirect to EditCustomer.aspx with correct query string
                Response.Redirect($"EditCustomer.aspx?CustomerId={customerId}");
            }
            else if (e.CommandName == "DeleteCustomer")
            {
                DeleteCustomer(customerId);
            }
        }

        private void DeleteCustomer(int id)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                new SqlCommand("DELETE FROM Customer_Email WHERE Customer_id=@id", con).ExecuteNonQuery();
                new SqlCommand("DELETE FROM Customer_Phone WHERE Customer_id=@id", con).ExecuteNonQuery();
                new SqlCommand("DELETE FROM Customer WHERE Customer_id=@id", con).ExecuteNonQuery();
            }

            lblMessage.Text = "Customer deleted successfully!";
            lblMessage.CssClass = "success-message";
            LoadCustomers();
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("AdminDashboard.aspx");
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Response.Redirect("Login.aspx");
        }
    }
}
