% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/padronizar_estados.R
\name{padronizar_estados}
\alias{padronizar_estados}
\title{Padronizar estados}
\usage{
padronizar_estados(estados)
}
\arguments{
\item{estados}{Um vetor de caracteres ou números. Os estados a serem
padronizados.}
}
\value{
Um vetor de caracteres com os estados padronizados.
}
\description{
Padroniza um vetor de caracteres ou números representando estados
brasileiros. Veja a seção \emph{Detalhes} para mais informações sobre a
padronização.
}
\section{Detalhes}{

Operações realizadas durante a padronização:
\enumerate{
\item conversão para caracter, se o input for numérico;
\item remoção de espaços em branco antes e depois dos valores e remoção de
espaços em excesso entre palavras;
\item conversão de caracteres para caixa alta;
\item remoção de zeros à esquerda;
\item busca, a partir do código numérico ou da abreviação da UF, do nome
completo de cada estado;
\item caso a busca não tenha encontrado determinado valor, remoção de acentos e
caracteres não ASCII - esta etapa, de manipulação de strings, pode ser
incrementada para adequação futura a bases de dados com as quais as etapas
anteriores não resultem em valores padronizados.
}
}

\examples{
estados <- c("21", "021", "MA", " 21", " MA ", "ma", "", NA)
padronizar_estados(estados)

estados <- c(21, NA)
padronizar_estados(estados)

}
