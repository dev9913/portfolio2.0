<?php

session_start();  // Start the session at the top of your file

// Check if there's a success message to display
if (isset($_SESSION['reply_success']) && $_SESSION['reply_success']) {
    echo '<div class="alert alert-success" role="alert" id="successMessage">Message sent successfully!</div>';

    // Unset the session variable to prevent it from showing after a refresh
    unset($_SESSION['reply_success']);
}




require 'vendor/autoload.php';  // Add PHPMailer autoload

function loadEnv($file) {
    if (file_exists($file)) {
        $lines = file($file, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
        foreach ($lines as $line) {
            if (strpos($line, '#') === 0 || empty($line)) continue;
            list($key, $value) = explode('=', $line, 2);
            putenv(trim($key) . '=' . trim($value));
        }
    }
}

loadEnv(__DIR__ . '/.env');

// ================= DATABASE CONFIG =================
$dbHost = getenv('DB_HOST');
$dbName = getenv('DB_NAME');
$dbUser = getenv('DB_USER');
$dbPass = getenv('DB_PASSWORD');

try {
    $pdo = new PDO("mysql:host=$dbHost;dbname=$dbName;charset=utf8", $dbUser, $dbPass);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    exit("Database connection failed: " . $e->getMessage());
}

// ================= LOGOUT =================
if (isset($_GET['logout'])) {
    session_destroy();
    header("Location: admin.php");
    exit;
}

// ================= LOGIN SESSION =================
$adminPassword = getenv("ADMIN_PASSWORD");

if (!isset($_SESSION['logged_in'])) {
    if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['password'])) {
        if ($_POST['password'] === $adminPassword) {
            $_SESSION['logged_in'] = true;
        } else {
            $login_error = "Invalid password!";
        }
    } else {
        ?>
        <!DOCTYPE html>
        <html>
        <head>
            <title>Admin Login</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        </head>
        <body class="bg-light">
        <div class="container py-5">
            <div class="card p-4 mx-auto" style="max-width:400px">
                <h3 class="mb-3 text-center">Admin Login</h3>
                <?php if (!empty($login_error)) echo '<p class="text-danger">' . htmlspecialchars($login_error) . '</p>'; ?>
                <form method="POST">
                    <input type="password" name="password" class="form-control mb-3" placeholder="Password" required>
                    <button class="btn btn-primary w-100">Login</button>
                </form>
            </div>
        </div>
        </body>
        </html>
        <?php
        exit;
    }
}

// ================= REPLY FUNCTIONALITY (with PHPMailer) =================

if (isset($_POST['send_reply'])) {
    $reply = $_POST['reply'];
    $messageId = $_POST['message_id'];

    // Get the original message data
    $messageData = $pdo->prepare("SELECT * FROM messages WHERE id = ?");
    $messageData->execute([$messageId]);
    $msg = $messageData->fetch(PDO::FETCH_ASSOC);

    // Update the database with the reply
    $stmt = $pdo->prepare("UPDATE messages SET replied_message = ? WHERE id = ?");
    $stmt->execute([$reply, $messageId]);

    // Send the email reply using PHPMailer
    $mail = new PHPMailer\PHPMailer\PHPMailer();
    try {
        // SMTP Configuration
        $mail->isSMTP();
        $mail->Host = 'smtp.gmail.com';  // Use Gmail's SMTP server
        $mail->SMTPAuth = true;
        $mail->Username = 'devjangig@gmail.com';  // Your Gmail email address
        $mail->Password = 'kqhqrggjgsjudmxv';  // Use App Password here if 2FA is enabled
        $mail->SMTPSecure = PHPMailer\PHPMailer\PHPMailer::ENCRYPTION_STARTTLS;  // Use STARTTLS (Port 587)
        $mail->Port = 587;  // Recommended for TLS encryption with Gmail
        
        // Sender and recipient
        $mail->setFrom('devjangig@gmail.com', 'Admin');
        $mail->addAddress($msg['email'], $msg['name']);  // Send email to the user who contacted you

        // Email content
        $mail->isHTML(true);
        $mail->Subject = 'Reply to Your Message from Admin';
        $mail->Body    = "Hello " . $msg['name'] . ",<br><br>The admin has replied to your message:<br><br>" . nl2br(htmlspecialchars($reply)) . "<br><br>Best regards,<br>Admin";

        // Send email
        if ($mail->send()) {
            // Set a session variable for success
            $_SESSION['reply_success'] = true;

            // Redirect back to the admin page
            header("Location: admin.php"); // Redirect to reload the page
            exit;  // Stop further execution
        } else {
            // If email sending fails
            $error_message = "Message could not be sent. Mailer Error: {$mail->ErrorInfo}";
            // Handle the error gracefully (e.g., log or display an error message)
        }
    } catch (Exception $e) {
        // Catch any exceptions during sending
        $error_message = "Message could not be sent. Mailer Error: {$mail->ErrorInfo}";
        // Handle the error gracefully (e.g., log or display an error message)
    }
}






// // Handle Delete Request
if (isset($_POST['delete_message'])) {
    $messageId = $_POST['message_id'];

    // Prepare and execute the delete query
    $stmt = $pdo->prepare("DELETE FROM messages WHERE id = ?");
    $stmt->execute([$messageId]);

    // Redirect back to admin page after deletion
    header("Location: admin.php");
    exit;
}

// ================= SEARCH & PAGINATION =================
$search = $_GET['search'] ?? '';
$sort = $_GET['sort'] ?? 'newest';
$page = max(1, intval($_GET['page'] ?? 1));
$perPage = 10;
$startDate = $_GET['start_date'] ?? '';
$endDate = $_GET['end_date'] ?? '';

