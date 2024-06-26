
# enderecopadrao

[![CRAN
status](https://www.r-pkg.org/badges/version/enderecopadrao)](https://CRAN.R-project.org/package=enderecopadrao)
[![B
status](https://github.com/ipeaGIT/enderecopadrao/workflows/check/badge.svg)](https://github.com/ipeaGIT/enderecopadrao/actions?query=workflow%3Acheck)
[![Codecov test
coverage](https://codecov.io/gh/ipeaGIT/enderecopadrao/branch/main/graph/badge.svg)](https://app.codecov.io/gh/ipeaGIT/enderecopadrao?branch=main)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html)

**enderecopadrao** é um pacote de R que permite padronizar endereços
brasileiros a partir de diferentes critérios. Os métodos de padronização
atualmente incluem apenas manipulações de strings, não oferecendo
suporte a correspondências probabilísticas entre strings.

## Instalação

O pacote ainda não se encontra no CRAN. Para baixar a última versão
estável, use o código abaixo:

``` r
# install.packages("remotes")
remotes::install_github("ipeaGIT/enderecopadrao@v0.1.0")
```

Para baixar a versão em desenvolvimento, use o seguinte código:

``` r
remotes::install_github("ipeaGIT/enderecopadrao")
```

## Utilização

Esta seção visa oferecer apenas uma rápida visão das funcionalidades do
pacote. Para mais detalhes, leia a vignette introdutória:

- [**enderecopadrao**: padronizador de endereços
  brasileiros](https://ipeagit.github.io/enderecopadrao/articles/enderecopadrao.html)

O pacote fornece funções para padronizar diferentes campos de um
endereço. A `padronizar_enderecos()` padroniza diversos campos
simultaneamente, recebendo, para isso, um dataframe e uma relação de
correspondência entre as colunas desse dataframe e os campos a serem
padronizados:

``` r
library(enderecopadrao)

enderecos <- data.frame(
  logradouro = "r ns sra da piedade",
  nroLogradouro = 20,
  complemento = "qd 20",
  cep = 25220020,
  bairro = "jd botanico",
  codmun_dom = 3304557,
  uf_dom = "rj"
)

campos <- correspondencia_campos(
  logradouro = "logradouro",
  numero = "nroLogradouro",
  complemento = "complemento",
  cep = "cep",
  bairro = "bairro",
  municipio = "codmun_dom",
  estado = "uf_dom"
)

padronizar_enderecos(enderecos, campos_do_endereco = campos)
#>                      logradouro numero complemento       cep          bairro
#>                          <char> <char>      <char>    <char>          <char>
#> 1: RUA NOSSA SENHORA DA PIEDADE     20   QUADRA 20 25220-020 JARDIM BOTANICO
#>         municipio         estado
#>            <char>         <char>
#> 1: RIO DE JANEIRO RIO DE JANEIRO
```

Por trás dos panos, essa função utiliza diversas outras funções que
padronizam campos de forma individual. Cada uma delas recebe um vetor
com valores não padronizados e retorna um vetor de mesmo tamanho com os
respectivos valores padronizados. Algumas das funções disponíveis são
apresentadas abaixo:

``` r
estados <- c("21", " 21", "MA", " MA ", "ma", "MARANHÃO")
padronizar_estados(estados)
#> [1] "MARANHAO" "MARANHAO" "MARANHAO" "MARANHAO" "MARANHAO" "MARANHAO"

municipios <- c(
  "3304557", "003304557", " 3304557 ", "RIO DE JANEIRO", "rio de janeiro",
  "SÃO PAULO"
)
padronizar_municipios(municipios)
#> [1] "RIO DE JANEIRO" "RIO DE JANEIRO" "RIO DE JANEIRO" "RIO DE JANEIRO"
#> [5] "RIO DE JANEIRO" "SAO PAULO"

bairros <- c(
  "PRQ IND",
  "NSA SEN DE FATIMA",
  "ILHA DO GOV",
  "VL OLIMPICA",
  "NUC RES"
)
padronizar_bairros(bairros)
#> [1] "PARQUE INDUSTRIAL"       "NOSSA SENHORA DE FATIMA"
#> [3] "ILHA DO GOVERNADOR"      "VILA OLIMPICA"          
#> [5] "NUCLEO RESIDENCIAL"

ceps <- c("22290-140", "22.290-140", "22290 140", "22290140")
padronizar_ceps(ceps)
#> [1] "22290-140" "22290-140" "22290-140" "22290-140"

logradouros <- c(
  "r. gen.. glicério, 137",
  "cond pres j. k., qd 05 lt 02 1",
  "av d pedro I, 020"
)
padronizar_logradouros(logradouros)
#> [1] "RUA GENERAL GLICERIO, 137"                                    
#> [2] "CONDOMINIO PRESIDENTE JUSCELINO KUBITSCHEK, QUADRA 5 LOTE 2 1"
#> [3] "AVENIDA DOM PEDRO I, 20"

numeros <- c("0210", "001", "1", "", "S N", "S/N", "SN", "0180  0181")
padronizar_numeros(numeros)
#> [1] "210"     "1"       "1"       NA        "S/N"     "S/N"     "S/N"    
#> [8] "180 181"
```

## Nota <a href="https://www.ipea.gov.br"><img src="man/figures/ipea_logo.png" alt="Ipea" align="right" width="300"/></a>

**enderecopadrao** é desenvolvido por uma equipe de pesquisadores do
Instituto de Pesquisa Econômica Aplicada (Ipea).
