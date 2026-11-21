# Finalize thesis on Windows using Microsoft Word COM:
# Updates all TOC/Table/Figure fields and exports Kurmanji-TTS_Thesis_Rojava.pdf
$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $PSScriptRoot
$DocxPath = Join-Path $RepoRoot "docs\Kurmanji-TTS_Thesis_Rojava.docx"
$PdfPath  = Join-Path $RepoRoot "docs\Kurmanji-TTS_Thesis_Rojava.pdf"

$word = New-Object -ComObject Word.Application
$word.Visible = $false
try {
    $doc = $word.Documents.Open($DocxPath)
    foreach ($toc in $doc.TablesOfContents) { $toc.Update() }
    $doc.Fields.Update() | Out-Null
    $doc.Save()
    $doc.ExportAsFixedFormat($PdfPath, 17)
    $doc.Close($false)
    Write-Host "Exported finalized PDF with updated TOC: $PdfPath"
} finally {
    $word.Quit()
}
