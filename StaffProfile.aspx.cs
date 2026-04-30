using System;
using System.Data.SqlClient;

namespace CatResort
{
    public partial class StaffProfile : System.Web.UI.Page
    {
        string connStr = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\catdb.mdf;Integrated Security=True;";
        int StaffID => Session["StaffID"] != null ? Convert.ToInt32(Session["StaffID"]) : 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() != "Staff" || StaffID == 0)
                Response.Redirect("Login.aspx");

            if (!IsPostBack)
                LoadProfile();
        }

        void LoadProfile()
        {
            string sql = @"
                SELECT 
                    s.Fname,
                    s.Lname,
                    s.Address,
                    s.Role,
                    s.Salary,
                    ISNULL((SELECT TOP 1 Email FROM Staff_Email WHERE Staff_id = s.Staff_id), 'N/A') AS StaffEmail,
                    ISNULL((SELECT TOP 1 Phone_Number FROM Staff_Phone WHERE Staff_id = s.Staff_id), 'N/A') AS StaffPhone
                FROM Staff s
                WHERE s.Staff_id = @id;
            ";

            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                cmd.Parameters.AddWithValue("@id", StaffID);
                con.Open();

                SqlDataReader r = cmd.ExecuteReader();
                if (r.Read())
                {
                    lblName.Text = $"{r["Fname"]} {r["Lname"]}";
                    lblEmail.Text = r["StaffEmail"].ToString();
                    lblPhone.Text = r["StaffPhone"].ToString();
                    lblAddress.Text = r["Address"]?.ToString() ?? "N/A";
                    lblRole.Text = r["Role"]?.ToString() ?? "N/A";
                    lblSalary.Text = r["Salary"]?.ToString() ?? "N/A";
                }
            }
        }
    }
}
