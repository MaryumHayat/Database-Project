<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="CatResort.Login" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Staff / Vet Login</title>
    <style>
        body { font-family:"Segoe UI",sans-serif; background: #e6f7ff; display:flex; justify-content:center; align-items:center; height:100vh; }
        .login-container { background:white; padding:40px; border-radius:15px; box-shadow:0 5px 20px rgba(0,0,0,0.2); width:350px; }
        h2 { text-align:center; color:#ff4d94; margin-bottom:25px; }
        input[type="text"], input[type="password"] { width:100%; padding:12px; margin-bottom:15px; border-radius:8px; border:2px solid #ffd9ec; }
        input[type="text"]:focus, input[type="password"]:focus { border-color:#ff4d94; }
        .btn-login { width:100%; padding:12px; background:#ff66a3; border:none; color:white; font-weight:600; border-radius:8px; cursor:pointer; transition:0.3s; }
        .btn-login:hover { background:#ff3385; }
        #lblMessage { display:block; text-align:center; color:red; margin-top:10px; font-weight:600; }
    </style>
</head>
<body>

<form id="form1" runat="server">
    <div class="login-container">
        <h2>Login</h2>
        <asp:TextBox ID="txtUsername" runat="server" placeholder="Username"></asp:TextBox>
        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="Password"></asp:TextBox>
        <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn-login" OnClick="btnLogin_Click" />
        <asp:Label ID="lblMessage" runat="server" Text="" />
    </div>
</form>

</body>
</html>
