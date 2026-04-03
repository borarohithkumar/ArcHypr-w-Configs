import sys
import asyncio
import os
import time
import subprocess
from telethon import TelegramClient

# --- CONFIGURATION ---
API_ID = int(os.environ.get('TG_API_ID', 0))
API_HASH = os.environ.get('TG_API_HASH', '')
SESSION = os.path.expanduser('~/linux_session')
# ---------------------
# ---------------------

def notify(title, content):
    """Triggers a Linux desktop notification."""
    try:
        subprocess.run(['notify-send', title, content], check=False)
    except FileNotFoundError:
        pass

# Global variable to track live transfer speeds
start_time = 0

async def progress(current, total, prefix="Processing"):
    global start_time
    if current == 0:
        start_time = time.time()
        
    elapsed = time.time() - start_time
    # Calculate MB/s
    speed = (current / 1024 / 1024) / elapsed if elapsed > 0 else 0
    
    percent = (current / total) * 100
    bar_length = 20
    filled = int(bar_length * current // total)
    bar = '█' * filled + '-' * (bar_length - filled)
    
    # Now includes live MB/s speed tracking
    sys.stdout.write(f'\r⏳ {prefix}: [{bar}] {percent:.1f}% ({current/1024/1024:.1f}MB / {total/1024/1024:.1f}MB) @ {speed:.1f} MB/s')
    sys.stdout.flush()

async def main():
    global start_time
    
    if len(sys.argv) < 2:
        print("Usage:")
        print("  tg up <file_path>  # Upload a file")
        print("  tg dl <query>      # Search and download a file")
        print("  tg ls              # List the 10 most recent files")
        return

    cmd = sys.argv[1].lower()
    
    # connection_retries increased slightly for stability at high speeds
    async with TelegramClient(SESSION, API_ID, API_HASH, connection_retries=5) as client:
        
        # --- UPLOAD ---
        if cmd == 'up':
            if len(sys.argv) < 3:
                return print("❌ Error: Specify a file to upload.")
            
            path = sys.argv[2]
            if not os.path.exists(path):
                return print(f"❌ Error: File not found at '{path}'")
                
            print(f"🚀 Uploading: {path}")
            start_time = time.time() # Reset timer for accurate speed
            await client.send_file('me', path, progress_callback=lambda c, t: progress(c, t, "Uploading"))
            print("\n✅ Upload complete.")
            notify("Telegram Upload", f"Finished: {os.path.basename(path)}")

        # --- DOWNLOAD ---
        elif cmd == 'dl':
            query = sys.argv[2] if len(sys.argv) > 2 else ""
            print(f"🔍 Searching for '{query}' in Saved Messages...")
            
            async for msg in client.iter_messages('me', search=query):
                if msg.media:
                    filename = getattr(msg.file, 'name', 'unnamed_file')
                    print(f"📦 Found: {filename}")
                    
                    start_time = time.time() # Reset timer for accurate speed
                    path = await client.download_media(msg, progress_callback=lambda c, t: progress(c, t, "Downloading"))
                    print(f"\n✅ Done! Saved to: {path}")
                    notify("Telegram Download", f"Finished: {filename}")
                    return
            print("\n❌ No matching media found.")

        # --- LIST ---
        elif cmd == 'ls':
            print("📅 10 most recent files in Saved Messages:")
            count = 0
            async for msg in client.iter_messages('me', limit=30):
                if msg.media:
                    name = getattr(msg.file, 'name', 'Media (No Name)')
                    size = getattr(msg.file, 'size', 0) / (1024 * 1024)
                    print(f" - {name} ({size:.1f} MB)")
                    
                    count += 1
                    if count >= 10: 
                        break

if __name__ == '__main__':
    asyncio.run(main())
