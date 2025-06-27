<h1 align="center"> 
  🗺 Interpolação espacial (IDW)
</h1>

<p align="center">
  <a href="#-sobre-o-projeto">Sobre</a> •
  <a href="#-como-executar-o-projeto">Como executar</a> • 
  <a href="#-versões-do-algoritmo">Versões do algoritmo</a>
</p>

<br>

## 💻 Sobre o projeto

Projeto desenvolvido na disciplina Programação Concorrente do curso de Tecnologia da Informação (IMD/UFRN) implementando o algortimo de interpolação espacial em Crystal para previsão de temperatura.

A interpolação espacial é o processo de estimativa de valores desconhecidos em determinados pontos do espaço com base em informações conhecidas do ambiente. Os dados utilizados por essa técnica consistem em um conjunto de coordenadas espaciais, cada uma com um ou mais valores associados, como temperatura e precipitação, por exemplo.

Dentre os diversos métodos de interpolação espacial existentes, a aplicação desenvolvida utilizou o método Inverso da Distância à Potência (Inverse Distance Weighted – IDW). Esse algoritmo analisa todos os pontos do ambiente e atribui um peso (ou ponderação) a cada coordenada, de acordo com sua proximidade em relação ao ponto de interesse. Quanto mais próximo for o ponto conhecido, maior será seu peso e maior a influência sobre o cálculo da estimativa do valor do atributo.

---

## 🚀 Como executar o projeto

Para executar o projeto, siga os seguintes passos:

1. É preciso ter Crystal instalado na sua máquina. Para instalar, consulte o [link](https://crystal-lang.org/install/).
2. Adicione um arquivo `.txt` com o dados de entrada na pasta `data/`. Cada linha do algoritmo precisa seguir o formato `x,y,z`, sendo `x` um número inteiro a posição do ponto no eixo horizontal, `y` um número inteiro a posição do ponto no eixo vertical e `z` um número de ponto flutuante de uma casa decimal representando a temperatura medida para a coordenada.
3. Para executar pelo terminal:

```bash
# Clone este repositório
$ git clone git@github.com:fabianapduarte/idw-crystal.git

# Acesse a pasta do repositório
$ cd idw-crystal

# Execute o algoritmo, passando as coordenadas para cálculo da interpolação espacial
# crystal run src/idw/<versão do algoritmo>.cr -O3 -Dpreview_mt -Dexecution_context -- <x> <y>
# Exemplo:
$ crystal run src/idw/v0.cr -O3 -Dpreview_mt -Dexecution_context -- 1 1

```

> ⚠ Para a instalação no Windows
>
> Recomenda-se instalar dentro do shell MSYS2. Consulte o [link](https://crystal-lang.org/install/on_windows/).

> ⚠ Sobre o dataset
>
> Para gerar o arquivo de dataset, execute a classe `utils.GenerateData.java` presente no [projeto Java](https://github.com/fabianapduarte/idw-java).

---

## 🗂 Versões do algoritmo

- `baseline`: Versão serial e não otimizada do algoritmo;
- `v0`: Versão serial com otimizações para melhorar uso de memória;
- `v1`: Versão com concorrência;
- `v2`: Versão com paralelismo (sem tratamento de condição de corrida);
- `v3`: Versão com paralelismo e mutex.

> ⚠ Observação
>
> O paralelismo é experimental em Crystal. Ao executar as versões v2 e v3 é preciso passar as flags `-Dpreview_mt -Dexecution_context` no comando de execução. No entanto, não há garantia de que funcione, fazendo com que o algoritmo execute de forma sequencial.
