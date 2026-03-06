/* =====================================================
   KC ANNOUNCE - FINAL SCRIPT (STABLE VERSION)
===================================================== */

/* =========================
   ELEMENT REFERENCES
========================= */

const container = document.getElementById("announce-container");
const text = document.getElementById("announce-text");
const badge = document.getElementById("badge");

const panel = document.getElementById("panel");
const messageBox = document.getElementById("message");
const closeBtn = document.getElementById("close");
const sendBtn = document.getElementById("send");

/* AUDIO */
const soundAdmin = document.getElementById("sound-admin");
const soundLaw = document.getElementById("sound-law");
const soundMedic = document.getElementById("sound-medic");

let hideTimeout = null;


/* =====================================================
   AUDIO SYSTEM (OGG GUARANTEED PLAY)
===================================================== */

function playSound(type) {

    let audio = null;

    if (type === "admin") audio = soundAdmin;
    if (type === "law") audio = soundLaw;
    if (type === "medic") audio = soundMedic;

    if (!audio) return;

    audio.pause();
    audio.currentTime = 0;
    audio.volume = 0.35;

    audio.play().catch(() => {});
}


/* =====================================================
   RECEIVE MESSAGE FROM CLIENT.LUA
===================================================== */

window.addEventListener("message", (event) => {

    const data = event.data;

    /* ---------- OPEN INPUT PANEL ---------- */
    if (data.action === "open") {
        openPanel();
        return;
    }

    /* ---------- SHOW NOTIFICATION ---------- */
    if (data.action === "notify") {

        text.innerHTML = data.message;

        // BADGE SWITCH
        if (data.type === "admin")
            badge.src = "images/badge_admin.png";

        if (data.type === "law")
            badge.src = "images/badge_law.png";

        if (data.type === "medic")
            badge.src = "images/badge_medic.png";

        showNotification();
        playSound(data.type); // 🔊 SOUND TRIGGER

        return;
    }

    /* ---------- FORCE CLEAR (ADMIN OVERRIDE) ---------- */
    if (data.action === "clear") {

        if (hideTimeout)
            clearTimeout(hideTimeout);

        container.classList.remove("slide-in");
        container.classList.add("slide-out");

        setTimeout(() => {
            container.style.display = "none";
        }, 400);
    }

});


/* =====================================================
   PANEL CONTROL
===================================================== */

function openPanel() {

    panel.style.display = "block";

    setTimeout(() => {
        messageBox.focus();
    }, 50);
}

function closePanel() {

    panel.style.display = "none";
    messageBox.value = "";

    fetch(`https://${GetParentResourceName()}/close`, {
        method: "POST"
    });
}


/* =====================================================
   SEND ANNOUNCEMENT
===================================================== */

function sendNotice() {

    const msg = messageBox.value.trim();
    if (!msg) return;

    fetch(`https://${GetParentResourceName()}/send`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
            message: msg
        })
    });

    closePanel();
}


/* =====================================================
   BUTTON EVENTS
===================================================== */

closeBtn.onclick = closePanel;
sendBtn.onclick = sendNotice;


/* =====================================================
   KEYBOARD CONTROLS
===================================================== */

document.addEventListener("keydown", (e) => {

    if (e.key === "Escape" && panel.style.display === "block") {
        closePanel();
    }

    if (e.key === "Enter" && !e.shiftKey && panel.style.display === "block") {
        e.preventDefault();
        sendNotice();
    }
});


/* =====================================================
   NOTIFICATION ANIMATION (CINEMATIC SLIDE)
===================================================== */

function showNotification() {

    container.style.display = "block";

    // reset animation safely
    container.classList.remove("slide-out");
    void container.offsetWidth;
    container.classList.add("slide-in");

    if (hideTimeout)
        clearTimeout(hideTimeout);

    hideTimeout = setTimeout(() => {

        container.classList.remove("slide-in");
        container.classList.add("slide-out");

        setTimeout(() => {
            container.style.display = "none";
        }, 500);

    }, 8000);
}


/* =====================================================
   AUDIO WARMUP (NO FIRST DELAY)
===================================================== */

window.addEventListener("load", () => {

    [soundAdmin, soundLaw, soundMedic].forEach(audio => {

        if (!audio) return;

        audio.volume = 0;

        audio.play().then(() => {
            audio.pause();
            audio.currentTime = 0;
            audio.volume = 0.35;
        }).catch(()=>{});
    });

});