function ListarProgramas {
    $installedPrograms = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*,
                                           HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |
                                           Where-Object { $_.DisplayName -ne $null } |
                                           Select-Object DisplayName, UninstallString

    $index = 1
    foreach ($program in $installedPrograms) {
        Write-Host "$index`: $($program.DisplayName)"
        $index++
    }

    return $installedPrograms
}

function DesinstalarProgramas($programasParaDesinstalar) {
    foreach ($program in $programasParaDesinstalar) {
        if ($program.UninstallString) {
            Start-Process cmd.exe -ArgumentList "/c $($program.UninstallString)" -Wait
            Write-Host "Programa $($program.DisplayName) desinstalado."
        } else {
            Write-Host "Não foi possível encontrar o comando de desinstalação para $($program.DisplayName)."
        }
    }
}

do {
    $installedPrograms = ListarProgramas
    $userChoices = Read-Host "Digite os números dos programas que deseja desinstalar (separados por vírgula)"
    $selectedPrograms = $userChoices.Split(',') | ForEach-Object { $installedPrograms[$_ - 1] }
    DesinstalarProgramas -programasParaDesinstalar $selectedPrograms

    $continue = Read-Host "Deseja remover outros programas? (S/N)"
} while ($continue -eq 'S')
