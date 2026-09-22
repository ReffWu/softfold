<div align="center">

<img src="docs/icon.png" width="128" height="128" alt="Softfold" />

# Softfold

**Abaixe a tela, e sua mesa de trabalho se dobra suavemente.**

<a href="https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="docs/readme/download-en-dark.png">
    <img src="docs/readme/download-en-light.png" height="52" alt="Baixar o Softfold para Mac">
  </picture>
</a>

<p>
  <a href="https://trendshift.io/repositories/237288?utm_source=trendshift-badge&amp;utm_medium=badge&amp;utm_campaign=badge-trendshift-237288" target="_blank" rel="noopener noreferrer"><img src="https://trendshift.io/api/badge/trendshift/repositories/237288/daily?language=Swift" alt="ReffWu%2Fsoftfold | Trendshift" width="250" height="55"/></a>
</p>

<sub>Gratuito · MacBook com Apple Silicon · macOS 14 ou posterior · Autenticado pela Apple</sub>

<sub>Se você gostou do Softfold, uma ⭐ no GitHub ajuda mais pessoas a descobri-lo.</sub>

[English](README.md) · [简体中文](README.zh-CN.md) · [繁體中文](README.zh-TW.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [Deutsch](README.de.md) · [Français](README.fr.md) · [Español](README.es.md) · [Italiano](README.it.md) · Português · [Русский](README.ru.md) · [Nederlands](README.nl.md) · [Türkçe](README.tr.md) · [Polski](README.pl.md) · [العربية](README.ar.md) · [Tiếng Việt](README.vi.md)

</div>

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="docs/readme/hero-en-dark.webp">
    <img src="docs/readme/hero-en-light.webp" alt="Abaixe a tela, e sua mesa de trabalho se dobra suavemente.">
  </picture>
</p>

---

O Softfold acompanha o movimento da dobradiça do seu MacBook. À medida que você fecha a tela, sua mesa de trabalho em tempo real se inclina para trás, fica gradualmente desfocada a partir do topo e se dissolve nas bordas escuras. Abra a tela novamente e tudo volta ao normal, nítido e exatamente onde você deixou.

## Download

[Baixe o Softfold.dmg](https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg), abra o arquivo e arraste o Softfold para a pasta Aplicativos. O aplicativo é assinado com Developer ID e autenticado (notarizado) pela Apple, abrindo perfeitamente como qualquer outro app nativo do Mac.

Na primeira inicialização, autorize a «Gravação de Tela» nos Ajustes do Sistema, reabra o Softfold se o macOS solicitar e ative-o. A partir daí, ele iniciará automaticamente junto com o Mac e continuará funcionando.

Ao ser ativado pela primeira vez, o Softfold memoriza o ângulo atual da tela como referência de abertura. Para alterá-lo depois, posicione a tampa no ângulo que preferir e clique em **Usar Ângulo Atual**. Use o atalho <kbd>⌃</kbd> <kbd>⌥</kbd> <kbd>H</kbd> para ligar ou desligar o efeito a qualquer instante.

## Modelos de MacBook compatíveis

O Softfold requer o sensor de ângulo da tampa introduzido pela Apple a partir de 2019 (acessado nos chips Apple Silicon através do coprocessador de sensores), além do macOS 14 ou posterior. Se o seu Mac não possuir esse sensor, o Softfold avisará você imediatamente.

| Status | Modelos |
| --- | --- |
| Confirmado e funcional | MacBook Pro de 14" e 16" com M1 Pro ou M1 Max (2021), M2 Max (2023), M3 Pro ou M3 Max (2023), M4 Pro ou M4 Max (2024). MacBook Air com M4 (2025) ou M5 |
| Possui sensor, ainda não confirmado | MacBook Pro de 14" com M3, M4 ou M5. MacBook Pro de 14" e 16" com M5 Pro ou M5 Max. MacBook Air com M2 ou M3 |
| Não suportado | MacBook Air com M1, todos os MacBook Pro de 13" (Intel, M1 e M2), MacBook Pro com processador Intel, MacBook de 12", MacBook Neo, Macs de mesa |

O MacBook Pro de 16 polegadas de 2019 também possui esse sensor, mas esta versão disponibilizada foi desenvolvida exclusivamente para a arquitetura Apple Silicon.

Ficou na dúvida? Execute este comando no Terminal. Uma linha que terminar em «las» significa que o Softfold consegue ler o sensor da sua tela:

```sh
hidutil list --matching '{"VendorID":0x5ac,"PrimaryUsagePage":32,"PrimaryUsage":138}'
```

Testou em algum modelo da linha intermediária? [Conte-nos como foi a sua experiência](https://github.com/ReffWu/softfold/issues).

## Como funciona

O Softfold lê a inclinação da tampa via IOKit HID em centésimos de grau diretamente do sensor, respeitando a cadência nativa de atualização em vez de fazer leituras forçadas. Um filtro com amortecimento crítico traduz essas leituras em um movimento contínuo e orgânico. Inclinação suave, dobra suave. Movimento rápido, dobra imediata. Se você pausar o movimento no meio do caminho por um segundo, a mesa recupera a nitidez suavemente e volta a dobrar assim que você continuar fechando.

O ScreenCaptureKit captura a mesa em tempo real e o Metal renderiza a perspectiva tridimensional, o desfoque progressivo e o preenchimento lateral a fluidos 60 fps. A captura ocorre unicamente enquanto a tela está se movendo ou dobrada, e é interrompida instantes após a reabertura completa, o que também desativa o indicador de gravação do macOS. Os quadros permanecem exclusivamente na memória RAM e nunca são gravados ou enviados para a rede. Uma vez ao dia, o Softfold envia um sinal anônimo com um ID aleatório de instalação, versões do app e do macOS, modelo do Mac e se o efeito foi acionado no dia, apenas para contabilizar Macs ativos. Nenhum conteúdo de tela, arquivo, endereço IP ou dado pessoal é coletado. Você pode desativar o compartilhamento de estatísticas anônimas na janela do app a qualquer momento.

O design de movimento completo está detalhado em [MOTION.md](MOTION.md).

## Idiomas suportados

Inglês, chinês simplificado, chinês tradicional, japonês, coreano, alemão, francês, espanhol, italiano, português do Brasil, russo, holandês, turco, polonês, árabe e vietnamita. O Softfold segue automaticamente o idioma do sistema do seu Mac ou pode ser selecionado diretamente na janela do app.

## Compilar a partir do código-fonte

Instale o Xcode e execute:

```sh
git clone https://github.com/ReffWu/softfold.git
cd softfold
make build
open build/Softfold.app
```

As verificações de desenvolvimento estão documentadas em [CHECKS.md](CHECKS.md), e as compilações assinadas em [RELEASE.md](RELEASE.md).

## Contribuições

Ideias, relatos de problemas e pull requests são muito bem-vindos. [Abra uma issue](https://github.com/ReffWu/softfold/issues) ou envie uma pull request.

## Agradecimentos

O Softfold teve início como uma bifurcação (fork) do [Hinge](https://github.com/Noveum/hinge) da Noveum.ai, sob licença MIT. Os identificadores HID e a estrutura dos relatórios do sensor de tampa foram documentados pioneiramente pelo projeto [LidAngleSensor](https://github.com/samhenrigold/LidAngleSensor).

## Licença

[MIT](LICENSE)
