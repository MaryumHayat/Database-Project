<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="CatResort.AdminDashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Recursive:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <style>
        /* Same CSS as original AdminDashboard */
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Recursive', sans-serif; background:linear-gradient(135deg,#fdf2ff 0%,#f2fdff 100%); color:#5a4a6a; line-height:1.4; }
        .navbar { position: fixed; top:0; width:100%; background:rgba(255,255,255,0.95); backdrop-filter:blur(10px); box-shadow:0 2px 15px rgba(149,117,205,0.1); display:flex; justify-content:space-between; align-items:center; padding:12px 30px; z-index:1000; height:65px; }
        .navbar h1 { font-size:24px; font-weight:700; background:linear-gradient(135deg,#ff9ec0 0%,#9575cd 100%); -webkit-background-clip:text; -webkit-text-fill-color:transparent; }
        .logout-btn { background:linear-gradient(135deg,#ff9ec0 0%,#9575cd 100%); color:white; font-weight:600; padding:8px 18px; text-decoration:none; border:none; cursor:pointer; font-size:14px; transition:0.3s; box-shadow:0 3px 10px rgba(149,117,205,0.3); }
        .logout-btn:hover { transform:translateY(-1px); box-shadow:0 4px 12px rgba(149,117,205,0.4); }
        .main-content { margin-top:80px; padding:20px 30px; }
        .page-title { text-align:center; margin-bottom:25px; font-size:28px; font-weight:700; color:#5a4a6a; }
        .dashboard-container { display:flex; gap:20px; flex-wrap:wrap; justify-content:center; }
        .dashboard-card { flex:1; min-width:220px; max-width:280px; padding:20px; background:white; box-shadow:0 3px 15px rgba(149,117,205,0.15); text-align:center; border-radius:8px; transition:0.3s; }
        .dashboard-card:hover { transform:translateY(-3px); box-shadow:0 6px 20px rgba(149,117,205,0.25); }
        .dashboard-card h3 { margin-bottom:10px; color:#5a4a6a; }
        .dashboard-card p { font-size:13px; color:#7e6a9f; margin-bottom:15px; }
        .btn-primary { padding:10px 20px; border:none; background:linear-gradient(135deg,#ff9ec0 0%,#9575cd 100%); color:white; font-weight:600; cursor:pointer; text-decoration:none; display:inline-block; border-radius:4px; }
        footer { text-align:center; padding:20px 0; background:white; color:#7e6a9f; font-weight:600; box-shadow:0 -2px 8px rgba(149,117,205,0.1); margin-top:15px; font-size:14px; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="navbar">
            <h1>Cat Resort Admin Portal</h1>
            <div>
                <asp:LinkButton runat="server" ID="btnBack" CssClass="btn-primary" OnClick="btnBack_Click" Style="margin-right:10px;">Back</asp:LinkButton>
                <asp:LinkButton runat="server" ID="btnLogout" CssClass="logout-btn" OnClick="btnLogout_Click">Logout</asp:LinkButton>
            </div>
        </div>

        <div class="main-content">
            <h2 class="page-title">Admin Dashboard</h2>

            <div class="dashboard-container">
                <!-- Staff Management -->
                <div class="dashboard-card">
                    <h3>Staff Management</h3>
                    <p>Manage staff members, schedules, contacts, and performance.</p>
                    <asp:HyperLink runat="server" NavigateUrl="~/StaffManagement.aspx" CssClass="btn-primary">Go</asp:HyperLink>
                </div>

                <!-- User Management -->
                <div class="dashboard-card">
                    <h3>User Management</h3>
                    <p>Add, edit, delete users and manage roles & permissions.</p>
                    <asp:HyperLink runat="server" NavigateUrl="~/UserManagement.aspx" CssClass="btn-primary">Go</asp:HyperLink>
                </div>

                <!-- Customer Management -->
                <div class="dashboard-card">
                    <h3>Customer Management</h3>
                    <p>View customer accounts, pets, and manage details.</p>
                    <asp:HyperLink runat="server" NavigateUrl="~/CustomerManagement.aspx" CssClass="btn-primary">Go</asp:HyperLink>
                </div>

                <!-- Financial Management -->
                <div class="dashboard-card">
                    <h3>Financial Management</h3>
                    <p>Manage payments, invoices, reports, and refunds.</p>
                    <asp:HyperLink runat="server" NavigateUrl="~/FinancialManagement.aspx" CssClass="btn-primary">Go</asp:HyperLink>
                </div>

                <!-- System Settings -->
                <div class="dashboard-card">
                    <h3>Vet Management</h3>
                    <p>Manage staff members, contacts.</p>
                    <asp:HyperLink runat="server" NavigateUrl="~/VetManagement.aspx" CssClass="btn-primary">Go</asp:HyperLink>
                </div>

                
            </div>
        </div>

        <footer>© 2025 Cat Resort. All rights reserved.</footer>
    </form>
</body>
</html>
