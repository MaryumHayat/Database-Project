using System;
using System.Data;
using System.Data.SqlClient;

namespace CatResort
{
    public partial class Report : System.Web.UI.Page
    {
        string connStr = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\catdb.mdf;Integrated Security=True;";
        decimal monthlyGoal = 100000; // Example goal

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                GenerateReport();
            }
        }

        private void GenerateReport()
        {
            DataTable dtReport = new DataTable();
            decimal totalAmount = 0;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                // Get all payments for current month
                SqlDataAdapter da = new SqlDataAdapter(
                    "SELECT * FROM Payment WHERE MONTH(Date)=MONTH(GETDATE()) AND YEAR(Date)=YEAR(GETDATE()) ORDER BY Date DESC", con);
                da.Fill(dtReport);

                // Total amount
                SqlCommand cmdTotal = new SqlCommand(
                    "SELECT SUM(Amount) FROM Payment WHERE MONTH(Date)=MONTH(GETDATE()) AND YEAR(Date)=YEAR(GETDATE())", con);
                object result = cmdTotal.ExecuteScalar();
                totalAmount = result != DBNull.Value ? Convert.ToDecimal(result) : 0;

                // Insert into Report table (Type only)
                SqlCommand insertCmd = new SqlCommand(
                    "INSERT INTO Report (Type) VALUES (@Type)", con);
                insertCmd.Parameters.AddWithValue("@Type", "Monthly Financial Report");
                insertCmd.ExecuteNonQuery();
            }

            // Bind payments table
            gvReport.DataSource = dtReport;
            gvReport.DataBind();

            // Show summary
            lblTotalAmount.Text = $"Total Amount Collected: {totalAmount:C}";
            lblMonthlyGoal.Text = $"Monthly Goal: {monthlyGoal:C}";

            if (totalAmount >= monthlyGoal)
            {
                lblProfit.Text = $"Profit: {totalAmount - monthlyGoal:C}";
                lblLoss.Text = "Loss: No loss";
            }
            else
            {
                lblProfit.Text = "Profit: No profit";
                lblLoss.Text = $"Loss: {monthlyGoal - totalAmount:C}";
            }

            lblDateGenerated.Text = $"Date Generated: {DateTime.Now:yyyy-MM-dd HH:mm}";
        }
    }
}
