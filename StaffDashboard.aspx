<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StaffDashboard.aspx.cs" Inherits="CatResort.StaffDashboard" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Staff Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <style>
        body { background: linear-gradient(135deg,#ffe6f2,#e6f7ff); padding-top:80px; font-family:"Segoe UI",sans-serif; }
        .navbar { width:100%; height:70px; background:rgba(255,255,255,0.5); backdrop-filter:blur(10px); position:fixed; top:0; left:0; padding:0 40px; display:flex; align-items:center; justify-content:space-between; z-index:999; border-bottom:1px solid rgba(255,255,255,0.4); }
        .navbar a { margin-left:20px; color:#444; text-decoration:none; font-weight:600; }
        .navbar a:hover { color:#ff4d94; }
        .container-box { width:90%; margin:auto; background:white; padding:30px; border-radius:20px; box-shadow:0 10px 40px rgba(0,0,0,0.1); }
        h2 { text-align:center; color:#ff4d94; margin-bottom:20px; }

        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(100px, 1fr));
            gap: 10px;
            padding: 10px 0;
        }
        .dashboard-card {
            background: #96087e;
            color:aliceblue;
            border-radius: 15px;
            padding: 10px;
            text-align: center;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            transition: 0.3s;
            cursor: pointer;
            border: 1px solid #f9cfe1;
        }
        .dashboard-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(255,51,133,0.25);
            border-color: #ff4d94;
        }
        .dashboard-card i {
            font-size: 38px;
            color: #ff4d94;
        }
        .dashboard-card h4 { margin-top: 10px; font-weight: 700; }

        .appt-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 20px;
        }
        .appt-card {
            background: #fff;
            padding: 20px;
            border-radius: 15px;
            border: 1px solid #ffd9ec;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
        }
        .appt-card h5 { margin-bottom: 10px; font-weight: 700; color:#ff4d94; }
        .appt-card p { margin: 5px 0; }
        .btn-small { padding: 8px 15px; border-radius: 8px; font-size: 14px; }
    </style>
</head>

<body>
    <div class="navbar">
        <div style="font-weight:700; font-size:22px; color:#ff4d94;">Staff Portal</div>
        <div>
            
            <a href="StaffProfile.aspx">Profile</a>
            <a href="Dashboard.aspx">Logout</a>
        </div>
    </div>

    <form id="form1" runat="server">
        <div class="container-box">
            <h2>Quick Menu</h2>

            <div class="dashboard-grid">
                <asp:Button ID="btnGoTasks" runat="server" CssClass="dashboard-card" OnClick="btnGoTasks_Click" Text="Tasks" />
                <asp:Button ID="btnGoRooms" runat="server" CssClass="dashboard-card" OnClick="btnGoRooms_Click" Text="Rooms" />
                <asp:Button ID="btnGoCatCare" runat="server" CssClass="dashboard-card" OnClick="btnGoCatCare_Click" Text="Cat Care" />
                <asp:Button ID="btnGoReports" runat="server" CssClass="dashboard-card" OnClick="btnGoReports_Click" Text="Reports" />
            </div>

            <script>
                document.addEventListener("DOMContentLoaded", () => {
                    document.getElementById("btnGoTasks").innerHTML = `<i class="bi bi-list-check"></i><h4>Tasks</h4>`;
                    document.getElementById("btnGoRooms").innerHTML = `<i class="bi bi-door-open"></i><h4>Rooms</h4>`;
                    document.getElementById("btnGoCatCare").innerHTML = `<i class="bi bi-heart"></i><h4>Cat Care</h4>`;
                    document.getElementById("btnGoReports").innerHTML = `<i class="bi bi-bar-chart"></i><h4>Reports</h4>`;
                });
            </script>

            <h2>Pending Appointments</h2>
            <asp:TextBox ID="txtFilterDate" runat="server" placeholder="MM/dd/yyyy" CssClass="form-control"></asp:TextBox>
            <asp:Button ID="btnFilterApp" runat="server" CssClass="btn btn-info btn-small mt-2" Text="Filter" OnClick="btnFilterApp_Click" />

            <div class="appt-grid mt-4">
                <asp:Repeater ID="rptAppointments" runat="server">
                    <ItemTemplate>
                        <div class="appt-card">
                            <h5>Appointment #<%# Eval("Appointment_id") %></h5>
                            <p><b>Cat:</b> <%# Eval("CatName") %></p>
                            <p><b>Purpose:</b> <%# Eval("Purpose") %></p>
                            <p><b>Date:</b> <%# Convert.ToDateTime(Eval("Date")).ToString("MM/dd/yyyy") %></p>
                            <p><b>Time:</b> <%# Eval("Time") %></p>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </form>
</body>
</html>
