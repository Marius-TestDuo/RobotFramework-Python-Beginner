#Requires -Version 5.1

# Define script parameters
param (
    [Parameter(Mandatory=$true)]
    [ValidateSet('web', 'api', 'mobile')]
    [string]$EnvType, # Maps to -EnvType (or -e)
    
    [string[]]$IncludeTag, # Maps to -IncludeTag (or -it), can accept multiple tags
    [string[]]$ExcludeTag  # Maps to -ExcludeTag (or -et), can accept multiple tags
)

$ErrorActionPreference = 'Stop'
$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition

Write-Host "----------------------------------------------------"
Write-Host "Starting Robot Framework execution..."
Write-Host "Environment/Type: $EnvType"
Write-Host "Included Tags:    $($IncludeTag -join ', ')"
Write-Host "Excluded Tags:    $($ExcludeTag -join ', ')"
Write-Host "----------------------------------------------------"

# --- Virtual Environment Activation ---
$venvPath = Join-Path -Path $scriptRoot -ChildPath ".venv\Scripts\Activate.ps1"
if (Test-Path $venvPath) {
    Write-Host "Activating virtual environment..."
    # ExecutionPolicy Bypass is often needed for PS scripts to run within a script
    & powershell.exe -ExecutionPolicy Bypass -File $venvPath
} else {
    Write-Host "Virtual environment script not found at $venvPath. Assuming environment is already set up."
}

# --- Dynamic Pathing and Timestamps ---
$timestamp = Get-Date -Format "yyyy_MM_dd_HH_mm_ss"
$resultsDir = Join-Path -Path $scriptRoot -ChildPath "results\$EnvType\run_$timestamp"
$testsPath = Join-Path -Path $scriptRoot -ChildPath "tests\$EnvType"

# Ensure results directory exists
if (-not (Test-Path $resultsDir)) {
    New-Item -Path $resultsDir -ItemType Directory | Out-Null
}

if (-not (Test-Path $testsPath)) {
    Write-Error "Error: Test path not found: $testsPath"
    exit 1
}

# --- Build Robot Framework Command Arguments ---
$robotArgs = @(
    "--outputdir", $resultsDir
)

# Add include tags if provided
if ($IncludeTag) {
    foreach ($tag in $IncludeTag) {
        $robotArgs += "--include", $tag
    }
}
# Add exclude tags if provided
if ($ExcludeTag) {
    foreach ($tag in $ExcludeTag) {
        $robotArgs += "--exclude", $tag
    }
}

# Add the final test path argument
$robotArgs += $testsPath

Write-Host "Executing command: robot $robotArgs"

# --- Execute Robot Framework ---
# Use the call operator '&' to run the command correctly
& robot @robotArgs

# Check the exit code
if ($LASTEXITCODE -ne 0) {
    Write-Error "Robot Framework tests failed with exit code $LASTEXITCODE."
    exit 1
}

Write-Host "Robot Framework tests completed successfully."
# Pause for visibility if run directly (remove if integrating into CI/CD)
Read-Host -Prompt "Press Enter to exit"

# Examples
# .\run_robot.ps1 -EnvType web -IncludeTag login
# .\run_robot.ps1 -EnvType api -IncludeTag smoke -ExcludeTag slow
# .\run_robot.ps1 -EnvType mobile   (runs all test for API)
