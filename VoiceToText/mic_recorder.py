import sounddevice as sd
import soundfile as sf
import keyboard
import time
import numpy as np
from datetime import datetime

recording = False
samplerate = 44100
channels = 1
buffer = []

def callback(indata, frames, time_info, status):
    if recording:
        buffer.append(indata.copy())

print("Нажмите и удерживайте ScrollLock для записи. Отпустите — чтобы остановить.")

while True:
    if keyboard.is_pressed("scroll lock") and not recording:
        print("🎙️ Начало записи...")
        buffer = []
        recording = True
        stream = sd.InputStream(samplerate=samplerate, channels=channels, callback=callback)
        stream.start()
    elif not keyboard.is_pressed("scroll lock") and recording:
        print("🛑 Остановка записи...")
        recording = False
        stream.stop()
        stream.close()
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        filename = f"recording_{timestamp}.wav"
        audio_data = np.concatenate(buffer, axis=0)  # Соединяем фреймы
        sf.write(filename, audio_data, samplerate)
        print(f"💾 Сохранено: {filename}")
        break
    time.sleep(0.1)
