<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CustomerProfile.aspx.cs" Inherits="CatResort.CustomerProfile" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>My Profile - Cat Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Recursive:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

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
            font-size: 24px;
            color: #772695;
            font-weight: 700;
        }

        .nav-buttons { display: flex; gap: 15px; align-items: center; }

        .btn { padding: 8px 20px; border-radius: 20px; font-weight: 600; cursor: pointer; transition: 0.3s; text-decoration: none; }
        .btn-secondary { background: linear-gradient(135deg, #9575cd 0%, #7986cb 100%); color: white; }
        .logout-btn { background: linear-gradient(135deg, #ff6b6b 0%, #ff5252 100%); color: white; }

        .main-content { margin-top: 80px; padding: 30px; max-width: 900px; margin-left: auto; margin-right: auto; }

        .profile-header {
            text-align: center;
            margin-bottom: 40px;
            padding: 30px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(149, 117, 205, 0.1);
        }

        .profile-header h2 { font-size: 28px; margin-bottom: 10px; color: #5a4a6a; }

        .profile-card {
            background: white;
            border-radius: 15px;
            padding: 20px; /* reduced padding */
            box-shadow: 0 5px 20px rgba(149, 117, 205, 0.1);
            margin-bottom: 15px; /* reduced margin */
        }

        .profile-card h3 { font-size: 22px; margin-bottom: 15px; border-bottom: 2px solid #f0eaf9; padding-bottom: 10px; }

        .form-group { margin-bottom: 15px; } /* reduced margin */
        .form-group label { display: block; margin-bottom: 8px; font-weight: 600; color: #7e6a9f; font-size: 14px; }
        .form-control { width: 100%; padding: 10px 12px; border: 2px solid #e1d7f2; border-radius: 10px; font-size: 16px; font-family: 'Recursive', sans-serif; transition: all 0.3s; background-color: #faf7ff; }
        .form-control:focus { border-color: #b39ddb; outline: none; box-shadow: 0 0 0 3px rgba(179, 157, 219, 0.2); background-color: white; }
        .form-control[readonly] { background-color: #f5f5f5; color: #666; }

        
        .btn-primary { background: linear-gradient(135deg, #ff9ec0 0%, #9575cd 100%); color: white; padding: 12px 30px; box-shadow: 0 4px 15px rgba(149, 117, 205, 0.3); border-radius: 20px; }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(149, 117, 205, 0.4); }

        .contact-info { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }

        /* PERSONAL INFO IMAGE SIDE BY SIDE */
        .personal-wrapper { display: flex; width: 100%; gap: 25px; margin-bottom: 25px; }
        
            .personal-image {
            width: 45%;
            height: 550px; /* adjust if needed */
            background-image: url('https://i.pinimg.com/736x/ce/9e/88/ce9e8845051fc3c0b69fa1501c870ad6.jpg');
            background-size: cover; /* slightly zoomed to fill div */
            background-position: center top; /* adjust vertical position if needed */
            background-repeat: no-repeat;
            border-radius: 5px;
        }
        .personal-card { width: 55%; }

        /* MOBILE RESPONSIVE */
        @media (max-width: 900px) {
            .personal-wrapper { flex-direction: column; }
            .personal-image { width: 100%; height: 250px; }
            .personal-card { width: 100%; }
            .contact-info { grid-template-columns: 1fr; }
        }
    </style>
</head>

<body>
<form id="form1" runat="server">

    <!-- NAVBAR -->
    <div class="navbar">
        <h1>Cat Resort - My Profile</h1>
        <div class="nav-buttons">
            <asp:Button ID="btnDashboard" runat="server" Text="Dashboard" CssClass="btn btn-secondary" OnClick="btnDashboard_Click" />
            <asp:Button ID="btnMyCats" runat="server" Text="My Cats" CssClass="btn btn-secondary" OnClick="btnMyCats_Click" />
            <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn logout-btn" OnClick="btnLogout_Click" />
        </div>
    </div>

    <div class="main-content">

        <asp:Label ID="lblMessage" runat="server" CssClass="message" Visible="false"></asp:Label>

        <!-- PAGE HEADER -->
        <div class="profile-header">
            <h2>My Profile</h2>
            <p>Manage your personal information and contact details</p>
        </div>

        <!-- PERSONAL INFORMATION SIDE BY SIDE WITH IMAGE -->
        <div class="personal-wrapper">

            <div class="personal-image"></div>

            <div class="profile-card personal-card">
                <h3>Personal Information</h3>

                <div class="form-group">
                    <label for="txtFirstName">First Name</label>
                    <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label for="txtLastName">Last Name</label>
                    <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label for="txtAddress">Address</label>
                    <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label for="txtCats">Number of Cats</label>
                    <asp:TextBox ID="txtCats" runat="server" CssClass="form-control" TextMode="Number" min="0"></asp:TextBox>
                </div>
            </div>

        </div>

        <!-- CONTACT INFORMATION BELOW -->
        <div class="profile-card">
            <h3>Contact Information</h3>
            <div class="contact-info">
                <div class="form-group">
                    <label for="txtEmail">Email Address</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label for="txtPhone">Phone Number</label>
                    <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
            </div>
        </div>

        <!-- UPDATE BUTTON -->
        <div style="text-align:center;">
            <asp:Button ID="btnUpdate" runat="server" Text="Update Profile" CssClass="btn btn-primary" OnClick="btnUpdate_Click" />
        </div>

    </div> <!-- end main-content -->

</form>
</body>
</html>
