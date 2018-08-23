clc; clear all;

load('fcm_dataset.mat');

%parametros 
m = 2; %c-means
eps = 1e-3; %criterio de parada 1
N = 1e3; %criterio de parada 2
p = 4; %quantidade de centros

%aleatoriza os centros
index = round(size(x,1)*rand(p,1));
c = x(index,:);

c_old = zeros(size(c));
iter=0;

while norm(c-c_old)>eps && iter<N
       
    %calculo da matriz de pertinencia
    U = zeros(size(x,1),size(c,1));
    
    for i=1:size(x,1)
        %checa se o ponto i é algum centro
        if sum(sum(repmat(x(i,:),[4,1])==c))==2;
            [~,ind]=max(repmat(x(i,:),[4,1])==c);
            U(i,:)=0; %atribui 0 de pertinencia aos outros centros
            U(i,ind(1))=1; %atribui 1 de pertinencia ao centro que coincide com o ponto
        else    
            %calcula as distancias
            for j=1:size(c,1)
                dist(j) = norm(x(i,:)-c(j,:));
            end
            for j=1:size(c,1)               
                s=0;
                %somatoria conforme o artigo
                for k=1:size(c,1)
                    s=s+(dist(j)/dist(k))^2;
                end
                U(i,j) = 1/s;
            end
        end
        
    end
    
    %% novos centros
    c_new=zeros(size(c));
    for j=1:size(c,1)
        aux=U(:,j).^m; %matriz com as pertinencias daquele centro ao quadrado
        c_new(j,:)=sum([aux aux].*x,1)/sum(aux);%calcula o novo centro j
    end
    
    %critérios de parada
    c_old=c;
    c=c_new;
    iter=iter+1
    
end

[~,ind]=max(U,[],2);

for k = 1 : length(ind)
	if ind(k)==1
		colorMap(k, :) = [1,0,0]; % Red
    elseif ind(k)==2
		colorMap(k, :) = [0,0,1]; % Blue
    elseif ind(k)==3
        colorMap(k, :) = [0,1,0]; % Green
    elseif ind(k)==4
        colorMap(k, :) = [1,0,1]; % Pink
    end
end

scatter(x(:,1),x(:,2),5,colorMap,'filled');

%% comparacao com a função fcm()

c_fcm = fcm(x,4)




