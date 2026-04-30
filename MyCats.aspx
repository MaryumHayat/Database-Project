<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MyCats.aspx.cs" Inherits="CatResort.MyCats" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>My Cats - Cat Resort</title>

    <style>
        @import url('https://fonts.googleapis.com/css2?family=Great+Vibes&display=swap');

        body { 
            font-family: 'Recursive', sans-serif; 
            padding: 30px; 
            background-color: #f5f5f5;
            color: #5a4a6a;
        }

        .back-btn {
            display: inline-block;
            margin-bottom: 20px;
            padding: 8px 20px;
            border-radius: 20px;
            background-color: #9575cd;
            color: white;
            text-decoration: none;
            font-weight: bold;
        }

        /* Hero Section */
        .hero {
            position: relative;
            width: 100%;
            height: 250px;
            margin-bottom: 40px;
            border-radius: 10px;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
            background-image: url('https://i.pinimg.com/736x/74/63/17/746317fdb7bf011ee420eecffd5097ba.jpg');
            background-size: cover;
            background-position: center;
        }

        .hero-overlay {
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background-color: rgba(128,128,128,0.4);
            z-index: 1;
        }

        .hero h1 {
            position: relative;
            z-index: 2;
            color: white;
            font-size: 2.5em;
            text-align: center;
            font-family: 'Great Vibes', cursive;
            text-shadow: 0 2px 5px rgba(0,0,0,0.5);
        }

        /* SIDE BY SIDE FIX */
        .main-content {
            display: flex;
            flex-direction: row;   /* ensure horizontal */
            gap: 20px;
            flex-wrap: nowrap;     /* prevent stacking */
            align-items: flex-start;
        }

        /* Form Section */
        .form-section {
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            width: 35%;
            min-width: 280px;
            min-height: 300px;
        }

        .form-column input {
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
            border-radius: 5px;
            border: 1px solid #ccc;
        }

        .form-buttons {
            text-align: right;
        }

        /* Table Section */
        .grid-section {
            width: 65%;
            min-width: 400px;
            background: white;
            border-radius: 10px;
            padding: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }

        /* VERY IMPORTANT FIX */
        .scrollable {
            max-height: 350px;
            overflow-y: auto;
            flex: 1;               /* allow flexbox to keep side-by-side */
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 6px 10px;
            border: 1px solid #ddd;
        }

        th {
            background-color: #f0eaf9;
        }

        tr:nth-child(even) {
            background-color: #faf7ff;
        }

        /* Buttons */
        .btn {
            padding: 8px 20px;
            border-radius: 20px;
            cursor: pointer;
            margin-right: 5px;
        }

        .btn-add { background-color: #9575cd; color: white; }
        .btn-clear { background-color: #ff9800; color: white; }

        /* Responsive for small screens */
        @media screen and (max-width: 900px) {
            .main-content {
                flex-wrap: wrap; /* ok for mobile */
            }
            .form-section, .grid-section {
                width: 100%;
                min-width: unset;
            }
        }
    </style>
</head>

<body>
    <form id="form1" runat="server">
        <a class="back-btn" href="CustomerProfile.aspx">&larr; Back</a>

        <div class="hero">
            <div class="hero-overlay"></div>
            <h1>My World of Whiskers and Wonders</h1>
        </div>

        <div class="main-content">

            <!-- FORM -->
            <div id="catForm" runat="server" class="form-section">
                <asp:HiddenField ID="hfCatId" runat="server" />
                <asp:Label ID="lblFormTitle" runat="server" Text="Add Cat" Font-Bold="true" Font-Size="Large" />

                <br /><br />

                <asp:TextBox ID="txtCatName" runat="server" placeholder="Name"></asp:TextBox>
                <asp:TextBox ID="txtCatBreed" runat="server" placeholder="Breed"></asp:TextBox>
                <asp:TextBox ID="txtCatAge" runat="server" placeholder="Age"></asp:TextBox>
                <asp:TextBox ID="txtCatBehavior" runat="server" placeholder="Behavior"></asp:TextBox>
                <asp:TextBox ID="txtCatVaccine" runat="server" placeholder="Vaccine Info (Optional)"></asp:TextBox>

                <div class="form-buttons">
                    <asp:Button ID="btnSaveCat" runat="server" Text="Save" CssClass="btn btn-add" OnClick="btnSaveCat_Click" />
                    <asp:Button ID="btnClearCat" runat="server" Text="Clear" CssClass="btn btn-clear" OnClick="btnClearCat_Click" />
                </div>
            </div>

            <!-- TABLE -->
            <div class="grid-section">
                <div class="scrollable">
                    <asp:GridView ID="gvCats" runat="server" AutoGenerateColumns="False"
                        DataKeyNames="Cat_id"
                        OnRowEditing="gvCats_RowEditing"
                        OnRowDeleting="gvCats_RowDeleting">

                        <Columns>
                            <asp:BoundField DataField="Name" HeaderText="Name" />
                            <asp:BoundField DataField="Breed" HeaderText="Breed" />
                            <asp:BoundField DataField="Age" HeaderText="Age" />
                            <asp:BoundField DataField="Behavior" HeaderText="Behavior" />
                            <asp:CommandField ShowEditButton="True" ShowDeleteButton="True" />
                        </Columns>

                    </asp:GridView>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
