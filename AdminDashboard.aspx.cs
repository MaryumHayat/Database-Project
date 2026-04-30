using System;
using System.Web.UI;

namespace CatResort
{
    public partial class AdminDashboard : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() != "Admin")
                Response.Redirect("Login.aspx");
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("Dashboard.aspx");
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            // For now, if dashboard is first page, we can redirect home or just reload
            Response.Redirect("AdminDashboard.aspx");
        }
    }
}
