<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FinancialManagement.aspx.cs" Inherits="CatResort.FinancialManagement" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Financial Management</title>
    <link href="https://fonts.googleapis.com/css2?family=Recursive:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />

    <style>
        body {
            font-family: 'Recursive', sans-serif;
            background: linear-gradient(135deg,#fdf2ff 0%,#f2fdff 100%);
            color:#5a4a6a;
            padding: 40px;
        }

        h2 {
            text-align:center;
            margin-bottom:25px;
            font-size:28px;
            font-weight:700;
            color:#9575cd;
        }

        .container-box {
            max-width: 1200px;
            margin: auto;
            background:white;
            padding:25px;
            border-radius:12px;
            box-shadow: 0 3px 15px rgba(149,117,205,0.20);
        }

        .btn {
            margin-top:10px;
            margin-right:10px;
            padding:10px 18px;
            border:none;
            cursor:pointer;
            border-radius:6px;
            font-weight:600;
            color:white;
            box-shadow:0 3px 10px rgba(149,117,205,0.3);
        }

        .back-btn { background:#777; }
        .report-btn { background:#4caf50; }

        .table-responsive {
            max-height:400px;
            overflow-y:auto;
            margin-top:20px;
        }

        .table th { color:#9575cd; }

        .report-summary {
            margin-top:20px;
            padding:15px;
            border-radius:8px;
            background:#f8f9fa;
        }

        .report-summary h4 {
            margin-bottom:15px;
        }

        .msg {
            margin-top:15px;
            font-weight:600;
        }

        .success { color:green; }
        .error { color:red; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container-box">
            <asp:Button ID="btnBack" runat="server" Text="&larr; Back" CssClass="btn back-btn" OnClick="btnBack_Click" />

            <h2>Financial Management</h2>

            <asp:Button ID="btnGenerateReport" runat="server" Text="Generate Report" CssClass="btn report-btn" OnClick="btnGenerateReport_Click" />

            <div class="table-responsive">
                <asp:GridView ID="gvPayments" runat="server" AutoGenerateColumns="False" CssClass="table table-striped table-bordered">
                    <Columns>
                        <asp:BoundField DataField="Payment_id" HeaderText="Payment ID" />
                        <asp:BoundField DataField="Customer_id" HeaderText="Customer ID" />
                        <asp:BoundField DataField="Date" HeaderText="Date" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                        <asp:BoundField DataField="Amount" HeaderText="Amount" DataFormatString="{0:C}" />
                        <asp:BoundField DataField="Method" HeaderText="Payment Method" />
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </form>
</body>
</html>
