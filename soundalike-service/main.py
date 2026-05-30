# D:\Project_Music_MelodyHub\source\soundalike-service\main.py

import subprocess
import tempfile
import os
import time
from fastapi import FastAPI, UploadFile, File, Form
from fastapi.responses import JSONResponse
import httpx

app = FastAPI(title="Soundalike Audio Comparison Service")

@app.get("/health")
async def health():
    return {"status": "ok", "service": "soundalike"}

@app.get("/version")
async def version():
    result = subprocess.run(["soundalike", "-version"], capture_output=True, text=True)
    return {"version": result.stdout.strip()}

@app.post("/compare")
async def compare_audio(
    file1: UploadFile = File(...),
    file2: UploadFile = File(...),
    fpcalc_length: int = Form(60)
):
    temp_files = []
    
    try:
        file1_path = tempfile.NamedTemporaryFile(suffix=".mp3", delete=False).name
        file2_path = tempfile.NamedTemporaryFile(suffix=".mp3", delete=False).name
        
        with open(file1_path, "wb") as f:
            f.write(await file1.read())
        with open(file2_path, "wb") as f:
            f.write(await file2.read())
        
        temp_files = [file1_path, file2_path]
        
        start = time.time()
        result = subprocess.run(
            ["soundalike", "-compare", "-fpcalc-length", str(fpcalc_length), file1_path, file2_path],
            capture_output=True,
            text=True,
            timeout=120
        )
        duration_ms = int((time.time() - start) * 1000)
        
        if result.returncode != 0:
            return JSONResponse(status_code=500, content={"error": result.stderr})
        
        similarity_raw = float(result.stdout.strip())
        similarity_percent = round(similarity_raw * 100, 2)
        
        return {
            "success": True,
            "similarity_raw": similarity_raw,
            "similarity_percent": similarity_percent,
            "is_violation": similarity_raw >= 0.60,
            "duration_ms": duration_ms
        }
        
    except Exception as e:
        return JSONResponse(status_code=500, content={"error": str(e)})
    finally:
        for f in temp_files:
            if os.path.exists(f):
                os.unlink(f)

@app.post("/compare-urls")
async def compare_urls(
    url1: str = Form(...),
    url2: str = Form(...),
    fpcalc_length: int = Form(60)
):
    temp_files = []
    
    try:
        file1_path = tempfile.NamedTemporaryFile(suffix=".mp3", delete=False).name
        file2_path = tempfile.NamedTemporaryFile(suffix=".mp3", delete=False).name
        
        async with httpx.AsyncClient() as client:
            r1 = await client.get(url1, timeout=60)
            r2 = await client.get(url2, timeout=60)
            
            with open(file1_path, "wb") as f:
                f.write(r1.content)
            with open(file2_path, "wb") as f:
                f.write(r2.content)
        
        temp_files = [file1_path, file2_path]
        
        result = subprocess.run(
            ["soundalike", "-compare", "-fpcalc-length", str(fpcalc_length), file1_path, file2_path],
            capture_output=True,
            text=True,
            timeout=120
        )
        
        if result.returncode != 0:
            return {"error": result.stderr}
        
        similarity_raw = float(result.stdout.strip())
        
        return {
            "success": True,
            "similarity_raw": similarity_raw,
            "similarity_percent": round(similarity_raw * 100, 2),
            "is_violation": similarity_raw >= 0.60
        }
        
    finally:
        for f in temp_files:
            if os.path.exists(f):
                os.unlink(f)