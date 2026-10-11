# Pure ASCII PowerShell script to fill 1_MAU_DE_CUONG_CHI_TIET 2026.doc
$ErrorActionPreference = "Stop"

$baseDir = "c:\Users\kaziila\Downloads\DO_AN_CO_SO_NGANH\server\data"
$docPath = Join-Path $baseDir "1_MAU_DE_CUONG_CHI_TIET 2026.doc"
$backupPath = Join-Path $baseDir "1_MAU_DE_CUONG_CHI_TIET 2026_BACKUP.doc"
$jsonPath = Join-Path $baseDir "data_de_cuong.json"

if (-not (Test-Path $backupPath)) {
    Copy-Item $docPath $backupPath
}

# Always restore clean template backup
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

    # 2. Sinh vien (Row 2, Cell 3)
    $c = $t2.Rows.Item(2).Cells.Item(3)
    $c.Range.Text = ($data.sinh_vien -join "`r`n")
    $c.Range.Font.Name = "Times New Roman"
    $c.Range.Font.Size = 13
    $c.Range.Font.Bold = $false
    $c.Range.ParagraphFormat.LineSpacingRule = 5
    $c.Range.ParagraphFormat.LineSpacing = 16

    # 3. Giang vien (Row 3, Cell 3)
    $c = $t2.Rows.Item(3).Cells.Item(3)
    $c.Range.Text = ($data.giang_vien -join "`r`n")
    $c.Range.Font.Name = "Times New Roman"
    $c.Range.Font.Size = 13
    $c.Range.Font.Bold = $false
    $c.Range.ParagraphFormat.LineSpacingRule = 5
    $c.Range.ParagraphFormat.LineSpacing = 16

    # 4. Tinh cap thiet (Row 4, Cell 2)
    $c = $t2.Rows.Item(4).Cells.Item(2)
    $txt4 = $data.tinh_cap_thiet.title + "`r`n" + ($data.tinh_cap_thiet.paragraphs -join "`r`n")
    $c.Range.Text = $txt4
    $c.Range.Font.Name = "Times New Roman"
    $c.Range.Font.Size = 13
    $c.Range.Paragraphs.Item(1).Range.Font.Bold = $true
    for ($p = 2; $p -le $c.Range.Paragraphs.Count; $p++) {
        $pRange = $c.Range.Paragraphs.Item($p).Range
        $pRange.Font.Bold = $false
        $pRange.ParagraphFormat.Alignment = 3
        $pRange.ParagraphFormat.LineSpacingRule = 5
        $pRange.ParagraphFormat.LineSpacing = 16
        $pRange.ParagraphFormat.SpaceAfter = 6
    }

    # 5. Muc tieu (Row 5, Cell 2)
    $c = $t2.Rows.Item(5).Cells.Item(2)
    $txt5 = $data.muc_tieu.title + "`r`n" +
        $data.muc_tieu.label_tong_quat + "`r`n" +
        $data.muc_tieu.tong_quat + "`r`n" +
        $data.muc_tieu.label_cu_the + "`r`n" +
        ($data.muc_tieu.cu_the -join "`r`n")
    $c.Range.Text = $txt5
    $c.Range.Font.Name = "Times New Roman"
    $c.Range.Font.Size = 13
    $c.Range.Paragraphs.Item(1).Range.Font.Bold = $true
    for ($p = 2; $p -le $c.Range.Paragraphs.Count; $p++) {
        $pRange = $c.Range.Paragraphs.Item($p).Range
        $pTxt = $pRange.Text.Trim()
        if ($pTxt.StartsWith("5.1.") -or $pTxt.StartsWith("5.2.")) {
            $pRange.Font.Bold = $true
        } else {
            $pRange.Font.Bold = $false
        }
        $pRange.ParagraphFormat.Alignment = 3
        $pRange.ParagraphFormat.LineSpacingRule = 5
        $pRange.ParagraphFormat.LineSpacing = 16
        $pRange.ParagraphFormat.SpaceAfter = 4
    }

    # 6. Noi dung nghien cuu (Row 6, Cell 2)
    $c = $t2.Rows.Item(6).Cells.Item(2)
    $ndList = @($data.noi_dung_nghien_cuu.title)
    foreach ($nd in $data.noi_dung_nghien_cuu.items) {
        $ndList += $nd.title
        $ndList += $nd.desc
    }
    $c.Range.Text = ($ndList -join "`r`n")
    $c.Range.Font.Name = "Times New Roman"
    $c.Range.Font.Size = 13
    $c.Range.Paragraphs.Item(1).Range.Font.Bold = $true
    for ($p = 2; $p -le $c.Range.Paragraphs.Count; $p++) {
        $pRange = $c.Range.Paragraphs.Item($p).Range
        $pTxt = $pRange.Text.Trim()
        if ($pTxt.StartsWith("N")) {
            $pRange.Font.Bold = $true
        } else {
            $pRange.Font.Bold = $false
        }
        $pRange.ParagraphFormat.Alignment = 3
        $pRange.ParagraphFormat.LineSpacingRule = 5
        $pRange.ParagraphFormat.LineSpacing = 16
        $pRange.ParagraphFormat.SpaceAfter = 4
    }

    # 7. Doi tuong va pham vi (Row 7, Cell 2)
    $c = $t2.Rows.Item(7).Cells.Item(2)
    $c.Range.Text = $data.doi_tuong_pham_vi.title_main
    $c.Range.Font.Name = "Times New Roman"
    $c.Range.Font.Size = 13
    $c.Range.Font.Bold = $true

    # 7.1. Doi tuong nghien cuu (Row 8, Cell 2)
    $c = $t2.Rows.Item(8).Cells.Item(2)
    $c.Range.Text = $data.doi_tuong_pham_vi.title_doi_tuong + "`r`n" + ($data.doi_tuong_pham_vi.doi_tuong -join "`r`n")
    $c.Range.Font.Name = "Times New Roman"
    $c.Range.Font.Size = 13
    $c.Range.Paragraphs.Item(1).Range.Font.Bold = $true
    for ($p = 2; $p -le $c.Range.Paragraphs.Count; $p++) {
        $pRange = $c.Range.Paragraphs.Item($p).Range
        $pRange.Font.Bold = $false
        $pRange.ParagraphFormat.Alignment = 3
        $pRange.ParagraphFormat.LineSpacingRule = 5
        $pRange.ParagraphFormat.LineSpacing = 16
        $pRange.ParagraphFormat.SpaceAfter = 4
    }

    # 7.2. Pham vi nghien cuu (Row 9, Cell 2)
    $c = $t2.Rows.Item(9).Cells.Item(2)
    $c.Range.Text = $data.doi_tuong_pham_vi.title_pham_vi + "`r`n" + ($data.doi_tuong_pham_vi.pham_vi -join "`r`n")
    $c.Range.Font.Name = "Times New Roman"
    $c.Range.Font.Size = 13
    $c.Range.Paragraphs.Item(1).Range.Font.Bold = $true
    for ($p = 2; $p -le $c.Range.Paragraphs.Count; $p++) {
        $pRange = $c.Range.Paragraphs.Item($p).Range
        $pRange.Font.Bold = $false
        $pRange.ParagraphFormat.Alignment = 3
        $pRange.ParagraphFormat.LineSpacingRule = 5
        $pRange.ParagraphFormat.LineSpacing = 16
        $pRange.ParagraphFormat.SpaceAfter = 4
    }

    # 8. Phuong phap nghien cuu (Row 10, Cell 2)
    $c = $t2.Rows.Item(10).Cells.Item(2)
    $c.Range.Text = $data.phuong_phap_nghien_cuu.title + "`r`n" + ($data.phuong_phap_nghien_cuu.paragraphs -join "`r`n")
    $c.Range.Font.Name = "Times New Roman"
    $c.Range.Font.Size = 13
    $c.Range.Paragraphs.Item(1).Range.Font.Bold = $true
    for ($p = 2; $p -le $c.Range.Paragraphs.Count; $p++) {
        $pRange = $c.Range.Paragraphs.Item($p).Range
        $pRange.Font.Bold = $false
        $pRange.ParagraphFormat.Alignment = 3
        $pRange.ParagraphFormat.LineSpacingRule = 5
        $pRange.ParagraphFormat.LineSpacing = 16
        $pRange.ParagraphFormat.SpaceAfter = 4
    }

    # 9. Ke hoach thuc hien (Row 11 & Nested Table in Row 12)
    $c = $t2.Rows.Item(11).Cells.Item(2)
    $c.Range.Text = $data.ke_hoach_thuc_hien.title
    $c.Range.Font.Name = "Times New Roman"
    $c.Range.Font.Size = 13
    $c.Range.Font.Bold = $true

    $nt = $t2.Rows.Item(12).Cells.Item(1).Tables.Item(1)
    $targetRowCount = $data.ke_hoach_thuc_hien.schedule.Count + 1

    # Adjust row count of nested table to match schedule (8 weeks + 1 header = 9 rows)
    while ($nt.Rows.Count -lt $targetRowCount) {
        $null = $nt.Rows.Add()
    }
    while ($nt.Rows.Count -gt $targetRowCount) {
        $nt.Rows.Item($nt.Rows.Count).Delete()
    }

    for ($i = 0; $i -lt $data.ke_hoach_thuc_hien.schedule.Count; $i++) {
        $rowIndex = $i + 2
        $rowObj = $nt.Rows.Item($rowIndex)
        $item = $data.ke_hoach_thuc_hien.schedule[$i]

        $c1 = $rowObj.Cells.Item(1)
        $c1.Range.Text = $item.week
        $c1.Range.Font.Name = "Times New Roman"
        $c1.Range.Font.Size = 13
        $c1.Range.ParagraphFormat.Alignment = 1

        $c2 = $rowObj.Cells.Item(2)
        $c2.Range.Text = $item.time
        $c2.Range.Font.Name = "Times New Roman"
        $c2.Range.Font.Size = 13
        $c2.Range.ParagraphFormat.Alignment = 1

        $c3 = $rowObj.Cells.Item(3)
        $c3.Range.Text = $item.task
        $c3.Range.Font.Name = "Times New Roman"
        $c3.Range.Font.Size = 13
        $c3.Range.ParagraphFormat.Alignment = 3

        $c4 = $rowObj.Cells.Item(4)
        $c4.Range.Text = $item.result
        $c4.Range.Font.Name = "Times New Roman"
        $c4.Range.Font.Size = 13
        $c4.Range.ParagraphFormat.Alignment = 3
    }

    # 10. Ket qua du kien (Row 13, Cell 2)
    $c = $t2.Rows.Item(13).Cells.Item(2)
    $c.Range.Text = $data.ket_qua_du_kien.title
    $c.Range.Font.Name = "Times New Roman"
    $c.Range.Font.Size = 13
    $c.Range.Font.Bold = $true

    # 10.1 & 10.2 (Row 14, Cell 1)
    $c = $t2.Rows.Item(14).Cells.Item(1)
    $kq = $data.ket_qua_du_kien
    $txt14 = $kq.title_ung_dung + "`r`n" +
        $kq.label_prototype + "`t" + $kq.prototype + "`r`n" +
        $kq.label_may_tinh + "`t" + $kq.may_tinh + "`r`n" +
        $kq.label_quy_trinh + "`t`t" + $kq.quy_trinh + "`r`n" +
        $kq.label_so_do + "`t`t" + $kq.so_do + "`r`n" +
        $kq.label_khac + "`t`t" + $kq.khac + "`r`n" +
        $kq.title_ket_qua_khac + "`r`n" +
        ($kq.ket_qua_khac -join "`r`n")

    $c.Range.Text = $txt14
    $c.Range.Font.Name = "Times New Roman"
    $c.Range.Font.Size = 13
    $c.Range.Paragraphs.Item(1).Range.Font.Bold = $true
    for ($p = 2; $p -le $c.Range.Paragraphs.Count; $p++) {
        $pRange = $c.Range.Paragraphs.Item($p).Range
        $pTxt = $pRange.Text.Trim()
        if ($pTxt.StartsWith("K")) {
            $pRange.Font.Bold = $true
        } else {
            $pRange.Font.Bold = $false
        }
        $pRange.ParagraphFormat.Alignment = 3
        $pRange.ParagraphFormat.LineSpacingRule = 5
        $pRange.ParagraphFormat.LineSpacing = 16
        $pRange.ParagraphFormat.SpaceAfter = 4
    }

    # 11. Chu ky (Row 15)
    $ck = $data.chu_ky
    $c1 = $t2.Rows.Item(15).Cells.Item(1)
    $c1.Range.Text = $ck.label_gv + "`r`n" + $ck.label_ky_gv + "`r`n`r`n`r`n`r`n"
    $c1.Range.Font.Name = "Times New Roman"
    $c1.Range.Font.Size = 13
    $c1.Range.Paragraphs.Item(1).Range.Font.Bold = $true
    $c1.Range.Paragraphs.Item(2).Range.Font.Italic = $true
    $c1.Range.ParagraphFormat.Alignment = 1

    $c2 = $t2.Rows.Item(15).Cells.Item(2)
    $c2.Range.Text = $ck.dia_diem_ngay + "`r`n" + $ck.label_sv + "`r`n" + $ck.label_ky_sv + "`r`n`r`n`r`n`r`n"
    $c2.Range.Font.Name = "Times New Roman"
    $c2.Range.Font.Size = 13
    $c2.Range.Paragraphs.Item(1).Range.Font.Italic = $true
    $c2.Range.Paragraphs.Item(2).Range.Font.Bold = $true
    $c2.Range.Paragraphs.Item(3).Range.Font.Italic = $true
    $c2.Range.ParagraphFormat.Alignment = 1

    # Save original .doc
    $doc.Save()
    Write-Host "SUCCESS: Saved populated 1_MAU_DE_CUONG_CHI_TIET 2026.doc"

    # Export DOCX copy
    $docxPath = Join-Path $baseDir "1_MAU_DE_CUONG_CHI_TIET 2026.docx"
    $doc.SaveAs2($docxPath, 16)
    Write-Host "SUCCESS: Exported modern DOCX copy to $docxPath"

    # Export PDF copy
    $pdfPath = Join-Path $baseDir "1_MAU_DE_CUONG_CHI_TIET 2026.pdf"
    $doc.SaveAs2($pdfPath, 17)
    Write-Host "SUCCESS: Exported PDF copy to $pdfPath"

} finally {
    if ($doc) { $doc.Close() }
    if ($word) { $word.Quit() }
}
