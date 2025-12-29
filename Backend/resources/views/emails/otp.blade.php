<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OTP CODE</title>
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
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
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
        .otp-code {
            background-color: #f8f9fa;
            border: 2px dashed #dee2e6;
            border-radius: 8px;
            padding: 20px;
            text-align: center;
            margin: 30px 0;
            font-family: 'Courier New', monospace;
        }
        .otp-code h2 {
            margin: 0;
            color: #667eea;
            font-size: 42px;
            letter-spacing: 10px;
            font-weight: bold;
        }
        .info-box {
            background-color: #e7f3ff;
            border-left: 4px solid #2196F3;
            padding: 15px;
            margin: 25px 0;
            border-radius: 4px;
        }
        .warning {
            color: #e74c3c;
            font-weight: bold;
        }
        .footer {
            text-align: center;
            padding: 20px;
            color: #666;
            font-size: 12px;
            border-top: 1px solid #eee;
            background-color: #f9f9f9;
        }
        .btn {
            display: inline-block;
            padding: 12px 30px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-decoration: none;
            border-radius: 5px;
            margin: 10px 5px;
        }
        @media only screen and (max-width: 600px) {
            .container {
                padding: 10px;
            }
            .content {
                padding: 20px 15px;
            }
            .otp-code h2 {
                font-size: 32px;
                letter-spacing: 5px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="email-wrapper">
            <div class="header">
                <h1>🔐 OTP code of you</h1>
            </div>
            
            <div class="content">
                @if($userName)
                <p>Welcome <strong>{{ $userName }}</strong>,</p>
                @else
                <p>Hi,</p>
                @endif
                
                <p>Here is your OTP code:</p>
                
                <div class="otp-code">
                    <h2>{{ $otp }}</h2>
                </div>
                
                <div class="info-box">
                    <p><strong>⚠️ Warning important:</strong></p>
                    <ul>
                        <li>The code inval in <span class="warning">{{ $expiryMinutes }} Minute</span></li>
                        <li>Don't share the code with anyone</li>
                        <li>The OTP code can only be userd once</li>
                        <li>If you are not requesting a code, please disregard this email.</li>
                    </ul>
                </div>
                
                <p>Use this code to complete the verification process on our website..</p>
                
                <p>Thank you very much.,<br>
                <strong>Team {{ config('app.name') }}</strong></p>
            </div>
            
            <div class="footer">
                <p>© {{ $currentYear }} {{ config('app.name') }}. All rights reserved..</p>
                <p>This is an automated email, please do not reply..</p>
            </div>
        </div>
    </div>
</body>
</html>