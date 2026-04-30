<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MakeAppointment.aspx.cs" Inherits="CatResort.MakeAppointment" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Make Appointment - Cat Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Recursive:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <style>
        body {
            background: linear-gradient(135deg, #fdf2ff 0%, #f2fdff 100%);
            font-family: 'Recursive';
            padding: 20px;
            color: #5a4a6a;
            min-height: 100vh;
        }
        .form-card {
            max-width: 500px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(149, 117, 205, 0.15);
        }
        .form-card h2 {
            text-align: center;
            margin-bottom: 25px;
            color: #772695;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #5a4a6a;
            font-size: 15px;
        }
        .form-control {
            width: 100%;
            padding: 12px 15px;
            border-radius: 8px;
            border: 1px solid #d9cbea;
            box-sizing: border-box;
            font-family: 'Recursive';
            font-size: 16px;
            transition: border 0.3s;
        }
        .form-control:focus {
            outline: none;
            border-color: #9575cd;
            box-shadow: 0 0 0 3px rgba(149, 117, 205, 0.1);
        }
        .btn-primary, .btn-back {
            padding: 14px 25px;
            border: none;
            border-radius: 10px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            font-family: 'Recursive';
            font-size: 16px;
            width: 100%;
            display: block;
        }
        .btn-primary {
            background: linear-gradient(135deg, #ff9ec0 0%, #9575cd 100%);
            color: white;
            margin-top: 10px;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(149,117,205,0.4);
        }
        .btn-back {
            background: linear-gradient(135deg, #9575cd 0%, #7986cb 100%);
            color: white;
            margin-bottom: 20px;
        }
        .btn-back:hover { 
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(149,117,205,0.4);
        }
        .message {
            text-align: center;
            margin: 20px 0;
            font-weight: 600;
            padding: 15px;
            border-radius: 10px;
            font-size: 15px;
        }
        .success { 
            background: #e8f5e9; 
            color: #2e7d32; 
            border: 1px solid #c8e6c9;
        }
        .error { 
            background: #ffebee; 
            color: #d32f2f; 
            border: 1px solid #ffcdd2;
        }
        .info-text {
            color: #888;
            font-size: 13px;
            margin-top: 5px;
            display: block;
        }
        .example {
            color: #9575cd;
            font-weight: 500;
        }
        .input-container {
            position: relative;
        }
        .today-btn {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            background: #f0e6ff;
            color: #9575cd;
            border: 1px solid #d9cbea;
            padding: 4px 10px;
            border-radius: 5px;
            font-size: 12px;
            cursor: pointer;
            font-weight: 600;
        }
        .today-btn:hover {
            background: #e0d6ff;
        }
    </style>
</head>

<body>
    <form id="form1" runat="server">
        <div class="form-card">
            <!-- Back Button -->
            <asp:Button ID="btnBack" runat="server" Text="← Back to Dashboard" CssClass="btn-back" OnClick="btnBack_Click" />

            <h2>📅 Book Appointment</h2>

            <!-- Message Display -->
            <asp:Label runat="server" ID="lblMsg" Visible="false" CssClass="message"></asp:Label>

            <!-- Date Input -->
            <div class="form-group">
                <label for="txtDate">Appointment Date:</label>
                <div class="input-container">
                    <asp:TextBox ID="txtDate" runat="server" CssClass="form-control"
                        placeholder="MM/DD/YYYY" ClientIDMode="Static"></asp:TextBox>
                    <button type="button" class="today-btn" onclick="setTomorrow()">Tomorrow</button>
                </div>
                <span class="info-text">Format: <span class="example">MM/DD/YYYY</span> (e.g., <span class="example">12/08/2025</span>)</span>
            </div>

            <!-- Time Input -->
            <div class="form-group">
                <label for="txtTime">Appointment Time:</label>
                <asp:TextBox ID="txtTime" runat="server" CssClass="form-control"
                    placeholder="HH:MM AM/PM" ClientIDMode="Static"></asp:TextBox>
                <span class="info-text">Format: <span class="example">HH:MM AM/PM</span> (e.g., <span class="example">11:00 AM</span>)</span>
                <span class="info-text">Business hours: <span class="example">9:00 AM - 6:00 PM</span></span>
            </div>

            <!-- Purpose Input -->
            <div class="form-group">
                <label for="txtPurpose">Purpose of Visit:</label>
                <asp:TextBox ID="txtPurpose" runat="server" CssClass="form-control" 
                    placeholder="e.g., Grooming, Vaccination, Check-up" MaxLength="100" ClientIDMode="Static"></asp:TextBox>
            </div>
            
            <!-- Submit Button -->
            <asp:Button ID="btnSubmit" runat="server" Text="✅ Confirm Appointment" CssClass="btn-primary"
                OnClick="btnSubmit_Click" OnClientClick="return validateForm();" />
        </div>
    </form>
    
    <script type="text/javascript">
        // Set tomorrow's date
        function setTomorrow() {
            var today = new Date();
            var tomorrow = new Date(today);
            tomorrow.setDate(today.getDate() + 1);

            var month = (tomorrow.getMonth() + 1).toString().padStart(2, '0');
            var day = tomorrow.getDate().toString().padStart(2, '0');
            var year = tomorrow.getFullYear();

            document.getElementById('txtDate').value = month + '/' + day + '/' + year;
        }

        // Client-side validation
        function validateForm() {
            var dateInput = document.getElementById('txtDate');
            var timeInput = document.getElementById('txtTime');
            var purposeInput = document.getElementById('txtPurpose');

            // Check for empty fields
            if (!dateInput.value.trim()) {
                alert('Please enter appointment date.');
                dateInput.focus();
                return false;
            }
            if (!timeInput.value.trim()) {
                alert('Please enter appointment time.');
                timeInput.focus();
                return false;
            }
            if (!purposeInput.value.trim()) {
                alert('Please enter purpose of visit.');
                purposeInput.focus();
                return false;
            }

            // Date validation (MM/DD/YYYY)
            var datePattern = /^(0[1-9]|1[0-2])\/(0[1-9]|[12][0-9]|3[01])\/\d{4}$/;
            if (!datePattern.test(dateInput.value)) {
                alert('Please enter date in MM/DD/YYYY format (e.g., 12/08/2025)');
                dateInput.focus();
                return false;
            }

            // Parse date to check if it's in the past
            var parts = dateInput.value.split('/');
            var inputDate = new Date(parts[2], parts[0] - 1, parts[1]);
            var today = new Date();
            today.setHours(0, 0, 0, 0);

            if (inputDate < today) {
                alert('Cannot book appointment for a past date.');
                dateInput.focus();
                return false;
            }

            // Time validation
            var timePattern12 = /^(1[0-2]|0?[1-9]):[0-5][0-9]\s?(AM|PM|am|pm)$/i;
            var timePattern24 = /^([01]?[0-9]|2[0-3]):[0-5][0-9]$/;

            if (!timePattern12.test(timeInput.value) && !timePattern24.test(timeInput.value)) {
                alert('Please enter time in HH:MM AM/PM format (e.g., 11:00 AM or 14:30)');
                timeInput.focus();
                return false;
            }

            // Convert time to 24-hour format for comparison
            var timeValue = timeInput.value.toUpperCase();
            var hours, minutes;

            if (timeValue.includes('AM') || timeValue.includes('PM')) {
                // 12-hour format
                var isPM = timeValue.includes('PM');
                timeValue = timeValue.replace(/[APM]/gi, '').trim();
                var timeParts = timeValue.split(':');
                hours = parseInt(timeParts[0]);
                minutes = parseInt(timeParts[1]);

                if (isPM && hours !== 12) hours += 12;
                if (!isPM && hours === 12) hours = 0;
            } else {
                // 24-hour format
                var timeParts = timeValue.split(':');
                hours = parseInt(timeParts[0]);
                minutes = parseInt(timeParts[1]);
            }

            // Check business hours (9 AM to 6 PM)
            if (hours < 9 || hours >= 18) {
                alert('Appointments can only be booked between 9:00 AM and 6:00 PM.');
                timeInput.focus();
                return false;
            }

            // If booking for today, check it's at least 1 hour from now
            if (inputDate.getTime() === today.getTime()) {
                var now = new Date();
                var appointmentTime = new Date();
                appointmentTime.setHours(hours, minutes, 0, 0);

                var diffHours = (appointmentTime - now) / (1000 * 60 * 60);
                if (diffHours < 1) {
                    alert('Appointments must be booked at least 1 hour in advance.');
                    timeInput.focus();
                    return false;
                }
            }

            return true;
        }

        // Auto-format date input
        document.addEventListener('DOMContentLoaded', function () {
            var dateInput = document.getElementById('txtDate');

            if (dateInput) {
                dateInput.addEventListener('input', function (e) {
                    var value = e.target.value.replace(/\D/g, '');
                    if (value.length > 8) value = value.substring(0, 8);

                    if (value.length >= 2) {
                        value = value.substring(0, 2) + '/' + value.substring(2);
                    }
                    if (value.length >= 5) {
                        value = value.substring(0, 5) + '/' + value.substring(5);
                    }
                    e.target.value = value;
                });
            }

            // Set default tomorrow if empty
            if (dateInput && !dateInput.value) {
                setTomorrow();
            }
        });
    </script>
</body>
</html>