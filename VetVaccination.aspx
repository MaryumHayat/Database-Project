<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="VetVaccination.aspx.cs" Inherits="CatResort.VetVaccination" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Vet Vaccination Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <style>
        body { background-color: #f8fff0; font-family: 'Segoe UI', sans-serif; }
        .container { margin-top: 20px; }
        .form-section { background-color: white; padding: 20px; border-radius: 12px; box-shadow: 0 4px 15px rgba(102,187,106,0.2); }
        .table-container { background-color: white; padding: 20px; border-radius: 12px; box-shadow: 0 4px 15px rgba(102,187,106,0.2); margin-top: 30px; }
        .scrollable-table { max-height: 400px; overflow-y: auto; border: 1px solid #dee2e6; border-radius: 8px; }
        .btn-crud { margin-right: 5px; }
        .left-image { background-image: url('https://m.media-amazon.com/images/I/31RTc4Cgh9L._SY445_SX342_FMwebp_.jpg'); background-size: cover; background-position: center; min-height: 400px; border-radius: 12px; }
        .table-sm td, .table-sm th { padding: 0.5rem; }
        .table-hover tbody tr:hover { background-color: rgba(102,187,106,0.1); }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <asp:Button ID="btnBack" runat="server" Text="← Back to Dashboard" CssClass="btn btn-dark mb-3" OnClick="btnBack_Click" />

            <h2 class="text-center mb-4">Vaccination Management</h2>
            
            <!-- Form and Image Section -->
            <div class="row g-4">
                <!-- Left Image -->
                <div class="col-md-4">
                    <div class="left-image"></div>
                </div>

                <!-- Right Form -->
                <div class="col-md-8">
                    <div class="form-section">
                        <div class="mb-3">
                            <label class="form-label">Select Cat</label>
                            <asp:DropDownList ID="ddlCat" runat="server" CssClass="form-select"></asp:DropDownList>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Vaccine Name</label>
                            <asp:TextBox ID="txtVaccineName" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">Due Date</label>
                                    <asp:TextBox ID="txtDueDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">Vaccination Date</label>
                                    <asp:TextBox ID="txtVaccinationDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                                </div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Status</label>
                            <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-select">
                                <asp:ListItem Text="Pending" Value="Pending" />
                                <asp:ListItem Text="Completed" Value="Completed" />
                            </asp:DropDownList>
                        </div>

                        <div class="mb-3">
                            <asp:Button ID="btnAdd" runat="server" Text="Add" CssClass="btn btn-success btn-crud" OnClick="btnAdd_Click" />
                            <asp:Button ID="btnUpdate" runat="server" Text="Update" CssClass="btn btn-primary btn-crud" OnClick="btnUpdate_Click" />
                            <asp:Button ID="btnDelete" runat="server" Text="Delete" CssClass="btn btn-danger btn-crud" OnClick="btnDelete_Click" />
                            <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn btn-secondary btn-crud" OnClick="btnClear_Click" />
                        </div>
                    </div>
                </div>
            </div>

            <!-- Vaccination Records Table - Outside the form/image row container -->
            <div class="table-container mt-4">
                <h4 class="mb-3">Vaccination Records</h4>
                <div class="scrollable-table">
                    <asp:GridView ID="gvVaccines" runat="server" CssClass="table table-striped table-hover table-sm"
                        AutoGenerateColumns="False" OnSelectedIndexChanged="gvVaccines_SelectedIndexChanged" 
                        DataKeyNames="Vaccine_id" ShowHeaderWhenEmpty="true" EmptyDataText="No vaccination records found">
                        <Columns>
                            <asp:BoundField DataField="Vaccine_id" HeaderText="ID" ReadOnly="True" ItemStyle-Width="60px" />
                            <asp:BoundField DataField="CatName" HeaderText="Cat" ItemStyle-Width="120px" />
                            <asp:BoundField DataField="Name" HeaderText="Vaccine Name" ItemStyle-Width="150px" />
                            <asp:BoundField DataField="Due_date" HeaderText="Due Date" DataFormatString="{0:yyyy-MM-dd}" HtmlEncode="False" ItemStyle-Width="120px" />
                            <asp:BoundField DataField="Vaccination_date" HeaderText="Vaccination Date" DataFormatString="{0:yyyy-MM-dd}" HtmlEncode="False" ItemStyle-Width="120px" />
                            <asp:BoundField DataField="Vaccine_Status" HeaderText="Status" ItemStyle-Width="100px" />
                            <asp:CommandField ShowSelectButton="True" SelectText="Select" ButtonType="Button" 
                                ControlStyle-CssClass="btn btn-sm btn-outline-primary" ItemStyle-Width="80px" />
                        </Columns>
                        <HeaderStyle CssClass="table-dark" />
                    </asp:GridView>
                </div>
            </div>
        </div>
    </form>
</body>
</html>