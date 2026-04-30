<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StaffProfile.aspx.cs" Inherits="CatResort.StaffProfile" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>My Profile</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet" />

    <style>
        body {
            position: relative;
            background-image: url('https://www.thisisdimashq.com/wp-content/uploads/2024/11/mango-cat-hotel-thapra-bangkok-q7h3x-Screenshot2023-06-28at17.10.03.png');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            padding-top: 80px;
            font-family: "Segoe UI", sans-serif;
        }

        /* Gray Overlay */
        body::before {
            content: "";
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(45, 45, 45, 0.45); /* Gray tint */
            z-index: -1;
        }

        .profile-card {
            margin: auto;
            width: 420px;
            background: white;
            padding: 30px;
            border-radius: 20px;
            box-shadow: 0 10px 35px rgba(0,0,0,0.1);
        }

        h3 {
            text-align:center;
            color:#ff4d94;
            margin-bottom:25px;
        }

        .info {
            font-size:16px;
            margin-bottom:12px;
        }
    </style>
</head>
<body>

<form runat="server">

    <div class="profile-card">
        <h3>My Profile</h3>

        <div class="info"><b>Name:</b> <asp:Label ID="lblName" runat="server" /></div>
        <div class="info"><b>Email:</b> <asp:Label ID="lblEmail" runat="server" /></div>
        <div class="info"><b>Phone:</b> <asp:Label ID="lblPhone" runat="server" /></div>
        <div class="info"><b>Address:</b> <asp:Label ID="lblAddress" runat="server" /></div>
        <div class="info"><b>Role:</b> <asp:Label ID="lblRole" runat="server" /></div>
        <div class="info"><b>Salary:</b> <asp:Label ID="lblSalary" runat="server" /></div>

        <a href="StaffDashboard.aspx" class="btn btn-primary w-100 mt-3">Back to Dashboard</a>
    </div>

</form>

</body>
</html>
