clc; clear all;

img = imread('img03.jpg');

x=zeros(size(img,1)*size(img,2),3);

%% transformando a imagem em uma matriz
ind=0;
for i=1:size(img,1)
    for j=1:size(img,2)
        ind=ind+1;
        x(ind,:)=img(i,j,:);
    end
end

%parametros 
m = 2; %c-means
eps = 1e-2; %criterio de parada 1
N = 1e5; %criterio de parada 2
p = 6; %quantidade de centros
n = size(x,1); %qtd de padrões

% %aleatoriza os centros
index = round(n*rand(p,1));
c = x(index,:);

c_old = zeros(size(c));
iter=0;

while norm(c-c_old)>eps && iter<N

    %calculo da matriz de pertinencia
    U = zeros(size(x,1),size(c,1));
    for i=1:size(x,1) 
        %checa se o ponto i é algum centro
        if sum(sum(repmat(x(i,:),[p,1])==c))>=3;
            [~,ind]=max(sum(repmat(x(i,:),[p,1])==c,2));
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
        c_new(j,:)=sum(repmat(aux,[1,3]).*x,1)/sum(aux);%calcula o novo centro j
    end
    
    %critérios de parada
    c_old=c;
    c=c_new;
    iter=iter+1;
    
end

%% retornando a imagem
ind=0;
img_class=zeros(size(img,1),size(img,2),3);
for i=1:size(img,1)
    for j=1:size(img,2)
        ind=ind+1;
        [~,centro]=max(U(ind,:));
        img_class(i,j,:)=c(centro,:);
    end
end

% image(uint8(img_class))

subplot(1,2,1), subimage(img)
subplot(1,2,2), subimage(uint8(img_class))


