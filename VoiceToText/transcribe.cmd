rem // ffmpeg -i output.wav -af "loudnorm=I=-23:TP=-1.5:LRA=11" normalized.wav
ffmpeg -i output.wav -filter:a "dynaudnorm" normalized.wav
ffmpeg -i normalized.wav -af "afftdn" denoised.wav
rem // ffmpeg -i normalized.wav -af "highpass=f=200, lowpass=f=3000, afftdn" denoised.wav
rem vosk-transcriber -l ru -i denoised.wav -m model -o text.txt
vosk-transcriber -l ru -i denoised.wav  -o text.txt

rem // vosk-transcriber --list-languages
rem // python transcribe.py
pause