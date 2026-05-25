---
title: "Distribuições amostrais"
author: Rafael Japiassu Regis do Amaral
output:
  html_document:
    theme: spacelab
    highlight: tango
    code_folding: hide
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```
#Simulação de monte carlo: Uma Investigação Empírica do Teorema do Limite Central (TCL)📌 

#### O objetivo deste projeto é demonstrar empiricamente a validade e a convergência do Teorema do Limite Central (TCL) por meio de simulações computacionais. Utilizando a linguagem R (Base), o estudo analisa o comportamento da distribuição amostral da média em diferentes cenários, partindo de uma população original caracterizada por forte assimetria.


### ⚙️ Metodologia e Escopo da Simulação
#### Para conduzir o experimento e forçar o teste do TCL, foi selecionada como população original uma distribuição Gama (com parâmetros de forma $\alpha=2$ e taxa $\beta=1$).


#### O motor da simulação segue a seguinte estrutura:

- #### Geração de Amostras: 
Foram simuladas de forma independente $m = 1000$ amostras aleatórias, avaliando o impacto de diferentes tamanhos amostrais ($n \in \{2, 5, 10, 30, 50, 100\}$).


- #### Análise de Viés e Eficiência: 
Para cada tamanho de amostra, a média amostral empírica foi calculada e comparada diretamente com a média teórica verdadeira da população original.


- #### Modelagem Visual: 
O projeto constrói histogramas de densidade das médias amostrais para cada $n$, sobrepondo a eles duas curvas matemáticas:A distribuição exata da média amostral (dada pelas propriedades da distribuição Gama).A densidade Normal aproximada, garantida pelo Teorema do Limite Central.


### 📊 Resultados e Discussão:


A análise final discute, de forma quantitativa e gráfica, a evolução da aproximação estatística. O estudo detalha como o aumento sistemático do tamanho da amostra ($n$) atenua a assimetria herdada da população original e induz a convergência da distribuição empírica para o formato de sino de uma curva Normal.

```{r}
library(knitr) # Apenas para deixar a tabela bonita no final
set.seed(123) 

m <- 1000 # Número de repetições
n_values <- c(2,5,10,30,50,100) # Diferentes tamanhos de amostras
theta <- 2

#criando variáveis para anotar os resultados numéricos
medias_simuladas <- numeric(length(n_values))
variancias_simuladas <- numeric(length(n_values))

par(mfrow = c(1, 3))

# Vamos preparar a tela do R para mostrar os 3 gráficos lado a lado


par(mfrow = c(1, 3)) 


for (j in 1:length(n_values)) {
  n <- n_values[j]
  medias <- numeric(m) # Inicializa o vetor para o 'n' atual
  
  for (i in 1:m) {
  
    amostra <- rgamma(n, shape = 2, rate = 1) 
    
    medias[i] <- mean(amostra) # Calcula e guarda a média
  }
  
  # AÇÃO: Plota o gráfico antes que o loop passe para o próximo 'n'
  hist(medias, 
       
       main = paste("Amostra n =", n),
       xlab = "Médias", 
       ylab = "frequência",
       col = "cadetblue", 
       border = "white",
       prob = TRUE)

  curve(dgamma(x, shape = n, rate = n/theta), 
        col = "red", lwd = 2, add = TRUE)
  
  # 2. A NOVA CURVA: APROXIMAÇÃO NORMAL PELO TCL (Azul Tracejada)
  # A média é theta, e o erro padrão é o desvio da população (theta) / sqrt(n)
  curve(dnorm(x, mean = theta, sd = theta/sqrt(n)), 
        col = "blue", lwd = 2, lty = 2, add = TRUE)
  
  # Adicionando uma legenda pequenininha no gráfico
  legend("topright", legend=c("Exata (Gama)", "TCL (Normal)"), 
         col=c("red", "blue"), lty=c(1, 2), lwd=2, cex=0.6)
  

medias_simuladas[j] <- mean(medias)  
}
par(mfrow = c(1,1))

# Reseta a tela de gráficos para o padrão (1x1)

tabela_resultados <- data.frame(
  `Tamanho (n)` = n_values,
  `Média Teórica` = theta,
  `Média Simulada` = medias_simuladas)

kable(tabela_resultados, digits = 4, align = 'c',
     caption = "Comparação:")
```
## Considerações sobre o Resultado da simulação

- ### 1. A precisão da média amostral (Estimador não viesado):
A tabela demonstra que a média global das nossas simulações permaneceu consistentemente muito próxima de $2$ (que é o nosso $\theta$ teórico), independentemente de a amostra ser pequena ($n=2$) ou grande ($n=100$). Isso comprova na prática que a média amostral é um estimador justo e não viesado, pois reflete com precisão a média verdadeira da população.
- ### 2. A redução do erro em amostras maiores:
Observando a evolução dos gráficos, fica evidente que, conforme o $n$ aumenta, a base do histograma se torna mais estreita e concentrada em torno do centro. Essa "afinação" da curva ocorre devido à queda do erro padrão. Em termos analíticos, isso significa que uma amostra maior resulta em uma estimativa muito mais precisa e com menor variância.
- ### 3. O Teorema do Limite Central (TCL):
Esta é a constatação mais visual do experimento. Nossa distribuição original possui uma cauda longa à direita, sendo bastante assimétrica. Nos primeiros cenários ($n=2$ e $n=5$), a distribuição das médias ainda herda parte dessa assimetria. Contudo, à medida que o tamanho da amostra cresce para $n=30$, $50$ e $100$, essa distorção desaparece e o histograma converge para a forma de um sino perfeitamente simétrico (uma Distribuição Normal). Além disso, a curva teórica da densidade exata encaixou perfeitamente em todos os cenários, validando que a formulação matemática modela com exatidão os dados empíricos que simulamos.



