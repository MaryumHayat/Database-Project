<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MakePayment.aspx.cs" Inherits="CatResort.MakePayment" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Make Payment - Cat Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Recursive:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Recursive', sans-serif;
            background: linear-gradient(135deg, #fdf2ff 0%, #f2fdff 100%);
            color: #5a4a6a;
            line-height: 1.6;
        }

        .navbar {
            position: fixed;
            top: 0;
            width: 100%;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            box-shadow: 0 2px 15px rgba(149, 117, 205, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 30px;
            z-index: 1000;
            height: 70px;
        }

        .navbar h1 {
            font-family: 'Recursive', sans-serif;
            font-size: 24px;
            font-weight: 700;
            background: linear-gradient(135deg, #ff9ec0 0%, #9575cd 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .nav-buttons {
            display: flex;
            gap: 15px;
            align-items: center;
        }

        .btn {
            padding: 8px 20px;
            border: none;
            border-radius: 20px;
            font-family: 'Recursive', sans-serif;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .btn-secondary {
            background: linear-gradient(135deg, #9575cd 0%, #7986cb 100%);
            color: white;
            box-shadow: 0 3px 10px rgba(149, 117, 205, 0.3);
        }

        .btn-secondary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(149, 117, 205, 0.4);
        }

        .logout-btn {
            background: linear-gradient(135deg, #ff6b6b 0%, #ff5252 100%);
            color: white;
            box-shadow: 0 3px 10px rgba(255, 107, 107, 0.3);
        }

        .logout-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(255, 107, 107, 0.4);
        }

        .main-content {
            margin-top: 80px;
            padding: 30px;
            max-width: 800px;
            margin-left: auto;
            margin-right: auto;
        }

        .payment-header {
            text-align: center;
            margin-bottom: 40px;
            padding: 30px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(149, 117, 205, 0.1);
        }

        .payment-header h2 {
            font-size: 28px;
            margin-bottom: 10px;
            color: #5a4a6a;
        }

        .payment-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 5px 20px rgba(149, 117, 205, 0.1);
            margin-bottom: 25px;
        }

        .payment-card h3 {
            color: #5a4a6a;
            margin-bottom: 20px;
            font-size: 22px;
            border-bottom: 2px solid #f0eaf9;
            padding-bottom: 10px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #7e6a9f;
            font-size: 14px;
        }

        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e1d7f2;
            border-radius: 10px;
            font-size: 16px;
            font-family: 'Recursive', sans-serif;
            transition: all 0.3s;
            background-color: #faf7ff;
        }

        .form-control:focus {
            border-color: #b39ddb;
            outline: none;
            box-shadow: 0 0 0 3px rgba(179, 157, 219, 0.2);
            background-color: white;
        }

        .btn-primary {
            background: linear-gradient(135deg, #ff9ec0 0%, #9575cd 100%);
            color: white;
            padding: 15px 40px;
            font-size: 16px;
            box-shadow: 0 4px 15px rgba(149, 117, 205, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(149, 117, 205, 0.4);
        }

        .btn-success {
            background: linear-gradient(135deg, #4CAF50 0%, #45a049 100%);
            color: white;
            padding: 15px 40px;
            font-size: 16px;
            box-shadow: 0 4px 15px rgba(76, 175, 80, 0.3);
        }

        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(76, 175, 80, 0.4);
        }

        .message {
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-weight: 600;
            text-align: center;
        }

        .success {
            background-color: #e8f5e9;
            color: #2e7d32;
            border: 1px solid #c8e6c9;
        }

        .error {
            background-color: #ffebee;
            color: #d32f2f;
            border: 1px solid #ffcdd2;
        }

        .payment-methods {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }

        .payment-method {
            border: 2px solid #e1d7f2;
            border-radius: 10px;
            padding: 15px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
        }

        .payment-method:hover {
            border-color: #b39ddb;
            background-color: #faf7ff;
        }

        .payment-method.selected {
            border-color: #9575cd;
            background-color: #f0eaf9;
        }

        .payment-history {
            margin-top: 40px;
        }

        /* Updated Table Styles */
        .table-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(149, 117, 205, 0.1);
            overflow: hidden;
        }

        .table-container h3 {
            padding: 20px;
            margin: 0;
            color: #5a4a6a;
            background: linear-gradient(135deg, #f8f4ff 0%, #f0eaf9 100%);
            border-bottom: 1px solid #f0eaf9;
        }

        .table-wrapper {
            max-height: 200px; /* Shows approximately 4-5 rows */
            overflow-y: auto;
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 500px; /* Ensures table doesn't get too narrow */
        }

        th, td {
            padding: 8px 12px; /* Reduced padding for narrower rows */
            text-align: left;
            border-bottom: 1px solid #f0eaf9;
            font-size: 13px; /* Smaller font size */
            line-height: 1.2; /* Tighter line height */
        }

        th {
            background: linear-gradient(135deg, #f8f4ff 0%, #f0eaf9 100%);
            font-weight: 700;
            color: #7e6a9f;
            font-family: 'Recursive', sans-serif;
            position: sticky;
            top: 0;
            z-index: 10;
        }

        tr {
            height: 35px; /* Fixed height for consistent narrow rows */
        }

        tr:hover {
            background-color: #faf7ff;
        }

        /* Custom scrollbar for table wrapper */
        .table-wrapper::-webkit-scrollbar {
            width: 6px;
            height: 6px;
        }

        .table-wrapper::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 3px;
        }

        .table-wrapper::-webkit-scrollbar-thumb {
            background: linear-gradient(135deg, #ff9ec0 0%, #9575cd 100%);
            border-radius: 3px;
        }

        .table-wrapper::-webkit-scrollbar-thumb:hover {
            background: linear-gradient(135deg, #ff8ab4 0%, #8465c4 100%);
        }

        .grid-view {
            width: 100%;
            border-collapse: collapse;
        }

        .grid-view th,
        .grid-view td {
            padding: 8px 12px;
            text-align: left;
            border-bottom: 1px solid #f0eaf9;
            font-size: 13px;
            line-height: 1.2;
        }

        .grid-view tr {
            height: 35px;
        }

        @media (max-width: 768px) {
            .payment-methods {
                grid-template-columns: 1fr 1fr;
            }
            
            .navbar {
                padding: 12px 20px;
            }
            
            .navbar h1 {
                font-size: 20px;
            }

            .table-wrapper {
                max-height: 180px;
            }

            th, td {
                padding: 6px 10px;
                font-size: 12px;
            }

            tr {
                height: 32px;
            }
        }

        @media (max-width: 480px) {
            .table-wrapper {
                max-height: 150px;
            }

            th, td {
                padding: 5px 8px;
                font-size: 11px;
            }

            tr {
                height: 30px;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Navbar -->
        <div class="navbar">
            <h1>Cat Resort - Make Payment</h1>
            <div class="nav-buttons">
                <asp:Button ID="btnDashboard" runat="server" Text="Dashboard" CssClass="btn btn-secondary" OnClick="btnDashboard_Click" />
                <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn logout-btn" OnClick="btnLogout_Click" />
            </div>
        </div>

        <div class="main-content">
            <asp:Label ID="lblMessage" runat="server" CssClass="message" Visible="false"></asp:Label>

            <!-- Payment Header -->
            <div class="payment-header">
                <h2>Make a Payment</h2>
                <p>Secure payment processing for your cat's care services</p>
            </div>

            <!-- Payment Form -->
            <div class="payment-card">
                <h3>Payment Details</h3>
                <div class="form-group">
                    <label for="txtAmount">Amount ($)</label>
                    <asp:TextBox ID="txtAmount" runat="server" CssClass="form-control" TextMode="Number" step="0.01" min="0" placeholder="Enter amount"></asp:TextBox>
                </div>
                
                <div class="form-group">
                    <label>Payment Method</label>
                    <div class="payment-methods">
                        <div class="payment-method" onclick="selectPaymentMethod('Credit Card')">
                            💳 Credit Card
                        </div>
                        <div class="payment-method" onclick="selectPaymentMethod('Debit Card')">
                            🏦 Debit Card
                        </div>
                        <div class="payment-method" onclick="selectPaymentMethod('PayPal')">
                            📱 PayPal
                        </div>
                        <div class="payment-method" onclick="selectPaymentMethod('Bank Transfer')">
                            💰 Bank Transfer
                        </div>
                    </div>
                    <asp:HiddenField ID="hdnPaymentMethod" runat="server" />
                </div>

                <div style="text-align: center; margin-top: 30px;">
                    <asp:Button ID="btnProcessPayment" runat="server" Text="Process Payment" CssClass="btn btn-success" OnClick="btnProcessPayment_Click" />
                </div>
            </div>

            <!-- Payment History -->
            <div class="payment-history">
                <h3 style="color: #5a4a6a; margin-bottom: 20px;">Payment History</h3>
                <div class="table-container">
                    <div class="table-wrapper">
                        <asp:GridView ID="gvPaymentHistory" runat="server" AutoGenerateColumns="False" Width="100%">
                            <Columns>
                                <asp:BoundField HeaderText="Payment ID" DataField="Payment_id" />
                                <asp:BoundField HeaderText="Date" DataField="Date" DataFormatString="{0:MMM dd, yyyy}" />
                                <asp:BoundField HeaderText="Amount" DataField="Amount" DataFormatString="{0:C}" />
                                <asp:BoundField HeaderText="Method" DataField="Method" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </div>

        <script>
            function selectPaymentMethod(method) {
                document.getElementById('<%= hdnPaymentMethod.ClientID %>').value = method;

                // Remove selected class from all methods
                var methods = document.querySelectorAll('.payment-method');
                methods.forEach(function (m) {
                    m.classList.remove('selected');
                });

                // Add selected class to clicked method
                event.currentTarget.classList.add('selected');
            }

            // Select first payment method by default
            window.onload = function () {
                selectPaymentMethod('Credit Card');
            };
        </script>
    </form>
</body>
</html>