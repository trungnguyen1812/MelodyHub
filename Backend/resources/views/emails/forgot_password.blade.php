<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>New Password</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            line-height: 1.6;
            color: #333;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
        }
        .email-wrapper {
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px 20px;
            text-align: center;
        }
        .header h1 {
            margin: 0;
            font-size: 24px;
        }
        .content {
            padding: 40px 30px;
        }
        .password-box {
            background-color: #f8f9fa;
            border: 2px dashed #dee2e6;
            border-radius: 8px;
            padding: 20px;
            text-align: center;
            margin: 30px 0;
            font-family: 'Courier New', monospace;
        }
        .password-box h2 {
            margin: 0;
            color: #667eea;
            font-size: 28px;
            font-weight: bold;
            letter-spacing: 4px;
        }
        .password-label {
            font-size: 13px;
            color: #888;
            margin-bottom: 10px;
        }
        .info-box {
            background-color: #fff3cd;
            border-left: 4px solid #ffc107;
            padding: 15px;
            margin: 25px 0;
            border-radius: 4px;
        }
        .warning { color: #e74c3c; font-weight: bold; }
        .footer {
            text-align: center;
            padding: 20px;
            color: #666;
            font-size: 12px;
            border-top: 1px solid #eee;
            background-color: #f9f9f9;
        }
        @media only screen and (max-width: 600px) {
            .container { padding: 10px; }
            .content { padding: 20px 15px; }
            .password-box h2 { font-size: 22px; letter-spacing: 2px; }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="email-wrapper">
            <div class="header">
                <h1>🔑 Password Reset</h1>
            </div>

            <div class="content">
                <p>Hello <strong>{{ $userName }}</strong>,</p>
                <p>We received a request to reset your password for your <strong>{{ config('app.name') }}</strong> account.</p>
                <p>Your new temporary password is:</p>

                <div class="password-box">
                    <p class="password-label">New Password</p>
                    <h2>{{ $newPassword }}</h2>
                </div>

                <div class="info-box">
                    <p><strong>⚠️ Important:</strong></p>
                    <ul>
                        <li>Please <span class="warning">log in immediately</span> and change your password.</li>
                        <li>Do not share this password with anyone.</li>
                        <li>If you did not request a password reset, please contact support immediately.</li>
                    </ul>
                </div>

                <p>Thank you,<br>
                <strong>Team {{ config('app.name') }}</strong></p>
            </div>

            <div class="footer">
                <p>© {{ date('Y') }} {{ config('app.name') }}. All rights reserved.</p>
                <p>This is an automated email, please do not reply.</p>
            </div>
        </div>
    </div>
</body>
</html>
