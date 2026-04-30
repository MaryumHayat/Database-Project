<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StaffManagement.aspx.cs" Inherits="CatResort.StaffManagement" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Staff Management - Cat Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Recursive:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        /* === COPY CSS FROM AdminDashboard === */
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family: 'Recursive', sans-serif; background: linear-gradient(135deg, #fdf2ff 0%, #f2fdff 100%); color: #5a4a6a; line-height: 1.4; }
        .navbar { position: fixed; top:0; width:100%; background: rgba(255,255,255,0.95); backdrop-filter: blur(10px); box-shadow:0 2px 15px rgba(149,117,205,0.1); display:flex; justify-content:space-between; align-items:center; padding:12px 30px; z-index:1000; height:65px; }
        .navbar h1 { font-family: 'Recursive', sans-serif; font-size:24px; font-weight:700; background: linear-gradient(135deg, #ff9ec0 0%, #9575cd 100%); -webkit-background-clip:text; -webkit-text-fill-color:transparent; }
        .navbar-buttons { display:flex; gap:10px; }
        .logout-btn, .back-btn { background: linear-gradient(135deg, #ff9ec0 0%, #9575cd 100%); color:white; font-weight:600; text-decoration:none; padding:8px 18px; transition:0.3s; box-shadow:0 3px 10px rgba(149,117,205,0.3); border:none; cursor:pointer; font-family:'Recursive', sans-serif; font-size:14px; }
        .logout-btn:hover, .back-btn:hover { transform: translateY(-1px); box-shadow:0 4px 12px rgba(149,117,205,0.4); }
        .main-content { margin-top:80px; padding:20px 30px; }
        .page-title { text-align:center; margin-bottom:25px; font-family:'Recursive', sans-serif; font-size:28px; font-weight:700; color:#5a4a6a; }
        .container { display:flex; gap:25px; margin-bottom:25px; }
        .crud-form { flex:1; padding:20px; background:white; box-shadow:0 3px 15px rgba(149,117,205,0.15); }
        .image-box { flex:1; display:flex; align-items:center; justify-content:center; overflow:hidden; }
        .image-box img { width:100%; height:100%; object-fit:cover; border-radius:6px; }
        .form-group { margin-bottom:12px; }
        .form-group label { display:block; margin-bottom:5px; font-weight:600; color:#7e6a9f; font-size:14px; }
        .crud-form input[type="text"], .crud-form input[type="number"] { width:100%; padding:8px 12px; border:2px solid #e1d7f2; font-size:14px; font-family:'Recursive', sans-serif; transition: all 0.3s; background-color:#faf7ff; }
        .crud-form input:focus { border-color:#b39ddb; outline:none; box-shadow:0 0 0 2px rgba(179,157,219,0.2); background-color:white; }
        .button-group { display:flex; gap:10px; margin-top:15px; }
        .btn-primary { padding:10px 20px; border:none; background: linear-gradient(135deg, #ff9ec0 0%, #9575cd 100%); color:white; font-family:'Recursive', sans-serif; font-weight:600; font-size:14px; cursor:pointer; transition:0.3s; box-shadow:0 3px 10px rgba(149,117,205,0.3); flex:1; }
        .btn-secondary { padding:10px 20px; border:none; background: linear-gradient(135deg, #9575cd 0%, #7986cb 100%); color:white; font-family:'Recursive', sans-serif; font-weight:600; font-size:14px; cursor:pointer; transition:0.3s; box-shadow:0 3px 10px rgba(149,117,205,0.3); flex:1; }
        .btn-danger { padding:10px 20px; border:none; background: linear-gradient(135deg, #ff6b6b 0%, #ff5252 100%); color:white; font-family:'Recursive', sans-serif; font-weight:600; font-size:14px; cursor:pointer; transition:0.3s; box-shadow:0 3px 10px rgba(255,107,107,0.3); flex:1; }
        .btn-query { padding:10px 20px; border:none; background: linear-gradient(135deg, #4CAF50 0%, #45a049 100%); color:white; font-family:'Recursive', sans-serif; font-weight:600; font-size:14px; cursor:pointer; transition:0.3s; box-shadow:0 3px 10px rgba(76,175,80,0.3); }
        .btn-primary:hover, .btn-secondary:hover, .btn-danger:hover, .btn-query:hover { transform:translateY(-1px); box-shadow:0 4px 12px rgba(149,117,205,0.4); }
        .query-section { background:white; padding:20px; margin-bottom:25px; box-shadow:0 3px 15px rgba(149,117,205,0.15); }
        .query-section h3 { color:#5a4a6a; margin-bottom:15px; font-family:'Recursive', sans-serif; }
        .query-input { width:100%; padding:12px; border:2px solid #e1d7f2; border-radius:4px; font-family:'Recursive', sans-serif; font-size:14px; margin-bottom:10px; background-color:#faf7ff; resize:vertical; min-height:80px; }
        .query-input:focus { border-color:#b39ddb; outline:none; box-shadow:0 0 0 2px rgba(179,157,219,0.2); background-color:white; }
        .query-examples { background:#f8f4ff; padding:15px; border-radius:4px; margin-top:15px; font-size:13px; }
        .query-examples h4 { color:#7e6a9f; margin-bottom:8px; }
        .query-examples code { background:#e1d7f2; padding:2px 6px; border-radius:3px; font-family:monospace; display:block; margin:5px 0; }
        .table-container { background:white; box-shadow:0 3px 15px rgba(149,117,205,0.15); overflow:hidden; margin-bottom:25px; }
        table { width:100%; border-collapse:collapse; font-size:13px; }
        th, td { padding:8px 12px; text-align:left; border-bottom:1px solid #f0eaf9; }
        th { background: linear-gradient(135deg, #f8f4ff 0%, #f0eaf9 100%); font-weight:700; color:#7e6a9f; font-family:'Recursive', sans-serif; font-size:13px; }
        tr { height:35px; }
        tr:hover { background-color:#faf7ff; }
        .action-buttons { display:flex; gap:5px; }
        .btn-edit, .btn-delete { padding:4px 8px; border:none; font-size:11px; cursor:pointer; font-family:'Recursive', sans-serif; font-weight:500; }
        .btn-edit { background:#9575cd; color:white; }
        .btn-delete { background:#ff6b6b; color:white; }
        footer { text-align:center; padding:20px 0; background:white; color:#7e6a9f; font-weight:600; box-shadow:0 -2px 8px rgba(149,117,205,0.1); margin-top:15px; font-size:14px; }
        #lblMessage { display:block; padding:8px 12px; margin-bottom:15px; background-color:#ffebee; color:#d32f2f; font-weight:600; font-size:13px; }
        .success-message { background-color:#e8f5e9 !important; color:#2e7d32 !important; }
        @media (max-width:900px) { .container { flex-direction:column; } .crud-form, .image-box { width:100%; } .image-box img { height:200px; } .navbar h1 { font-size:20px; } .button-group { flex-direction:column; } }
    </style>
</head>

<body>
    <form id="form1" runat="server">
        <div class="navbar">
            <h1>Cat Resort Admin Portal</h1>
            <div class="navbar-buttons">
                <asp:LinkButton runat="server" ID="btnBack" CssClass="back-btn" OnClick="btnBack_Click">Back</asp:LinkButton>
                <asp:LinkButton runat="server" ID="btnLogout" CssClass="logout-btn" OnClick="btnLogout_Click">Logout</asp:LinkButton>
            </div>
        </div>

        <div class="main-content">
            <h2 class="page-title">Staff Management</h2>

            <div class="container">
                <div class="crud-form">
                    <asp:Label runat="server" ID="lblMessage"></asp:Label>
                    <asp:HiddenField runat="server" ID="hdnStaffId" />

                    <div class="form-group">
                        <label for="txtFname">First Name</label>
                        <asp:TextBox runat="server" ID="txtFname" Placeholder="First Name"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label for="txtLname">Last Name</label>
                        <asp:TextBox runat="server" ID="txtLname" Placeholder="Last Name"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label for="txtAddress">Address</label>
                        <asp:TextBox runat="server" ID="txtAddress" Placeholder="Address"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label for="txtRole">Role</label>
                        <asp:TextBox runat="server" ID="txtRole" Placeholder="Role"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label for="txtSalary">Salary</label>
                        <asp:TextBox runat="server" ID="txtSalary" Placeholder="Salary" TextMode="Number"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label for="txtEmails">Emails (comma separated)</label>
                        <asp:TextBox runat="server" ID="txtEmails" Placeholder="Emails (comma separated)"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label for="txtPhones">Phones (comma separated)</label>
                        <asp:TextBox runat="server" ID="txtPhones" Placeholder="Phones (comma separated)"></asp:TextBox>
                    </div>

                    <div class="button-group">
                        <asp:Button runat="server" ID="btnAddStaff" Text="Add Staff" CssClass="btn-primary" OnClick="btnAddStaff_Click" />
                        <asp:Button runat="server" ID="btnUpdateStaff" Text="Update Staff" CssClass="btn-secondary" OnClick="btnUpdateStaff_Click" />
                        <asp:Button runat="server" ID="btnClear" Text="Clear" CssClass="btn-danger" OnClick="btnClear_Click" />
                    </div>
                </div>

                <div class="image-box">
                    <img src="https://english.news.cn/20250326/ec8f3240bfe944e681ecfe379b2b6401/bfa743ba42cc4c71abe40ed259a8eb90.jpg" alt="Cat Resort" />
                </div>
            </div>

            <!-- Query Section -->
            <div class="query-section">
                <h3>SQL Query Execution</h3>
                <asp:TextBox runat="server" ID="txtQuery" CssClass="query-input" TextMode="MultiLine" Rows="4" Placeholder="Enter your SQL query here (SELECT only)"></asp:TextBox>
                <asp:Button runat="server" ID="btnExecuteQuery" Text="Execute Query" CssClass="btn-query" OnClick="btnExecuteQuery_Click" />

                <div class="query-examples">
                    <h4>Example Queries:</h4>
                    <code>SELECT * FROM Staff</code>
                    <code>SELECT Fname, Lname, Role FROM Staff WHERE Role = 'Manager'</code>
                    <code>SELECT s.Staff_id, s.Fname, s.Role, e.Email FROM Staff s LEFT JOIN Staff_Email e ON s.Staff_id = e.Staff_id</code>
                    <code>SELECT Role, COUNT(*) as Total FROM Staff GROUP BY Role</code>
                    <code>SELECT * FROM Staff WHERE Salary > 50000 ORDER BY Salary DESC</code>
                </div>
            </div>

            <!-- Results Table -->
            <div class="table-container">
                <asp:GridView runat="server" ID="gvQueryResults" AutoGenerateColumns="True" Visible="false"></asp:GridView>

                <asp:GridView runat="server" ID="gvStaff" AutoGenerateColumns="False" OnRowCommand="gvStaff_RowCommand">
                    <Columns>
                        <asp:BoundField HeaderText="ID" DataField="Staff_id" />
                        <asp:BoundField HeaderText="First Name" DataField="Fname" />
                        <asp:BoundField HeaderText="Last Name" DataField="Lname" />
                        <asp:BoundField HeaderText="Address" DataField="Address" />
                        <asp:BoundField HeaderText="Role" DataField="Role" />
                        <asp:BoundField HeaderText="Salary" DataField="Salary" DataFormatString="{0:C}" />
                        <asp:BoundField HeaderText="Emails" DataField="Emails" />
                        <asp:BoundField HeaderText="Phones" DataField="Phones" />
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <div class="action-buttons">
                                    <asp:LinkButton runat="server" CommandName="EditStaff" CommandArgument='<%# Eval("Staff_id") %>' Text="Edit" CssClass="btn-edit" />
                                    <asp:LinkButton runat="server" CommandName="DeleteStaff" CommandArgument='<%# Eval("Staff_id") %>' Text="Delete" CssClass="btn-delete" OnClientClick="return confirm('Are you sure you want to delete this staff member?');" />
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

            <footer>© 2025 Cat Resort. All rights reserved.</footer>
        </div>
    </form>
</body>
</html>
