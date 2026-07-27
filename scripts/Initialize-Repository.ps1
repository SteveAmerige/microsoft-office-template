[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
$SubmoduleName = "microsoft-office-template"

function Stop-WithError {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message
    )

    Write-Error $Message
    exit 1
}

function Write-Result {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Status,

        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    Write-Host ("{0,-10} {1}" -f $Status, $Path)
}

function Get-RelativeDestination {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Destination
    )

    $basePrefix = $script:Base.TrimEnd(
        [System.IO.Path]::DirectorySeparatorChar,
        [System.IO.Path]::AltDirectorySeparatorChar
    ) + [System.IO.Path]::DirectorySeparatorChar

    if ($Destination.StartsWith(
        $basePrefix,
        [System.StringComparison]::OrdinalIgnoreCase
    )) {
        return $Destination.Substring($basePrefix.Length)
    }

    return $Destination
}

function Test-FilesIdentical {
    param(
        [Parameter(Mandatory = $true)]
        [string]$First,

        [Parameter(Mandatory = $true)]
        [string]$Second
    )

    if (-not (Test-Path -LiteralPath $First -PathType Leaf) -or
        -not (Test-Path -LiteralPath $Second -PathType Leaf)) {
        return $false
    }

    $firstHash = (Get-FileHash -LiteralPath $First -Algorithm SHA256).Hash
    $secondHash = (Get-FileHash -LiteralPath $Second -Algorithm SHA256).Hash

    return $firstHash -eq $secondHash
}

function Copy-ManagedFile {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Source,

        [Parameter(Mandatory = $true)]
        [string]$Destination
    )

    if (-not (Test-Path -LiteralPath $Source -PathType Leaf)) {
        Stop-WithError "Required source file is missing: $Source"
    }

    $destinationDirectory = Split-Path -Parent $Destination

    if (-not (Test-Path -LiteralPath $destinationDirectory)) {
        New-Item -ItemType Directory -Path $destinationDirectory -Force |
            Out-Null
    }

    $relativeDestination = Get-RelativeDestination $Destination

    if (-not (Test-Path -LiteralPath $Destination)) {
        Copy-Item -LiteralPath $Source -Destination $Destination
        Write-Result "CREATED" $relativeDestination
    }
    elseif (Test-FilesIdentical $Source $Destination) {
        Write-Result "CURRENT" $relativeDestination
    }
    else {
        Copy-Item `
            -LiteralPath $Source `
            -Destination $Destination `
            -Force

        Write-Result "REFRESHED" $relativeDestination
    }
}

function Copy-IfMissing {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Source,

        [Parameter(Mandatory = $true)]
        [string]$Destination
    )

    if (-not (Test-Path -LiteralPath $Source -PathType Leaf)) {
        Stop-WithError "Required source file is missing: $Source"
    }

    $relativeDestination = Get-RelativeDestination $Destination

    if (Test-Path -LiteralPath $Destination) {
        Write-Result "PRESERVED" $relativeDestination
        return
    }

    $destinationDirectory = Split-Path -Parent $Destination

    if (-not (Test-Path -LiteralPath $destinationDirectory)) {
        New-Item -ItemType Directory -Path $destinationDirectory -Force |
            Out-Null
    }

    Copy-Item -LiteralPath $Source -Destination $Destination
    Write-Result "CREATED" $relativeDestination
}

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Stop-WithError "Git is not available on PATH."
}

$gitRootOutput = & git rev-parse --show-toplevel 2>$null

if ($LASTEXITCODE -ne 0 -or -not $gitRootOutput) {
    Stop-WithError "Run this script from within your own Git repository."
}

$script:Base = [System.IO.Path]::GetFullPath(
    ($gitRootOutput | Select-Object -First 1).Trim()
)

Set-Location -LiteralPath $script:Base

$publicRoot = Join-Path $script:Base $SubmoduleName
$gitmodules = Join-Path $script:Base ".gitmodules"

if (-not (Test-Path -LiteralPath $gitmodules -PathType Leaf)) {
    Stop-WithError "No .gitmodules file was found in $script:Base."
}

if (-not (Test-Path -LiteralPath $publicRoot -PathType Container)) {
    Stop-WithError "The $SubmoduleName submodule directory was not found."
}

$submoduleConfiguration = & git config `
    --file $gitmodules `
    --get-regexp '^submodule\..*\.path$' 2>$null

$submoduleRegistered = $false

foreach ($line in $submoduleConfiguration) {
    $parts = $line -split '\s+', 2

    if ($parts.Count -eq 2 -and $parts[1] -eq $SubmoduleName) {
        $submoduleRegistered = $true
        break
    }
}

if (-not $submoduleRegistered) {
    Stop-WithError "$SubmoduleName is not registered as a Git submodule."
}

$publicSpecimen = Join-Path $publicRoot "src\Style-Specimen.docx"

if (-not (Test-Path -LiteralPath $publicSpecimen -PathType Leaf)) {
    Stop-WithError (
        "The submodule is incomplete. Run: " +
        "git submodule update --init"
    )
}

Write-Host ""
Write-Host "Initializing Microsoft Office template repository"
Write-Host "Repository: $script:Base"
Write-Host ""

$directories = @(
    ".github\workflows",
    "src\brands",
    "releases"
)

foreach ($relativeDirectory in $directories) {
    $directory = Join-Path $script:Base $relativeDirectory

    if (-not (Test-Path -LiteralPath $directory)) {
        New-Item -ItemType Directory -Path $directory -Force | Out-Null
    }

    Write-Result "ENSURED" ($relativeDirectory + "\")
}

# User-managed configuration files are created only when absent.
Copy-IfMissing `
    (Join-Path $publicRoot ".gitattributes") `
    (Join-Path $script:Base ".gitattributes")

Copy-IfMissing `
    (Join-Path $publicRoot ".gitignore") `
    (Join-Path $script:Base ".gitignore")

Copy-IfMissing `
    (Join-Path $publicRoot "templates\template-release-name.txt") `
    (Join-Path $script:Base "template-release-name.txt")

# Project-managed files are refreshed whenever this script runs.
Copy-ManagedFile `
    (Join-Path $publicRoot "src\README.md") `
    (Join-Path $script:Base "src\README.md")

Copy-ManagedFile `
    $publicSpecimen `
    (Join-Path $script:Base "src\Style-Specimen.docx")

Copy-ManagedFile `
    (Join-Path $publicRoot "releases\README.md") `
    (Join-Path $script:Base "releases\README.md")

Copy-ManagedFile `
    (Join-Path $publicRoot "templates\publish-office-templates.yml") `
    (Join-Path `
        $script:Base `
        ".github\workflows\publish-office-templates.yml"
    )

Write-Host @"

Initialization complete.

Managed file notice
-------------------
src/Style-Specimen.docx is maintained by microsoft-office-template and
may be overwritten whenever this script is run.

Before modifying the specimen itself, copy it to another filename, such
as:

    src/My-Style-Specimen.docx

Release archive name
--------------------
The release archive name is configured in:

    template-release-name.txt

The default value is:

    mytemplates

You may edit this file to choose another name. For example, a value of:

    organization-office-templates

produces a release archive named:

    organization-office-templates-v1.0.0.zip

Next steps
----------
1. Copy src/Style-Specimen.docx into a directory under src/brands/.
2. Replace the logo and contact information in each branded copy.
3. Save completed Word templates as .dotx files under releases/.
4. Commit and push the repository.
5. Run "Publish Office Templates" from the GitHub Actions tab.
"@
