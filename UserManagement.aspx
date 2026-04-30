<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UserManagement.aspx.cs" Inherits="CatResort.UserManagement" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>User Management</title>
    <link href="https://fonts.googleapis.com/css2?family=Recursive:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        /* ORIGINAL CSS KEPT UNCHANGED */
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Recursive', sans-serif; background:linear-gradient(135deg,#fdf2ff 0%,#f2fdff 100%); color:#5a4a6a; line-height:1.4; }
        .navbar { position: fixed; top:0; width:100%; background:rgba(255,255,255,0.95); backdrop-filter:blur(10px); box-shadow:0 2px 15px rgba(149,117,205,0.1); display:flex; justify-content:space-between; align-items:center; padding:12px 30px; z-index:1000; height:65px; }
        .navbar h1 { font-size:24px; font-weight:700; background:linear-gradient(135deg,#ff9ec0 0%,#9575cd 100%); -webkit-background-clip:text; -webkit-text-fill-color:transparent; }
        .logout-btn, .back-btn { background:linear-gradient(135deg,#ff9ec0 0%,#9575cd 100%); color:white; font-weight:600; padding:8px 18px; text-decoration:none; border:none; cursor:pointer; font-size:14px; transition:0.3s; box-shadow:0 3px 10px rgba(149,117,205,0.3); margin-left:5px; }
        .logout-btn:hover, .back-btn:hover { transform:translateY(-1px); box-shadow:0 4px 12px rgba(149,117,205,0.4); }
        .main-content { margin-top:80px; padding:20px 30px; }
        .page-title { text-align:center; margin-bottom:25px; font-size:28px; font-weight:700; color:#5a4a6a; }
        .container { display:flex; gap:25px; margin-bottom:25px; }
        .crud-form { flex:1; padding:20px; background:white; box-shadow:0 3px 15px rgba(149,117,205,0.15); }
        .form-group { margin-bottom:12px; }
        .form-group label { display:block; margin-bottom:5px; font-weight:600; color:#7e6a9f; font-size:14px; }
        .crud-form input[type="text"], .crud-form input[type="password"], .crud-form select { width:100%; padding:8px 12px; border:2px solid #e1d7f2; font-size:14px; font-family:'Recursive', sans-serif; transition:all 0.3s; background-color:#faf7ff; }
        .crud-form input:focus, .crud-form select:focus { border-color:#b39ddb; outline:none; box-shadow:0 0 0 2px rgba(179,157,219,0.2); background-color:white; }
        .button-group { display:flex; gap:10px; margin-top:15px; flex-wrap:wrap; }
        .btn-primary, .btn-secondary, .btn-danger { padding:10px 20px; border:none; font-family:'Recursive', sans-serif; font-weight:600; font-size:14px; cursor:pointer; transition:0.3s; flex:1; text-align:center; }
        .btn-primary { background:linear-gradient(135deg,#ff9ec0 0%,#9575cd 100%); color:white; }
        .btn-secondary { background:linear-gradient(135deg,#9575cd 0%,#7986cb 100%); color:white; }
        .btn-danger { background:linear-gradient(135deg,#ff6b6b 0%,#ff5252 100%); color:white; }
        .btn-primary:hover, .btn-secondary:hover, .btn-danger:hover { transform:translateY(-1px); box-shadow:0 4px 12px rgba(149,117,205,0.4); }
        .table-container { flex:1; background:white; box-shadow:0 3px 15px rgba(149,117,205,0.15); overflow:hidden; margin-top:20px; }

        /* NEW CSS FOR SCROLLABLE TABLE WITH FIXED HEADER */
        .table-responsive-wrapper {
            max-height:220px; /* ~3-4 rows */
            overflow-y:auto;
        }
        .table thead th {
            position: sticky;
            top:0;
            background:linear-gradient(135deg,#f8f4ff 0%,#f0eaf9 100%);
            z-index:2;
        }

        .action-buttons { display:flex; gap:5px; }
        .btn-edit, .btn-delete { padding:4px 8px; border:none; font-size:11px; cursor:pointer; font-family:'Recursive', sans-serif; font-weight:500; }
        .btn-edit { background:#9575cd; color:white; }
        .btn-delete { background:#ff6b6b; color:white; }
        footer { text-align:center; padding:20px 0; background:white; color:#7e6a9f; font-weight:600; box-shadow:0 -2px 8px rgba(149,117,205,0.1); margin-top:15px; font-size:14px; }
        #lblMessage { display:block; padding:8px 12px; margin-bottom:15px; background-color:#ffebee; color:#d32f2f; font-weight:600; font-size:13px; }
        .success-message { background-color:#e8f5e9 !important; color:#2e7d32 !important; }
        .image-box { flex:1; display:flex; align-items:center; justify-content:center; overflow:hidden; }
        .image-box img { width:100%; height:100%; object-fit:cover; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="navbar">
            <h1>Cat Resort Admin Portal</h1>
            <asp:LinkButton runat="server" ID="btnBack" CssClass="back-btn" OnClick="btnBack_Click">Back</asp:LinkButton>
            <asp:LinkButton runat="server" ID="btnLogout" CssClass="logout-btn" OnClick="btnLogout_Click">Logout</asp:LinkButton>
        </div>

        <div class="main-content">
            <h2 class="page-title">User Management</h2>

            <div class="container">
                <div class="crud-form">
                    <asp:Label runat="server" ID="lblMessage"></asp:Label>
                    <asp:HiddenField runat="server" ID="hdnUserId" />

                    <div class="form-group">
                        <label for="txtUsername">Username</label>
                        <asp:TextBox runat="server" ID="txtUsername" Placeholder="Username"></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <label for="txtPassword">Password (Optional for Customers)</label>
                        <asp:TextBox runat="server" ID="txtPassword" Placeholder="Password" TextMode="Password"></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <label for="ddlRole">Role</label>
                        <asp:DropDownList runat="server" ID="ddlRole" AutoPostBack="true" OnSelectedIndexChanged="ddlRole_SelectedIndexChanged">
                            <asp:ListItem Text="Select Role" Value=""></asp:ListItem>
                            <asp:ListItem Text="Admin" Value="Admin"></asp:ListItem>
                            <asp:ListItem Text="Staff" Value="Staff"></asp:ListItem>
                            <asp:ListItem Text="Vet" Value="Vet"></asp:ListItem>
                            <asp:ListItem Text="Customer" Value="Customer"></asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="form-group">
                        <label for="ddlReference">Link to</label>
                        <asp:DropDownList runat="server" ID="ddlReference">
                            <asp:ListItem Text="Select Reference" Value=""></asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="button-group">
                        <asp:Button runat="server" ID="btnAddUser" Text="Add User" CssClass="btn-primary" OnClick="btnAddUser_Click" />
                        <asp:Button runat="server" ID="btnUpdateUser" Text="Update User" CssClass="btn-secondary" OnClick="btnUpdateUser_Click" />
                        <asp:Button runat="server" ID="btnClear" Text="Clear" CssClass="btn-danger" OnClick="btnClear_Click" />
                    </div>
                </div>

                <div class="image-box">
                    <img src="https://cdn.homecrux.com/wp-content/uploads/2017/02/Catzonia-in-Malaysia-is-world%E2%80%99s-first-five-star-Cat-Hotel_8.jpg" alt="User Management" />
                </div>
            </div>

            <!-- Scrollable Table -->
            <div class="table-container table-responsive-wrapper">
                <asp:GridView runat="server" ID="gvUsers" AutoGenerateColumns="False" CssClass="table table-striped table-bordered"
                    OnRowCommand="gvUsers_RowCommand" DataKeyNames="User_id">
                    <Columns>
                        <asp:BoundField HeaderText="ID" DataField="User_id" />
                        <asp:BoundField HeaderText="Username" DataField="Username" />
                        <asp:BoundField HeaderText="Role" DataField="Role" />
                        <asp:BoundField HeaderText="Reference Name" DataField="ReferenceName" />
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <div class="action-buttons">
                                    <asp:LinkButton runat="server" CommandName="EditUser" CommandArgument='<%# Eval("User_id") %>' Text="Edit" CssClass="btn-edit" />
                                    <asp:LinkButton runat="server" CommandName="DeleteUser" CommandArgument='<%# Eval("User_id") %>' Text="Delete" CssClass="btn-delete" OnClientClick="return confirm('Are you sure?');" />
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

            <footer>© 2025 Cat Resort. All rights reserved.</footer>
        </div>
    </form>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
