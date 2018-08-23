function [Ccon, CF] = modelo2(K,par,X,tnorma)

%matriz de 1 e 0, cuja coluna representa a classe
C(:,1)=X(:,end)==1;
C(:,2)=X(:,end)==2;
C(:,3)=X(:,end)==3;

%R -> Cardinalidade de cada ponto para cada regra
for i=1:K
    for j=1:K
        R(:,j+((i-1)*K))=tnorma(trimf(X(:,1),[par(j,1) (par(j,1)+par(j,2))/2 par(j,2)]),trimf(X(:,2),[par(i,1) (par(i,1)+par(i,2))/2 par(i,2)]));
    end
end

%RC -> cardinalidade de cada classe para cada regra
for i=1:3 %quantidade de classes
    for j=i:K^2 %quantidade de regras
        RC(i,j)=sum(R(:,j)'*C(:,i));
    end
end


%encontra o valor do maior beta (Bcon)
%encontra o índice do maior beta (Ccon - classe consequente)
[Bcon, Ccon] = max(RC);

for i=1:K^2
    %calcula o Beta_barra da regra do artigo
    Bbarra=(sum(RC(:,i))-Bcon(i))/2; %soma todos Betas, exceto o referente à classe consequente
    
    %calcula o CF, conforme artigo
    CF(i)=(Bcon(i)-Bbarra)/sum(RC(:,i));
end

