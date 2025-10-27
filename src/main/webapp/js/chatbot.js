const chatBody = document.querySelector(".chat-body");
const messageInput = document.querySelector(".message-input");
const sendMessageButton = document.querySelector("#send-message");
const fileInput = document.querySelector("#file-input");
const fileUploadWrapper = document.querySelector(".file-upload-wrapper");
const fileCancelButton = document.querySelector("#file-cancel");
const chatbotToggler = document.querySelector("#chatbot-toggler");
const closeChatbot = document.querySelector("#close-chatbot");


// Api setup - Sử dụng Gemini API
const API_KEY = "AIzaSyBb69nSya4kTsfgsqGH_sXRadPH2pZjASU";
const API_URL = `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=${API_KEY}`;

const userData = {
    message: null,
    file: {
        data: null,
        mime_type: null
    }
};

// System context cho chatbot - thông tin về phòng khám
const systemContext = `Bạn là trợ lý ảo của Phòng Khám Nha Khoa DentalCare. 
THÔNG TIN PHÒNG KHÁM:
- Địa chỉ: 123 Đường Sức Khỏe, Quận Y Tế, Thành Phố 12345
- Hotline: (555) 123-4567
- Email: info@dentalcare.com
- Giờ làm việc: Thứ 2-Thứ 6: 8h-18h, Thứ 7: 9h-15h, Chủ Nhật: Nghỉ

DỊCH VỤ:
- Khám tổng quát: $50-80
- Vệ sinh răng: $80-120
- Niềng răng: $2000-5000
- Làm răng sứ: $500-2000/nhân
- Nhổ răng khôn: $150-300
- Điều trị tủy răng: $200-500

QUAN TRỌNG:
- Luôn trả lời thân thiện, chuyên nghiệp
- Không đưa ra chẩn đoán y khoa
- Khuyên liên hệ trực tiếp cho trường hợp phức tạp
- Trường hợp khẩn cấp yêu cầu đến phòng khám ngay`;

// Lịch sử chat
const chatHistory = [
    {
        role: "user",
        parts: [{
            text: systemContext
        }]
    },
    {
        role: "model",
        parts: [{
            text: "Xin chào! 👋 Tôi là chatbot của Phòng Khám Nha Khoa DentalCare. Tôi có thể giúp bạn:\n\n" +
                "• Trả lời câu hỏi về dịch vụ nha khoa\n" +
                "• Hướng dẫn đặt lịch hẹn online\n" +
                "• Giải thích về các phương pháp điều trị\n" +
                "• Tư vấn chăm sóc răng miệng\n" +
                "• Cung cấp thông tin về giờ làm việc và địa chỉ\n\n" +
                "Bạn cần hỗ trợ gì hôm nay?"
        }]
    }
];

const initialInputHeight = messageInput.scrollHeight;

// Create message element with dynamic classes and return it
const createMessageElement = (content, ...classes) => {
    const div = document.createElement("div");
    div.classList.add("message", ...classes);
    div.innerHTML = content;
    return div;
};

// Generate bot response using API
const generateBotResponse = async (incomingMessageDiv) => {
    const messageElement = incomingMessageDiv.querySelector(".message-text");

    chatHistory.push({
        role: "user",
        parts: [{ text: userData.message }, ...(userData.file.data ? [{ inline_data: userData.file }] : [])],
    });

    // API request options
    const requestOptions = {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
            contents: chatHistory
        })
    }

    try {
        // Fetch bot response from API
        const response = await fetch(API_URL, requestOptions);
        const data = await response.json();
        
        if (!response.ok) {
            let errorMsg = "Xin lỗi, tôi gặp sự cố kỹ thuật. ";
            if (data.error && data.error.message) {
                console.error("API Error:", data.error.message);
            }
            throw new Error(errorMsg);
        }

        // Extract and display bot's response text
        if (data.candidates && data.candidates[0] && data.candidates[0].content && data.candidates[0].content.parts && data.candidates[0].content.parts[0]) {
            const apiResponseText = data.candidates[0].content.parts[0].text.replace(/\*\*(.*?)\*\*/g, "$1").trim();
            messageElement.innerText = apiResponseText;
            chatHistory.push({
                role: "model",
                parts: [{ text: apiResponseText }]
            });
        } else {
            throw new Error("Không thể nhận được phản hồi từ hệ thống");
        }
    } catch (error) {
        console.error("Chatbot error:", error);
        messageElement.innerText = "Xin lỗi, tôi đang gặp sự cố kỹ thuật. Vui lòng:\n\n" +
            "📞 Gọi trực tiếp: (555) 123-4567\n" +
            "✉️ Email: info@dentalcare.com\n" +
            "📍 Địa chỉ: 123 Đường Sức Khỏe, Quận Y Tế\n\n" +
            "Hoặc vui lòng thử lại sau!";
        messageElement.style.color = "#dc2626";
        messageElement.style.fontSize = "0.9rem";
    } finally {
        userData.file = {};
        incomingMessageDiv.classList.remove("thinking");
        chatBody.scrollTo({ behavior: "smooth", top: chatBody.scrollHeight });
    }
};

