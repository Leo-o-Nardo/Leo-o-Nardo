# Gera as imagens de assets/ a partir das páginas desta pasta, com o Edge sem janela.
# Uso: powershell -File fontes\gerar.ps1
$edge = 'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe'
$fontes = 'file:///' + ($PSScriptRoot -replace '\\', '/')
$saida = Join-Path (Split-Path $PSScriptRoot) 'assets'
$perfil = Join-Path $env:TEMP 'perfil-edge'
New-Item -ItemType Directory -Force $saida | Out-Null

# Escala 2: as imagens saem com o dobro dos pixels, nítidas em telas de alta densidade.
function Shot($pagina, $arquivo, $w, $h) {
  Start-Process -Wait -FilePath $edge -ArgumentList @(
    '--headless=new', '--disable-gpu', '--hide-scrollbars',
    '--force-device-scale-factor=2', "--window-size=$w,$h",
    '--virtual-time-budget=10000', "--user-data-dir=$perfil",
    "--screenshot=$(Join-Path $saida $arquivo)", "$fontes/$pagina")
}

foreach ($tema in 'claro', 'escuro') {
  Shot "cabecalho.html?tema=$tema" "cabecalho-$tema.png" 1280 280
  Shot "projeto.html?p=caderneta&tema=$tema" "caderneta-$tema.png" 1280 580
  Shot "projeto.html?p=safepay&tema=$tema" "safepay-$tema.png" 640 420
  Shot "projeto.html?p=pgsaas&tema=$tema" "pgsaas-$tema.png" 640 420
}
Get-ChildItem $saida -Filter *.png | Select-Object Name, Length
