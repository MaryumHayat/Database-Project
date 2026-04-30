<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CustomerManagement.aspx.cs" Inherits="CatResort.CustomerManagement" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Customer Management</title>
    <link href="https://fonts.googleapis.com/css2?family=Recursive:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Recursive', sans-serif; background:linear-gradient(135deg,#fdf2ff 0%,#f2fdff 100%); color:#5a4a6a; line-height:1.4; }
        .navbar { position: fixed; top:0; width:100%; background:rgba(255,255,255,0.95); backdrop-filter:blur(10px); box-shadow:0 2px 15px rgba(149,117,205,0.1); display:flex; justify-content:space-between; align-items:center; padding:12px 30px; z-index:1000; height:65px; }
        .navbar h1 { font-size:24px; font-weight:700; background:linear-gradient(135deg,#ff9ec0 0%,#9575cd 100%); -webkit-background-clip:text; -webkit-text-fill-color:transparent; }
        .logout-btn, .back-btn { background:linear-gradient(135deg,#ff9ec0 0%,#9575cd 100%); color:white; font-weight:600; padding:8px 18px; border:none; cursor:pointer; font-size:14px; box-shadow:0 3px 10px rgba(149,117,205,0.3); margin-left:5px; }
        .main-content { margin-top:80px; padding:20px 30px; }
        .page-title { text-align:center; margin-bottom:25px; font-size:28px; font-weight:700; color:#5a4a6a; }
        .table-container { margin-top:20px; max-height:300px; overflow-y:auto; border:1px solid #e1d7f2; box-shadow:0 3px 15px rgba(149,117,205,0.15); }
        table { width:100%; border-collapse:collapse; }
        th, td { padding:10px 12px; text-align:left; border-bottom:1px solid #f0eaf9; font-size:14px; }
        th { background:linear-gradient(135deg,#f8f4ff 0%,#f0eaf9 100%); font-weight:700; color:#7e6a9f; position: sticky; top:0; z-index:10; }
        tr:hover { background-color:#faf7ff; }
        .action-buttons { display:flex; gap:5px; }
        .btn-edit { background:#9575cd; color:white; padding:4px 8px; border:none; cursor:pointer; }
        .btn-delete { background:#ff6b6b; color:white; padding:4px 8px; border:none; cursor:pointer; }
        #lblMessage { display:block; padding:8px 12px; margin-bottom:15px; font-weight:600; font-size:13px; }
        .success-message { background-color:#e8f5e9 !important; color:#2e7d32 !important; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="navbar">
            <h1>Cat Resort Admin Portal</h1>
            <div>
                <asp:LinkButton runat="server" ID="btnBack" CssClass="back-btn" OnClick="btnBack_Click">Back</asp:LinkButton>
                <asp:LinkButton runat="server" ID="btnLogout" CssClass="logout-btn" OnClick="btnLogout_Click">Logout</asp:LinkButton>
            </div>
        </div>

        <div class="main-content">
            <h2 class="page-title">Customer Management</h2>
            <asp:Label runat="server" ID="lblMessage"></asp:Label>

            <div class="table-container">
                <asp:GridView runat="server" ID="gvCustomers" AutoGenerateColumns="False" OnRowCommand="gvCustomers_RowCommand">
                    <Columns>
                        <asp:BoundField HeaderText="ID" DataField="Customer_id" />
                        <asp:BoundField HeaderText="Full Name" DataField="FullName" />
                        <asp:BoundField HeaderText="Email(s)" DataField="Email" />
                        <asp:BoundField HeaderText="Phone(s)" DataField="Phone" />
                        <asp:BoundField HeaderText="No. of Cats" DataField="No_of_Cats" />
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <div class="action-buttons">
                                    <asp:LinkButton runat="server" CommandName="EditCustomer" CommandArgument='<%# Eval("Customer_id") %>' Text="Edit" CssClass="btn-edit" />
                                    <asp:LinkButton runat="server" CommandName="DeleteCustomer" CommandArgument='<%# Eval("Customer_id") %>' Text="Delete" CssClass="btn-delete" OnClientClick="return confirm('Are you sure?');" />
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </form>
</body>
</html>
