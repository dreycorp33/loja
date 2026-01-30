# Integração com MongoDB (passo a passo)

> Este projeto é 100% front-end (HTML/JS). Para integrar com MongoDB de forma segura, é necessário criar um **back-end** (API) para guardar credenciais e acessar o banco. O front-end passa a consumir essa API.

## 1) Crie um cluster no MongoDB Atlas
1. Acesse o MongoDB Atlas e crie um novo projeto.
2. Crie um cluster gratuito (M0).
3. Em **Database Access**, crie um usuário com senha forte.
4. Em **Network Access**, permita o IP do servidor onde sua API vai rodar.
5. Copie a string de conexão (`mongodb+srv://...`).

## 2) Crie uma API (Node.js + Express + Mongoose)
1. Inicialize um projeto Node.js:
   - `npm init -y`
   - `npm install express mongoose dotenv cors`
2. Crie um arquivo `.env` com a variável `MONGODB_URI`.
3. Crie `server.js` com:
   - Conexão com o MongoDB (`mongoose.connect`).
   - Rotas REST para `products`, `customers`, `sales`, `cash`, `movements`, `users`, `settings`.

## 3) Estruture os schemas
1. Crie schemas equivalentes aos dados que hoje estão no IndexedDB (ver `index.html`).
2. Exemplos de coleções:
   - `products` com `variants` (array).
   - `sales` com `items` e `totals`.
   - `settings` com preferências (tema, appTitle, etc.).

## 4) Implemente endpoints
Sugestão de endpoints REST:
- `GET /api/products` | `POST /api/products`
- `PUT /api/products/:id` | `DELETE /api/products/:id`
- Repita para `customers`, `sales`, `cash`, `movements`, `users`, `settings`.

## 5) Proteja as credenciais
1. Nunca coloque a string do MongoDB no front-end.
2. Deixe as credenciais no `.env` do servidor.
3. Se necessário, adicione autenticação com JWT na API.

## 6) Conecte o front-end à API
1. Substitua as operações do IndexedDB por `fetch()` para sua API.
2. Mapeie as operações atuais (listar, salvar, editar, remover) para as rotas REST.
3. Exemplo: ao salvar um produto no `index.html`, faça `POST /api/products`.

## 7) Deploy
1. Hospede a API (Render, Railway, Fly.io, etc.).
2. Atualize o front-end para usar a URL pública da API.

## 8) Migração de dados (opcional)
1. Exporte o JSON completo pela tela de Backup.
2. Crie um script que leia esse JSON e grave no MongoDB.
3. Valide os registros no Atlas.

## 9) Testes
1. Teste as rotas com Postman/Insomnia.
2. Verifique se o front-end carrega e grava dados corretamente.

---

Se quiser, posso:
- criar a API base pronta com Node/Express/Mongoose,
- adaptar o front-end para usar essa API,
- ou gerar um script de migração dos dados atuais.
