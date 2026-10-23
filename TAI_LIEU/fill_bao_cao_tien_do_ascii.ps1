# Pure ASCII PowerShell script to fill 3_MAU_BAO CAO TIEN DO 2026.doc
$ErrorActionPreference = "Stop"

$baseDir = "c:\Users\kaziila\Downloads\DO_AN_CO_SO_NGANH\TAI_LIEU"
$docPath = Join-Path $baseDir "3_MAU_BAO CAO TIEN DO 2026.doc"
$backupPath = Join-Path $baseDir "3_MAU_BAO CAO TIEN DO 2026_BACKUP.doc"
$jsonPath = Join-Path $baseDir "data_bao_cao_tien_do.json"

if (-not (Test-Path $backupPath)) {
    Copy-Item $docPath $backupPath
    Write-Host "Created backup: $backupPath"
}

# Always restore clean template backup before filling
Copy-Item $backupPath $docPath -Force

$rawJson = [System.IO.File]::ReadAllText($jsonPath, [System.Text.Encoding]::UTF8)
$data = $rawJson | ConvertFrom-Json

$word = New-Object -ComObject Word.Application
$word.Visible = $false
$word.DisplayAlerts = 0

try {
    $doc = $word.Documents.Open($docPath)
    $t2 = $doc.Tables.Item(2)

    # 1. Ten de tai (Row 1, Cell 3)
    $c = $t2.Rows.Item(1).Cells.Item(3)
    $c.Range.Text = $data.ten_de_tai
    $c.Range.Font.Name = "Times New Roman"
    $c.Range.Font.Size = 13
    $c.Range.Font.Bold = $true
    $c.Range.ParagraphFormat.Alignment = 3

    # 2. Sinh vien thuc hien (Row 2, Cell 3)
    $c = $t2.Rows.Item(2).Cells.Item(3)
    $c.Range.Text = ($data.sinh_vien -join "`r`n")
    $c.Range.Font.Name = "Times New Roman"
    $c.Range.Font.Size = 13
    $c.Range.Font.Bold = $false
    $c.Range.ParagraphFormat.LineSpacingRule = 5
    $c.Range.ParagraphFormat.LineSpacing = 16

    # 3. Giang vien huong dan (Row 3, Cell 3)
    $c = $t2.Rows.Item(3).Cells.Item(3)
    $c.Range.Text = ($data.giang_vien -join "`r`n")
    $c.Range.Font.Name = "Times New Roman"
    $c.Range.Font.Size = 13
    $c.Range.Font.Bold = $false
    $c.Range.ParagraphFormat.LineSpacingRule = 5
    $c.Range.ParagraphFormat.LineSpacing = 16

    # 4. Tieu de Ke hoach theo de cuong chi tiet (Row 4, Cell 2)
    $c = $t2.Rows.Item(4).Cells.Item(2)
    $c.Range.Text = $data.ke_hoach_theo_de_cuong.title
    $c.Range.Font.Name = "Times New Roman"
    $c.Range.Font.Size = 13
    $c.Range.Font.Bold = $true

    # 5. Bang long 1: Ke hoach theo de cuong (Row 5, Cell 1 -> Table 1)
    $nt1 = $t2.Rows.Item(5).Cells.Item(1).Tables.Item(1)
    $targetRowCount1 = $data.ke_hoach_theo_de_cuong.rows.Count + 1

    while ($nt1.Rows.Count -gt $targetRowCount1) {
        $nt1.Rows.Item($nt1.Rows.Count).Delete()
    }
    while ($nt1.Rows.Count -lt $targetRowCount1) {
        $null = $nt1.Rows.Add()
    }

    # Format Header Bang 1
    for ($col = 1; $col -le 4; $col++) {
        $hc = $nt1.Rows.Item(1).Cells.Item($col)
        $hc.Range.Text = $data.ke_hoach_theo_de_cuong.headers[$col - 1]
        $hc.Range.Font.Name = "Times New Roman"
        $hc.Range.Font.Size = 13
        $hc.Range.Font.Bold = $true
        $hc.Range.ParagraphFormat.Alignment = 1
    }

    # Format Rows Bang 1
    for ($i = 0; $i -lt $data.ke_hoach_theo_de_cuong.rows.Count; $i++) {
        $rIdx = $i + 2
        $rowObj = $nt1.Rows.Item($rIdx)
        $item = $data.ke_hoach_theo_de_cuong.rows[$i]

        $rowObj.Cells.Item(1).Range.Text = $item.week
        $rowObj.Cells.Item(2).Range.Text = $item.time
        $rowObj.Cells.Item(3).Range.Text = $item.task
        $rowObj.Cells.Item(4).Range.Text = $item.result

        for ($col = 1; $col -le 4; $col++) {
            $cellObj = $rowObj.Cells.Item($col)
            $cellObj.Range.Font.Name = "Times New Roman"
            $cellObj.Range.Font.Size = 13
            $cellObj.Range.Font.Bold = $false
            if ($col -le 2) {
                $cellObj.Range.ParagraphFormat.Alignment = 1
            } else {
                $cellObj.Range.ParagraphFormat.Alignment = 3
            }
            $cellObj.Range.ParagraphFormat.LineSpacingRule = 5
            $cellObj.Range.ParagraphFormat.LineSpacing = 16
        }
    }

    # 6. Tieu de Tien do thuc hien de tai (Row 6, Cell 2)
    $c = $t2.Rows.Item(6).Cells.Item(2)
    $c.Range.Text = $data.tien_do_thuc_hien.title
    $c.Range.Font.Name = "Times New Roman"
    $c.Range.Font.Size = 13
    $c.Range.Font.Bold = $true

    # 7. Bang long 2: Tien do thuc hien (Row 7, Cell 1 -> Table 1)
    $nt2 = $t2.Rows.Item(7).Cells.Item(1).Tables.Item(1)
    $targetRowCount2 = $data.tien_do_thuc_hien.rows.Count + 1

    while ($nt2.Rows.Count -gt $targetRowCount2) {
        $nt2.Rows.Item($nt2.Rows.Count).Delete()
    }
    while ($nt2.Rows.Count -lt $targetRowCount2) {
        $null = $nt2.Rows.Add()
    }

    # Format Header Bang 2
    for ($col = 1; $col -le 5; $col++) {
        $hc = $nt2.Rows.Item(1).Cells.Item($col)
        $hc.Range.Text = $data.tien_do_thuc_hien.headers[$col - 1]
        $hc.Range.Font.Name = "Times New Roman"
        $hc.Range.Font.Size = 13
        $hc.Range.Font.Bold = $true
        $hc.Range.ParagraphFormat.Alignment = 1
    }

    # Format Rows Bang 2
    for ($i = 0; $i -lt $data.tien_do_thuc_hien.rows.Count; $i++) {
        $rIdx = $i + 2
        $rowObj = $nt2.Rows.Item($rIdx)
        $item = $data.tien_do_thuc_hien.rows[$i]

        $rowObj.Cells.Item(1).Range.Text = $item.week
        $rowObj.Cells.Item(2).Range.Text = $item.time
        $rowObj.Cells.Item(3).Range.Text = $item.task
        $rowObj.Cells.Item(4).Range.Text = $item.actual_result
        $rowObj.Cells.Item(5).Range.Text = $item.next_plan

        for ($col = 1; $col -le 5; $col++) {
            $cellObj = $rowObj.Cells.Item($col)
            $cellObj.Range.Font.Name = "Times New Roman"
            $cellObj.Range.Font.Size = 13
            $cellObj.Range.Font.Bold = $false
            if ($col -le 2) {
                $cellObj.Range.ParagraphFormat.Alignment = 1
            } else {
                $cellObj.Range.ParagraphFormat.Alignment = 3
            }
            $cellObj.Range.ParagraphFormat.LineSpacingRule = 5
            $cellObj.Range.ParagraphFormat.LineSpacing = 16
        }
    }

    # 8. Tieu de Kho khan va De xuat (Row 8, Cell 2)
    $c = $t2.Rows.Item(8).Cells.Item(2)
    $c.Range.Text = $data.kho_khan_va_de_xuat.title
    $c.Range.Font.Name = "Times New Roman"
    $c.Range.Font.Size = 13
    $c.Range.Font.Bold = $true

    # 9. Noi dung Kho khan va De xuat (Row 9, Cell 1)
    $c = $t2.Rows.Item(9).Cells.Item(1)
    $c.Range.Text = $data.kho_khan_va_de_xuat.content
    $c.Range.Font.Name = "Times New Roman"
    $c.Range.Font.Size = 13
    $c.Range.Font.Bold = $false
    $c.Range.ParagraphFormat.Alignment = 3
    $c.Range.ParagraphFormat.LineSpacingRule = 5
    $c.Range.ParagraphFormat.LineSpacing = 16

    for ($p = 1; $p -le $c.Range.Paragraphs.Count; $p++) {
        $pRange = $c.Range.Paragraphs.Item($p).Range
        $pText = $pRange.Text.Trim()
        if ($pText.StartsWith("1.") -or $pText.StartsWith("2.")) {
            $pRange.Font.Bold = $true
        } else {
            $pRange.Font.Bold = $false
        }
    }

    # 10. Chu ky (Row 10, Cell 2)
    $c = $t2.Rows.Item(10).Cells.Item(2)
    $ckText = $data.chu_ky.dia_diem_ngay + "`r`n" +
              $data.chu_ky.label_sv + "`r`n" +
              $data.chu_ky.label_ky_sv + "`r`n`r`n`r`n`r`n"
    $c.Range.Text = $ckText
    $c.Range.Font.Name = "Times New Roman"
    $c.Range.Font.Size = 13
    $c.Range.Paragraphs.Item(1).Range.Font.Italic = $true
    $c.Range.Paragraphs.Item(2).Range.Font.Bold = $true
    $c.Range.Paragraphs.Item(3).Range.Font.Italic = $true
    $c.Range.ParagraphFormat.Alignment = 1

    # Save original .doc
    $doc.Save()
    Write-Host "SUCCESS: Saved populated 3_MAU_BAO CAO TIEN DO 2026.doc"

    # Export DOCX copy
    $docxPath = Join-Path $baseDir "3_MAU_BAO CAO TIEN DO 2026.docx"
    $doc.SaveAs2($docxPath, 16)
    Write-Host "SUCCESS: Exported modern DOCX copy to $docxPath"

    # Export PDF copy
    $pdfPath = Join-Path $baseDir "3_MAU_BAO CAO TIEN DO 2026.pdf"
    $doc.SaveAs2($pdfPath, 17)
    Write-Host "SUCCESS: Exported PDF copy to $pdfPath"

} finally {
    if ($doc) { $doc.Close() }
    if ($word) { $word.Quit() }
}
