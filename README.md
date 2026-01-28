# DR Soluções - PDV & Gestão Offline (Modo 1 arquivo)

WebApp offline-first para loja de roupas, rodando apenas com `index.html` (sem backend). Dados ficam no **IndexedDB** e preferências no **LocalStorage**.

## Como usar

1. Abra `index.html` em um navegador moderno (Chrome/Edge/Firefox).
2. Primeiro acesso: usuário `admin` senha `1234`.
3. Use o menu lateral para navegar entre PDV, Produtos, Clientes, Estoque, Caixa, Relatórios e Configurações.

## Impressão 80mm

* O cupom é impresso via `window.print()`.
* Clique em **Imprimir cupom** após finalizar a venda.
* Garanta que a impressora térmica esteja configurada para **80mm** no sistema.

## Leitor de código de barras

* **USB**: o leitor atua como teclado. Basta focar o campo de busca no PDV.
* **Câmera**: clique em **Ler câmera** (usa BarcodeDetector API, se suportada pelo navegador).

## Backup e restauração

* Vá em **Configurações > Backup**.
* **Exportar JSON completo** cria um backup total do banco.
* **Importar JSON** permite mesclar ou substituir dados.

## Integração Google Sheets (funcional)

### Visão geral
O app envia e recebe dados usando um **Google Apps Script** publicado como Web App. O fluxo é:

1. App envia `POST` com JSON completo para o endpoint (ação `export`).
2. App faz `GET` com `?action=import` para buscar dados do Google Sheets.

### Passo a passo (Apps Script)
1. Crie uma planilha no Google Sheets com as abas: `products`, `customers`, `sales`, `cash`, `movements`.
2. Acesse **Extensões > Apps Script** e cole o código abaixo.
3. Publique em **Implantar > Nova implantação > Web app**.
4. Copie a URL do Web App e cole em **Configurações > Integração Google Sheets**.

### Código pronto do Apps Script

```javascript
const SHEETS = ["products", "customers", "sales", "cash", "movements"];

function doPost(e) {
  const body = JSON.parse(e.postData.contents || "{}");
  if (body.action !== "export") return json({ ok: false, error: "Invalid action" });
  const payload = body.payload || {};
  SHEETS.forEach((name) => {
    const sheet = getSheet(name);
    sheet.clear();
    const rows = payload[name] || [];
    if (!rows.length) return;
    const headers = Object.keys(rows[0]);
    sheet.appendRow(headers);
    rows.forEach((row) => {
      sheet.appendRow(headers.map((key) => stringify(row[key])));
    });
  });
  return json({ ok: true });
}

function doGet(e) {
  const action = e.parameter.action;
  if (action !== "import") return json({ ok: false, error: "Invalid action" });
  const payload = {};
  SHEETS.forEach((name) => {
    const sheet = getSheet(name);
    const data = sheet.getDataRange().getValues();
    if (data.length < 2) {
      payload[name] = [];
      return;
    }
    const headers = data[0];
    payload[name] = data.slice(1).map((row) => {
      const obj = {};
      headers.forEach((h, i) => (obj[h] = parseValue(row[i])));
      return obj;
    });
  });
  return json(payload);
}

function getSheet(name) {
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  let sheet = ss.getSheetByName(name);
  if (!sheet) sheet = ss.insertSheet(name);
  return sheet;
}

function json(data) {
  return ContentService.createTextOutput(JSON.stringify(data)).setMimeType(ContentService.MimeType.JSON);
}

function stringify(value) {
  if (value === null || value === undefined) return "";
  if (typeof value === "object") return JSON.stringify(value);
  return value;
}

function parseValue(value) {
  if (value === "") return null;
  if (typeof value === "string" && (value.startsWith("{") || value.startsWith("["))) {
    try { return JSON.parse(value); } catch (err) { return value; }
  }
  return value;
}
```

### Modelos de abas (headers)

```
products: id,name,sku,barcode,category,brand,price,cost,variants_json,unit,supplier,status
customers: id,name,phone,email,cpf,birthday,address,notes
sales: id,date,userId,userName,items_json,totals_json,paymentMethod,paid,change,customerId
cash: id,type,date,amount,method,saleId
movements: id,type,date,productId,quantity,userId,reason
```

> Observação: campos JSON (ex.: `items_json`) são armazenados como texto na planilha.

## Importação de produtos (CSV)

Na tela de Produtos, baixe o template CSV e preencha:

```
name,sku,barcode,category,brand,price,cost,variants_json,unit,supplier,status
```

`variants_json` deve estar no formato JSON, exemplo:

```
[{"size":"P","color":"Preto","stock":10}]
```

## Dados seed

Ao iniciar pela primeira vez são criados automaticamente:

* 10 produtos de exemplo
* 5 clientes de exemplo
* Usuários: admin, gerente, operador (senha padrão: 1234)

## Checklist manual de testes (PDV)

- [ ] Buscar produto por nome ou código de barras
- [ ] Adicionar item ao carrinho
- [ ] Testar desconto por item
- [ ] Aplicar desconto geral e taxa
- [ ] Finalizar venda em dinheiro e conferir troco
- [ ] Imprimir cupom 80mm
- [ ] Confirmar baixa de estoque
- [ ] Verificar lançamento no Caixa

## Observações

* Sistema funciona offline-first.
* Preparado para exportação/importação e futura integração com APIs.

---

WhatsApp DR Soluções: **35991617669**
