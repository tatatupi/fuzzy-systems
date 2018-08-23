function [classe] = classificador4(K,par,X,Ccon,CF)

 for d=1:K
    for c=1:K
        for b=1:K
            for a=1:K
                R(:,a+((b-1)*K)+((c-1)*K)+((d-1)*K))=...
                    tnorma(trimf(X(:,1),[par(a,1) (par(a,1)+par(a,2))/2 par(a,2)]),...
                    trimf(X(:,2),[par(b,1) (par(b,1)+par(b,2))/2 par(b,2)])),...
                    trimf(X(:,3),[par(c,1) (par(c,1)+par(c,2))/2 par(c,2)])),...
                    trimf(X(:,4),[par(d,1) (par(d,1)+par(d,2))/2 par(d,2)]))...
                    *CF(a+((b-1)*K)+((c-1)*K)+((d-1)*K));
            end
        end
    end
 end
 
 [~,iclasse]=max(R'); %encontra os índice das maiores pertinencias
 classe=Ccon(iclasse)'; %retorna um vetor com as classes de maior pertinencia
 