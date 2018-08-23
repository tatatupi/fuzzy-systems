function [Bcon, Ccon, CF] = modelo4(K,par,X,tnorma)

C=zeros(size(X,1),3);

C(:,1)=X(:,end)==1;
C(:,2)=X(:,end)==2;
C(:,3)=X(:,end)==3;

%R -> Cardinalidade de cada ponto para cada regra

for i=1:K
    P1(:,i)=trimf(X(:,1),[par(i,1) (par(i,1)+par(i,2))/2 par(i,2)]);
    P2(:,i)=trimf(X(:,2),[par(i,1) (par(i,1)+par(i,2))/2 par(i,2)]);
    P3(:,i)=trimf(X(:,3),[par(i,1) (par(i,1)+par(i,2))/2 par(i,2)]);
    P4(:,i)=trimf(X(:,4),[par(i,1) (par(i,1)+par(i,2))/2 par(i,2)]);
end

n=size(X,2)-1;
R=zeros(150,K^n);

for d=1:K
    ind1=(d-1)*(K^3)+1
    R(:,ind1:ind1+(K^3-1))=repmat(P1(:,d),[1,(K^3)]);
    for c=1:K
        ind2=ind1+(c-1)*(K^2);
        R(:,ind2:ind2+(K^2-1))=tnorma(R(:,ind2:ind2+(K^2-1)),repmat(P2(:,c),[1,(K^2)]));
        for b=1:K
            ind3=ind2+(b-1)*K;
            R(:,ind3:ind3+K-1)=tnorma(R(:,ind3:ind3+K-1),repmat(P3(:,b),[1,K]));
            for a=1:K
               ind4=ind3+a-1;
               R(:,ind4)=tnorma(R(:,ind4),P4(:,a)); 
            end
        end
    end
end

%RC -> cardinalidade de cada classe para cada regra
for i=1:3 %quantidade de classes
    for j=i:K^n %quantidade de regras
        RC(i,j)=sum(R(:,j)'*C(:,i));
    end
end


%encontra o valor do maior beta (Bcon)
%encontra o índice do maior beta (Ccon - classe consequente)
[Bcon, Ccon] = max(RC);

for i=1:K^n
    %calcula o Beta_barra da regra do artigo
    Bbarra=(sum(RC(:,i))-Bcon(i))/2; %soma todos Betas, exceto o referente à classe consequente
    
    %calcula o CF, conforme artigo
    CF(i)=(Bcon(i)-Bbarra)/sum(RC(:,i));
end

