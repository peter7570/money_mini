chrome.runtime.onInstalled.addListener(() => {
    chrome.storage.local.get(["blacklist"], (data) => {
        if (!data.blacklist) {
            chrome.storage.local.set({ blacklist: [] });
        }
    });

    checkLicenseOnStartup();
});

/** 🔐 Проверка лицензии при запуске */
function checkLicenseOnStartup() {
    chrome.storage.local.get(["licenseKey", "licenseValid"], (data) => {
        if (data.licenseKey && data.licenseValid) {
            console.log("✅ License valid. Enabling blocking.");
            updateBlockingRules();
        } else {
            console.warn("🔴 No valid license. Blocking disabled.");
        }
    });
}

/** 🧠 Проверка, активна ли блокировка по дате */
function isWithinBlockRange(entry) {
    const now = new Date();
    const start = new Date(`${entry.startDate}T${entry.startTime || "00:00"}`);
    const end = new Date(`${entry.endDate}T${entry.endTime || "23:59"}`);
    return now >= start && now <= end;
}

/** 🔄 Основная функция обновления правил */
function updateBlockingRules() {
    chrome.storage.local.get(["blacklist", "licenseValid"], (data) => {
        if (!data.licenseValid) {
            console.warn("🔒 License invalid. Blocking skipped.");
            return;
        }

        const fullBlacklist = data.blacklist || [];
        const now = new Date();

        // Удаляем просроченные записи
        const validEntries = fullBlacklist.filter(isWithinBlockRange);
        if (validEntries.length !== fullBlacklist.length) {
            chrome.storage.local.set({ blacklist: validEntries }, () => {
                console.log("🧹 Cleaned expired blacklist entries.");
            });
        }

        // Создаём правила на основе валидных
        const rules = [];
        let ruleId = 1;

        validEntries.forEach(entry => {
            rules.push({
                id: ruleId++,
                priority: 1,
                action: {
                    type: "redirect",
                    redirect: { url: chrome.runtime.getURL("blocked.html") }
                },
                condition: {
                    urlFilter: `||${entry.resource}`,
                    resourceTypes: ["main_frame"]
                }
            });
        });

        // Удаляем ВСЕ старые правила и добавляем новые
        const allIds = Array.from({ length: 1000 }, (_, i) => i + 1); // максимум 1000
        chrome.declarativeNetRequest.updateDynamicRules({
            removeRuleIds: allIds,
            addRules: rules
        }, () => {
            console.log(`✅ Updated ${rules.length} blocking rules`);
        });
    });
}

/** 🔁 При сообщении извне */
chrome.runtime.onMessage.addListener((message) => {
    if (message.action === "updateBlocking") {
        updateBlockingRules();
    }
});

/** ⏱️ Автообновление раз в 1 минуту */
setInterval(() => {
    updateBlockingRules();
}, 60 * 1000);

/** 🔄 При загрузке вкладки */
chrome.tabs.onUpdated.addListener((tabId, changeInfo) => {
    if (changeInfo.status === "complete") {
        updateBlockingRules();
    }
});
