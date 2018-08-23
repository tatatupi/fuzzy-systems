clc;
clear all;

%% carrega os dados
file = readtable('iris.txt','Delimiter',',');
X=[file.Var1 file.Var2 file.Var3 file.Var4];
Y=[file.Var5];

%define a tnorma
tnorma=@min;

%normalização
for i=1:size(X,2)
    X(:,i)=(X(:,i)-min(X(:,i)))/(max(X(:,i))-min(X(:,i)));
end

Class1='Iris-setosa';
Class2='Iris-versicolor';
Class3='Iris-virginica';

%adiciona vetor com número das classes
X=[X strcmp(Y,Class1)+2*strcmp(Y,Class2)+3*strcmp(Y,Class3)];


%% loop para verificar performance por K
tic();

for i=1:100 %quantidade de iterações
    
    %randomiza as linhas
    ind=randperm(size(X,1));
    for j=1:size(X,1);
        Xrand(j,:)=X(ind(j),:);
    end
    
    for K=2:15 %variações de K
        par=tpar(K);
        
        %Bcon representa o Beta da classe consequente (máximo)
        %Ccon representa a classe consequente
        [Ccon, CF] = modelo4(K,par,Xrand(1:105,:),tnorma); %treina com 70% dos dados
        
        %Ccon representa o a classe consequente de cada regra
        [classe_valid] = classificador4(K,par,Xrand(106:end,:),Ccon,CF,tnorma); %testa com os 30% restantes
        [classe_trein] = classificador4(K,par,Xrand(1:105,:),Ccon,CF,tnorma); %testa com os 30% restantes

        acertos_valid=classe_valid==Xrand(106:end,end);
        desemp_valid(i,K-1)=sum(acertos_valid)/45;
        
        acertos_trein=classe_trein==Xrand(1:105,end);
        desemp_trein(i,K-1)=sum(acertos_trein)/105;
    end
end

%calcula as médias de acertos (desempenho)
desemp_valid_=num2cell(desemp_valid, 1);
desemp_valid_avg=cellfun(@mean,desemp_valid_);
desemp_trein_=num2cell(desemp_trein, 1);
desemp_trein_avg=cellfun(@mean,desemp_trein_);

disp('Execution Time')
disp(toc())

%% plots

k=2:15;

plot(k,1-desemp_valid_avg,'r',k,1-desemp_trein_avg,'b');
xlabel('K - quantidade de regras'); 
ylabel('Erro de classificação');
legend('Validação','Treinamento');
title('Desempenho do classificador VS quantidade de regras');


