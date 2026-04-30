<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StaffReport.aspx.cs" Inherits="CatResort.StaffReport" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Staff Reports - Cat Resort</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <style>
        body { 
            background: linear-gradient(135deg, #fff9e6, #fff0d9); 
            padding-top: 30px; 
            font-family: "Segoe UI", Arial, sans-serif; 
            font-size: 14px;
        }
        .main-container { 
            width: 95%; 
            margin: auto; 
            background: white; 
            padding: 25px; 
            border-radius: 15px; 
            box-shadow: 0 5px 20px rgba(0,0,0,0.08); 
        }
        h2 { 
            text-align: center; 
            color: #ff9800; 
            margin-bottom: 25px; 
            font-size: 24px;
            font-weight: 600;
        }
        .btn-back { 
            position: fixed; 
            top: 20px; 
            left: 20px; 
            background: #ff9800; 
            color: white; 
            padding: 8px 15px; 
            border-radius: 8px; 
            border: none; 
            font-weight: 500; 
            font-size: 14px;
            cursor: pointer; 
            z-index: 1000; 
            transition: 0.3s; 
        }
        .btn-back:hover { 
            background: #f57c00; 
            transform: translateY(-2px);
        }
        .btn-primary { 
            background: #ffb74d; 
            border: none; 
            color: white; 
            padding: 8px 16px; 
            border-radius: 8px; 
            cursor: pointer; 
            transition: 0.3s; 
            font-weight: 500;
            font-size: 14px;
        }
        .btn-primary:hover { 
            background: #ff9800; 
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(255, 152, 0, 0.2);
        }
        .btn-outline { 
            background: transparent; 
            border: 1px solid #ffb74d; 
            color: #ff9800; 
            padding: 8px 16px; 
            border-radius: 8px; 
            cursor: pointer; 
            transition: 0.3s; 
            font-weight: 500;
            font-size: 14px;
        }
        .btn-outline:hover { 
            background: #ffb74d; 
            color: white;
        }
        .stat-card { 
            background: linear-gradient(135deg, #ffecb3, #ffe082); 
            color: #5d4037; 
            padding: 12px; 
            border-radius: 10px; 
            text-align: center; 
            margin-bottom: 12px; 
            min-height: 100px; 
            display: flex; 
            flex-direction: column; 
            justify-content: center;
            border: 1px solid #ffd54f;
            box-shadow: 0 3px 6px rgba(0,0,0,0.05);
        }
        .stat-number { 
            font-size: 1.8em; 
            font-weight: 700; 
            margin-bottom: 3px;
            color: #e65100;
        }
        .stat-label { 
            font-size: 0.85em; 
            opacity: 0.8;
            font-weight: 500;
        }
        .report-section { 
            background: #fffcf5; 
            padding: 18px; 
            border-radius: 12px; 
            border: 1px solid #ffecb3; 
            margin-bottom: 20px; 
            box-shadow: 0 3px 8px rgba(0,0,0,0.04);
        }
        .section-title { 
            color: #ff9800; 
            border-bottom: 2px solid #ffd54f; 
            padding-bottom: 8px; 
            margin-bottom: 18px; 
            font-weight: 600;
            font-size: 18px;
        }
        .grid-container { 
            max-height: 250px; 
            overflow-y: auto;
            border: 1px solid #eee;
            border-radius: 8px;
            padding: 1px;
        }
        .grid-header { 
            background-color: #ff9800 !important; 
            color: white !important;
            font-size: 13px;
            font-weight: 600;
        }
        .action-buttons { 
            text-align: right; 
            margin-bottom: 20px; 
        }
        .clickable-row { 
            cursor: pointer; 
            font-size: 13px;
        }
        .clickable-row:hover { 
            background-color: #fff8e1 !important; 
        }
        h5 {
            color: #ff8f00;
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 15px;
        }
        h6 {
            color: #ffa726;
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 10px;
        }
        .table {
            font-size: 13px;
            margin-bottom: 0;
        }
        .table thead th {
            border-top: none;
        }
        .table td, .table th {
            padding: 8px 12px;
            vertical-align: middle;
        }
        strong {
            color: #ff6f00;
            font-weight: 600;
        }
        .text-muted {
            color: #8d6e63 !important;
        }
        .badge {
            font-size: 0.75em;
            padding: 3px 8px;
        }
        .icon-small {
            font-size: 0.9em;
            margin-right: 5px;
        }
        .status-indicator {
            display: inline-block;
            width: 10px;
            height: 10px;
            border-radius: 50%;
            margin-right: 6px;
        }
        .status-active { background: #4caf50; }
        .status-pending { background: #ff9800; }
        .status-completed { background: #2196f3; }
    </style>
</head>
<body>
<form id="form1" runat="server">
    <asp:Button ID="btnBack" runat="server" CssClass="btn-back" Text="← Dashboard" OnClick="btnBack_Click" />

    <div class="main-container">
        <h2><i class="bi bi-clipboard-data"></i> Staff Reports Dashboard</h2>
        
        <asp:Label ID="lblMessage" runat="server" CssClass="d-block text-center mb-3" style="color: #d84315; font-weight: 500;" Text=""></asp:Label>
        
        <!-- Action Buttons -->
        <div class="action-buttons">
            <asp:Button ID="btnGenerateReport" runat="server" CssClass="btn-primary me-2" 
                Text=" Generate New Report" OnClick="btnGenerateReport_Click" />
            <asp:Button ID="btnExportReport" runat="server" CssClass="btn-outline" 
                Text=" Export Current Report" OnClick="btnExportReport_Click" />
        </div>
        
        <!-- A. CURRENT STATUS REPORT -->
        <div class="report-section">
            <h4 class="section-title"><i class="bi bi-speedometer2"></i> Current Status Report</h4>
            
            <div class="row">
                <!-- Occupancy Summary -->
                <div class="col-md-6">
                    <h5><i class="bi bi-door-closed icon-small"></i> Occupancy Summary</h5>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="stat-card">
                                <div class="stat-number"><asp:Label ID="lblTotalRooms" runat="server" Text="0"></asp:Label></div>
                                <div class="stat-label">Total Rooms</div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="stat-card">
                                <div class="stat-number"><asp:Label ID="lblOccupied" runat="server" Text="0"></asp:Label></div>
                                <div class="stat-label">Occupied Rooms</div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="stat-card">
                                <div class="stat-number"><asp:Label ID="lblAvailable" runat="server" Text="0"></asp:Label></div>
                                <div class="stat-label">Available Rooms</div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="stat-card">
                                <div class="stat-number"><asp:Label ID="lblMaintenance" runat="server" Text="0"></asp:Label></div>
                                <div class="stat-label">Maintenance Rooms</div>
                            </div>
                        </div>
                    </div>
                    <div class="mt-3">
                        <strong><i class="bi bi-percent icon-small"></i>Occupancy Rate: </strong>
                        <asp:Label ID="lblOccupancyRate" runat="server" Text="0%" style="color: #e65100; font-weight: 700;"></asp:Label>
                    </div>
                </div>
                
                <!-- Today's Activity -->
                <div class="col-md-6">
                    <h5><i class="bi bi-calendar-check icon-small"></i> Today's Activity</h5>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="stat-card">
                                <div class="stat-number"><asp:Label ID="lblCheckInsToday" runat="server" Text="0"></asp:Label></div>
                                <div class="stat-label">Check-ins Today</div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="stat-card">
                                <div class="stat-number"><asp:Label ID="lblCheckOutsToday" runat="server" Text="0"></asp:Label></div>
                                <div class="stat-label">Check-outs Today</div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="stat-card">
                                <div class="stat-number"><asp:Label ID="lblNewAppointments" runat="server" Text="0"></asp:Label></div>
                                <div class="stat-label">New Appointments</div>
                            </div>
                        </div>
                    </div>
                    <div class="mt-3">
                        <div class="row">
                            <div class="col-md-6">
                                <strong><i class="bi bi-heart-fill icon-small" style="color: #e91e63;"></i>Current Cats: </strong>
                                <asp:Label ID="lblCurrentCats" runat="server" Text="0" style="color: #e65100; font-weight: 700;"></asp:Label>
                            </div>
                            <div class="col-md-6">
                                <strong><i class="bi bi-list-task icon-small"></i>Pending Tasks: </strong>
                                <asp:Label ID="lblPendingTasks" runat="server" Text="0" style="color: #e65100; font-weight: 700;"></asp:Label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- B. CAT STATISTICS REPORT -->
        <div class="report-section">
            <h4 class="section-title"><i class="bi bi-bar-chart"></i> Cat Statistics Report</h4>
            
            <div class="row mb-4">
                <div class="col-md-12">
                    <div class="d-flex justify-content-between align-items-center">
                        <h5><i class="bi bi-heart-fill icon-small" style="color: #e91e63;"></i> Current Boarding Cats</h5>
                        <div style="font-size: 13px;">
                            <strong>Total Cats: </strong>
                            <asp:Label ID="lblCurrentCats2" runat="server" Text="0" style="color: #e65100; font-weight: 700;"></asp:Label>
                            <span class="ms-3">
                                <strong>Avg Stay: </strong>
                                <asp:Label ID="lblAvgStay" runat="server" Text="N/A" style="color: #e65100; font-weight: 700;"></asp:Label>
                            </span>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="row">
                <!-- Breed Distribution -->
                <div class="col-md-6">
                    <h6><i class="bi bi-pie-chart icon-small"></i> Breed Distribution</h6>
                    <div class="grid-container">
                        <asp:GridView ID="gvBreedDistribution" runat="server" 
                            CssClass="table table-sm table-striped table-bordered"
                            AutoGenerateColumns="true"
                            GridLines="None"
                            ShowHeader="true">
                            <HeaderStyle CssClass="grid-header" />
                            <RowStyle CssClass="clickable-row" />
                        </asp:GridView>
                    </div>
                </div>
                
                <!-- Age Groups -->
                <div class="col-md-6">
                    <h6><i class="bi bi-people icon-small"></i> Age Groups</h6>
                    <div class="grid-container">
                        <asp:GridView ID="gvAgeGroups" runat="server" 
                            CssClass="table table-sm table-striped table-bordered"
                            AutoGenerateColumns="true"
                            GridLines="None"
                            ShowHeader="true">
                            <HeaderStyle CssClass="grid-header" />
                            <RowStyle CssClass="clickable-row" />
                        </asp:GridView>
                    </div>
                </div>
            </div>
            
            <!-- Vaccination Status -->
            <div class="row mt-4">
                <div class="col-md-12">
                    <h6><i class="bi bi-shield-check icon-small"></i> Vaccination Status</h6>
                    <div class="grid-container">
                        <asp:GridView ID="gvVaccination" runat="server" 
                            CssClass="table table-sm table-striped table-bordered"
                            AutoGenerateColumns="true"
                            GridLines="None"
                            ShowHeader="true">
                            <HeaderStyle CssClass="grid-header" />
                            <RowStyle CssClass="clickable-row" />
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- REPORT HISTORY -->
        <div class="report-section">
            <h4 class="section-title"><i class="bi bi-clock-history"></i> Report History</h4>
            
            <div class="grid-container">
                <asp:GridView ID="gvReportHistory" runat="server" 
                    CssClass="table table-striped table-bordered table-hover"
                    AutoGenerateColumns="false"
                    OnRowDataBound="gvReportHistory_RowDataBound"
                    GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="Report_id" HeaderText="Report ID" ItemStyle-Width="80px" />
                        <asp:BoundField DataField="Type" HeaderText="Report Type" ItemStyle-Width="150px" />
                        <asp:BoundField DataField="Date_generated" HeaderText="Generated Date" DataFormatString="{0:yyyy-MM-dd HH:mm}" ItemStyle-Width="160px" />
                        <asp:BoundField DataField="StaffName" HeaderText="Generated By" ItemStyle-Width="120px" />
                    </Columns>
                    <EmptyDataTemplate>
                        <div class="text-center py-3">
                            <i class="bi bi-file-earmark-text" style="font-size: 1.5rem; color: #ffb74d;"></i>
                            <p class="mt-2 text-muted">No reports generated yet</p>
                        </div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>
    </div>
</form>
</body>
</html>