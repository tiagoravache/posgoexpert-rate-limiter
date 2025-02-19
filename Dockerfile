# Usar uma imagem base oficial do Go para build
FROM golang:1.20-alpine as builder

# Definir o diretório de trabalho
WORKDIR /app

# Copiar o arquivo go.mod e go.sum (caso você utilize Go modules)
COPY go.mod go.sum ./

# Baixar as dependências
RUN go mod tidy

# Copiar o código fonte da aplicação para dentro do contêiner
COPY . .

# Compilar a aplicação Go
RUN GOOS=linux GOARCH=amd64 go build -o main .

# Usar uma imagem mais leve para rodar a aplicação
FROM alpine:latest

# Instalar as dependências necessárias para rodar o binário (como libc, se necessário)
RUN apk --no-cache add ca-certificates

# Definir o diretório onde o binário estará
WORKDIR /root/

# Copiar o binário compilado da imagem builder
COPY --from=builder /app/main .

# Expor a porta que a aplicação vai rodar
EXPOSE 8080

# Rodar o binário quando o contêiner for iniciado
CMD ["./main"]
