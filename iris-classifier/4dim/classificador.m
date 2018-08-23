function [classe] = classificador(K,par,X,Ccon,CF)

 for i=1:K
     for j=1:K
         R(:,j+((i-1)*K))=trimf(X(:,1),[par(j,1) (par(j,1)+par(j,2))/2 par(j,2)])... %mu de x1
         .*trimf(X(:,2),[par(i,1) (par(i,1)+par(i,2))/2 par(i,2)])... %vezes o mu de x2
         *CF(j+((i-1)*K)); %vezes o grau de certeza
     end
 end

 [~,iclasse]=max(R'); %encontra os índice das maiores pertinencias
 classe=Ccon(iclasse)'; %retorna um vetor com as classes de maior pertinencia
 