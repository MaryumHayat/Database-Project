<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="VetCheckups.aspx.cs" Inherits="CatResort.VetCheckups" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Vet Checkups</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body { background-color: #0b3d2e; color: white; }
        .table-container { max-height: 450px; overflow-y: auto; border: 2px solid #145a43; padding: 10px; border-radius: 10px; background-color: #114d38; }
        table thead { background-color: #0d5c40; color: white; position: sticky; top: 0; z-index: 10; }
        table tbody tr { background-color: #eaf6f1; color: black; }
        table tbody tr:hover { background-color: #d2eee3; }
        h2 { color: white; margin-top: 20px; margin-bottom: 20px; }
        .back-btn { margin-bottom: 15px; }
    </style>
</head>

<body>
    <form id="form1" runat="server" class="container mt-4">

        <!-- Back Button -->
        <asp:Button ID="btnBack" runat="server" Text="← Back to Dashboard" CssClass="btn btn-light back-btn" OnClick="btnBack_Click" />

        <h2 class="text-center">Scheduled Cat Checkups</h2>

        <div class="table-container">
            <asp:GridView 
                ID="gvCheckups" 
                runat="server"
                CssClass="table table-bordered table-hover"
                AutoGenerateColumns="False"
                ShowHeaderWhenEmpty="true">

                <Columns>
                    <asp:BoundField DataField="Appointment_id" HeaderText="Appointment ID" />
                    <asp:BoundField DataField="Cat_id" HeaderText="Cat ID" />
                    <asp:BoundField DataField="CatName" HeaderText="Cat Name" />
                    <asp:BoundField DataField="OwnerName" HeaderText="Owner" />
                    <asp:BoundField DataField="Date" HeaderText="Date" DataFormatString="{0:yyyy-MM-dd}" />
                    <asp:BoundField DataField="Time" HeaderText="Time" />
                    <asp:BoundField DataField="Purpose" HeaderText="Purpose" />
                    <asp:BoundField DataField="RoomStatus" HeaderText="Room Assigned" />
                </Columns>

                <EmptyDataTemplate>
                    <tr>
                        <td colspan="8" class="text-center" style="color:#0b3d2e; font-weight:bold;">
                            No scheduled appointments
                        </td>
                    </tr>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
    </form>
</body>
</html>
