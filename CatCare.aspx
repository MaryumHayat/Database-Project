<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CatCare.aspx.cs" Inherits="CatResort.CatCare" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Current Cats - Cat Resort</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <style>
        body { background: linear-gradient(135deg,#fff0f5,#f0f8ff); padding-top:80px; font-family:"Segoe UI",sans-serif; }
        .main-container { width:95%; margin:auto; background:white; padding:30px; border-radius:20px; box-shadow:0 10px 40px rgba(0,0,0,0.1); }
        h2 { text-align:center; color:#ff4d94; margin-bottom:20px; }
        .btn-back { position:fixed; top:20px; left:20px; background:#ff66a3; color:white; padding:10px 15px; border-radius:10px; border:none; font-weight:600; cursor:pointer; z-index:1000; transition:0.3s; }
        .btn-back:hover { background:#ff3385; }
        .filter-box { background:#fff6fc; padding:20px; border-radius:15px; border:1px solid #ffcae6; margin-bottom:25px; }
        .btn-pink { background:#ff66a3; border:none; color:white; padding:8px 18px; border-radius:10px; cursor:pointer; transition:0.3s; }
        .btn-pink:hover { background:#ff3385; transform:scale(1.05); }
        .btn-outline-pink { background:transparent; border:2px solid #ff66a3; color:#ff66a3; padding:8px 18px; border-radius:10px; cursor:pointer; transition:0.3s; }
        .btn-outline-pink:hover { background:#ff66a3; color:white; }
        .status-badge { padding:4px 12px; border-radius:20px; font-size:12px; font-weight:600; }
        .status-active { background:#e6ffe6; color:#006600; }
        .status-leaving-soon { background:#fffae6; color:#996600; }
        .status-overdue { background:#ffe6e6; color:#cc0000; }
        .cat-card { border:1px solid #e0e0e0; border-radius:10px; padding:15px; margin-bottom:15px; transition:0.3s; }
        .cat-card:hover { box-shadow:0 5px 15px rgba(0,0,0,0.1); }
        .table-container { max-height:600px; overflow-y:auto; }
        .table-container thead th { background:#fff; position:sticky; top:0; z-index:5; border-bottom:2px solid #ff66a3; }
        .cat-name { font-weight:600; color:#ff3385; }
        .owner-info { font-size:0.9em; color:#666; }
        .special-needs { max-width:200px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; cursor:help; }
        .stats-card { background:linear-gradient(135deg,#ff66a3,#ff99c2); color:white; padding:15px; border-radius:10px; text-align:center; margin-bottom:20px; }
        .stats-number { font-size:2em; font-weight:bold; }
        .clickable-row { cursor:pointer; transition:0.2s; }
        .clickable-row:hover { background-color:#fff6fc !important; }
        .grid-header { background-color:#ff66a3 !important; color:white; }
    </style>
</head>
<body>
<form id="form1" runat="server">
    <asp:Button ID="btnBack" runat="server" CssClass="btn-back" Text="← Dashboard" OnClick="btnBack_Click" />

    <div class="main-container">
        <h2><i class="bi bi-card-checklist"></i> Current Cat Boarding Management</h2>
        
        <asp:Label ID="lblMessage" runat="server" CssClass="d-block text-center mb-3 fw-bold" Text=""></asp:Label>
        
        <!-- Statistics Card -->
        <div class="row">
            <div class="col-md-12">
                <div class="stats-card">
                    <asp:Label ID="lblTotalCats" runat="server" CssClass="stats-number" Text="Loading..."></asp:Label>
                    <p>Cats Currently Staying</p>
                </div>
            </div>
        </div>
        
        <!-- Filter Section -->
        <div class="filter-box">
            <div class="row align-items-end">
                <div class="col-md-3">
                    <label class="form-label">Search Cat Name</label>
                    <asp:TextBox ID="txtSearchName" runat="server" CssClass="form-control" 
                        placeholder="Enter cat name..."></asp:TextBox>
                </div>
                <div class="col-md-2">
                    <label class="form-label">Filter by Room</label>
                    <asp:DropDownList ID="ddlFilterRoom" runat="server" CssClass="form-control">
                    </asp:DropDownList>
                </div>
                <div class="col-md-2">
                    <label class="form-label">Filter by Breed</label>
                    <asp:DropDownList ID="ddlFilterBreed" runat="server" CssClass="form-control">
                    </asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <asp:Button ID="btnFilter" runat="server" CssClass="btn-pink w-100 mt-2" 
                        Text="Apply Filters" OnClick="btnFilter_Click" />
                </div>
                <div class="col-md-2">
                    <asp:Button ID="btnClearFilter" runat="server" CssClass="btn-outline-pink w-100 mt-2" 
                        Text="Clear Filters" OnClick="btnClearFilter_Click" />
                </div>
            </div>
        </div>
        
        
        <div class="mb-3 text-end">
            <asp:Button ID="btnExport" runat="server" CssClass="btn-pink" 
                Text="Export to CSV" OnClick="btnExport_Click" />
        </div>
        
        <!-- Cats Grid -->
        <div class="table-container">
            <asp:GridView ID="gvCurrentCats" runat="server" 
                CssClass="table table-striped table-bordered table-hover clickable-row"
                AutoGenerateColumns="false"
                OnRowDataBound="gvCurrentCats_RowDataBound"
                OnSelectedIndexChanged="gvCurrentCats_SelectedIndexChanged"
                OnRowCommand="gvCurrentCats_RowCommand"
                DataKeyNames="Cat_id"
                GridLines="None"
                HeaderStyle-CssClass="grid-header">
                <HeaderStyle CssClass="grid-header" />
                <Columns>
                    
                    <asp:TemplateField HeaderText="Cat Information">
                        <ItemTemplate>
                            <div class="cat-name">
                                <i class="bi bi-heart-fill text-danger"></i>
                                <%# Eval("CatName") %>
                            </div>
                            <div>
                                <small>
                                    <strong>Breed:</strong> <%# Eval("Breed", "{0}") %> | 
                                    <strong>Age:</strong> <%# Eval("Age", "{0}") %> years
                                </small>
                            </div>
                            <div class="special-needs" title='<%# Eval("SpecialNeeds") %>'>
                                <strong>Special Needs:</strong> <%# Eval("SpecialNeeds", "{0}") %>
                            </div>
                        </ItemTemplate>
                        <ItemStyle Width="25%" />
                    </asp:TemplateField>
                    
                    
                    <asp:TemplateField HeaderText="Vaccination">
                        <ItemTemplate>
                            <span class='badge <%# Eval("Vaccinated").ToString().ToLower().Contains("yes") ? "bg-success" : "bg-warning" %>'>
                                <%# Eval("Vaccinated") %>
                            </span>
                        </ItemTemplate>
                        <ItemStyle Width="10%" HorizontalAlign="Center" />
                    </asp:TemplateField>
                    
                    
                    <asp:TemplateField HeaderText="Room Details">
                        <ItemTemplate>
                            <strong>Room #<%# Eval("Room_no") %></strong><br />
                            <small>
                                <strong>Check-in:</strong><br />
                                <%# Eval("Check_in_date", "{0:MM/dd/yyyy HH:mm}") %><br />
                                <strong>Check-out:</strong><br />
                                <%# Eval("Check_out_date", "{0:MM/dd/yyyy HH:mm}") %>
                            </small>
                        </ItemTemplate>
                        <ItemStyle Width="25%" />
                    </asp:TemplateField>
                    
                   
                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <span class='status-badge status-<%# Eval("Status").ToString().ToLower().Replace(" ", "-") %>'>
                                <%# Eval("Status") %>
                            </span>
                            <br />
                            <small>
                                Days left: <strong><%# Eval("DaysRemaining") %></strong>
                            </small>
                        </ItemTemplate>
                        <ItemStyle Width="15%" HorizontalAlign="Center" />
                    </asp:TemplateField>
                    
                    
                    <asp:TemplateField HeaderText="Owner Contact">
                        <ItemTemplate>
                            <div class="owner-info">
                                <strong><%# Eval("OwnerName") %></strong><br />
                                <i class="bi bi-telephone"></i> <%# Eval("OwnerPhone") %><br />
                                <i class="bi bi-envelope"></i> <%# Eval("OwnerEmail") %>
                            </div>
                        </ItemTemplate>
                        <ItemStyle Width="25%" />
                    </asp:TemplateField>
                   
                </Columns>
                <EmptyDataTemplate>
                    <div class="text-center py-5">
                        <i class="bi bi-emoji-frown" style="font-size: 3rem; color: #ff66a3;"></i>
                        <h4 class="mt-3">No cats currently staying</h4>
                        <p class="text-muted">All rooms are available. Check for new appointments.</p>
                    </div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
    </div>
</form>
</body>
</html>