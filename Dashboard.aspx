<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="CatResort.Dashboard" %> 

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Cat Resort Dashboard</title>

    <style>
        /* GENERAL RESET */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: "Segoe UI", sans-serif;
        }

        body {
            background: #f5f5f5;
            min-height: 100vh;
        }

        /* NAVBAR */
        .navbar {
            width: 100%;
            height: 70px;
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.4);
            position: fixed;
            top: 0;
            left: 0;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 40px;
            z-index: 999;
        }

        .navbar .logo {
            font-size: 20px;
            font-weight: bold;
            color: #4f1717;
        }

        .navbar a {
            margin-left: 20px;
            text-decoration: none;
            color: #333;
            font-weight: 600;
            transition: color 0.3s;
        }

        .navbar a:hover {
            color: #ff66a3;
        }

        /* HERO SECTION */
        .hero {
            position: relative;
            width: 100%;
            height: 500px;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
            animation: fadeInHero 1s ease forwards;
        }

        .hero video {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            z-index: 1;
        }

        .hero::after {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(128, 128, 128, 0.5); /* gray overlay */
            z-index: 2;
        }

        .hero h1 {
            position: relative;
            z-index: 3;
            color: white;
            font-size: 30px;
            text-align: center;
            font-family: "Lucida Calligraphy", cursive;
            letter-spacing: 1px;
            opacity: 0;
            animation: fadeInText 2s ease 0.5s forwards;
        }

        @keyframes fadeInHero {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes fadeInText {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* DASHBOARD CARDS */
        /* DASHBOARD CARDS */
.dashboard-cards {
    display: flex;
    justify-content: center;
    gap: 20px; /* Reduced gap */
    margin: 60px auto;
    max-width: 1200px; /* Increased max-width */
    flex-wrap: nowrap; /* Prevent wrapping */
    padding: 0 20px;
}

.card {
    background: white;
    padding: 30px 20px; /* Reduced padding */
    border-radius: 15px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.1);
    flex: 1; /* Equal width */
    min-width: 0; /* Allows cards to shrink */
    max-width: 280px; /* Set max width */
    text-align: center;
    transition: transform 0.3s, box-shadow 0.3s;
    cursor: default;
    opacity: 0;
    transform: translateY(20px);
    animation: fadeInCard 1s ease forwards;
}



        .card:nth-child(1) { animation-delay: 0.5s; }
        .card:nth-child(2) { animation-delay: 0.7s; }
        .card:nth-child(3) { animation-delay: 0.9s; }
        .card:nth-child(4) { animation-delay: 1.1s; } /* Add animation for 4th card */
        

        @keyframes fadeInCard {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.2);
        }

        .card h2 {
            color: #ff66a3;
            margin-bottom: 15px;
            font-size: 24px;
        }

        .card p {
            color: #666;
            font-size: 14px;
            margin-bottom: 20px;
        }

        .card button {
            background: #ff66a3;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 10px;
            font-size: 14px;
            cursor: pointer;
            transition: background 0.3s;
        }

        .card button:hover {
            background: #e05592;
        }

        /* FOOTER */
        .footer {
            width: 100%;
            height: 70px;
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(8px);
            border-top: 1px solid rgba(255, 255, 255, 0.4);
            position: fixed;
            bottom: 0;
            left: 0;
            text-align: center;
            padding-top: 20px;
            font-size: 14px;
            color: #444;
        }
    </style>
</head>
<body>

    <!-- NAVBAR -->
    <div class="navbar">
        <div class="logo">Cat Resort Management System</div>
    </div>

    <!-- HERO SECTION -->
    <section class="hero">
        <video autoplay muted loop>
            <source src="https://v1.pinimg.com/videos/mc/expMp4/24/8b/ce/248bcea49922428457beec8f14befb01_t1.mp4" type="video/mp4">
        </video>
        <h1>Settle In, Sweet Kitty! Your Vacation Starts Now</h1>
    </section>

    <!-- DASHBOARD CARDS -->
    <section class="dashboard-cards">
        <div class="card">
            <h2>Admin Dashboard</h2>
            <p>Manage all operations, view reports, and oversee the entire resort.</p>
            <button onclick="location.href='AdminDashboard.aspx'">Go</button>
        </div>
        <div class="card">
            <h2>Staff Dashboard</h2>
            <p>Track tasks, manage bookings, and assist with daily operations.</p>
            <button onclick="location.href='StaffDashboard.aspx'">Go</button>
        </div>
        <div class="card">
            <h2>Customer Dashboard</h2>
            <p>View reservations, services, and special offers for your kitty.</p>
            <button onclick="location.href='CustomerDashboard.aspx'">Go</button>
        </div>
         <div class="card">
             <h2>Vet Dashboard</h2>
             <p>Treat Cats, and special offers for your kitty.</p>
             <button onclick="location.href='VetDashboard.aspx'">Go</button>
         </div>
    </section>

    <!-- FOOTER -->
    <div class="footer">
        © 2025 Cat Resort Management System — All Rights Reserved
    </div>

</body>
</html>
