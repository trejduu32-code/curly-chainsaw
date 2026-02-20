from fastapi import FastAPI, Request
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
from playwright.async_api import async_playwright
import asyncio

app = FastAPI()
app.mount("/static", StaticFiles(directory="static"), name="static")

tabs = {}

@app.on_event("startup")
async def startup():
    global browser, pw
    pw = await async_playwright().start()
    browser = await pw.chromium.launch(headless=True)
    print("Chromium launched headless")

@app.get("/", response_class=HTMLResponse)
async def homepage(request: Request):
    with open("static/index.html") as f:
        return HTMLResponse(f.read())

@app.post("/new_tab")
async def new_tab(url: str):
    page = await browser.new_page()
    await page.goto(url)
    tab_id = id(page)
    tabs[tab_id] = page
    return {"tab_id": tab_id, "url": url}

@app.post("/goto")
async def goto_tab(tab_id: int, url: str):
    page = tabs.get(tab_id)
    if page:
        await page.goto(url)
        return {"status": "ok", "url": url}
    return {"error": "tab not found"}

@app.get("/screenshot/{tab_id}")
async def screenshot(tab_id: int):
    page = tabs.get(tab_id)
    if page:
        img_bytes = await page.screenshot(full_page=True)
        return HTMLResponse(content=f'<img src="data:image/png;base64,{img_bytes.hex()}">', media_type="text/html")
    return {"error": "tab not found"}

@app.on_event("shutdown")
async def shutdown():
    await browser.close()
    await pw.stop()
