// ?tema=escuro troca as cores para o tema escuro do GitHub.
if (new URLSearchParams(location.search).get('tema') === 'escuro') {
  document.documentElement.classList.add('escuro');
}
