<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditCustomer.aspx.cs" Inherits="CatResort.EditCustomer" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Edit Customer</title>
    <link href="https://fonts.googleapis.com/css2?family=Recursive:wght@300;400;500;600;700&display=swap" rel="stylesheet" />

    <style>
        body {
            font-family: 'Recursive', sans-serif;
            background: linear-gradient(135deg,#fdf2ff 0%,#f2fdff 100%);
            color:#5a4a6a;
            padding: 40px;
        }

        .back-btn {
            position:absolute;
            top:20px;
            left:20px;
            padding:10px 15px;
            background:#9575cd;
            color:white;
            text-decoration:none;
            border-radius:6px;
            font-weight:600;
            box-shadow:0 3px 10px rgba(149,117,205,0.3);
        }

        .container-table { width:95%; margin:auto; }
        .left, .right {
            vertical-align:top;
            padding:20px;
            background:white;
            border-radius:12px;
            box-shadow:0 3px 15px rgba(149,117,205,0.20);
        }

        h2 { text-align:center; margin-bottom:20px; color:#9575cd; }

        label { display:block; margin-top:15px; font-weight:600; color:#7e6a9f; }
        input[type=text] {
            width:100%; padding:10px; border-radius:6px; border:1px solid #d8cfee;
        }

        .section-title { margin-top:20px; font-weight:700; color:#9575cd; }

        .btn { padding:10px 18px; border:none; cursor:pointer; border-radius:6px; font-weight:600; color:white; margin-top:20px; }
        .save-btn { background:#9575cd; }
        .cancel-btn { background:#ff6b6b; }

        .msg { margin-top:20px; padding:10px; border-radius:6px; font-weight:600;}
        .success { background:#e8f5e9; color:#2e7d32; }
        .error { background:#ffebee; color:#c62828; }

        table.cat-table { width:100%; border-collapse:collapse; margin-top:10px; }
        table.cat-table th { color:#9575cd; text-align:left; padding-bottom:8px; }
        table.cat-table td { padding:5px 0; }
    </style>

</head>
<body>

    <a href="CustomerManagement.aspx" class="back-btn">← Back</a>

    <form id="form1" runat="server">

        <table class="container-table">
            <tr>
                <!-- LEFT SIDE — CUSTOMER -->
                <td class="left">
                    <h2>Edit Customer</h2>

                    <asp:HiddenField runat="server" ID="hdnCustomerId" />

                    <label>First Name</label>
                    <asp:TextBox runat="server" ID="txtFname" />

                    <label>Last Name</label>
                    <asp:TextBox runat="server" ID="txtLname" />

                    <label>Address</label>
                    <asp:TextBox runat="server" ID="txtAddress" />

                    <div class="section-title">Emails</div>
                    <asp:Repeater ID="rptEmails" runat="server">
                        <ItemTemplate>
                            <asp:TextBox runat="server" Text='<%# Eval("Email") %>' />
                            <asp:HiddenField ID="hdnEmailId" runat="server" Value='<%# Eval("Email_id") %>' />
                            <br />
                        </ItemTemplate>
                    </asp:Repeater>

                    <div class="section-title">Phone Numbers</div>
                    <asp:Repeater ID="rptPhones" runat="server">
                        <ItemTemplate>
                            <asp:TextBox runat="server" Text='<%# Eval("Phone_Number") %>' />
                            <asp:HiddenField ID="hdnPhoneId" runat="server" Value='<%# Eval("Phone_id") %>' />
                            <br />
                        </ItemTemplate>
                    </asp:Repeater>

                    <asp:Button ID="btnSaveCustomer" runat="server" Text="Save" CssClass="btn save-btn" OnClick="btnSaveCustomer_Click" />
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn cancel-btn" OnClick="btnCancel_Click" />

                    <asp:Label ID="lblMessage" runat="server" CssClass="msg"></asp:Label>
                </td>


                <!-- RIGHT SIDE — CATS -->
                <td class="right">
                    <h2>Edit Cats</h2>

                    <asp:Repeater ID="rptCats" runat="server" OnItemCommand="rptCats_ItemCommand">
                        <HeaderTemplate>
                            <table class="cat-table">
                                <tr>
                                    <th>Name</th>
                                    <th>Breed</th>
                                    <th>Age</th>
                                    <th>Behavior</th>
                                    <th>Vaccinated</th>
                                    <th>Actions</th>
                                </tr>
                        </HeaderTemplate>

                        <ItemTemplate>
                            <tr>
                                <td><asp:TextBox ID="txtCatName" runat="server" Text='<%# Eval("Name") %>' Width="90px" /></td>
                                <td><asp:TextBox ID="txtCatBreed" runat="server" Text='<%# Eval("Breed") %>' Width="90px" /></td>
                                <td><asp:TextBox ID="txtCatAge" runat="server" Text='<%# Eval("Age") %>' Width="50px" /></td>
                                <td><asp:TextBox ID="txtCatBehavior" runat="server" Text='<%# Eval("Behavior") %>' Width="120px" /></td>
                                <td><asp:TextBox ID="txtCatVaccinated" runat="server" Text='<%# Eval("Vaccinated") %>' Width="120px" /></td>

                                <asp:HiddenField ID="hdnCatId" runat="server" Value='<%# Eval("Cat_id") %>' />

                                <td>
                                    <asp:Button Text="Update" runat="server" CommandName="UpdateCat" CommandArgument='<%# Eval("Cat_id") %>' CssClass="btn save-btn" />
                                    <asp:Button Text="Delete" runat="server" CommandName="DeleteCat" CommandArgument='<%# Eval("Cat_id") %>' CssClass="btn cancel-btn" />
                                </td>
                            </tr>
                        </ItemTemplate>

                        <FooterTemplate>
                            </table>
                        </FooterTemplate>
                    </asp:Repeater>

                    <asp:Button ID="btnAddCat" runat="server" Text="Add New Cat" CssClass="btn save-btn" OnClick="btnAddCat_Click" />
                </td>
            </tr>
        </table>

    </form>

</body>
</html>
