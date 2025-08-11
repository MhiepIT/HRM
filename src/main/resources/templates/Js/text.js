window.onload = function () {
    const user = JSON.parse(localStorage.getItem('loggedInUser'));
    if (!user || !user.username) {
        alert("Bạn chưa đăng nhập.");
        window.location.href = "/login";
        return;
    }

    document.getElementById('username').textContent = user.username;
    loadMessages();
    document.getElementById('messageInput').addEventListener('keydown', function (e) {
        if (e.key === 'Enter') sendMessage();
    });
};

function loadMessages() {
    fetch("http://localhost:8080/api/texts")
        .then(response => {
            if (!response.ok) throw new Error("Không thể load tin nhắn");
            return response.json();
        })
        .then(messages => {
            const messageList = document.getElementById('messageList');
            messageList.innerHTML = '';
            messages.forEach(appendMessageToChat);
        })
        .catch(error => {
            console.error("Lỗi khi tải tin nhắn:", error);
        });
}

function sendMessage() {
    const input = document.getElementById('messageInput');
    const messageText = input.value.trim();
    if (!messageText) return;

    const user = JSON.parse(localStorage.getItem('loggedInUser'));
    const createdAt = new Date().toISOString();

    const payload = {
        text: `${user.username}: ${messageText}`,
        createdAt: createdAt
    };

    fetch('http://localhost:8080/api/texts', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(payload)
    })
        .then(response => {
            if (!response.ok) throw new Error("Gửi tin nhắn thất bại");
            return response.json();
        })
        .then(savedMessage => {
            appendMessageToChat(savedMessage);
            input.value = '';
        })
        .catch(error => {
            console.error("Lỗi gửi tin nhắn:", error);
            alert("Không thể gửi tin nhắn.");
        });
}

function appendMessageToChat(messageObj) {
    const messageList = document.getElementById('messageList');
    const div = document.createElement('div');
    div.className = 'chat-message';

    const timestamp = new Date(messageObj.createdAt).toLocaleString("vi-VN");
    div.textContent = `${messageObj.text} 🕒 (${timestamp})`;

    messageList.appendChild(div);
    messageList.scrollTop = messageList.scrollHeight;
}
