<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Tasks.aspx.cs" Inherits="CatResort.Tasks" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Staff Tasks</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body { background: linear-gradient(135deg,#ffe6f2,#e6f7ff); padding-top:80px; font-family:"Segoe UI",sans-serif; }
        .container-box { width:95%; margin:auto; background:white; padding:30px; border-radius:20px; box-shadow:0 10px 40px rgba(0,0,0,0.1); }
        h2 { text-align:center; color:#ff4d94; margin-bottom:20px; }
        .btn-back { position:fixed; top:20px; left:20px; background:#ff66a3; color:white; padding:10px 15px; border-radius:10px; border:none; font-weight:600; cursor:pointer; z-index:1000; transition:0.3s; }
        .btn-back:hover { background:#ff3385; }
        .table-container { max-height:500px; overflow-y:auto; margin-top:10px; }
        .table-container thead th { background:#fff; position:sticky; top:0; z-index:5; }
        .task-status { padding:4px 12px; border-radius:20px; font-size:12px; font-weight:600; }
        .status-pending { background:#fff3cd; color:#856404; }
        .status-completed { background:#d4edda; color:#155724; }
        .status-inprogress { background:#d1ecf1; color:#0c5460; }
        .task-completed { background-color: #f8f9fa; opacity: 0.7; }
        .room-status { font-size:11px; color:#666; font-style:italic; }
    </style>
</head>
<body>
<form id="form1" runat="server">
    <asp:Button ID="btnBack" runat="server" CssClass="btn-back" Text="&larr; Back" OnClick="btnBack_Click" />
    <div class="container-box">
        <h2>All Tasks</h2>
        
        <div class="row mb-3">
            <div class="col-md-3">
                <asp:DropDownList ID="ddlStatusFilter" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlStatusFilter_SelectedIndexChanged">
                    <asp:ListItem Value="All">All Status</asp:ListItem>
                    <asp:ListItem Value="Pending">Pending</asp:ListItem>
                    <asp:ListItem Value="In Progress">In Progress</asp:ListItem>
                    <asp:ListItem Value="Completed">Completed</asp:ListItem>
                </asp:DropDownList>
            </div>
        </div>

        <div class="table-container">
            <asp:GridView ID="gvTasks" runat="server" AutoGenerateColumns="false" 
                CssClass="table table-striped table-bordered" OnRowDataBound="gvTasks_RowDataBound" DataKeyNames="Task_id">
                <Columns>
                    <asp:BoundField HeaderText="Task ID" DataField="Task_id" />
                    <asp:BoundField HeaderText="Task Name" DataField="Name" />
                    <asp:BoundField HeaderText="Room No" DataField="Room_no" />
                    <asp:BoundField HeaderText="Cat Name" DataField="CatName" />
                    <asp:BoundField HeaderText="Check-in" DataField="Check_in_date" DataFormatString="{0:MM/dd/yyyy HH:mm}" HtmlEncode="false" />
                    <asp:BoundField HeaderText="Check-out" DataField="Check_out_date" DataFormatString="{0:MM/dd/yyyy HH:mm}" HtmlEncode="false" />
                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <span class='task-status status-<%# Eval("Status").ToString().ToLower().Replace(" ", "") %>'>
                                <%# Eval("Status") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Complete">
                        <ItemTemplate>
                            <asp:CheckBox ID="chkComplete" runat="server" 
                                AutoPostBack="true" 
                                OnCheckedChanged="chkComplete_CheckedChanged" />
                            <asp:HiddenField ID="hfTaskId" runat="server" Value='<%# Eval("Task_id") %>' />
                            <asp:HiddenField ID="hfRoomId" runat="server" Value='<%# Eval("Room_id") %>' />
                            <asp:HiddenField ID="hfCatId" runat="server" Value='<%# Eval("Cat_id") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
</form>
</body>
</html>