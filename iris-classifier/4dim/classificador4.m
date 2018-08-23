function [classe] = classificador4(K,par,X,Ccon,CF,tnorma)

for i=1:K
    P1(:,i)=trimf(X(:,1),[par(i,1) (par(i,1)+par(i,2))/2 par(i,2)]);
    P2(:,i)=trimf(X(:,2),[par(i,1) (par(i,1)+par(i,2))/2 par(i,2)]);
    P3(:,i)=trimf(X(:,3),[par(i,1) (par(i,1)+par(i,2))/2 par(i,2)]);
    P4(:,i)=trimf(X(:,4),[par(i,1) (par(i,1)+par(i,2))/2 par(i,2)]);
end

n=size(X,2)-1;
R=zeros(size(X,1),K^n);

for d=1:K
    ind1=(d-1)*(K^3)+1;
    R(:,ind1:ind1+(K^3-1))=repmat(P1(:,d),[1,(K^3)]);
    for c=1:K
        ind2=ind1+(c-1)*(K^2);
        R(:,ind2:ind2+(K^2-1))=tnorma(R(:,ind2:ind2+(K^2-1)),repmat(P2(:,c),[1,(K^2)]));
        for b=1:K
            ind3=ind2+(b-1)*K;
            R(:,ind3:ind3+K-1)=tnorma(R(:,ind3:ind3+K-1),repmat(P3(:,b),[1,K]));
            for a=1:K
               ind4=ind3+a-1;
               R(:,ind4)=tnorma(R(:,ind4),P4(:,a))*CF(ind4); 
            end
        end
    end
end
 
 [~,iclasse]=max(R'); %encontra os índice das maiores pertinencias
 classe=Ccon(iclasse)'; %retorna um vetor com as classes de maior pertinencia
 