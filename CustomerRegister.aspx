<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CustomerRegister.aspx.cs" Inherits="CatResort.CustomerRegister" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Register - Cat Resort</title>
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
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(149, 117, 205, 0.2);
            padding: 40px;
            width: 100%;
            max-width: 500px;
        }

        .logo {
            text-align: center;
            margin-bottom: 30px;
        }

        .logo h1 {
            font-family: 'Recursive', sans-serif;
            font-size: 32px;
            font-weight: 700;
            background: linear-gradient(135deg, #ff9ec0 0%, #9575cd 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 10px;
        }

        .logo p {
            color: #7e6a9f;
            font-size: 16px;
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
            width: 100%;
            padding: 15px;
            border: none;
            border-radius: 10px;
            background: linear-gradient(135deg, #ff9ec0 0%, #9575cd 100%);
            color: white;
            font-family: 'Recursive', sans-serif;
            font-weight: 600;
            font-size: 16px;
            cursor: pointer;
            transition: 0.3s;
            box-shadow: 0 4px 15px rgba(149, 117, 205, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(149, 117, 205, 0.4);
        }

        .login-link {
            text-align: center;
            margin-top: 25px;
            color: #7e6a9f;
        }

        .login-link a {
            color: #9575cd;
            text-decoration: none;
            font-weight: 600;
        }

        .login-link a:hover {
            text-decoration: underline;
        }

        .message {
            padding: 12px;
            border-radius: 8px;
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
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="logo">
                <h1>Cat Resort</h1>
                <p>Create your account</p>
            </div>

            <asp:Label ID="lblMessage" runat="server" CssClass="message" Visible="false"></asp:Label>
            
            <div class="form-group">
                <label for="txtFirstName">First Name</label>
                <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" placeholder="Enter first name" required></asp:TextBox>
            </div>
            
            <div class="form-group">
                <label for="txtLastName">Last Name</label>
                <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" placeholder="Enter last name" required></asp:TextBox>
            </div>
            
            <div class="form-group">
                <label for="txtAddress">Address</label>
                <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" placeholder="Enter your address" TextMode="MultiLine" Rows="3"></asp:TextBox>
            </div>
            
            <div class="form-group">
                <label for="txtCats">Number of Cats</label>
                <asp:TextBox ID="txtCats" runat="server" CssClass="form-control" placeholder="How many cats do you have?" TextMode="Number" min="0"></asp:TextBox>
            </div>
            
            <div class="form-group">
                <label for="txtEmail">Email Address</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Enter email address" TextMode="Email" required></asp:TextBox>
            </div>
            
            <div class="form-group">
                <label for="txtPhone">Phone Number</label>
                <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="Enter phone number" required></asp:TextBox>
            </div>

            <asp:Button ID="btnRegister" runat="server" Text="Create Account" CssClass="btn-primary" OnClick="btnRegister_Click" />
            
            <div class="login-link">
                Already have an account? <a href="CustomerLogin.aspx">Sign in here</a>
            </div>
        </div>
    </form>
</body>
</html>