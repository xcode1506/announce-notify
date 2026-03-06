kc-announce - RedM Announcement System
A professional announcement system for RedM servers using RSG Core framework, featuring role-based permissions and priority queuing.

📋 Overview
kc-announce is a comprehensive announcement system designed for RedM servers running RSG Core. It allows authorized personnel (Law Enforcement, Medical Staff, and Administrators) to send important announcements to all players with a clean, modern UI and intelligent priority-based message handling.

✨ Features
Role-Based Access Control

Law Enforcement (sheriff, lawman, vallaw, blklaw, strlaw, rholaw)

Medical Staff (medic, doctor, ems, valmedic, blkmedic, strawmedic)

Administrators (ACE permission based)

Smart Priority System

Admin announcements (Priority 3) - Highest priority

Law announcements (Priority 2) - Medium priority

Medical announcements (Priority 1) - Standard priority

Higher priority messages automatically override lower priority ones

Professional UI/UX

Clean, modern notification interface

Role-specific styling and colors

Built-in sound effects for different announcement types

Smooth animations and transitions

Reliable Performance

Automatic permission sync on player load, job change, and resource restart

Periodic permission refresh every 60 seconds

Message queuing system prevents overlaps

Priority-based message management

🎮 Commands
Command	Description	Permission Required
/announce	Open admin announcement panel	Admin (ACE permission)
/law	Open law enforcement announcement panel	Law jobs (on duty)
/medic	Open medical announcement panel	Medical jobs (on duty)
🔧 Configuration
Job Whitelist Configuration
Edit server.lua to modify authorized jobs:

lua
-- Law Enforcement Jobs
local LawJobs = {
    vallaw = true,
    blklaw = true,
    strlaw = true,
    rholaw = true,
    lawman = true,
    sheriff = true
    -- Add your custom law jobs here
}

-- Medical Jobs
local MedicJobs = {
    medic = true,
    doctor = true,
    ems = true,
    valmedic = true,
    blkmedic = true,
    strawmedic = true
    -- Add your custom medical jobs here
}
Priority Levels
Adjust priority levels in client.lua:

lua
local Priority = {
    admin = 3,  -- Highest priority
    law = 2,    -- Medium priority
    medic = 1   -- Standard priority
}
Display Duration
Modify the announcement display duration in client.lua:

lua
Citizen.SetTimeout(8000, function()  -- 8 seconds (adjust as needed)
    ProcessQueue()
end)
📥 Installation
Download the resource to your server's resources folder

Ensure rsg-core is properly installed and running

Add to your server.cfg:

text
ensure kc-announce
Configure job lists in server.lua to match your server

Restart your server or start the resource

🔒 Security Features
Server-side permission validation for all announcements

Job and duty status verification

ACE permission checking for admin commands

No client-side permission manipulation possible

Automatic permission sync and refresh

🚀 Usage
Law/Medical Personnel: Type /law or /medic while on duty

Admins: Type /announce (requires ACE permission)

Type your announcement message in the NUI panel

Send - the announcement appears to all players with appropriate styling

📁 Dependencies
RSG Core - Required framework

⚙️ Technical Details
Priority System: Higher priority announcements interrupt lower priority ones

Queue Management: Messages are queued during active announcements

Permission Sync: Automatic sync on player load, job change, and resource restart

Resource Efficiency: Lightweight with minimal performance impact

🎨 UI Features
Admin: Distinctive styling for server-wide announcements

Law: Law enforcement specific appearance

Medical: Medical service specific appearance

Sound Effects: Role-specific notification sounds

Animations: Smooth entry and exit animations

🔄 Automatic Processes
Permission sync on player connection

Permission update on job change

Full permission resync on resource restart

Periodic permission refresh every 60 seconds

Message queue auto-processing

🛠️ Troubleshooting
Q: Announcements not showing?

Check if you're on duty (for law/medic roles)

Verify job name matches configuration

Check server console for errors

Q: No permission error?

Confirm job is in whitelist (law/medic)

Check ACE permissions for admin

Ensure resource started after RSG Core

Q: UI not opening?

Check command spelling

Verify permissions are synced

Check client console for errors

📝 Notes
Players must be on duty to use law/medic announcements

Admin announcements work regardless of duty status

All announcements are broadcast to all players

The system includes proper error handling and validation

📄 License
This resource is open-source and free to use for RedM servers. Modify as needed for your server's requirements.

