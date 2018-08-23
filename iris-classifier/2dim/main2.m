clc;
clear all;

%% carregamento os dados
file = readtable('iris.txt','Delimiter',',');
X=[file.Var1 file.Var2 file.Var3 file.Var4];
Y=[file.Var5];


%normalização
for i=1:size(X,2)
    X(:,i)=(X(:,i)-min(X(:,i)))/(max(X(:,i))-min(X(:,i)));
end

Class1='Iris-setosa';
Class2='Iris-versicolor';
Class3='Iris-virginica';

%adiciona vetor com número das classes
X=[X strcmp(Y,Class1)+2*strcmp(Y,Class2)+3*strcmp(Y,Class3)];

%% Parametros
K=25; %número de regras
tnorma=@min; %define a tnorma
par=tpar(K); %parâmetros da função triangular

%% Teste bidimensional
X=[X(:,1:2) X(:,end)];

%Ccon representa o a classe consequente de cada regra
%CF representa o grau de certeza
[Ccon, CF] = modelo2(K,par,X,tnorma);

%classe é um vetor com as classes de cada ponto
[classe] = classificador2(K,par,X,Ccon,CF,tnorma);

%% desenhando o grid
x1=0:0.01:1;
x2=0:0.01:1;

for i=1:size(x1,2)
    for j=1:size(x2,2)
        G(j+(i-1)*size(x1,2),1)=x1(i);
        G(j+(i-1)*size(x1,2),2)=x2(j);
    end
end

[classeG] = classificador2(K,par,G,Ccon,CF,tnorma);

G=[G classeG];

for k = 1 : length(classeG)
	if classeG(k)==1
		colorMap(k, :) = [1,0,0]; % Red
    elseif classeG(k)==2
		colorMap(k, :) = [0,0,1]; % Blue
    elseif classeG(k)==3
        colorMap(k, :) = [0,1,0]; % Green
    end
end

scatter(G(:,1),G(:,2),5,colorMap,'filled');
hold on;


%% desenhando os pontos da base de dados
for k = 1 : length(Y)
	if strcmp(Y(k),Class1);
		c1=plot(X(k,1),X(k,2),'ko-','MarkerFaceColor', 'r','MarkerSize',10);
        hold on;
    elseif strcmp(Y(k),Class2);
		c2=plot(X(k,1),X(k,2),'kd-','MarkerFaceColor', 'b','MarkerSize',10);
        hold on;
    elseif strcmp(Y(k),Class3);
        c3=plot(X(k,1),X(k,2),'ks-','MarkerFaceColor', 'g','MarkerSize',10);
        hold on;
    end
end

xlabel('Comprimento das sépalas (normalizado)'); 
ylabel('Largura das sépalas (normalizado)');
title('Regiões de Classificação para os Tipos de Lírios');
legend([c1 c2 c3], 'setosa', 'versicolor', 'virginica')

