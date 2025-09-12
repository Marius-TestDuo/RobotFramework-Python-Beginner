# PowerShell setup script for Robot Framework environment
# Usage: powershell -ExecutionPolicy Bypass -File .\scripts\setup.ps1

$ErrorActionPreference = 'Stop'

Write-Host "==> Creating virtual environment (.venv)"
if (!(Test-Path .\.venv)) {
    python -m venv .venv
} else {
    Write-Host "Virtual environment already exists."
}

$venvPython = Join-Path (Resolve-Path .\.venv\Scripts).Path 'python.exe'

Write-Host "==> Upgrading pip"
& $venvPython -m pip install --upgrade pip

Write-Host "==> Installing requirements from requirements.txt"
& $venvPython -m pip install -r requirements.txt

Write-Host "==> (Optional) Downloading ChromeDriver with webdrivermanager"
try {
    & $venvPython -m webdrivermanager chrome --linkpath (Resolve-Path .\drivers).Path
} catch {
    Write-Warning "webdrivermanager not available or download failed. You can rerun later: `n  .\.venv\Scripts\python -m webdrivermanager chrome --linkpath .\drivers"
}

Write-Host "==> Done. Activate the venv with: `n  .\\.venv\\Scripts\\Activate.ps1"
