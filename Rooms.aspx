<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Rooms.aspx.cs" Inherits="CatResort.Rooms" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Manage Rooms & Services</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <style>
        body { background: linear-gradient(135deg,#ffe6f2,#e6f7ff); padding-top:80px; font-family:"Segoe UI",sans-serif; }
        .main-container { width:95%; margin:auto; background:white; padding:30px; border-radius:20px; box-shadow:0 10px 40px rgba(0,0,0,0.1); }
        h2 { text-align:center; color:#ff4d94; margin-bottom:20px; }
        .form-box { padding:20px; background:#fff6fc; border:1px solid #ffcae6; border-radius:15px; }
        label { font-weight:600; margin-top:10px; }
        .btn-pink { background:#ff66a3; border:none; color:white; padding:8px 18px; border-radius:10px; cursor:pointer; transition:0.3s; }
        .btn-pink:hover { background:#ff3385; transform:scale(1.05); }
        .table-container { max-height:500px; overflow-y:auto; margin-top:10px; }
        .table-container thead th { background:#fff; position:sticky; top:0; z-index:5; }
        .btn-back { position:fixed; top:20px; left:20px; background:#ff66a3; color:white; padding:10px 15px; border-radius:10px; border:none; font-weight:600; cursor:pointer; z-index:1000; transition:0.3s; }
        .btn-back:hover { background:#ff3385; }
        .duration-input { width:80px; display:inline-block; margin-right:10px; }
        .status-badge { padding:4px 12px; border-radius:20px; font-size:12px; font-weight:600; }
        .status-occupied { background:#ffe6e6; color:#cc0000; }
        .status-available { background:#e6ffe6; color:#006600; }
        .status-maintenance { background:#fffae6; color:#996600; }
    </style>
</head>
<body>
<form id="form1" runat="server">
    <asp:Button ID="btnBack" runat="server" CssClass="btn-back" Text="← Back" OnClick="btnBack_Click" />

    <div class="main-container">
        <h2><i class="bi bi-door-closed-fill"></i> Room & Services Management</h2>

        <asp:Label ID="lblMessage" runat="server" CssClass="d-block text-center mb-3 fw-bold" Text=""></asp:Label>

        <div class="row">
            <!-- LEFT SIDE: ROOMS GRID -->
            <div class="col-md-7">
                <div class="table-container">
                    <asp:GridView ID="gvRooms" runat="server" CssClass="table table-striped table-bordered table-hover"
                        AutoGenerateColumns="false" OnRowDataBound="gvRooms_RowDataBound">
                        <Columns>
                            <asp:BoundField HeaderText="Room Id" DataField="Room_id" />
                            <asp:BoundField HeaderText="Type" DataField="Type" />
                            <asp:BoundField HeaderText="Price" DataField="Price" DataFormatString="{0:C}" />
                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate>
                                    <span class='status-badge status-<%# Eval("Status").ToString().ToLower() %>'>
                                        <%# Eval("Status") %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField HeaderText="Cat" DataField="CatName" />
                            <asp:BoundField HeaderText="Check-in" DataField="Check_in_date" DataFormatString="{0:MM/dd/yyyy HH:mm}" />
                            <asp:BoundField HeaderText="Check-out" DataField="Check_out_date" DataFormatString="{0:MM/dd/yyyy HH:mm}" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>

            <!-- RIGHT SIDE: ASSIGN ROOM FORM -->
            <div class="col-md-5">
                <div class="form-box">
                    <label>Select Appointment</label>
                    <asp:DropDownList ID="ddlAppointments" runat="server" CssClass="form-control"
                        AutoPostBack="true" OnSelectedIndexChanged="ddlAppointments_SelectedIndexChanged">
                    </asp:DropDownList>

                    <label class="mt-2">Select Cat</label>
                    <asp:DropDownList ID="ddlCats" runat="server" CssClass="form-control"></asp:DropDownList>

                    <label class="mt-2">Select Room</label>
                    <asp:DropDownList ID="ddlRooms" runat="server" CssClass="form-control"></asp:DropDownList>

                    <label class="mt-2">Duration</label><br />
                    <asp:TextBox ID="txtDurationDays" runat="server" CssClass="form-control duration-input" Text="1" TextMode="Number"></asp:TextBox> Days
                    <asp:TextBox ID="txtDurationHours" runat="server" CssClass="form-control duration-input" Text="0" TextMode="Number"></asp:TextBox> Hours

                    <label class="mt-2">Select Services</label>
                    <asp:CheckBoxList ID="chkServices" runat="server" RepeatDirection="Vertical"></asp:CheckBoxList>

                    <asp:Button ID="btnAssignRoom" runat="server" CssClass="btn-pink w-100 mt-3"
                        Text="Assign Room & Services" OnClick="btnAssignRoom_Click" />
                </div>
            </div>
        </div>
    </div>
</form>
</body>
</html>