$params = [];
$where = '';

if ($search !== '') {
    $where = "WHERE name LIKE ? OR email LIKE ? OR message LIKE ?";
    $like = "%$search%";
    $params = [$like, $like, $like];
}

if ($startDate !== '' && $endDate !== '') {
    $where .= " AND created_at BETWEEN ? AND ?";
    $params[] = $startDate . ' 00:00:00';
    $params[] = $endDate . ' 23:59:59';
}

$countStmt = $pdo->prepare("SELECT COUNT(*) FROM messages $where");
$countStmt->execute($params);
$total = $countStmt->fetchColumn();
$pages = ceil($total / $perPage);
$start = ($page - 1) * $perPage;

$order = $sort === 'oldest' ? 'ASC' : 'DESC';
$sql = "SELECT * FROM messages $where ORDER BY created_at $order LIMIT $start, $perPage";
$stmt = $pdo->prepare($sql);
$stmt->execute($params);

$messages = $stmt->fetchAll(PDO::FETCH_ASSOC);

date_default_timezone_set('Asia/Kolkata');

foreach ($messages as &$msg) {
    $datetime = new DateTime($msg['created_at'], new DateTimeZone('UTC'));
    $datetime->setTimezone(new DateTimeZone('Asia/Kolkata'));
    $msg['formatted_date'] = $datetime->format('F j, Y, g:i a');
}

?>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1>Admin Dashboard</h1>
        <a href="admin.php?logout" class="btn btn-secondary">Logout</a>
    </div>

    <?php if (isset($error_message)): ?>
        <div class="alert alert-danger"><?= $error_message ?></div>
    <?php elseif (isset($_GET['reply_success'])): ?>
        <div class="alert alert-success">Reply sent successfully!</div>
    <?php endif; ?>

    <!-- Search & Filter -->
    <form class="d-flex gap-2 mb-3" method="GET">
        <input type="text" name="search" class="form-control" placeholder="Search messages..." value="<?= htmlspecialchars($search) ?>">
        <select name="sort" class="form-select">
            <option value="newest" <?= $sort === 'newest' ? 'selected' : '' ?>>Newest First</option>
            <option value="oldest" <?= $sort === 'oldest' ? 'selected' : '' ?>>Oldest First</option>
        </select>
        <button type="submit" class="btn btn-success">Filter</button>
    </form>
<form method="POST">
    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
        <?php if (empty($messages)): ?>
            <p class="text-center">No messages found.</p>
        <?php else: foreach ($messages as $msg): ?>
        <div class="col">
            <div class="card p-3 shadow-sm">
                <p>
                <h5 class="card-title"><?= htmlspecialchars($msg['name']) ?></h5>
                <p><strong>Email:</strong> <?= htmlspecialchars($msg['email']) ?></p>
                <p><strong>Message:</strong> <?= htmlspecialchars(substr($msg['message'], 0, 120)) ?>...</p>
                <p><strong>Date:</strong> <?= htmlspecialchars($msg['formatted_date']) ?></p>
                <p><strong>Reply:</strong> <?= htmlspecialchars($msg['replied_message'] ?? '') ?></p>

            </p>
                <div class="d-flex justify-content-between">
                    <!-- Reply Button -->
                    <button type="button" class="btn btn-info btn-sm" data-bs-toggle="modal" data-bs-target="#replyModal<?= $msg['id'] ?>">Reply</button>

                    <!-- Delete Button -->
                    <button type="button" class="btn btn-danger btn-sm" data-bs-toggle="modal" data-bs-target="#deleteModal<?= $msg['id'] ?>">Delete</button>
                </div>
            </div>

            <!-- Modal for replying -->
            <div class="modal fade" id="replyModal<?= $msg['id'] ?>" tabindex="-1" aria-labelledby="replyModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="replyModalLabel">Reply to <?= htmlspecialchars($msg['name']) ?></h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <form method="POST">
                                <textarea name="reply" class="form-control" placeholder="Enter your reply here..." required></textarea>
                                <input type="hidden" name="message_id" value="<?= $msg['id'] ?>">
                                <div class="d-flex justify-content-end mt-3">
                                    <button type="submit" name="send_reply" class="btn btn-primary btn-sm">Send Reply</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Modal for delete confirmation -->
            <div class="modal fade" id="deleteModal<?= $msg['id'] ?>" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="deleteModalLabel">Delete Message from <?= htmlspecialchars($msg['name']) ?></h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <p>Are you sure you want to delete this message?</p>
                        </div>
                        <div class="modal-footer">
                            <form method="POST" action="admin.php">
                                <input type="hidden" name="message_id" value="<?= $msg['id'] ?>">
                                <button type="submit" name="delete_message" class="btn btn-danger btn-sm">Delete</button>
                                <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Cancel</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <?php endforeach; endif; ?>
    </div>
</form>


<!-- Pagination  -->
<nav class="mt-4">
<ul class="pagination justify-content-center">
<?php for($p=1;$p<=$pages;$p++): ?>
<li class="page-item <?= $p==$page?'active':'' ?>">
<a class="page-link"
 href="?page=<?= $p ?>&search=<?= urlencode($search) ?>&sort=<?= $sort ?>">
<?= $p ?>
</a>
</li>
<?php endfor; ?>
</ul>
</nav>

</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Use JavaScript to hide the success message after 2 seconds
    window.onload = function() {
        var successMessage = document.getElementById("successMessage");
        if (successMessage) {
            setTimeout(function() {
                successMessage.style.display = 'none'; // Hide the success message
            }, 2000); // 2000 ms = 2 seconds
        }
    };
</script>
</body>
</html>
