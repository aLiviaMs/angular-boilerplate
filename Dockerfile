FROM node:18 AS build

WORKDIR /app

# Copie apenas os arquivos de dependência primeiro
COPY package.json package-lock.json ./

# Use npm install em vez de npm ci
RUN npm install && npm install -g @angular/cli

# Agora copie o resto dos arquivos
COPY . .

# Build da aplicação
RUN ng build --configuration production

# Estágio de produção
FROM nginx:1.24

# Copie a configuração do nginx
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

# Copie os arquivos buildados do estágio anterior
COPY --from=build /app/dist/angular-boilerplate/browser /usr/share/nginx/html

EXPOSE 80
