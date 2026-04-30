<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Report.aspx.cs" Inherits="CatResort.Report" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Financial Monthly Report</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body { font-family: 'Recursive', sans-serif; padding: 40px; background:#fdf2ff; color:#5a4a6a; }
        h1 { text-align:center; color:#9575cd; font-weight:700; }
        h2 { text-align:center; margin-bottom:25px; }
        .container-box { max-width:900px; margin:auto; background:white; padding:25px; border-radius:12px; box-shadow:0 3px 15px rgba(149,117,205,0.2);}
        .table th { color:#9575cd; }
        .summary { margin-top:20px; padding:15px; background:#f8f9fa; border-radius:8px; }
        .footer { margin-top:20px; text-align:center; font-style:italic; color:#555; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container-box">
            <h1>Cat Resort Management System</h1>
            <h2>Financial Monthly Report</h2>

            <div class="table-responsive">
                <asp:GridView ID="gvReport" runat="server" AutoGenerateColumns="False" CssClass="table table-striped table-bordered">
                    <Columns>
                        <asp:BoundField DataField="Payment_id" HeaderText="Payment ID" />
                        <asp:BoundField DataField="Customer_id" HeaderText="Customer ID" />
                        <asp:BoundField DataField="Date" HeaderText="Date" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                        <asp:BoundField DataField="Amount" HeaderText="Amount" DataFormatString="{0:C}" />
                        <asp:BoundField DataField="Method" HeaderText="Payment Method" />
                    </Columns>
                </asp:GridView>
            </div>

            <div class="summary">
                <asp:Label ID="lblTotalAmount" runat="server"></asp:Label><br />
                <asp:Label ID="lblMonthlyGoal" runat="server"></asp:Label><br />
                <asp:Label ID="lblProfit" runat="server"></asp:Label><br />
                <asp:Label ID="lblLoss" runat="server"></asp:Label><br />
                <asp:Label ID="lblDateGenerated" runat="server"></asp:Label>
            </div>

            <div class="footer">
                This is an auto-generated report; no signature required.
            </div>
        </div>
    </form>
</body>
</html>
