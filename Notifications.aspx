<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Notifications.aspx.cs" Inherits="CatResort.Notifications" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Notifications - Cat Resort</title>
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
            max-width: 1000px;
            margin-left: auto;
            margin-right: auto;
        }

        .notifications-header {
            text-align: center;
            margin-bottom: 40px;
            padding: 30px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(149, 117, 205, 0.1);
        }

        .notifications-header h2 {
            font-size: 28px;
            margin-bottom: 10px;
            color: #5a4a6a;
        }

        .notification-item {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 5px 20px rgba(149, 117, 205, 0.1);
            border-left: 4px solid #9575cd;
            transition: transform 0.3s;
            display: flex;
            align-items: flex-start;
            gap: 20px;
        }

        .notification-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(149, 117, 205, 0.15);
        }

        .notification-item.unread {
            border-left: 4px solid #ff6b6b;
            background: linear-gradient(135deg, #fff 0%, #fff5f5 100%);
        }

        .notification-icon {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, #ff9ec0 0%, #9575cd 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 20px;
            flex-shrink: 0;
        }

        .notification-item.unread .notification-icon {
            background: linear-gradient(135deg, #ff6b6b 0%, #ff5252 100%);
        }

        .notification-content {
            flex: 1;
        }

        .notification-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 10px;
            flex-wrap: wrap;
            gap: 10px;
        }

        .notification-title {
            font-weight: 600;
            color: #5a4a6a;
            font-size: 18px;
        }

        .notification-date {
            color: #7e6a9f;
            font-size: 14px;
            font-weight: 600;
            white-space: nowrap;
        }

        .notification-message {
            color: #5a4a6a;
            font-size: 16px;
            line-height: 1.5;
            margin-bottom: 15px;
        }

        .notification-actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }

        .btn-small {
            padding: 8px 16px;
            border: none;
            border-radius: 8px;
            font-family: 'Recursive', sans-serif;
            font-weight: 500;
            cursor: pointer;
            transition: 0.3s;
            font-size: 14px;
        }

        .btn-mark-read {
            background: linear-gradient(135deg, #4CAF50 0%, #45a049 100%);
            color: white;
            box-shadow: 0 2px 8px rgba(76, 175, 80, 0.3);
        }

        .btn-mark-read:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(76, 175, 80, 0.4);
        }

        .btn-delete {
            background: linear-gradient(135deg, #ff6b6b 0%, #ff5252 100%);
            color: white;
            box-shadow: 0 2px 8px rgba(255, 107, 107, 0.3);
        }

        .btn-delete:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(255, 107, 107, 0.4);
        }

        .no-notifications {
            text-align: center;
            padding: 60px 30px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(149, 117, 205, 0.1);
            color: #7e6a9f;
        }

        .no-notifications h3 {
            font-size: 24px;
            margin-bottom: 10px;
            color: #5a4a6a;
        }

        .no-notifications p {
            font-size: 16px;
            margin-bottom: 20px;
        }

        .filters {
            display: flex;
            gap: 15px;
            margin-bottom: 25px;
            flex-wrap: wrap;
        }

        .filter-btn {
            padding: 10px 20px;
            border: 2px solid #e1d7f2;
            background: white;
            color: #7e6a9f;
            border-radius: 25px;
            font-family: 'Recursive', sans-serif;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }

        .filter-btn.active {
            background: linear-gradient(135deg, #ff9ec0 0%, #9575cd 100%);
            color: white;
            border-color: transparent;
            box-shadow: 0 3px 10px rgba(149, 117, 205, 0.3);
        }

        .filter-btn:hover {
            transform: translateY(-1px);
            border-color: #b39ddb;
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

        @media (max-width: 768px) {
            .notification-header {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .notification-date {
                align-self: flex-end;
            }
            
            .navbar {
                padding: 12px 20px;
            }
            
            .navbar h1 {
                font-size: 20px;
            }
            
            .nav-buttons {
                flex-direction: column;
                gap: 10px;
            }
            
            .notification-item {
                flex-direction: column;
                text-align: center;
                gap: 15px;
            }
            
            .notification-actions {
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Navbar -->
        <div class="navbar">
            <h1>Cat Resort - Notifications</h1>
            <div class="nav-buttons">
                <asp:Button ID="btnDashboard" runat="server" Text="Dashboard" CssClass="btn btn-secondary" OnClick="btnDashboard_Click" />
                <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn logout-btn" OnClick="btnLogout_Click" />
            </div>
        </div>

        <div class="main-content">
            <asp:Label ID="lblMessage" runat="server" CssClass="message" Visible="false"></asp:Label>

            <!-- Notifications Header -->
            <div class="notifications-header">
                <h2>Your Notifications</h2>
                <p>Stay updated with important messages about your cat's care</p>
            </div>

            <!-- Filters -->
            <div class="filters">
                <button type="button" class="filter-btn active" onclick="filterNotifications('all')">All Notifications</button>
                <button type="button" class="filter-btn" onclick="filterNotifications('unread')">Unread</button>
                <button type="button" class="filter-btn" onclick="filterNotifications('read')">Read</button>
            </div>

            <!-- Notifications List -->
            <asp:Repeater ID="rptNotifications" runat="server" OnItemCommand="rptNotifications_ItemCommand">
                <ItemTemplate>
                    <div class="notification-item">
                        <div class="notification-content">
                            <p><strong>Message:</strong> <%# Eval("Message") %></p>
                            <p><strong>Date:</strong> <%# FormatDate(Eval("Date")) %></p>
                            <p><strong>Time:</strong> <%# Eval("FormattedTime") %></p>
                        </div>
                        <div class="notification-actions">
                            <asp:LinkButton ID="btnDelete" runat="server" 
                                CommandName="Delete" 
                                CommandArgument='<%# Eval("Notification_id") %>'
                                Text="Delete" 
                                CssClass="btn-delete" 
                                OnClientClick="return confirm('Are you sure you want to delete this notification?');" />
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>


            <!-- No Notifications Message -->
            <asp:Panel ID="pnlNoNotifications" runat="server" CssClass="no-notifications" Visible="false">
                <h3>No Notifications</h3>
                <p>You're all caught up! There are no notifications at the moment.</p>
                <p>New messages will appear here when you have updates about your cat's care.</p>
            </asp:Panel>

            <!-- Clear All Button -->
            <div style="text-align: center; margin-top: 30px;">
                <asp:Button ID="btnClearAll" runat="server" Text="Clear All Notifications" 
                    CssClass="btn logout-btn" OnClick="btnClearAll_Click"
                    OnClientClick="return confirm('Are you sure you want to delete all notifications? This action cannot be undone.');" />
            </div>
        </div>
    </form>

    <script>
        function filterNotifications(filter) {
            // Remove active class from all buttons
            document.querySelectorAll('.filter-btn').forEach(btn => {
                btn.classList.remove('active');
            });
            
            // Add active class to clicked button
            event.target.classList.add('active');
            
            // Filter logic would go here
            const notifications = document.querySelectorAll('.notification-item');
            
            notifications.forEach(notification => {
                switch (filter) {
                    case 'all':
                        notification.style.display = 'flex';
                        break;
                    case 'unread':
                        if (notification.classList.contains('unread')) {
                            notification.style.display = 'flex';
                        } else {
                            notification.style.display = 'none';
                        }
                        break;
                    case 'read':
                        if (!notification.classList.contains('unread')) {
                            notification.style.display = 'flex';
                        } else {
                            notification.style.display = 'none';
                        }
                        break;
                }
            });
        }

        // Initialize with all notifications showing
        document.addEventListener('DOMContentLoaded', function() {
            filterNotifications('all');
        });
    </script>
</body>
</html>