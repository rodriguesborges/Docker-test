# Use uma imagem base oficial do Python.
# A versão -slim é menor que a versão completa, mas inclui ferramentas comuns.
# Usar uma versão específica como 3.11 garante a reprodutibilidade.
FROM python:3.11-slim-bullseye

# Define o diretório de trabalho no container
WORKDIR /app

# Copia o arquivo de dependências primeiro para aproveitar o cache do Docker
COPY requirements.txt ./

# Instala os pacotes necessários especificados em requirements.txt
# --no-cache-dir: Desativa o cache, que não é necessário em uma imagem de container.
# --upgrade pip: Garante que temos a versão mais recente do pip.
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copia o restante do código-fonte da aplicação do host para o container
COPY . .

# Disponibiliza a porta 8000 para o mundo fora deste container
EXPOSE 8000

# Define o comando para executar a aplicação usando uvicorn
# --host 0.0.0.0 é necessário para tornar o servidor acessível de fora do container
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
