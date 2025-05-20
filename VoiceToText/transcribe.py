from vosk import Model, KaldiRecognizer
import wave
import json

wf = wave.open("recording.wav", "rb")

if wf.getnchannels() != 1 or wf.getsampwidth() != 2 or wf.getframerate() not in [8000, 16000, 44100]:
    print("⚠️ WAV-файл должен быть 16-bit mono (1 канал) с частотой 8000/16000/44100 Гц.")
    exit(1)

model = Model("model")  # путь к модели
rec = KaldiRecognizer(model, wf.getframerate())
println ('start recognizing')
results = []
while True:
    data = wf.readframes(4000)
    if len(data) == 0:
        break
    if rec.AcceptWaveform(data):
        results.append(json.loads(rec.Result())["text"])
println('end while')
results.append(json.loads(rec.FinalResult())["text"])
println("start saving txt")
# Сохраняем результат в файл
with open("transcription.txt", "w", encoding="utf-8") as f:
    f.write(" ".join(results))

print("✅ Распознанный текст сохранён в transcription.txt")
