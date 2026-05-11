from fastapi import FastAPI, UploadFile, File, Form
from fastapi.responses import JSONResponse
from aeneas.executetask import ExecuteTask
from aeneas.task import Task
import tempfile
import os

app = FastAPI()

@app.get("/health")
def health():
    return {"status": "ok"}
@app.post("/align")
async def align_lyrics(
    audio: UploadFile = File(...),
    lyrics: str = Form(...)
):
    try:
        with tempfile.TemporaryDirectory() as tmpdir:
            audio_path = os.path.join(tmpdir, "audio.mp3")
            with open(audio_path, "wb") as f:
                f.write(await audio.read())

            lyrics_path = os.path.join(tmpdir, "lyrics.txt")
            with open(lyrics_path, "w", encoding="utf-8") as f:
                f.write(lyrics)

            output_path = os.path.join(tmpdir, "output.json")

            config = "task_language=vie|is_text_type=plain|os_task_file_format=json"
            task = Task(config_string=config)
            task.audio_file_path_absolute = audio_path
            task.text_file_path_absolute  = lyrics_path
            task.sync_map_file_path_absolute = output_path

            ExecuteTask(task).execute()
            task.output_sync_map_file()

            with open(output_path, "r", encoding="utf-8") as f:
                import json
                sync_map = json.load(f)

            # Convert aeneas JSON → LRC string
            lrc_lines = []
            for fragment in sync_map.get("fragments", []):
                begin = float(fragment["begin"])
                text  = fragment["lines"][0] if fragment.get("lines") else ""
                if not text.strip():
                    continue
                minutes = int(begin // 60)
                seconds = begin % 60
                lrc_lines.append(f"[{minutes:02d}:{seconds:05.2f}]{text}")

            lrc_content = "\n".join(lrc_lines)

        return JSONResponse({"lrc": lrc_content})

    except Exception as e:
        print(f"Error in /align: {str(e)}")
        return JSONResponse({"error": str(e)}, status_code=500)