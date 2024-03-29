% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/padronizar_ceps.R
\name{padronizar_ceps}
\alias{padronizar_ceps}
\title{Padronizar CEPs}
\usage{
padronizar_ceps(ceps)
}
\arguments{
\item{ceps}{Um vetor de caracteres ou números. Os CEPs a serem padronizados.}
}
\value{
Um vetor de caracteres com os CEPs padronizados.
}
\description{
Padroniza um vetor de caracteres ou números representando CEPs. Veja a seção
\emph{Detalhes} para mais informações sobre a padronização.
}
\section{Detalhes}{

Operações realizadas durante a padronização:
\enumerate{
\item conversão para caracter, se o input for numérico;
\item adição de zeros à esquerda, se o input contiver menos de 8 dígitos;
\item remoção de espaços em branco, pontos e vírgulas;
\item adição de traço separando o radical (5 primeiros dígitos) do sufixo (3
últimos digitos).
}
}

\examples{
ceps <- c("22290-140", "22.290-140", "22290 140", "22290140")
padronizar_ceps(ceps)

ceps <- c(22290140, 1000000, NA)
padronizar_ceps(ceps)

}
