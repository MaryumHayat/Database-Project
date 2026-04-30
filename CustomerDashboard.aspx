<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CustomerDashboard.aspx.cs" Inherits="CatResort.CustomerDashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Customer Dashboard - Cat Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Recursive:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>
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
            color: #772695;            
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .logout-btn {
            background: linear-gradient(135deg, #ff9ec0 0%, #9575cd 100%);
            color: white;
            font-weight: 600;
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 20px;
            transition: 0.3s;
            box-shadow: 0 3px 10px rgba(149, 117, 205, 0.3);
            border: none;
            cursor: pointer;
            font-family: 'Recursive', sans-serif;
        }

        .logout-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(149, 117, 205, 0.4);
        }

        /* Video Hero Section */
        .video-hero {
            position: relative;
            height: 90vh;
            margin-top: 70px;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .video-background {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            z-index: 1;
        }

        .video-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, rgba(149, 117, 205, 0.6) 0%, rgba(255, 255, 255, 0.2) 100%);
            z-index: 2;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
        }

        .hero-content {
            position: relative;
            z-index: 3;
            color: white;
            max-width: 800px;
            padding: 0 20px;
        }

        .hero-content h2 {
            font-size: 3.5rem;
            font-weight: 700;
            margin-bottom: 20px;
            text-shadow: 2px 2px 8px rgba(0, 0, 0, 0.5);
        }

        .hero-content p {
            font-size: 1.4rem;
            margin-bottom: 30px;
            text-shadow: 1px 1px 4px rgba(0, 0, 0, 0.5);
            opacity: 0.95;
        }

        .cta-button {
            display: inline-block;
            padding: 15px 40px;
            background: rgba(255, 255, 255, 0.9);
            color: #9575cd;
            text-decoration: none;
            border-radius: 30px;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }

        .cta-button:hover {
            background: white;
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.3);
        }

        .main-content {
            padding: 60px 30px;
            background: linear-gradient(135deg, #fdf2ff 0%, #f2fdff 100%);
        }

        .welcome-section {
            text-align: center;
            margin-bottom: 40px;
            padding: 30px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(149, 117, 205, 0.1);
        }

        .welcome-section h2 {
            font-size: 28px;
            margin-bottom: 10px;
            color: #5a4a6a;
        }

        .welcome-section p {
            color: #7e6a9f;
            font-size: 16px;
        }

        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }

        .card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 5px 20px rgba(149, 117, 205, 0.1);
            transition: transform 0.3s;
        }

        .card:hover {
            transform: translateY(-5px);
        }

        .card h3 {
            color: #5a4a6a;
            margin-bottom: 15px;
            font-size: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .card-icon {
            width: 24px;
            height: 24px;
            background: linear-gradient(135deg, #ff9ec0 0%, #9575cd 100%);
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 12px;
        }

        .btn {
            padding: 12px 25px;
            border: none;
            border-radius: 10px;
            font-family: 'Recursive', sans-serif;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .btn-primary {
            background: linear-gradient(135deg, #ff9ec0 0%, #9575cd 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(149, 117, 205, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(149, 117, 205, 0.4);
        }

        /* Updated Table Styles */
        .table-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(149, 117, 205, 0.1);
            overflow: hidden;
            margin-bottom: 30px;
        }

        .table-container h3 {
            padding: 20px;
            margin: 0;
            color: #5a4a6a;
            background: linear-gradient(135deg, #f8f4ff 0%, #f0eaf9 100%);
            border-bottom: 1px solid #f0eaf9;
        }

        .table-wrapper {
            max-height: 250px; /* Adjust this value to control visible rows */
            overflow-y: auto;
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 600px; /* Ensures table doesn't get too narrow */
        }

        th, td {
            padding: 10px 15px; /* Reduced padding for narrower rows */
            text-align: left;
            border-bottom: 1px solid #f0eaf9;
            font-size: 14px; /* Slightly smaller font */
            line-height: 1.3; /* Tighter line height */
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
            height: 40px; /* Fixed height for consistent narrow rows */
        }

        tr:hover {
            background-color: #faf7ff;
        }

        /* Custom scrollbar for table wrapper */
        .table-wrapper::-webkit-scrollbar {
            width: 8px;
            height: 8px;
        }

        .table-wrapper::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 4px;
        }

        .table-wrapper::-webkit-scrollbar-thumb {
            background: linear-gradient(135deg, #ff9ec0 0%, #9575cd 100%);
            border-radius: 4px;
        }

        .table-wrapper::-webkit-scrollbar-thumb:hover {
            background: linear-gradient(135deg, #ff8ab4 0%, #8465c4 100%);
        }

        .notification-badge {
            background: #ff6b6b;
            color: white;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            margin-left: 5px;
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

        /* Grid View specific styles */
        .grid-view {
            width: 100%;
            border-collapse: collapse;
        }

        .grid-view th,
        .grid-view td {
            padding: 10px 15px;
            text-align: left;
            border-bottom: 1px solid #f0eaf9;
            font-size: 14px;
            line-height: 1.3;
        }

        .grid-view tr {
            height: 40px;
        }

        @media (max-width: 768px) {
            .dashboard-grid {
                grid-template-columns: 1fr;
            }
            
            .navbar {
                padding: 12px 20px;
            }
            
            .navbar h1 {
                font-size: 20px;
            }
            
            .video-hero {
                height: 50vh;
            }
            
            .hero-content h2 {
                font-size: 2.5rem;
            }
            
            .hero-content p {
                font-size: 1.1rem;
            }

            .table-wrapper {
                max-height: 200px;
            }

            th, td {
                padding: 8px 12px;
                font-size: 13px;
            }

            tr {
                height: 35px;
            }
        }

        @media (max-width: 480px) {
            .video-hero {
                height: 40vh;
            }
            
            .hero-content h2 {
                font-size: 2rem;
            }
            
            .hero-content p {
                font-size: 1rem;
            }
            
            .cta-button {
                padding: 12px 30px;
                font-size: 1rem;
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
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Navbar -->
        <div class="navbar">
            <h1>Cat Resort - Customer Portal</h1>
            <div class="user-info">
                <span>Welcome, <asp:Label ID="lblCustomerName" runat="server" Font-Bold="true"></asp:Label></span>
                <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="logout-btn" OnClick="btnLogout_Click" />
            </div>
        </div>

        <!-- Video Hero Section -->
        <div class="video-hero">
            <video class="video-background" autoplay="autoplay" muted="muted" loop="loop" playsinline="playsinline">
                <source src="https://v1.pinimg.com/videos/mc/expMp4/24/8b/ce/248bcea49922428457beec8f14befb01_t1.mp4" type="video/mp4" />
                Your browser does not support the video tag.
            </video>
            <div class="video-overlay"></div>
            <div class="hero-content">
                <h2>Welcome to Cat Resort</h2>
                <p>Where your feline friends receive the royal treatment they deserve</p>
                <a href="#dashboard" class="cta-button">Explore Your Dashboard</a>
            </div>
        </div>

        <!-- Main Content -->
        <div class="main-content" id="dashboard">
            <asp:Label ID="lblMessage" runat="server" CssClass="message" Visible="false"></asp:Label>

            <!-- Welcome Section -->
            <div class="welcome-section">
                <h2>Welcome to Your Dashboard, <asp:Label ID="lblWelcomeName" runat="server"></asp:Label>!</h2>
                <p>Manage your cat's care, view payments, and stay updated with notifications</p>
            </div>

            <!-- Quick Actions -->
            <div class="dashboard-grid">
                <div class="card">
                    <h3><span class="card-icon">🐱</span> My Profile</h3>
                    <p>View and update your personal information and cat details</p>
                    <asp:Button ID="btnViewProfile" runat="server" Text="View Profile" CssClass="btn btn-primary" OnClick="btnViewProfile_Click" />
                </div>

            <div class="card">
                <h3><span class="card-icon">📅</span> Make Appointment</h3>
                <p>Schedule a visit for grooming, vet check, or consultation</p>
                <asp:Button ID="btnMakeAppointment" runat="server" Text="Make Appointment" 
                    CssClass="btn btn-primary" OnClick="btnMakeAppointment_Click" />
            </div>


                <div class="card">
                    <h3><span class="card-icon">💳</span> Make Payment</h3>
                    <p>Pay for services and view payment history</p>
                    <asp:Button ID="btnMakePayment" runat="server" Text="Make Payment" CssClass="btn btn-primary" OnClick="btnMakePayment_Click" />
                </div>

                <div class="card">
                    <h3><span class="card-icon">🔔</span> Notifications 
                        <asp:Label ID="lblNotificationCount" runat="server" CssClass="notification-badge" Visible="false"></asp:Label>
                    </h3>
                    <p>Stay updated with important messages and alerts</p>
                    <asp:Button ID="btnViewNotifications" runat="server" Text="View Notifications" CssClass="btn btn-primary" OnClick="btnViewNotifications_Click" />
                </div>
            </div>

            <!-- Recent Payments -->
            <div class="table-container">
                <h3>Recent Payments</h3>
                <div class="table-wrapper">
                    <asp:GridView ID="gvPayments" runat="server" AutoGenerateColumns="False" Width="100%">
                        <Columns>
                            <asp:BoundField HeaderText="Payment ID" DataField="Payment_id" />
                            <asp:BoundField HeaderText="Date" DataField="Date" DataFormatString="{0:MMM dd, yyyy}" />
                            <asp:BoundField HeaderText="Amount" DataField="Amount" DataFormatString="{0:C}" />
                            <asp:BoundField HeaderText="Method" DataField="Method" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>

            <!-- Recent Notifications -->
            <div class="table-container">
                <h3>Recent Notifications</h3>
                <div class="table-wrapper">
                    <asp:GridView ID="gvNotifications" runat="server" AutoGenerateColumns="False" CssClass="grid-view">
                        <Columns>
                            <asp:BoundField DataField="Message" HeaderText="Message" />
                            <asp:BoundField DataField="Date" HeaderText="Date" DataFormatString="{0:MMM dd, yyyy}" />
                            <asp:BoundField DataField="FormattedTime" HeaderText="Time" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </form>

    <script>
        // Smooth scroll for CTA button
        document.querySelector('.cta-button').addEventListener('click', function (e) {
            e.preventDefault();
            document.querySelector('#dashboard').scrollIntoView({
                behavior: 'smooth'
            });
        });

        // Add fallback image if video fails to load
        document.querySelector('.video-background').addEventListener('error', function () {
            this.style.backgroundImage = 'linear-gradient(135deg, #ff9ec0 0%, #9575cd 100%)';
            this.innerHTML = '';
        });
    </script>
</body>
</html>