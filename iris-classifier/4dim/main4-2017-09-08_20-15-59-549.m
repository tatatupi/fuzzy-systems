clc;
clear all;

%% carrega os dados
file = readtable('iris.txt','Delimiter',',');
X=[file.Var1 file.Var2 file.Var3 file.Var4];
Y=[file.Var5];

tnorma=@min;

%normalização
for i=1:size(X,2)
    X(:,i)=(X(:,i)-min(X(:,i)))/(max(X(:,i))-min(X(:,i)));
end

Class1='Iris-setosa';
Class2='Iris-versicolor';
Class3='Iris-virginica';

% K=3; %número de regras

%adiciona vetor com número das classes
X=[X strcmp(Y,Class1)+2*strcmp(Y,Class2)+3*strcmp(Y,Class3)];


for i=1:10
    
    %randomiza as linhas
    ind=randperm(size(X,1));
    for j=1:size(X,1);
        Xrand(j,:)=X(ind(j),:);
    end
    
    for K=2:10
        par=tpar(K);
        
        %Bcon representa o Beta da classe consequente (máximo)
        [Bcon, Ccon, CF] = modelo4(K,par,Xrand(1:105,:),tnorma);
        
        %Ccon representa o a classe consequente de cada regra
        [classe] = classificador4(K,par,X(106:end,:),Ccon,CF,tnorma);
        
        rights=classe==X(106:end,end);
        e(i,K-1)=sum(rights)/45;
    end
end

        
error=num2cell(e, 1);

