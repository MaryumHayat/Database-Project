<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="VetDashboard.aspx.cs" Inherits="CatResort.VetDashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Vet Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Recursive:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"/>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Recursive', sans-serif; background: linear-gradient(135deg, #f0fff4 0%, #f8fff0 100%); color: #2d5a3d; line-height:1.4; min-height: 100vh; }
        .navbar { position: fixed; top:0; width:100%; background: rgba(255,255,255,0.98); backdrop-filter: blur(10px); box-shadow: 0 2px 15px rgba(100, 200, 150, 0.1); display: flex; justify-content: space-between; align-items: center; padding: 12px 30px; z-index: 1000; height: 65px; border-bottom: 1px solid #e0f7e9; }
        .navbar h1 { font-size: 24px; font-weight: 700; background: linear-gradient(135deg, #66bb6a 0%, #81c784 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; letter-spacing: 0.5px; }
        .logout-btn { background: linear-gradient(135deg, #66bb6a 0%, #81c784 100%); color: white; font-weight: 600; padding: 8px 20px; border: none; cursor: pointer; font-size: 14px; transition: all 0.3s ease; border-radius: 6px; display: flex; align-items: center; gap: 6px; box-shadow: 0 3px 12px rgba(102, 187, 106, 0.25); }
        .logout-btn:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(102, 187, 106, 0.35); background: linear-gradient(135deg, #57a85a 0%, #6cb56f 100%); }
        .main-content { margin-top: 80px; padding: 25px 30px; max-width: 1400px; margin-left: auto; margin-right: auto; }
        .page-title { text-align: center; margin-bottom: 30px; font-size: 28px; font-weight: 700; color: #2d5a3d; position: relative; padding-bottom: 15px; }
        .page-title:after { content: ''; position: absolute; bottom: 0; left: 50%; transform: translateX(-50%); width: 80px; height: 3px; background: linear-gradient(to right, #66bb6a, #81c784); border-radius: 2px; }
        .dashboard-container { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 25px; justify-content: center; }
        .dashboard-card { background: white; box-shadow: 0 4px 20px rgba(102, 187, 106, 0.12); text-align: center; border-radius: 12px; transition: all 0.3s ease; padding: 25px 20px; border: 1px solid #e8f5e9; position: relative; overflow: hidden; }
        .dashboard-card:hover { transform: translateY(-5px); box-shadow: 0 8px 25px rgba(102, 187, 106, 0.2); border-color: #c8e6c9; }
        .dashboard-card h3 { margin-bottom: 12px; color: #2d5a3d; font-size: 18px; font-weight: 600; }
        .dashboard-card p { font-size: 13px; color: #5a8a6a; margin-bottom: 20px; line-height: 1.5; }
        .btn-primary { padding: 10px 22px; border: none; background: linear-gradient(135deg, #66bb6a 0%, #81c784 100%); color: white; font-weight: 600; cursor: pointer; text-decoration: none; display: inline-block; border-radius: 6px; transition: all 0.3s ease; font-size: 14px; box-shadow: 0 3px 10px rgba(102, 187, 106, 0.2); }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(102, 187, 106, 0.3); background: linear-gradient(135deg, #57a85a 0%, #6cb56f 100%); }
        footer { text-align: center; padding: 20px 0; background: white; color: #5a8a6a; font-weight: 500; box-shadow: 0 -2px 10px rgba(102, 187, 106, 0.08); margin-top: 40px; font-size: 14px; border-top: 1px solid #e8f5e9; }
        .icon-wrapper { width: 50px; height: 50px; background: linear-gradient(135deg, #e8f5e9, #c8e6c9); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 15px; color: #66bb6a; font-size: 22px; }
        .welcome-message { text-align: center; margin-bottom: 30px; color: #5a8a6a; font-size: 16px; background: white; padding: 15px; border-radius: 10px; box-shadow: 0 3px 10px rgba(102, 187, 106, 0.1); border: 1px solid #e8f5e9; max-width: 800px; margin-left: auto; margin-right: auto; }
        .btn-back { background: transparent; border: 1px solid #66bb6a; color: #66bb6a; padding: 8px 18px; border-radius: 6px; font-weight: 600; cursor: pointer; transition: all 0.3s ease; margin-right: 10px; display: flex; align-items: center; gap: 5px; }
        .btn-back:hover { background: rgba(102, 187, 106, 0.1); transform: translateY(-1px); }
        .card-content { display: flex; flex-direction: column; height: 100%; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="navbar">
            <h1><i class="bi bi-heart-pulse"></i> Cat Resort Veterinary Portal</h1>
            <div>
                <asp:LinkButton runat="server" ID="btnBack" CssClass="btn-back" OnClick="btnBack_Click">
                    <i class="bi bi-arrow-left"></i> Back
                </asp:LinkButton>
                <asp:LinkButton runat="server" ID="btnLogout" CssClass="logout-btn" OnClick="btnLogout_Click">
                    <i class="bi bi-box-arrow-right"></i> Logout
                </asp:LinkButton>
            </div>
        </div>

        <div class="main-content">
            <h2 class="page-title">Veterinary Dashboard</h2>
            
            <div class="welcome-message">
                <i class="bi bi-heart-fill" style="color:#66bb6a; margin-right:8px;"></i>
                Welcome, <asp:Label ID="lblVetName" runat="server" Font-Bold="true"></asp:Label>!
            </div>

            <div class="dashboard-container">
                <!-- Today's Check-ups -->
                <div class="dashboard-card emergency-card">
                    <div class="card-container">
                        <div class="icon-wrapper"><i class="bi bi-calendar-check"></i></div>
                        <div class="card-content">
                            <h3>Check-ups</h3>
                            <p>Cats due for veterinary examination today</p>
                            <asp:HyperLink runat="server" NavigateUrl="~/VetCheckups.aspx" CssClass="btn-primary">
                                <i class="bi bi-eye"></i> View Schedule
                            </asp:HyperLink>
                        </div>
                    </div>
                </div>

                <!-- Vaccinations Due -->
                <div class="dashboard-card info-card">
                    <div class="card-container">
                        <div class="icon-wrapper"><i class="bi bi-shield-check"></i></div>
                        <div class="card-content">
                            <h3>Vaccinations Due</h3>
                            <p>Cats needing vaccination updates</p>
                            <asp:HyperLink runat="server" NavigateUrl="~/VetVaccination.aspx" CssClass="btn-primary">
                                <i class="bi bi-shield-plus"></i> Vaccination Records
                            </asp:HyperLink>
                        </div>
                    </div>
                </div>

                              
            </div>
        </div>

        <footer>
            <i class="bi bi-heart-fill" style="color:#66bb6a; margin-right:5px;"></i>
            © 2025 Cat Resort Veterinary Services. Providing compassionate care for every feline friend.
        </footer>
    </form>
</body>
</html>