// Handle outgoing user message
const handleOutgoingMessage = (e) => {
    e.preventDefault();
    userData.message = messageInput.value.trim();
    if (!userData.message) return; // Don't send empty messages
    
    messageInput.value = "";
    fileUploadWrapper.classList.remove("file-uploaded");
    messageInput.dispatchEvent(new Event("input"));

    // Create and display user message
    const messageContent = `<div class="message-text"></div>
                            ${userData.file.data ? `<img src="data:${userData.file.mime_type};base64,${userData.file.data}" class="attachment" />` : ""}`;

    const outgoingMessageDiv = createMessageElement(messageContent, "user-message");
    outgoingMessageDiv.querySelector(".message-text").innerText = userData.message;
    chatBody.appendChild(outgoingMessageDiv);
    chatBody.scrollTop = chatBody.scrollHeight;

    // Simulate bot response with thinking indicator after a delay
    setTimeout(() => {
        const messageContent = `<svg class="bot-avatar" xmlns="http://www.w3.org/2000/svg" width="50" height="50" viewBox="0 0 1024 1024">
                    <path d="M738.3 287.6H285.7c-59 0-106.8 47.8-106.8 106.8v303.1c0 59 47.8 106.8 106.8 106.8h81.5v111.1c0 .7.8 1.1 1.4.7l166.9-110.6 41.8-.8h117.4l43.6-.4c59 0 106.8-47.8 106.8-106.8V394.5c0-59-47.8-106.9-106.8-106.9zM351.7 448.2c0-29.5 23.9-53.5 53.5-53.5s53.5 23.9 53.5 53.5-23.9 53.5-53.5 53.5-53.5-23.9-53.5-53.5zm157.9 267.1c-67.8 0-123.8-47.5-132.3-109h264.6c-8.6 61.5-64.5 109-132.3 109zm110-213.7c-29.5 0-53.5-23.9-53.5-53.5s23.9-53.5 53.5-53.5 53.5 23.9 53.5 53.5-23.9 53.5-53.5 53.5zM867.2 644.5V453.1h26.5c19.4 0 35.1 15.7 35.1 35.1v121.1c0 19.4-15.7 35.1-35.1 35.1h-26.5zM95.2 609.4V488.2c0-19.4 15.7-35.1 35.1-35.1h26.5v191.3h-26.5c-19.4 0-35.1-15.7-35.1-35.1zM561.5 149.6c0 23.4-15.6 43.3-36.9 49.7v44.9h-30v-44.9c-21.4-6.5-36.9-26.3-36.9-49.7 0-28.6 23.3-51.9 51.9-51.9s51.9 23.3 51.9 51.9z"></path>
                </svg>
                <div class="message-text">
                    <div class="thinking-indicator">
                        <div class="dot"></div>
                        <div class="dot"></div>
                        <div class="dot"></div>
                    </div>
                </div>`;

        const incomingMessageDiv = createMessageElement(messageContent, "bot-message", "thinking");
        chatBody.appendChild(incomingMessageDiv);
        chatBody.scrollTo({ behavior: "smooth", top: chatBody.scrollHeight });
        generateBotResponse(incomingMessageDiv);
    }, 600);
};

// Handle Enter key press for sending messages
if (messageInput) {
    messageInput.addEventListener("keydown", (e) => {
        const userMessage = e.target.value.trim();
        if (e.key === "Enter" && userMessage && !e.shiftKey && window.innerWidth > 768) {
            handleOutgoingMessage(e);
        }
    });

    messageInput.addEventListener("input", (e) => {
        messageInput.style.height = `${initialInputHeight}px`;
        messageInput.style.height = `${messageInput.scrollHeight}px`;
        const form = document.querySelector(".chat-form");
        if (form) {
            form.style.borderRadius = messageInput.scrollHeight > initialInputHeight ? "15px" : "32px";
        }
    });
}

// Handle file input change event
if (fileInput) {
    fileInput.addEventListener("change", async (e) => {
        const file = e.target.files[0];
        if (!file) return;
        const validImageTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
        if (!validImageTypes.includes(file.type)) {
            await Swal.fire({
                icon: 'error',
                title: 'Lỗi',
                text: 'Chỉ chấp nhận file ảnh (JPEG, PNG, GIF, WEBP)',
                confirmButtonText: 'OK'
            });
            resetFileInput();
            return;
        }
        const reader = new FileReader();
        reader.onload = (e) => {
            fileUploadWrapper.querySelector("img").src = e.target.result;
            fileUploadWrapper.classList.add("file-uploaded");
            const base64String = e.target.result.split(",")[1];
            userData.file = {
                data: base64String,
                mime_type: file.type
            };
        };
        reader.readAsDataURL(file);
    });
}

if (fileCancelButton) {
    fileCancelButton.addEventListener("click", (e) => {
        userData.file = {};
        fileUploadWrapper.classList.remove("file-uploaded");
    });
}

function resetFileInput() {
    fileInput.value = "";
    fileUploadWrapper.classList.remove("file-uploaded");
    fileUploadWrapper.querySelector("img").src = "#";
    userData.file = { data: null, mime_type: null };
}

// Initialize emoji picker
if (typeof EmojiMart !== 'undefined') {
    const picker = new EmojiMart.Picker({
        theme: "light",
        showSkinTones: "none",
        previewPosition: "none",
        onEmojiSelect: (emoji) => {
            const { selectionStart: start, selectionEnd: end } = messageInput;
            messageInput.setRangeText(emoji.native, start, end, "end");
            messageInput.focus();
        },
        onClickOutside: (e) => {
            if (e.target.id === "emoji-picker") {
                document.body.classList.toggle("show-emoji-picker");
            } else {
                document.body.classList.remove("show-emoji-picker");
            }
        },
    });

    const chatForm = document.querySelector(".chat-form");
    if (chatForm) {
        chatForm.appendChild(picker);
    }
}

// Initialize event listeners
if (sendMessageButton) {
    sendMessageButton.addEventListener("click", (e) => handleOutgoingMessage(e));
}

if (document.querySelector("#file-upload")) {
    document.querySelector("#file-upload").addEventListener("click", (e) => fileInput.click());
}

if (chatbotToggler) {
    chatbotToggler.addEventListener("click", () => document.body.classList.toggle("show-chatbot"));
}

if (closeChatbot) {
    closeChatbot.addEventListener("click", () => document.body.classList.remove("show-chatbot"));
}

