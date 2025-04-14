document.addEventListener("DOMContentLoaded", function () {
    const input = document.getElementById("licenseKey");
    const button = document.getElementById("activateLicense");
    const message = document.getElementById("message");

    button.addEventListener("click", function () {
        const key = input.value.trim();
        if (!key) {
            message.textContent = "Please enter a license key.";
            message.style.color = "red";
            return;
        }

        fetch(`https://4all.in.ua/license-check.php?key=${encodeURIComponent(key)}`)
            .then(response => response.json())
            .then(data => {
                if (data.valid) {
                    message.textContent = "✅ License activated! Redirecting...";
                    message.style.color = "green";

                    chrome.storage.local.set({ licenseKey: key, licenseValid: true }, () => {
                        chrome.runtime.sendMessage({ action: "updateBlocking" });
                        setTimeout(() => {
                            window.location.href = "options.html";
                        }, 1000);
                    });
                } else {
                    message.textContent = data.message || "❌ Invalid or expired license.";
                    message.style.color = "red";
                }
            })
            .catch(error => {
                console.error("License check error:", error);
                message.textContent = "Error checking license. Check your internet connection.";
                message.style.color = "red";
            });
    });
});
