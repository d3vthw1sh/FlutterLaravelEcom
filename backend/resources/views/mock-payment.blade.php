<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mock Payment</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .payment-card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            max-width: 400px;
            width: 100%;
            padding: 40px;
            text-align: center;
        }
        .logo {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 50%;
            margin: 0 auto 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 30px;
            color: white;
        }
        h1 {
            font-size: 24px;
            margin-bottom: 10px;
            color: #333;
        }
        .amount {
            font-size: 36px;
            font-weight: bold;
            color: #667eea;
            margin: 20px 0;
        }
        .order-id {
            color: #666;
            font-size: 14px;
            margin-bottom: 30px;
        }
        .btn {
            width: 100%;
            padding: 16px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin-bottom: 10px;
        }
        .btn-success {
            background: #10b981;
            color: white;
        }
        .btn-success:hover {
            background: #059669;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.4);
        }
        .btn-cancel {
            background: #f3f4f6;
            color: #666;
        }
        .btn-cancel:hover {
            background: #e5e7eb;
        }
        .info {
            margin-top: 20px;
            padding: 16px;
            background: #f9fafb;
            border-radius: 8px;
            font-size: 14px;
            color: #666;
        }
    </style>
</head>
<body>
    <div class="payment-card">
        <div class="logo">💳</div>
        <h1>Mock Payment Gateway</h1>
        <div class="amount">$<?php echo number_format($_GET['amount'] ?? 0, 2); ?></div>
        <div class="order-id">Order #<?php echo $_GET['orderId'] ?? 'N/A'; ?></div>
        
        <button class="btn btn-success" onclick="simulateSuccess()">
            ✓ Simulate Successful Payment
        </button>
        <button class="btn btn-cancel" onclick="simulateCancel()">
            ✗ Cancel Payment
        </button>
        
        <div class="info">
            <strong>ℹ️ Mock Payment Mode</strong><br>
            This is a simulated payment gateway. Click "Simulate Successful Payment" to complete your order.
        </div>
    </div>

    <script>
        function simulateSuccess() {
            // Redirect to success page (Flutter will handle this)
            window.location.href = '/success?orderId=<?php echo $_GET['orderId'] ?? ''; ?>';
        }

        function simulateCancel() {
            // Redirect to cancel page
            window.location.href = '/cancel';
        }
    </script>
</body>
</html>
