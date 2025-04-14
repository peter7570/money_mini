document.addEventListener("DOMContentLoaded", () => {
    const licenseContainer = document.getElementById("licenseContainer");
    const licenseKeyInput = document.getElementById("licenseKey");
    const saveLicenseButton = document.getElementById("saveLicense");
    const licenseStatus = document.getElementById("licenseStatus");

    const content = document.getElementById("content");
    const resourceInput = document.getElementById("resource");
    const blockStartDate = document.getElementById("blockStartDate");
    const blockStartTime = document.getElementById("blockStartTime");
    const blockEndDate = document.getElementById("blockEndDate");
    const blockEndTime = document.getElementById("blockEndTime");
    const addToBlacklistButton = document.getElementById("addToBlacklist");
    const blacklistList = document.getElementById("blacklist");
    const blacklistTitle = document.getElementById("blacklistTitle");

    // ✅ Проверка лицензии при загрузке
    chrome.storage.local.get(["licenseKey", "licenseValid"], (data) => {
        if (data.licenseKey && data.licenseValid) {
            licenseContainer.classList.add("hidden");
            content.classList.remove("hidden");
            loadBlacklist();
        } else {
            licenseContainer.classList.remove("hidden");
            content.classList.add("hidden");
        }
    });

    // 🔐 Сохранение лицензии
    saveLicenseButton.addEventListener("click", () => {
        const key = licenseKeyInput.value.trim();
        if (!key) return;

        fetch(`https://4all.in.ua/license-check.php?key=${encodeURIComponent(key)}`)
            .then((res) => res.json())
            .then((data) => {
                if (data.valid) {
                    chrome.storage.local.set({ licenseKey: key, licenseValid: true }, () => {
                        licenseStatus.textContent = "✅ License Activated!";
                        licenseContainer.classList.add("hidden");
                        content.classList.remove("hidden");
                        loadBlacklist();
                        chrome.runtime.sendMessage({ action: "updateBlocking" });
                    });
                } else {
                    licenseStatus.textContent = "❌ Invalid or expired license.";
                    chrome.storage.local.set({ licenseValid: false });
                }
            })
            .catch(() => {
                licenseStatus.textContent = "Error checking license.";
            });
    });

    // 📥 Загрузка черного списка
    function loadBlacklist() {
        chrome.storage.local.get(["blacklist"], (data) => {
            const blacklist = data.blacklist || [];
            if (blacklist.length > 0) {
                blacklist.forEach(addBlacklistEntryToUI);
                blacklistTitle.classList.remove("hidden");
            }
        });
    }

    // ➕ Добавить в черный список
    function addToBlacklist() {
        const resource = resourceInput.value.trim();
        const startDate = blockStartDate.value;
        const startTime = blockStartTime.value || "00:00";
        const endDate = blockEndDate.value;
        const endTime = blockEndTime.value || "23:59";

        if (!resource) {
            alert("Please enter a domain.");
            return;
        }

        const entry = {
            resource,
            startDate: startDate || "1970-01-01",
            startTime: startDate ? startTime : "00:00",
            endDate: endDate || "2999-12-31",
            endTime: endDate ? endTime : "23:59"
        };

        chrome.storage.local.get("blacklist", (data) => {
            const blacklist = data.blacklist || [];
            blacklist.push(entry);
            chrome.storage.local.set({ blacklist }, () => {
                addBlacklistEntryToUI(entry);
                blacklistTitle.classList.remove("hidden");
                chrome.runtime.sendMessage({ action: "updateBlocking" });
            });
        });

        resourceInput.value = "";
        blockStartDate.value = "";
        blockStartTime.value = "";
        blockEndDate.value = "";
        blockEndTime.value = "";
    }

    // ❌ Удалить сайт из черного списка
    function removeFromBlacklist(entry) {
        chrome.storage.local.get("blacklist", (data) => {
            const updated = (data.blacklist || []).filter(
                (item) =>
                    !(
                        item.resource === entry.resource &&
                        item.startDate === entry.startDate &&
                        item.endDate === entry.endDate
                    )
            );
            chrome.storage.local.set({ blacklist: updated }, () => {
                renderBlacklistUI(updated);
                chrome.runtime.sendMessage({ action: "updateBlocking" });
            });
        });
    }

    // 🔁 Перерисовка UI
    function renderBlacklistUI(blacklist) {
        blacklistList.innerHTML = "";
        if (blacklist.length === 0) {
            blacklistTitle.classList.add("hidden");
            return;
        }
        blacklist.forEach(addBlacklistEntryToUI);
    }

    // 👁️ Добавить сайт в DOM
    function addBlacklistEntryToUI(entry) {
        const li = document.createElement("li");
        li.innerHTML = `
            <strong>${entry.resource}</strong><br>
            <span>From: ${entry.startDate} ${entry.startTime}</span><br>
            <span>Until: ${entry.endDate} ${entry.endTime}</span>
        `;

        const btn = document.createElement("button");
        btn.classList.add("remove-btn");
        btn.textContent = "Remove";
        btn.addEventListener("click", () => removeFromBlacklist(entry));

        li.appendChild(btn);
        blacklistList.appendChild(li);
    }

    // 📌 Обработка событий
    addToBlacklistButton.addEventListener("click", addToBlacklist);
});
